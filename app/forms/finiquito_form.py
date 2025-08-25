from flask_wtf import FlaskForm
from wtforms import (
    StringField,
    DateField,
    SelectField,
    DecimalField,
    IntegerField,
)
from wtforms.validators import DataRequired, NumberRange, Optional


class FiniquitoForm(FlaskForm):
    # Identificación del trabajador y empleador
    trabajador_nombre = StringField(
        'Nombre trabajador',
        validators=[DataRequired(message='Ingrese el nombre del trabajador')]
    )
    trabajador_rut = StringField(
        'RUT trabajador',
        validators=[DataRequired(message='Ingrese el RUT del trabajador')]
    )
    empleador_nombre = StringField(
        'Razón social empleador',
        validators=[DataRequired(
            message='Ingrese la razón social del empleador')]
    )
    empleador_rut = StringField(
        'RUT empleador',
        validators=[DataRequired(message='Ingrese el RUT del empleador')]
    )

    # Datos del contrato
    fecha_inicio = DateField(
        'Fecha inicio',
        format='%Y-%m-%d',
        validators=[DataRequired(message='Ingrese la fecha de inicio')]
    )
    fecha_termino = DateField(
        'Fecha término',
        format='%Y-%m-%d',
        validators=[DataRequired(message='Ingrese la fecha de término')]
    )
    causal_termino = SelectField(
        'Causal de término',
        choices=[
            ('', 'Seleccione'),
            ('159-1', 'Mutuo acuerdo'),
            ('159-2', 'Renuncia del trabajador'),
            ('159-3', 'Muerte del trabajador'),
            ('159-4', 'Vencimiento del plazo convenido'),
            ('159-5', 'Conclusión del trabajo o servicio'),
            ('159-6', 'Caso fortuito o fuerza mayor'),
            ('160-1', 'Falta grave de probidad u otra conducta indebida'),
            ('160-2', 'Negociación prohibida'),
            ('160-3', 'Inasistencia o abandono injustificado'),
            ('160-4', 'Actos u omisiones temerarias'),
            ('160-5', 'Daño intencional a bienes del empleador'),
            ('160-6', 'Incumplimiento grave de obligaciones'),
            ('161', 'Necesidades de la empresa'),
            ('161-desahucio', 'Desahucio escrito del empleador'),
            ('163-bis', 'Liquidación de la empresa'),
        ],
        validators=[DataRequired(message='Seleccione la causal de término')]
    )
    tipo_jornada = SelectField(
        'Tipo de jornada',
        choices=[
            ('', 'Seleccione'),
            ('completa', 'Jornada completa'),
            ('parcial', 'Jornada parcial'),
            ('especial_transporte', 'Especial transporte interurbano'),
        ],
        validators=[DataRequired(message='Seleccione el tipo de jornada')]
    )
    remuneracion_base = DecimalField(
        'Sueldo base (último mes)',
        places=2,
        validators=[DataRequired(
            message='Ingrese el sueldo base'), NumberRange(min=0)]
    )

    # Haberes y tiempos
    gratificacion = DecimalField(
        'Gratificación mensual',
        places=2,
        default=0,
        validators=[Optional(), NumberRange(min=0)]
    )
    comisiones = DecimalField(
        'Promedio comisiones (3 meses)',
        places=2,
        default=0,
        validators=[Optional(), NumberRange(min=0)]
    )
    semana_corrida = DecimalField(
        'Promedio semana corrida (3 meses)',
        places=2,
        default=0,
        validators=[Optional(), NumberRange(min=0)]
    )
    bonos = DecimalField(
        'Promedio bonos/incentivos (3 meses)',
        places=2,
        default=0,
        validators=[Optional(), NumberRange(min=0)]
    )
    horas_espera = DecimalField(
        'Horas de espera (último mes)',
        places=2,
        default=0,
        validators=[Optional(), NumberRange(min=0)]
    )
    horas_extra = DecimalField(
        'Horas extras',
        places=2,
        default=0,
        validators=[Optional(), NumberRange(min=0)]
    )

    # Vacaciones y descuentos
    dias_vac_pendientes = IntegerField(
        'Días de vacaciones pendientes',
        default=0,
        validators=[Optional(), NumberRange(min=0)]
    )
    afp = DecimalField(
        'Descuento AFP',
        places=2,
        default=0,
        validators=[Optional(), NumberRange(min=0)]
    )
    salud = DecimalField(
        'Descuento salud',
        places=2,
        default=0,
        validators=[Optional(), NumberRange(min=0)]
    )
    cesantia = DecimalField(
        'Descuento seguro de cesantía',
        places=2,
        default=0,
        validators=[Optional(), NumberRange(min=0)]
    )
    otros_descuentos = DecimalField(
        'Otros descuentos',
        places=2,
        default=0,
        validators=[Optional(), NumberRange(min=0)]
    )

    # Ejemplo de validador opcional para que la fecha de término no sea anterior a la de inicio:
    # from wtforms import ValidationError
    # def validate_fecha_termino(self, field):
    #     if self.fecha_inicio.data and field.data < self.fecha_inicio.data:
    #         raise ValidationError('La fecha de término no puede ser anterior a la de inicio')
