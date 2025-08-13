# app/models/empleador.py
"""
Modelo de la tabla 'empleador' en la base de datos.

Define los campos, métodos de representación y utilidades
para manipular registros de empleadores.
"""

from app.extensions.extensions import db


class Empleador(db.Model):
    """
    Modelo que representa un empleador en el sistema.
    Mapea la tabla 'empleador' de la base de datos.
    """

    __tablename__ = "empleador"

    id = db.Column(db.Integer, primary_key=True)
    rut_cuerpo = db.Column(db.String(8), nullable=False)
    rut_dv = db.Column(db.String(1), nullable=False)
    razon_social = db.Column(db.String(255), nullable=False)
    direccion = db.Column(db.String(255))
    telefono = db.Column(db.String(50))
    email = db.Column(db.String(255))
    fecha_creacion = db.Column(db.DateTime)       # Antes 'created_at'
    fecha_actualizacion = db.Column(db.DateTime)  # Antes 'updated_at'

    def __repr__(self):
        """
        Retorna una representación legible del empleador para depuración.
        """
        return f"<Empleador {self.razon_social} ({self.rut_cuerpo}-{self.rut_dv})>"

    def rut_completo(self):
        """
        Retorna el RUT completo del empleador (cuerpo + dígito verificador).
        """
        return f"{self.rut_cuerpo}-{self.rut_dv}"

    def to_dict(self):
        """
        Convierte el objeto Empleador a un diccionario para exportación o serialización.
        """
        return {
            "id": self.id,
            "rut_cuerpo": self.rut_cuerpo,
            "rut_dv": self.rut_dv,
            "razon_social": self.razon_social,
            "direccion": self.direccion,
            "telefono": self.telefono,
            "email": self.email,
            "fecha_creacion": self.fecha_creacion,
            "fecha_actualizacion": self.fecha_actualizacion,
        }
