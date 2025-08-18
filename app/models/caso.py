from app.extensions.extensions import db
from datetime import datetime


class Caso(db.Model):
    __tablename__ = "caso"  # coincide con tu tabla real en MySQL

    id = db.Column(db.Integer, primary_key=True)

    # Columnas según tu SQL existente
    codigo = db.Column(db.String(36), unique=True, nullable=True)
    trabajador_id = db.Column(
        db.Integer,
        db.ForeignKey("trabajador.id", onupdate="CASCADE", ondelete="CASCADE"),
        index=True,
        nullable=True,
    )
    empleador_id = db.Column(
        db.Integer,
        db.ForeignKey("empleador.id", onupdate="CASCADE", ondelete="CASCADE"),
        index=True,
        nullable=True,
    )
    fecha_inicio = db.Column(db.Date, nullable=True)
    estado = db.Column(db.String(30), nullable=True)
    resumen = db.Column(db.Text, nullable=True)          # historia -> resumen
    tipo = db.Column(db.String(60), nullable=True)       # tipo_caso -> tipo
    nombre_caso = db.Column(db.String(200), nullable=True)
    fecha_creacion = db.Column(
        db.DateTime, nullable=True)  # DEFAULT NOW() en BD
    fecha_cierre = db.Column(db.Date, nullable=True)

    # Relaciones (usar nombres de clase como string evita import circular)
    trabajador = db.relationship(
        "Trabajador",
        backref=db.backref("casos", lazy="dynamic"),
        foreign_keys=[trabajador_id],
    )
    empleador = db.relationship(
        "Empleador",
        backref=db.backref("casos", lazy="dynamic"),
        foreign_keys=[empleador_id],
    )

    # -------------------- Helpers de presentación --------------------

    @property
    def codigo_humano(self) -> str:
        """
        Formato: YYYY-NNN (ej. 2025-008)
        Usa año de fecha_creacion (o año actual si viniera nulo) + id con padding.
        """
        year = (self.fecha_creacion or datetime.utcnow()).year
        try:
            return f"{year}-{int(self.id):03d}"
        except Exception:
            return f"{year}-{self.id}"

    @property
    def caratula_simple(self) -> str:
        """
        Solo 'APELLIDO_PATERNO / RAZÓN_SOCIAL' sin UUIDs ni extras.
        - Si no hay apellido_paterno, usa el último token del nombre del trabajador.
        - Si no hay razón_social, intenta 'fantasia' o 'nombre_fantasia'.
        """
        # Apellido paterno del trabajador
        ap = None
        if self.trabajador:
            ap = getattr(self.trabajador, "apellido_paterno", None)
            if not ap:
                # Fallback: último token del nombre completo
                nombre = (
                    getattr(self.trabajador, "nombre_completo", None)
                    or f"{getattr(self.trabajador, 'nombres', '')} {getattr(self.trabajador, 'apellidos', '')}".strip()
                    or getattr(self.trabajador, "nombre", "")
                ).strip()
                if nombre:
                    ap = nombre.split()[-1]
        ap = (ap or "—").strip()

        # Razón social del empleador
        rs = "—"
        if self.empleador:
            for attr in ("razon_social", "fantasia", "nombre_fantasia"):
                val = getattr(self.empleador, attr, None)
                if val:
                    rs = val
                    break
        return f"{ap}/{rs}"

    @property
    def trabajador_nombre(self) -> str:
        if not self.trabajador:
            return "—"
        nombre_completo = getattr(self.trabajador, "nombre_completo", None)
        if nombre_completo:
            return nombre_completo
        nombres = (
            getattr(self.trabajador, "nombres", "")
            or getattr(self.trabajador, "nombre", "")
            or ""
        )
        apellidos = (
            getattr(self.trabajador, "apellidos", "")
            or " ".join(
                filter(
                    None,
                    [
                        getattr(self.trabajador, "apellido_paterno", ""),
                        getattr(self.trabajador, "apellido_materno", ""),
                    ],
                )
            )
            or ""
        )
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
    def fecha_creacion_fmt(self) -> str:
        try:
            dt = self.fecha_creacion or datetime.utcnow()
            return dt.strftime("%Y-%m-%d")
        except Exception:
            return "—"

    def __repr__(self) -> str:
        return f"<Caso id={self.id} tipo={self.tipo} estado={self.estado} trabajador_id={self.trabajador_id} empleador_id={self.empleador_id}>"
