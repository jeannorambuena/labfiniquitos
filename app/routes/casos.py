from flask import Blueprint, render_template, request, redirect, url_for, flash
from app.forms.casos_form import CasoForm

casos_bp = Blueprint('casos', __name__)


@casos_bp.route('/casos', methods=['GET'])
def index():
    casos = []  # Aquí se cargará desde la BD en el futuro
    return render_template('casos/index.html', casos=casos)


@casos_bp.route('/casos/nuevo', methods=['GET', 'POST'])
def nuevo():
    form = CasoForm()
    if request.method == 'POST' and form.validate_on_submit():
        flash("Caso creado con éxito.", "success")
        return redirect(url_for('casos.index'))
    return render_template('casos/nuevo.html', form=form)
