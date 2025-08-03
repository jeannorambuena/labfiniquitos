"""
Modelo de datos para trabajadores.

Representa a un trabajador registrado en el sistema, incluyendo sus datos
personales, de contacto y situación laboral.

Autor: Jean Paul Norambuena
Proyecto: labfiniquito
"""

from app import db


class Trabajador(db.Model):
    """
    Modelo ORM para la tabla 'trabajador'.
    Estructura profesionalizada con separación de RUT (cuerpo y dígito verificador).
    """
    __tablename__ = 'trabajador'  # Usa singular, congruente con tu base

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    rut_cuerpo = db.Column(db.String(8), nullable=False)
    rut_dv = db.Column(db.String(1), nullable=False)
    nombre = db.Column(db.String(80), nullable=False)
    apellido_paterno = db.Column(db.String(60), nullable=False)
    apellido_materno = db.Column(db.String(60), nullable=True)
    fecha_nacimiento = db.Column(db.Date, nullable=True)
    direccion = db.Column(db.String(180), nullable=True)
    telefono = db.Column(db.String(20), nullable=True)
    email = db.Column(db.String(120), nullable=True)
    activo = db.Column(db.Boolean, default=True, nullable=False)

    __table_args__ = (
        db.UniqueConstraint('rut_cuerpo', 'rut_dv', name='rut_unico'),
    )

    @property
    def rut(self):
        """
        Retorna el RUT completo en formato estándar (cuerpo-dv), útil para mostrar en plantillas.
        """
        return f"{self.rut_cuerpo}-{self.rut_dv}"

    def __repr__(self):
        return f"<Trabajador {self.rut} - {self.nombre} {self.apellido_paterno} {self.apellido_materno}>"
