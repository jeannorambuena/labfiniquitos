"""
Módulo de rutas para la gestión de trabajadores.

Incluye:
- Listado conectado a la base de datos
- Formulario de creación con almacenamiento real
- Uso de plantilla estilizada coherente con el diseño del sistema
- Endpoint API para verificación instantánea de RUT
- Endpoint API para obtener detalles completos por RUT

Autor: Jean Paul Norambuena
Proyecto: labfiniquito
"""

from flask import request, redirect, url_for, flash, render_template, jsonify
from app.forms.trabajador_form import TrabajadorForm
from app.models.trabajador import Trabajador
from app import db
from flask import Blueprint

# Blueprint modular para trabajadores
trabajadores_bp = Blueprint(
    'trabajadores', __name__, url_prefix='/trabajadores')


@trabajadores_bp.route('/')
def index():
    """
    Vista principal del módulo Trabajadores.

    Obtiene todos los trabajadores desde la base de datos y los muestra en tabla.

    Returns:
        Render de la plantilla trabajadores/index.html con trabajadores reales.
    """
    trabajadores = Trabajador.query.order_by(Trabajador.nombre).all()
    return render_template('trabajadores/index.html', trabajadores=trabajadores)


@trabajadores_bp.route('/nuevo', methods=['GET', 'POST'])
def nuevo():
    """
    Vista para crear un nuevo trabajador.

    Procesa el formulario y guarda el registro en la base de datos.

    Returns:
        Redirección a la vista principal si se guarda correctamente.
        Render del formulario si es GET o si hay errores de validación.
    """
    form = TrabajadorForm()
    if form.validate_on_submit():
        nuevo_trabajador = Trabajador(
            rut_cuerpo=form.rut_cuerpo.data.strip(),
            rut_dv=form.rut_dv.data.strip().upper(),
            nombre=form.nombre.data.strip(),
            apellido_paterno=form.apellido_paterno.data.strip(),
            apellido_materno=form.apellido_materno.data.strip(
            ) if form.apellido_materno.data else None,
            fecha_nacimiento=form.fecha_nacimiento.data,
            direccion=form.direccion.data.strip() if form.direccion.data else None,
            telefono=form.telefono.data.strip() if form.telefono.data else None,
            email=form.email.data.strip() if form.email.data else None,
            activo=form.activo.data
        )
        db.session.add(nuevo_trabajador)
        db.session.commit()
        flash('✅ Trabajador registrado correctamente.', 'success')
        return redirect(url_for('trabajadores.index'))

    return render_template('trabajadores/nuevo.html', form=form)


@trabajadores_bp.route('/<int:id>/editar', methods=['GET', 'POST'])
def editar(id):
    """
    Vista para editar un trabajador existente.

    Permite cargar los datos del trabajador, editarlos y guardarlos.

    Args:
        id (int): ID del trabajador a editar.

    Returns:
        Redirección a la vista principal si se guarda correctamente.
        Render del formulario con datos cargados si es GET o hay errores de validación.
    """
    trabajador = Trabajador.query.get_or_404(id)
    form = TrabajadorForm(obj=trabajador)
    if form.validate_on_submit():
        # Carga todos los datos del form en el objeto
        form.populate_obj(trabajador)
        db.session.commit()
        flash('✅ Trabajador actualizado correctamente.', 'success')
        return redirect(url_for('trabajadores.index'))
    return render_template('trabajadores/editar.html', form=form, trabajador=trabajador)


@trabajadores_bp.route('/<int:id>/eliminar', methods=['POST', 'GET'])
def eliminar(id):
    """
    Vista para eliminar un trabajador existente.

    Permite borrar el registro de la base de datos. Al finalizar,
    redirige al listado de trabajadores con mensaje de confirmación.

    Args:
        id (int): ID del trabajador a eliminar.

    Returns:
        Redirección a la vista principal tras la eliminación.
    """
    trabajador = Trabajador.query.get_or_404(id)
    db.session.delete(trabajador)
    db.session.commit()
    flash('⚠️ Trabajador eliminado correctamente.', 'warning')
    return redirect(url_for('trabajadores.index'))


@trabajadores_bp.route('/api/trabajador/existe')
def existe_trabajador():
    """
    Endpoint API para verificar si un trabajador con el RUT dado existe.

    Query params:
        rut_cuerpo (str): Parte numérica del RUT, sin puntos.
        rut_dv (str): Dígito verificador.

    Returns:
        JSON: {'existe': True/False}
    """
    rut_cuerpo = request.args.get('rut_cuerpo', '').strip()
    rut_dv = request.args.get('rut_dv', '').strip().upper()

    if not rut_cuerpo or not rut_dv:
        return jsonify({'existe': False, 'error': 'Faltan parámetros.'}), 400

    existe = db.session.query(
        Trabajador.id
    ).filter_by(rut_cuerpo=rut_cuerpo, rut_dv=rut_dv).first() is not None

    return jsonify({'existe': existe})


@trabajadores_bp.route('/api/trabajador/detalle', methods=['GET'])
def detalle_trabajador():
    """
    Endpoint API para obtener los datos completos de un trabajador por RUT.

    Query params:
        rut_cuerpo (str): Parte numérica del RUT, sin puntos.
        rut_dv (str): Dígito verificador.

    Returns:
        JSON: {'ok': True, 'trabajador': {...}} o {'ok': False, 'msg': ...}
    """
    rut_cuerpo = request.args.get('rut_cuerpo', '').strip()
    rut_dv = request.args.get('rut_dv', '').strip().upper()

    if not rut_cuerpo or not rut_dv:
        return jsonify({'ok': False, 'msg': 'Faltan parámetros.'}), 400

    trabajador = Trabajador.query.filter_by(
        rut_cuerpo=rut_cuerpo, rut_dv=rut_dv).first()
    if trabajador:
        return jsonify({
            "ok": True,
            "trabajador": {
                "nombre": trabajador.nombre,
                "apellido_paterno": trabajador.apellido_paterno,
                "apellido_materno": trabajador.apellido_materno,
                "fecha_nacimiento": trabajador.fecha_nacimiento.strftime('%Y-%m-%d') if trabajador.fecha_nacimiento else "",
                "email": trabajador.email or "",
                "telefono": trabajador.telefono or "",
                "direccion": trabajador.direccion or ""
            }
        })
    else:
        return jsonify({'ok': False, 'msg': 'Trabajador no encontrado.'}), 404
