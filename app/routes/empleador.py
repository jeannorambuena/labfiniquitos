from flask import Blueprint, render_template, request, redirect, url_for, flash
from app.models.empleador import Empleador
from app.forms.empleador_form import EmpleadorForm
from app.extensions.extensions import db

empleador_bp = Blueprint('empleador', __name__, url_prefix='/empleador')


@empleador_bp.route('/')
def index():
    empleadores = Empleador.query.order_by(Empleador.razon_social).all()
    return render_template('empleador/index.html', empleadores=empleadores)


@empleador_bp.route('/nuevo', methods=['GET', 'POST'])
def nuevo():
    form = EmpleadorForm()
    if form.validate_on_submit():
        rut_existente = Empleador.query.filter_by(
            rut_cuerpo=form.rut_cuerpo.data,
            rut_dv=form.rut_dv.data.upper()
        ).first()
        if rut_existente:
            flash('El RUT ya está registrado en otro empleador.', 'warning')
            return render_template('empleador/nuevo.html', form=form)
        nuevo_empleador = Empleador(
            rut_cuerpo=form.rut_cuerpo.data,
            rut_dv=form.rut_dv.data.upper(),
            razon_social=form.razon_social.data,
            direccion=form.direccion.data,
            telefono=form.telefono.data,
            email=form.email.data
        )
        db.session.add(nuevo_empleador)
        db.session.commit()
        flash('Empleador creado correctamente.', 'success')
        return redirect(url_for('empleador.index'))
    return render_template('empleador/nuevo.html', form=form)


@empleador_bp.route('/editar/<int:id>', methods=['GET', 'POST'])
def editar(id):
    empleador = Empleador.query.get_or_404(id)
    form = EmpleadorForm(obj=empleador)
    if form.validate_on_submit():
        rut_existente = Empleador.query.filter(
            Empleador.rut_cuerpo == form.rut_cuerpo.data,
            Empleador.rut_dv == form.rut_dv.data.upper(),
            Empleador.id != id
        ).first()
        if rut_existente:
            flash('El RUT ya está registrado en otro empleador.', 'warning')
            return render_template('empleador/editar.html', form=form, empleador=empleador)
        form.populate_obj(empleador)
        empleador.rut_dv = empleador.rut_dv.upper()
        db.session.commit()
        flash('Empleador actualizado correctamente.', 'success')
        return redirect(url_for('empleador.index'))
    return render_template('empleador/editar.html', form=form, empleador=empleador)


@empleador_bp.route('/eliminar/<int:id>', methods=['POST'])
def eliminar(id):
    empleador = Empleador.query.get_or_404(id)
    db.session.delete(empleador)
    db.session.commit()
    flash('Empleador eliminado correctamente.', 'success')
    return redirect(url_for('empleador.index'))
