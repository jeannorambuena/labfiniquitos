# app/forms/empleador_form.py

from flask_wtf import FlaskForm
from wtforms import StringField
from wtforms.validators import DataRequired, Length, Email, Regexp, Optional


class EmpleadorForm(FlaskForm):
    rut_cuerpo = StringField(
        'RUT cuerpo',
        validators=[
            DataRequired(message="El RUT es obligatorio"),
            Length(min=7, max=8, message="Debe tener entre 7 y 8 dígitos"),
            Regexp(r'^\d{7,8}$', message="Sólo números en el cuerpo del RUT")
        ]
    )
    rut_dv = StringField(
        'Dígito verificador',
        validators=[
            DataRequired(message="El dígito verificador es obligatorio"),
            Length(min=1, max=1),
            Regexp(r'^[0-9kK]{1}$', message="Debe ser un dígito o letra K")
        ]
    )
    razon_social = StringField(
        'Razón social',
        validators=[
            DataRequired(message="La razón social es obligatoria"),
            Length(max=255)
        ]
    )
    direccion = StringField(
        'Dirección',
        validators=[
            Optional(),
            Length(max=255)
        ]
    )
    telefono = StringField(
        'Teléfono',
        validators=[
            Optional(),
            Length(max=50)
        ]
    )
    email = StringField(
        'Email',
        validators=[
            Optional(),
            Length(max=255),
            Email(message="Correo electrónico inválido")
        ]
    )
