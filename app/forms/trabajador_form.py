"""
Formulario WTForms para Trabajador con validación profesional de RUT chileno.
Alineado con el modelo de datos moderno (campos rut_cuerpo y rut_dv separados).
"""

from flask_wtf import FlaskForm
from wtforms import StringField, BooleanField, DateField
from wtforms.validators import DataRequired, Email, Length, Optional, ValidationError

# Importar la función de validación desde tu utilitario
from app.utils.validator import validar_rut


class TrabajadorForm(FlaskForm):
    """
    Formulario para creación/edición de Trabajador en el sistema.
    """

    rut_cuerpo = StringField('RUT (cuerpo, solo números)', validators=[
        DataRequired(message="Ingrese el número de RUT."),
        Length(min=7, max=8, message="El RUT debe tener entre 7 y 8 dígitos numéricos.")
    ])
    rut_dv = StringField('Dígito verificador', validators=[
        DataRequired(message="Ingrese el dígito verificador."),
        Length(min=1, max=1, message="El dígito verificador debe ser un solo carácter.")
    ])
    nombre = StringField('Nombre', validators=[
        DataRequired(), Length(min=2, max=80)])
    apellido_paterno = StringField('Apellido paterno', validators=[
        DataRequired(), Length(min=2, max=60)])
    apellido_materno = StringField('Apellido materno', validators=[
        Optional(), Length(min=2, max=60)])
    fecha_nacimiento = DateField(
        'Fecha de nacimiento', format='%Y-%m-%d', validators=[Optional()])
    email = StringField('Correo Electrónico', validators=[
        Optional(), Email(), Length(max=120)])
    telefono = StringField('Teléfono', validators=[
        Optional(), Length(min=8, max=20)])
    direccion = StringField('Dirección', validators=[
        Optional(), Length(max=180)])
    activo = BooleanField('¿Está activo?', default=True)

    def validate(self, extra_validators=None):
        """
        Valida el RUT usando el validador profesional externo.
        Llama a la validación estándar y luego agrega la validación custom.
        """
        # Primero corre las validaciones estándar
        if not super().validate(extra_validators):
            return False

        # Validación custom de RUT (usa el archivo app/utils/validator.py)
        valido, mensaje = validar_rut(self.rut_cuerpo.data, self.rut_dv.data)
        if not valido:
            self.rut_cuerpo.errors.append(mensaje)
            return False

        return True
