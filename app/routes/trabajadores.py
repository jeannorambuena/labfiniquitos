"""
Rutas para la gestión de Trabajadores.

Incluye:
- Listado y búsqueda
- Creación, edición y eliminación
- Validación de RUT vía API para uso en formularios con JavaScript
"""

from flask import Blueprint, render_template, request, redirect, url_for, flash, jsonify
from app.models.trabajador import Trabajador
from app.forms.trabajador_form import TrabajadorForm
from app.extensions.extensions import db

# Nombre correcto del blueprint para __init__.py
trabajadores_bp = Blueprint(
    'trabajadores', __name__, url_prefix='/trabajadores')


@trabajadores_bp.route('/')
def index():
    """
    Lista todos los trabajadores, ordenados por apellido paterno, luego materno y nombre.
    """
    trabajadores = Trabajador.query.order_by(
        Trabajador.apellido_paterno,
        Trabajador.apellido_materno,
        Trabajador.nombre
    ).all()
    return render_template('trabajadores/index.html', trabajadores=trabajadores)


@trabajadores_bp.route('/nuevo', methods=['GET', 'POST'])
def nuevo():
    """
    Crea un nuevo trabajador validando que el RUT no exista previamente.
    """
    form = TrabajadorForm()
    if form.validate_on_submit():
        rut_existente = Trabajador.query.filter_by(
            rut_cuerpo=form.rut_cuerpo.data,
            rut_dv=form.rut_dv.data.upper()
        ).first()
        if rut_existente:
            flash('El RUT ya está registrado en otro trabajador.', 'warning')
            return render_template('trabajadores/nuevo.html', form=form)

        nuevo_trabajador = Trabajador(
            rut_cuerpo=form.rut_cuerpo.data,
            rut_dv=form.rut_dv.data.upper(),
            nombre=form.nombre.data,
            apellido_paterno=form.apellido_paterno.data,
            apellido_materno=form.apellido_materno.data,
            fecha_nacimiento=form.fecha_nacimiento.data,
            direccion=form.direccion.data,
            telefono=form.telefono.data,
            email=form.email.data
        )
        db.session.add(nuevo_trabajador)
        db.session.commit()
        flash('Trabajador creado correctamente.', 'success')
        return redirect(url_for('trabajadores.index'))

    return render_template('trabajadores/nuevo.html', form=form)


@trabajadores_bp.route('/editar/<int:id>', methods=['GET', 'POST'])
def editar(id):
    """
    Edita los datos de un trabajador existente, validando que el nuevo RUT no esté en otro registro.
    """
    trabajador = Trabajador.query.get_or_404(id)
    form = TrabajadorForm(obj=trabajador)

    if form.validate_on_submit():
        rut_existente = Trabajador.query.filter(
            Trabajador.rut_cuerpo == form.rut_cuerpo.data,
            Trabajador.rut_dv == form.rut_dv.data.upper(),
            Trabajador.id != id
        ).first()
        if rut_existente:
            flash('El RUT ya está registrado en otro trabajador.', 'warning')
            return render_template('trabajadores/editar.html', form=form, trabajador=trabajador)

        form.populate_obj(trabajador)
        trabajador.rut_dv = trabajador.rut_dv.upper()
        db.session.commit()
        flash('Trabajador actualizado correctamente.', 'success')
        return redirect(url_for('trabajadores.index'))

    return render_template('trabajadores/editar.html', form=form, trabajador=trabajador)


@trabajadores_bp.route('/eliminar/<int:id>', methods=['POST'])
def eliminar(id):
    """
    Elimina un trabajador de la base de datos.
    """
    trabajador = Trabajador.query.get_or_404(id)
    db.session.delete(trabajador)
    db.session.commit()
    flash('Trabajador eliminado correctamente.', 'success')
    return redirect(url_for('trabajadores.index'))


# 📌 Endpoint API para validación de RUT (usado por rut_utils.js)
@trabajadores_bp.route('/api/trabajador/existe', methods=['GET'])
def api_trabajador_existe():
    """
    Endpoint para validar si un trabajador ya existe según su RUT.
    Uso:
        GET /trabajadores/api/trabajador/existe?rut_cuerpo=12345678&rut_dv=K
    Retorna:
        { "existe": true } o { "existe": false }
    """
    rut_cuerpo = request.args.get('rut_cuerpo', '').strip()
    rut_dv = request.args.get('rut_dv', '').strip().upper()

    existe = False
    if rut_cuerpo and rut_dv:
        existe = Trabajador.query.filter_by(
            rut_cuerpo=rut_cuerpo,
            rut_dv=rut_dv
        ).first() is not None

    return jsonify({"existe": existe})
