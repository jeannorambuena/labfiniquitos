from flask import Blueprint, render_template, request, redirect, url_for, flash
from app.forms.casos_form import CasoForm
from app.extensions.extensions import db

from app.models.trabajador import Trabajador
from app.models.empleador import Empleador

# Import robusto del modelo de Caso
import importlib
import inspect
try:
    from app.models.caso import Caso  # nombre esperado
except Exception:
    caso_mod = importlib.import_module('app.models.caso')
    Caso = None
    for name in ('Caso', 'CasoLaboral', 'CasoModel', 'Case', 'Casos'):
        cls = getattr(caso_mod, name, None)
        if cls is not None:
            Caso = cls
            break
    if Caso is None:
        disponibles = [n for n, obj in inspect.getmembers(
            caso_mod) if inspect.isclass(obj)]
        raise ImportError(
            f"No se encontró la clase del modelo de Caso en app.models.caso. "
            f"Clases disponibles: {disponibles}. Ajusta el nombre en routes/casos.py."
        )

casos_bp = Blueprint('casos', __name__)


@casos_bp.route('/casos', methods=['GET'])
def index():
    casos = []  # carga real desde BD se integrará después
    return render_template('casos/index.html', casos=casos)


@casos_bp.route("/casos/nuevo", methods=["GET", "POST"])
def nuevo():
    form = CasoForm()

    if request.method == "POST" and form.validate_on_submit():
        t_id = request.form.get("trabajador_id") or None
        e_id = request.form.get("empleador_id") or None

        trabajador = Trabajador.query.get(t_id) if t_id else None
        empleador = Empleador.query.get(e_id) if e_id else None

        rut_trab = (form.rut_trabajador.data or "").strip()
        rut_empl = (form.rut_empleador.data or "").strip()

        if not trabajador and rut_trab:
            trabajador = Trabajador.query.filter(
                Trabajador.rut == rut_trab).first()

        if not empleador and rut_empl:
            empleador = Empleador.query.filter(
                Empleador.rut == rut_empl).first()

        caso = Caso(
            tipo_caso=form.tipo_caso.data,
            causal=form.causal.data,
            fecha_inicio=form.fecha_inicio.data,
            fecha_termino=form.fecha_termino.data or None,
            base_calculo=form.base_calculo.data,
            trabajador_id=trabajador.id if trabajador else None,
            empleador_id=empleador.id if empleador else None,
        )

        db.session.add(caso)
        db.session.commit()

        if not trabajador and not empleador:
            flash(
                "Caso creado sin trabajador ni empleador vinculados. Podrás asociarlos más tarde.", "warning")
        elif not trabajador:
            flash("Caso creado. Empleador vinculado; trabajador pendiente.", "warning")
        elif not empleador:
            flash("Caso creado. Trabajador vinculado; empleador pendiente.", "warning")
        else:
            flash("Caso creado correctamente.", "success")

        try:
            return redirect(url_for("casos.detalle", id=caso.id))
        except Exception:
            return redirect(url_for("casos.index"))

    return render_template("casos/nuevo.html", form=form)
