from flask_wtf import FlaskForm
from wtforms import StringField, SelectField, DateField, DecimalField, SubmitField
from wtforms.validators import DataRequired, Optional


class CasoForm(FlaskForm):
    tipo_caso = SelectField(
        "Tipo de Caso",
        choices=[
            ("", "Seleccione..."),
            ("despido", "Despido"),
            ("autodespido", "Autodespido"),
            ("renuncia", "Renuncia")
        ],
        validators=[DataRequired(message="Selecciona el tipo de caso.")]
    )
    causal = StringField("Causal Legal", validators=[Optional()])
    fecha_inicio = DateField("Fecha Inicio", validators=[DataRequired()])
    fecha_termino = DateField("Fecha Término", validators=[DataRequired()])
    base_calculo = DecimalField(
        "Base de Cálculo", places=2, validators=[Optional()])

    rut_trabajador = StringField("RUT Trabajador", validators=[Optional()])
    rut_empleador = StringField("RUT Empleador", validators=[Optional()])

    submit = SubmitField("Guardar Caso")
