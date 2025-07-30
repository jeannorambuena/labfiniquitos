"""
Módulo de rutas para la gestión de trabajadores.

Incluye:
- Ruta para visualizar listado de trabajadores
- Integración con plantilla index.html (estilizada)
- Listado inicial simulado (hasta que se conecte con la BD)

Autor: Jean Paul Norambuena
Proyecto: labfiniquito
"""

from flask import request, redirect, url_for, flash
from app.forms.trabajador_form import TrabajadorForm
from flask import Blueprint, render_template

# Blueprint modular para trabajadores
trabajadores_bp = Blueprint(
    'trabajadores', __name__, url_prefix='/trabajadores')


@trabajadores_bp.route('/')
def index():
    """
    Vista principal del módulo Trabajadores.

    Retorna:
        Render de la plantilla trabajadores/index.html con lista simulada.
    """
    trabajadores = [
        {"nombre": "Juan Soto", "rut": "12.345.678-9",
            "cargo": "Chofer", "activo": True},
        {"nombre": "Marcela Díaz", "rut": "9.876.543-2",
            "cargo": "Ayudante", "activo": False},
    ]
    return render_template('trabajadores/index.html', trabajadores=trabajadores)


@trabajadores_bp.route('/nuevo', methods=['GET', 'POST'])
def nuevo():
    """
    Vista para crear un nuevo trabajador.

    Renderiza formulario y procesa su envío.
    """
    form = TrabajadorForm()
    if form.validate_on_submit():
        # Aquí irá la lógica real con el modelo y la BD
        flash('Trabajador registrado correctamente ✅', 'success')
        return redirect(url_for('trabajadores.index'))

    return render_template('trabajadores/nuevo.html', form=form)
