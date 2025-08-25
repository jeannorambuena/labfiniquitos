# C:\wamp64\www\labfiniquito\app\routes\finiquito.py
from __future__ import annotations

from flask import Blueprint, render_template, request, current_app, redirect, url_for, flash
from app.forms.finiquito_form import FiniquitoForm
from app.models.finiquito import FiniquitoCalculo
from app.models.caso import Caso
from app.extensions.extensions import db

finiquito_bp = Blueprint('finiquito', __name__, url_prefix='/finiquito')


def _formatea_rut(rut_cuerpo=None, rut_dv=None, rut_str=None) -> str:
    """
    Devuelve un RUT con formato 12.345.678-9 a partir de (rut_cuerpo, rut_dv)
    o desde un string 'XXXXXXXXD'/'XXXXXXXX-D'. Si no hay datos, retorna ''.
    """
    try:
        if rut_str:
            s = str(rut_str).strip()
            if "-" in s:
                return s
            cuerpo, dv = s[:-1], s[-1]
            return f"{int(cuerpo):,}".replace(",", ".") + f"-{dv.upper()}"
        if rut_cuerpo is not None and rut_dv is not None:
            s = f"{int(rut_cuerpo):,}".replace(",", ".")
            return f"{s}-{str(rut_dv).upper()}"
    except Exception:
        pass
    return ""


def _nombre_trabajador(t) -> str:
    """
    Construye el nombre completo del trabajador con tolerancia a distintos esquemas de campos.
    Prioriza:
      - nombres / nombre
      - apellidos  (si existe como un solo campo)
      - apellido_paterno + apellido_materno (o primer_apellido + segundo_apellido)
      - nombre_completo / full_name
    """
    parts = []

    # nombre(s)
    n = (getattr(t, "nombres", None) or getattr(
        t, "nombre", None) or "").strip()
    if n:
        parts.append(n)

    # apellidos (campo único)
    ap = (getattr(t, "apellidos", None) or "").strip()
    if ap:
        parts.append(ap)
    else:
        # Apellidos separados
        ap1 = (getattr(t, "apellido_paterno", None) or getattr(
            t, "primer_apellido", None) or "").strip()
        ap2 = (getattr(t, "apellido_materno", None) or getattr(
            t, "segundo_apellido", None) or "").strip()
        if ap1:
            parts.append(ap1)
        if ap2:
            parts.append(ap2)

    full = " ".join(parts).strip()
    if not full:
        full = (getattr(t, "nombre_completo", None)
                or getattr(t, "full_name", None) or "").strip()

    return full


def _nombre_empleador(e) -> str:
    razon = getattr(e, "razon_social", "") or ""
    if razon.strip():
        return razon.strip()
    nombres = getattr(e, "nombres", "") or ""
    apellidos = getattr(e, "apellidos", "") or ""
    return f"{nombres} {apellidos}".strip()


@finiquito_bp.route('/nuevo', methods=['GET'])
def nuevo():
    """
    Muestra el formulario de finiquito, pre-poblado desde el caso (?caso_id=).
    """
    form = FiniquitoForm()

    # Cargar caso por querystring
    caso_id = request.args.get("caso_id", type=int)
    if not caso_id:
        flash("Falta 'caso_id' en la URL.", "warning")
        return redirect(url_for("casos.index"))

    caso = Caso.query.get_or_404(caso_id)
    trabajador = getattr(caso, "trabajador", None)
    empleador = getattr(caso, "empleador", None)
    if not trabajador or not empleador:
        flash("El caso debe tener trabajador y empleador asociados.", "warning")
        return redirect(url_for("casos.editar", id=caso.id))

    # Pre-fill Identificación
    form.trabajador_nombre.data = _nombre_trabajador(trabajador)
    form.empleador_nombre.data = _nombre_empleador(empleador)

    if hasattr(trabajador, "rut_cuerpo") and hasattr(trabajador, "rut_dv"):
        form.trabajador_rut.data = _formatea_rut(
            trabajador.rut_cuerpo, trabajador.rut_dv)
    else:
        form.trabajador_rut.data = _formatea_rut(
            rut_str=getattr(trabajador, "rut", ""))

    if hasattr(empleador, "rut_cuerpo") and hasattr(empleador, "rut_dv"):
        form.empleador_rut.data = _formatea_rut(
            empleador.rut_cuerpo, empleador.rut_dv)
    else:
        form.empleador_rut.data = _formatea_rut(
            rut_str=getattr(empleador, "rut", ""))

    return render_template(
        'casos/finiquito.html',
        form=form,
        caso=caso,
        trabajador=trabajador,
        empleador=empleador,
    )


@finiquito_bp.route('/nuevo', methods=['POST'])
def calcular():
    """
    Procesa el cálculo del finiquito. Requiere ?caso_id= para re-render con contexto.
    """
    # Cargar caso por querystring para volver a renderizar con contexto completo
    caso_id = request.args.get("caso_id", type=int)
    if not caso_id:
        flash("Falta 'caso_id' en la URL.", "warning")
        return redirect(url_for("casos.index"))

    caso = Caso.query.get_or_404(caso_id)
    trabajador = getattr(caso, "trabajador", None)
    empleador = getattr(caso, "empleador", None)
    if not trabajador or not empleador:
        flash("El caso debe tener trabajador y empleador asociados.", "warning")
        return redirect(url_for("casos.editar", id=caso.id))

    form = FiniquitoForm(request.form)

    if form.validate_on_submit():
        # 1. Extrae los valores del formulario
        fecha_inicio = form.fecha_inicio.data
        fecha_termino = form.fecha_termino.data
        sueldo_base = form.remuneracion_base.data
        gratificacion = form.gratificacion.data or 0
        comisiones = form.comisiones.data or 0
        semana_corrida = form.semana_corrida.data or 0
        bonos = form.bonos.data or 0
        horas_espera = form.horas_espera.data or 0
        horas_extra = form.horas_extra.data or 0
        dias_vac = form.dias_vac_pendientes.data or 0
        causal = form.causal_termino.data

        # 2. Calcula años de servicio y fracción (redondeo simple)
        anios_servicio = 0
        if fecha_inicio and fecha_termino:
            dias = (fecha_termino - fecha_inicio).days
            anos = dias / 365.25
            anios_servicio = int(anos) + (1 if (anos % 1) > 0.5 else 0)

        # 3. Indemnización por años de servicio (solo art. 161)
        indemnizacion_anios = 0
        indemnizacion_aviso = 0
        if str(causal or "").startswith('161'):
            indemnizacion_anios = anios_servicio * (sueldo_base or 0)
            indemnizacion_aviso = (sueldo_base or 0)

        # 4. Vacaciones proporcionales
        sueldo_base = sueldo_base or 0
        vacaciones = (sueldo_base / 30) * (dias_vac or 0)

        # 5. Pago tiempo de espera (1,5 ingresos mínimos / 180h)
        IMM = current_app.config.get('IMM', 460000)
        valor_hora_espera = (1.5 * IMM) / 180
        pago_espera = (horas_espera or 0) * valor_hora_espera

        # 6. Horas extras (recargo 50 %)
        valor_hora_base = (sueldo_base or 0) / 180 if (sueldo_base or 0) else 0
        pago_horas_extra = (horas_extra or 0) * valor_hora_base * 1.5

        # 7. Total haberes
        total_haberes = (
            sueldo_base + gratificacion + comisiones + semana_corrida + bonos +
            indemnizacion_anios + indemnizacion_aviso +
            vacaciones + pago_espera + pago_horas_extra
        )

        # 8. Descuentos
        afp = form.afp.data or 0
        salud = form.salud.data or 0
        cesantia = form.cesantia.data or 0
        otros_desc = form.otros_descuentos.data or 0
        total_descuentos = afp + salud + cesantia + otros_desc

        # 9. Total a pagar
        total_pagar = total_haberes - total_descuentos

        # 10. Crea y guarda el registro de cálculo
        finiquito_calculo = FiniquitoCalculo(
            fecha_inicio=fecha_inicio,
            fecha_termino=fecha_termino,
            causal_termino=causal,
            tipo_jornada=form.tipo_jornada.data,
            remuneracion_base=sueldo_base,
            gratificacion=gratificacion,
            comisiones=comisiones,
            semana_corrida=semana_corrida,
            bonos=bonos,
            horas_espera=horas_espera,
            horas_extra=horas_extra,
            dias_vac_pendientes=dias_vac,
            afp=afp,
            salud=salud,
            cesantia=cesantia,
            otros_descuentos=otros_desc,
            anios_servicio=anios_servicio,
            indemnizacion_anios=indemnizacion_anios,
            indemnizacion_aviso=indemnizacion_aviso,
            vacaciones=vacaciones,
            pago_espera=pago_espera,
            total_haberes=total_haberes,
            total_descuentos=total_descuentos,
            total_pagar=total_pagar,
        )
        # Asociar caso si el modelo lo soporta (no rompe si no existe)
        try:
            setattr(finiquito_calculo, "caso_id", caso.id)
        except Exception:
            pass

        db.session.add(finiquito_calculo)
        db.session.commit()

        resultados = {
            'anios_servicio': anios_servicio,
            'indemnizacion_anios': indemnizacion_anios,
            'indemnizacion_aviso': indemnizacion_aviso,
            'vacaciones': vacaciones,
            'pago_espera': pago_espera,
            'total_haberes': total_haberes,
            'total_descuentos': total_descuentos,
            'total_pagar': total_pagar,
        }

        return render_template(
            'casos/finiquito.html',
            form=form,
            resultados=resultados,
            finiquito=finiquito_calculo,
            caso=caso,
            trabajador=trabajador,
            empleador=empleador,
        )

    # Form inválido: re-render con errores y contexto completo
    return render_template(
        'casos/finiquito.html',
        form=form,
        caso=caso,
        trabajador=trabajador,
        empleador=empleador,
    )
