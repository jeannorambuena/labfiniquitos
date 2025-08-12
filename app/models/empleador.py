# app/models/empleador.py

from app.extensions.extensions import db


class Empleador(db.Model):
    __tablename__ = "empleador"

    id = db.Column(db.Integer, primary_key=True)
    rut_cuerpo = db.Column(db.String(8), nullable=False)
    rut_dv = db.Column(db.String(1), nullable=False)
    razon_social = db.Column(db.String(255), nullable=False)
    direccion = db.Column(db.String(255))
    telefono = db.Column(db.String(50))
    email = db.Column(db.String(255))
    created_at = db.Column(db.DateTime)
    updated_at = db.Column(db.DateTime)

    def __repr__(self):
        return f"<Empleador {self.razon_social} ({self.rut_cuerpo}-{self.rut_dv})>"

    def rut_completo(self):
        return f"{self.rut_cuerpo}-{self.rut_dv}"

    def to_dict(self):
        return {
            "id": self.id,
            "rut_cuerpo": self.rut_cuerpo,
            "rut_dv": self.rut_dv,
            "razon_social": self.razon_social,
            "direccion": self.direccion,
            "telefono": self.telefono,
            "email": self.email,
            "created_at": self.created_at,
            "updated_at": self.updated_at,
        }
