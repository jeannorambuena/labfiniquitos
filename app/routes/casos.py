from flask import Blueprint, render_template, request, redirect, url_for, flash, current_app, abort
from app.forms.casos_form import CasoForm
from app.extensions.extensions import db
import os

# Modelos
from app.models.trabajador import Trabajador
from app.models.empleador import Empleador
from app.models.caso import Caso

casos_bp = Blueprint('casos', __name__)


@casos_bp.route('/casos', methods=['GET'])
def index():
    # Listado simple (últimos primero). Tus filtros de la UI siguen funcionando (de momento no se aplican en backend).
    casos = Caso.query.order_by(Caso.id.desc()).all()
    return render_template('casos/index.html', casos=casos)


def _int_or_none(v):
    try:
        if v is None:
            return None
        v = str(v).strip()
        return int(v) if v else None
    except Exception:
        return None


def _set_if_has(obj, attr, value):
    """Asigna sólo si el atributo existe en el modelo (defensivo)."""
    try:
        if hasattr(obj.__class__, attr):
            setattr(obj, attr, value)
    except Exception:
        pass


def _ensure_case_folders(case_id: int):
    """
    Crea las carpetas exactas para el caso:
    <ROOT>\{ID}\fuentes\contratos\
    <ROOT>\{ID}\fuentes\liquidaciones\
    <ROOT>\{ID}\fuentes\cartolas\
    """
    base_root = current_app.config.get(
        'UPLOAD_CASES_ROOT',
        r'C:\wamp64\www\labfiniquito\uploads\casos'
    )
    root = os.path.join(base_root, str(case_id))
    contratos = os.path.join(root, 'fuentes', 'contratos')
    liquidaciones = os.path.join(root, 'fuentes', 'liquidaciones')
    cartolas = os.path.join(root, 'fuentes', 'cartolas')

    for p in (contratos, liquidaciones, cartolas):
        os.makedirs(p, exist_ok=True)

    return {
        'root': root,
        'contratos': contratos,
        'liquidaciones': liquidaciones,
        'cartolas': cartolas,
    }


@casos_bp.route("/casos/nuevo", methods=["GET", "POST"])
def nuevo():
    form = CasoForm()
    created_caso = None
    carpetas_info = None

    if request.method == "POST":
        accion = (request.form.get("accion") or "").strip().lower()

        if accion == "precrear":
            # IDs ocultos desde los modales
            t_id = _int_or_none(request.form.get("trabajador_id"))
            e_id = _int_or_none(request.form.get("empleador_id"))

            caso = Caso()

            # FKs
            _set_if_has(caso, 'trabajador_id', t_id)
            _set_if_has(caso, 'empleador_id', e_id)

            # Mapeos a tu tabla real:
            _set_if_has(caso, 'tipo', getattr(
                form.tipo_caso, 'data', None))  # tipo_caso -> tipo
            _set_if_has(caso, 'resumen', (request.form.get(
                'historia') or '').strip())  # historia -> resumen
            _set_if_has(caso, 'fecha_inicio', getattr(
                form.fecha_inicio, 'data', None))
            _set_if_has(caso, 'estado', 'Recolección documental')

            db.session.add(caso)
            db.session.commit()  # caso.id asignado

            # Refrescar para leer campos generados por trigger (codigo, nombre_caso)
            try:
                db.session.refresh(caso)
            except Exception:
                caso = Caso.query.get(caso.id)

            # Crear carpetas requeridas
            carpetas_info = _ensure_case_folders(caso.id)

            flash(
                "Caso preliminar creado. Se habilitará la sección de Documentos.", "success")
            created_caso = caso

        else:
            # Flujo clásico (si lo usas más adelante)
            if form.validate_on_submit():
                t_id = _int_or_none(request.form.get("trabajador_id"))
                e_id = _int_or_none(request.form.get("empleador_id"))
                trabajador = Trabajador.query.get(t_id) if t_id else None
                empleador = Empleador.query.get(e_id) if e_id else None

                caso = Caso(
                    tipo=getattr(form.tipo_caso, 'data', None),
                    fecha_inicio=getattr(form.fecha_inicio, 'data', None),
                    trabajador_id=trabajador.id if trabajador else None,
                    empleador_id=empleador.id if empleador else None,
                )
                _set_if_has(caso, 'resumen',
                            (request.form.get('historia') or '').strip())
                _set_if_has(caso, 'estado', request.form.get(
                    'estado') or 'Recolección documental')

                db.session.add(caso)
                db.session.commit()

                try:
                    db.session.refresh(caso)
                except Exception:
                    caso = Caso.query.get(caso.id)

                carpetas_info = _ensure_case_folders(caso.id)

                flash("Caso creado correctamente.", "success")
                return redirect(url_for("casos.detalle", id=caso.id))
            else:
                flash("Revisa los campos del formulario.", "warning")

    # GET o POST (precrear) -> render con posible 'created_caso' y 'carpetas_info'
    return render_template("casos/nuevo.html", form=form, caso=created_caso, carpetas=carpetas_info)


# -------------------- Rutas adicionales para enlaces del índice --------------------

@casos_bp.route("/casos/<int:id>", methods=["GET"])
def detalle(id: int):
    caso = Caso.query.get_or_404(id)
    return render_template("casos/detalle.html", caso=caso)


@casos_bp.route("/casos/<int:id>/editar", methods=["GET"])
def editar(id: int):
    # Placeholder de momento
    caso = Caso.query.get_or_404(id)
    flash("Pantalla de edición en construcción.", "info")
    return render_template("casos/detalle.html", caso=caso)


@casos_bp.route("/casos/<int:id>/generar", methods=["GET"])
def generar(id: int):
    # Placeholder de momento
    caso = Caso.query.get_or_404(id)
    flash("Sección de generación de informes en construcción.", "info")
    return render_template("casos/detalle.html", caso=caso)
