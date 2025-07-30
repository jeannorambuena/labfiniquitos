"""
Formulario Flask-WTF para la creación y edición de trabajadores.

Campos incluidos:
- Nombres
- Apellidos
- RUT (con validación básica)
- Cargo
- Estado activo (checkbox)

Autor: Jean Paul Norambuena
Proyecto: labfiniquito
"""

from flask_wtf import FlaskForm
from wtforms import StringField, BooleanField, SubmitField
from wtforms.validators import DataRequired, Length


class TrabajadorForm(FlaskForm):
    """Formulario para registrar o editar un trabajador."""
    nombres = StringField('Nombres', validators=[
                          DataRequired(), Length(min=2, max=100)])
    apellidos = StringField('Apellidos', validators=[
                            DataRequired(), Length(min=2, max=100)])
    rut = StringField('RUT', validators=[
                      DataRequired(), Length(min=9, max=12)])
    cargo = StringField('Cargo', validators=[
                        DataRequired(), Length(min=2, max=50)])
    activo = BooleanField('Activo')

    submit = SubmitField('Guardar')
