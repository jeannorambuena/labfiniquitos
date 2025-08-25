from flask import Blueprint, render_template, request, current_app
from app.forms.finiquito_form import FiniquitoForm
from app.models.finiquito import FiniquitoCalculo
from app.extensions.extensions import db

finiquito_bp = Blueprint('finiquito', __name__, url_prefix='/finiquito')


@finiquito_bp.route('/nuevo', methods=['GET'])
def nuevo():
    form = FiniquitoForm()
    return render_template('casos/finiquito.html', form=form)


@finiquito_bp.route('/nuevo', methods=['POST'])
def calcular():
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

        # 2. Calcula años de servicio y fracción
        anios_servicio = 0
        if fecha_inicio and fecha_termino:
            dias = (fecha_termino - fecha_inicio).days
            anos = dias / 365.25
            anios_servicio = int(anos) + (1 if (anos % 1) > 0.5 else 0)

        # 3. Indemnización por años de servicio (solo art. 161)
        indemnizacion_anios = 0
        indemnizacion_aviso = 0
        if causal.startswith('161'):
            indemnizacion_anios = anios_servicio * sueldo_base
            indemnizacion_aviso = sueldo_base

        # 4. Vacaciones proporcionales
        vacaciones = (sueldo_base / 30) * dias_vac

        # 5. Pago tiempo de espera (1,5 ingresos mínimos / 180h)
        IMM = current_app.config.get('IMM', 460000)
        valor_hora_espera = (1.5 * IMM) / 180
        pago_espera = horas_espera * valor_hora_espera

        # 6. Horas extras (recargo 50 %)
        valor_hora_base = sueldo_base / 180
        pago_horas_extra = horas_extra * valor_hora_base * 1.5

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
            # asigna aquí caso_id, trabajador_id y empleador_id si los tienes
            # caso_id=request.args.get('caso_id'),
            # trabajador_id=request.args.get('trabajador_id'),
            # empleador_id=request.args.get('empleador_id')
        )
        db.session.add(finiquito_calculo)
        db.session.commit()

        # Puedes pasar el objeto a la plantilla o construir un diccionario
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

        return render_template('casos/finiquito.html',
                               form=form,
                               resultados=resultados,
                               finiquito=finiquito_calculo)

    # Si el formulario no es válido, vuelve a mostrarlo con los errores
    return render_template('casos/finiquito.html', form=form)
