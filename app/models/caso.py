from app.extensions.extensions import db
from datetime import datetime

from app.models.trabajador import Trabajador
from app.models.empleador import Empleador


class Caso(db.Model):
    __tablename__ = "casos"

    id = db.Column(db.Integer, primary_key=True)

    tipo_caso = db.Column(db.String(30), nullable=False)
    causal = db.Column(db.String(255), nullable=True)

    fecha_inicio = db.Column(db.Date, nullable=False)
    fecha_termino = db.Column(db.Date, nullable=True)

    base_calculo = db.Column(db.Numeric(14, 2), nullable=True)

    trabajador_id = db.Column(
        db.Integer,
        db.ForeignKey(f"{Trabajador.__tablename__}.id"),
        nullable=True,
        index=True,
    )
    empleador_id = db.Column(
        db.Integer,
        db.ForeignKey(f"{Empleador.__tablename__}.id"),
        nullable=True,
        index=True,
    )

    created_at = db.Column(
        db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(
        db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False
    )

    trabajador = db.relationship(
        Trabajador, backref=db.backref("casos", lazy="dynamic"))
    empleador = db.relationship(
        Empleador, backref=db.backref("casos", lazy="dynamic"))

    @property
    def trabajador_nombre(self) -> str:
        if not self.trabajador:
            return "—"
        nombre_completo = getattr(self.trabajador, "nombre_completo", None)
        if nombre_completo:
            return nombre_completo
        nombres = getattr(self.trabajador, "nombres", "") or getattr(
            self.trabajador, "nombre", "")
        apellidos = getattr(self.trabajador, "apellidos", "")
        full = f"{nombres} {apellidos}".strip()
        return full or getattr(self.trabajador, "rut", "") or "—"

    @property
    def trabajador_rut(self) -> str:
        return getattr(self.trabajador, "rut", "—") if self.trabajador else "—"

    @property
    def empleador_razon_social(self) -> str:
        if not self.empleador:
            return "—"
        for attr in ("razon_social", "fantasia", "nombre_fantasia"):
            val = getattr(self.empleador, attr, None)
            if val:
                return val
        return getattr(self.empleador, "rut", "") or "—"

    @property
    def empleador_rut(self) -> str:
        return getattr(self.empleador, "rut", "—") if self.empleador else "—"

    @property
    def estado(self) -> str:
        return "borrador"

    @property
    def actualizado_en(self) -> str | None:
        try:
            return self.updated_at.strftime("%Y-%m-%d")
        except Exception:
            return None

    def __repr__(self) -> str:
        return f"<Caso id={self.id} tipo={self.tipo_caso} trabajador_id={self.trabajador_id} empleador_id={self.empleador_id}>"
