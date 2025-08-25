# C:\wamp64\www\labfiniquito\app\routes\casos.py
"""
Rutas del módulo Casos.

Incluye:
- Listado de casos.
- Creación (nuevo) con precreación y creación definitiva.
- Edición (reutiliza la vista de creación).
- Detalle y generar (placeholder).
- Guardado y listado de documentos de un caso (contratos, liquidaciones, cartolas).
- Descarga/visualización de archivos guardados.
- Finiquito: vista que pre-puebla identificación del trabajador y empleador.

Nota: Se aplica "Opción B" para ocultar el módulo "Resumen" en la vista /casos/nuevo
mediante la bandera show_resumen=False enviada al template.
"""

from __future__ import annotations

import os
from typing import Any, Dict, Optional, Tuple, List
from werkzeug.utils import secure_filename
from flask import send_from_directory

from flask import (
    Blueprint,
    render_template,
    request,
    redirect,
    url_for,
    flash,
    current_app,
)

from app.forms.casos_form import CasoForm
from app.forms.finiquito_form import FiniquitoForm
from app.extensions.extensions import db
from app.models.trabajador import Trabajador
from app.models.empleador import Empleador
from app.models.caso import Caso

casos_bp = Blueprint("casos", __name__)


@casos_bp.route("/casos", methods=["GET"])
def index():
    """
    Lista los casos ordenados por ID descendente.
    """
    casos = Caso.query.order_by(Caso.id.desc()).all()
    return render_template("casos/index.html", casos=casos)


# ----------------------------- Utilidades -----------------------------

def _int_or_none(v: Any) -> Optional[int]:
    """
    Convierte el valor a int si es posible, de lo contrario retorna None.
    """
    try:
        if v is None:
            return None
        v = str(v).strip()
        return int(v) if v else None
    except Exception:
        return None


def _set_if_has(obj: Any, attr: str, value: Any) -> None:
    """
    Asigna dinámicamente un atributo a un objeto solo si el atributo existe
    en la clase del objeto.
    """
    try:
        if hasattr(obj.__class__, attr):
            setattr(obj, attr, value)
    except Exception:
        # Silencioso por seguridad.
        pass


def _ensure_case_folders(case_id: int) -> Dict[str, str]:
    """
    Crea la estructura de carpetas de un caso si no existe y retorna los paths.
    Estructura:
        <UPLOAD_CASES_ROOT>/<case_id>/
            fuentes/contratos
            fuentes/liquidaciones
            fuentes/cartolas
    """
    base_root = current_app.config.get(
        "UPLOAD_CASES_ROOT",
        r"C:\wamp64\www\labfiniquito\uploads\casos",
    )
    root = os.path.join(base_root, str(case_id))
    contratos = os.path.join(root, "fuentes", "contratos")
    liquidaciones = os.path.join(root, "fuentes", "liquidaciones")
    cartolas = os.path.join(root, "fuentes", "cartolas")

    for p in (contratos, liquidaciones, cartolas):
        os.makedirs(p, exist_ok=True)

    return {
        "root": root,
        "contratos": contratos,
        "liquidaciones": liquidaciones,
        "cartolas": cartolas,
    }


def _scan_docs_state(case_id: int) -> Tuple[Dict[str, List[str]], Dict[str, str], int]:
    """
    Devuelve:
      docs_files:   { 'contrato': [nombres], 'liquidaciones':[...], 'afp':[...] }
      docs_estados: { 'contrato':'subido'|'pendiente', ... }
      done_total:   cuántas categorías tienen archivos
    """
    rutas = _ensure_case_folders(case_id)

    def list_names(path: str) -> List[str]:
        try:
            if not os.path.isdir(path):
                return []
            out = []
            for n in os.listdir(path):
                fpath = os.path.join(path, n)
                if os.path.isfile(fpath):
                    out.append(n)
            return sorted(out, key=str.lower)
        except Exception:
            return []

    files_contrato = list_names(rutas["contratos"])
    files_liquidaciones = list_names(rutas["liquidaciones"])
    files_afp = list_names(rutas["cartolas"])

    docs_files: Dict[str, List[str]] = {
        "contrato": files_contrato,
        "liquidaciones": files_liquidaciones,
        "afp": files_afp,
    }

    docs_estados: Dict[str, str] = {
        "contrato":      "subido" if files_contrato else "pendiente",
        "liquidaciones": "subido" if files_liquidaciones else "pendiente",
        "afp":           "subido" if files_afp else "pendiente",
    }

    done_total = sum(1 for k in ("contrato", "liquidaciones",
                     "afp") if docs_estados[k] != "pendiente")
    return docs_files, docs_estados, done_total


def _formatea_rut(rut_cuerpo: Any = None, rut_dv: Any = None, rut_str: Optional[str] = None) -> str:
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


def _nombre_trabajador(t: Any) -> str:
    """
    Construye el nombre completo del trabajador según los campos disponibles.
    """
    nombres = getattr(t, "nombres", "") or ""
    apellidos = getattr(t, "apellidos", "") or ""
    full = f"{nombres} {apellidos}".strip()
    return full or getattr(t, "nombre_completo", "") or ""


def _nombre_empleador(e: Any) -> str:
    """
    Usa razon_social si existe; si no, nombres + apellidos.
    """
    razon = getattr(e, "razon_social", "") or ""
    if razon.strip():
        return razon.strip()
    nombres = getattr(e, "nombres", "") or ""
    apellidos = getattr(e, "apellidos", "") or ""
    return f"{nombres} {apellidos}".strip()


# (Compatibilidad: si en algún lugar te sirve solo el estado)
def _scan_docs_estado(case_id: int) -> Dict[str, str]:
    rutas = _ensure_case_folders(case_id)

    def hay_archivos(path: str) -> bool:
        try:
            return any(
                os.path.isfile(os.path.join(path, fn))
                for fn in os.listdir(path)
            )
        except Exception:
            return False

    return {
        "contrato":      "subido" if hay_archivos(rutas["contratos"]) else "pendiente",
        "liquidaciones": "subido" if hay_archivos(rutas["liquidaciones"]) else "pendiente",
        "afp":           "subido" if hay_archivos(rutas["cartolas"]) else "pendiente",
    }


# ----------------------------- Rutas -----------------------------

@casos_bp.route("/casos/nuevo", methods=["GET", "POST"])
def nuevo():
    """
    Vista de creación de caso.
    - POST con accion=precrear: crea un caso preliminar (ID disponible) para habilitar carga de documentos.
    - POST con accion=guardar_docs: guarda los archivos en las carpetas del caso.
    - POST validado (sin 'precrear' ni 'guardar_docs'): crea el caso definitivo y redirige a /casos/<id>/editar.
    - GET: muestra el formulario vacío.

    Opción B aplicada: se envía show_resumen=False al template para ocultar el módulo "Resumen".
    """
    form = CasoForm()
    created_caso: Optional[Caso] = None

    # Datos para template
    docs_files: Dict[str, List[str]] = {}
    docs_estados: Dict[str, str] = {}
    docs_done_total: int = 0

    show_resumen = False
    if request.method == "POST":
        accion = (request.form.get("accion") or "").strip().lower()

        if accion == "precrear":
            # Pre-crea un caso para habilitar estructura de carpetas y subida de documentos
            t_id = _int_or_none(request.form.get("trabajador_id"))
            e_id = _int_or_none(request.form.get("empleador_id"))

            caso = Caso()
            _set_if_has(caso, "trabajador_id", t_id)
            _set_if_has(caso, "empleador_id", e_id)

            _set_if_has(caso, "tipo", getattr(form.tipo_caso, "data", None))
            _set_if_has(caso, "resumen",
                        (request.form.get("historia") or "").strip())
            _set_if_has(caso, "fecha_inicio", getattr(
                form.fecha_inicio, "data", None))
            _set_if_has(caso, "estado", "Recolección documental")

            db.session.add(caso)
            db.session.commit()

            try:
                db.session.refresh(caso)
            except Exception:
                caso = Caso.query.get(caso.id)

            # Asegurar carpetas y escanear estado/listado de documentos
            _ensure_case_folders(caso.id)
            docs_files, docs_estados, docs_done_total = _scan_docs_state(
                caso.id)

            created_caso = caso
            flash("Caso preliminar creado. Se habilita Documentos.", "success")

        elif accion == "guardar_docs":
            # 1) Validar caso
            caso_id = _int_or_none(request.form.get("caso_id"))
            if not caso_id:
                flash(
                    "Debes crear el caso preliminar antes de guardar documentos.", "warning")
                return redirect(url_for("casos.nuevo"))

            caso = Caso.query.get(caso_id)
            if not caso:
                flash("El caso no existe.", "error")
                return redirect(url_for("casos.nuevo"))

            # 2) Asegurar estructura de carpetas
            rutas = _ensure_case_folders(caso.id)

            # 3) Mapeo exacto a carpetas
            folder_map = {
                "contrato": rutas["contratos"],
                "liquidaciones": rutas["liquidaciones"],
                "afp": rutas["cartolas"],
            }

            # 4) Guardar archivos (soporta múltiples)
            claves = ["contrato", "liquidaciones", "afp"]
            total_guardados = 0

            for k in claves:
                files = request.files.getlist(
                    f"file-{k}")  # nombre del input file
                carpeta_destino = folder_map[k]

                for f in files:
                    if not f or not f.filename:
                        continue
                    fname = secure_filename(f.filename)
                    if not fname:
                        continue

                    dst = os.path.join(carpeta_destino, fname)
                    base, ext = os.path.splitext(dst)
                    i = 1
                    # evita sobrescribir
                    while os.path.exists(dst):
                        dst = f"{base} ({i}){ext}"
                        i += 1

                    f.save(dst)
                    total_guardados += 1

            if total_guardados > 0:
                flash(
                    f"Documentos guardados ({total_guardados} archivo(s)).", "success")
            else:
                flash("No se detectaron archivos para guardar.", "warning")

            # Tras guardar, ir a editar (ahí se listan los archivos ya subidos)
            return redirect(url_for("casos.editar", id=caso.id))

        elif accion == "guardar_caso":
            # 1) Validar caso
            caso_id = _int_or_none(request.form.get("caso_id"))
            if not caso_id:
                flash(
                    "Debes crear el caso preliminar antes de guardar cambios.", "warning")
                return redirect(url_for("casos.nuevo"))

            caso = Caso.query.get(caso_id)
            if not caso:
                flash("El caso no existe.", "error")
                return redirect(url_for("casos.nuevo"))

            # 2) Actualizar datos básicos (sin validar todo el form)
            t_id = _int_or_none(request.form.get("trabajador_id"))
            e_id = _int_or_none(request.form.get("empleador_id"))
            historia = (request.form.get("historia") or "").strip()

            _set_if_has(caso, "trabajador_id", t_id)
            _set_if_has(caso, "empleador_id", e_id)
            _set_if_has(caso, "resumen", historia)

            # (Opcional) permitir editar también otros campos aquí:
            # _set_if_has(caso, "tipo", getattr(form.tipo_caso, "data", None))
            # _set_if_has(caso, "fecha_inicio", getattr(form.fecha_inicio, "data", None))
            # _set_if_has(caso, "fecha_termino", getattr(form.fecha_termino, "data", None))
            # _set_if_has(caso, "causal", getattr(form.causal, "data", None))
            # _set_if_has(caso, "base_calculo", getattr(form.base_calculo, "data", None))

            db.session.commit()
            flash("Cambios del caso guardados.", "success")
            return redirect(url_for("casos.editar", id=caso.id))

        else:
            # Creación definitiva del caso (si el form es válido)
            if form.validate_on_submit():
                t_id = _int_or_none(request.form.get("trabajador_id"))
                e_id = _int_or_none(request.form.get("empleador_id"))
                trabajador = Trabajador.query.get(t_id) if t_id else None
                empleador = Empleador.query.get(e_id) if e_id else None

                caso = Caso(
                    tipo=getattr(form.tipo_caso, "data", None),
                    fecha_inicio=getattr(form.fecha_inicio, "data", None),
                    trabajador_id=trabajador.id if trabajador else None,
                    empleador_id=empleador.id if empleador else None,
                )
                _set_if_has(caso, "resumen",
                            (request.form.get("historia") or "").strip())
                _set_if_has(caso, "estado", request.form.get(
                    "estado") or "Recolección documental")

                db.session.add(caso)
                db.session.commit()

                try:
                    db.session.refresh(caso)
                except Exception:
                    caso = Caso.query.get(caso.id)

                _ensure_case_folders(caso.id)
                flash("Caso creado correctamente.", "success")
                return redirect(url_for("casos.editar", id=caso.id))
            else:
                # Form inválido; si hay caso_id, recalcular estado de docs para re-render
                flash("Revisa los campos del formulario.", "warning")
                caso_id = _int_or_none(request.form.get("caso_id"))
                if caso_id:
                    created_caso = Caso.query.get(caso_id)
                    if created_caso:
                        docs_files, docs_estados, docs_done_total = _scan_docs_state(
                            created_caso.id)

    # GET o POST procesado sin redirección → render
    return render_template(
        "casos/nuevo.html",
        form=form,
        caso=created_caso,
        show_resumen=show_resumen,
        docs_files=docs_files,
        docs_estados=docs_estados,
        docs_done_total=docs_done_total,
    )


@casos_bp.route("/casos/<int:id>", methods=["GET"])
def detalle(id: int):
    """
    Muestra el detalle de un caso específico.
    """
    caso = Caso.query.get_or_404(id)
    return render_template("casos/detalle.html", caso=caso)


@casos_bp.route("/casos/<int:id>/editar", methods=["GET"])
def editar(id: int):
    """
    Reutiliza la vista de creación para continuar el flujo con datos precargados.
    Opción B: show_resumen=False para ocultar el módulo "Resumen".
    """
    caso = Caso.query.get_or_404(id)
    form = CasoForm(obj=caso)
    show_resumen = False

    # Estado/listado de documentos para el template
    docs_files, docs_estados, docs_done_total = _scan_docs_state(caso.id)

    return render_template(
        "casos/nuevo.html",
        form=form,
        caso=caso,
        show_resumen=show_resumen,
        docs_files=docs_files,
        docs_estados=docs_estados,
        docs_done_total=docs_done_total,
    )


@casos_bp.route("/casos/<int:id>/generar", methods=["GET"])
def generar(id: int):
    """
    Placeholder temporal para generación de documentos/informes del caso.
    """
    caso = Caso.query.get_or_404(id)
    return render_template("casos/detalle.html", caso=caso)


@casos_bp.route("/casos/<int:id>/archivo/<tipo>/<path:filename>", methods=["GET"])
def descargar_archivo(id: int, tipo: str, filename: str):
    """
    Descarga/visualización de archivos del caso.
    tipo ∈ {'contratos','liquidaciones','cartolas'}
    """
    caso = Caso.query.get_or_404(id)
    rutas = _ensure_case_folders(caso.id)

    tipo = tipo.lower().strip()
    if tipo not in ("contratos", "liquidaciones", "cartolas"):
        flash("Tipo de archivo inválido.", "warning")
        return redirect(url_for("casos.editar", id=caso.id))

    folder = rutas[tipo]
    return send_from_directory(folder, filename, as_attachment=False)


# --------- NUEVA RUTA: FINIQUITO (pre-poblado desde el caso) ----------

@casos_bp.route("/casos/<int:id>/finiquito", methods=["GET", "POST"])
def finiquito(id: int):
    """
    Muestra el formulario de finiquito del caso y pre-puebla identificación
    (trabajador y empleador) desde los datos del caso.

    GET:
        - Prellena trabajador_nombre, trabajador_rut, empleador_nombre, empleador_rut.
    POST:
        - Por ahora no calcula; deja preparado para conectar la lógica de cálculo.
    """
    caso = Caso.query.get_or_404(id)

    t = getattr(caso, "trabajador", None)
    e = getattr(caso, "empleador", None)
    if not t or not e:
        flash("Debes asociar un trabajador y un empleador al caso antes de iniciar el finiquito.", "warning")
        return redirect(url_for("casos.editar", id=caso.id))

    form = FiniquitoForm()

    # Prefill en GET o cuando el POST no valida
    if request.method == "GET" or not form.validate_on_submit():
        # Nombres
        form.trabajador_nombre.data = _nombre_trabajador(t)
        form.empleador_nombre.data = _nombre_empleador(e)

        # RUT trabajador
        if hasattr(t, "rut_cuerpo") and hasattr(t, "rut_dv"):
            form.trabajador_rut.data = _formatea_rut(t.rut_cuerpo, t.rut_dv)
        else:
            form.trabajador_rut.data = _formatea_rut(
                rut_str=getattr(t, "rut", ""))

        # RUT empleador
        if hasattr(e, "rut_cuerpo") and hasattr(e, "rut_dv"):
            form.empleador_rut.data = _formatea_rut(e.rut_cuerpo, e.rut_dv)
        else:
            form.empleador_rut.data = _formatea_rut(
                rut_str=getattr(e, "rut", ""))

    if form.validate_on_submit():
        # Aquí conectarás tu cálculo y armado de resultados
        # resultados = calcular_finiquito(form.data)
        flash("Datos de identificación cargados. Continúa con el llenado del finiquito.", "info")

    return render_template(
        "casos/finiquito.html",
        form=form,
        caso=caso,
        trabajador=t,
        empleador=e,
    )
