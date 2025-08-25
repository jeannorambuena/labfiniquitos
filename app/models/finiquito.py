"""
Modelo SQLAlchemy para almacenar cálculos de finiquitos detallados.

Este modelo crea una tabla propia llamada ``finiquito_calculo`` que no
colisiona con la tabla ``finiquito`` ya existente en tu base de datos. Su
propósito es guardar los datos introducidos por el usuario y los valores
calculados (años de servicio, indemnizaciones, vacaciones, horas extras,
haberes, descuentos, etc.), junto con referencias opcionales al caso,
trabajador y empleador correspondiente. Al persistir estos registros puedes
generar documentos oficiales, integrarlos con n8n o consultar el historial
de finiquitos calculados.

Si en un futuro prefieres utilizar la tabla ``finiquito`` que ya existe en
tu base de datos, puedes adaptar este modelo eliminando los campos
adicionales y utilizando la columna JSON ``extra_data`` para almacenar
valores detallados.

Para crear esta tabla en tu base de datos MySQL puedes ejecutar la
consulta que se muestra al final de este archivo en un cliente SQL o
mediante tu herramienta de migraciones.
"""

from datetime import datetime
from app.extensions.extensions import db


class FiniquitoCalculo(db.Model):
    """Representa un cálculo de finiquito con todos sus componentes.

    La tabla ``finiquito_calculo`` almacena las entradas del usuario y los
    montos resultantes. Los campos ``caso_id``, ``trabajador_id`` y
    ``empleador_id`` son opcionales para permitir guardar cálculos
    independientes, aunque lo habitual es asociarlos a un caso, trabajador
    y empleador existentes.
    """

    __tablename__ = "finiquito_calculo"

    id = db.Column(db.Integer, primary_key=True)
    # Relaciones opcionales con caso, trabajador y empleador
    caso_id = db.Column(db.Integer, db.ForeignKey("caso.id"), nullable=True)
    trabajador_id = db.Column(
        db.Integer, db.ForeignKey("trabajador.id"), nullable=True)
    empleador_id = db.Column(
        db.Integer, db.ForeignKey("empleador.id"), nullable=True)

    # Datos contractuales
    fecha_inicio = db.Column(db.Date, nullable=False)
    fecha_termino = db.Column(db.Date, nullable=False)
    causal_termino = db.Column(db.String(20), nullable=False)
    tipo_jornada = db.Column(db.String(30), nullable=False)

    # Remuneraciones
    remuneracion_base = db.Column(db.Numeric(12, 2), nullable=False)
    gratificacion = db.Column(db.Numeric(12, 2), default=0)
    comisiones = db.Column(db.Numeric(12, 2), default=0)
    semana_corrida = db.Column(db.Numeric(12, 2), default=0)
    bonos = db.Column(db.Numeric(12, 2), default=0)
    horas_espera = db.Column(db.Numeric(12, 2), default=0)
    horas_extra = db.Column(db.Numeric(12, 2), default=0)

    # Vacaciones y descuentos
    dias_vac_pendientes = db.Column(db.Integer, default=0)
    afp = db.Column(db.Numeric(12, 2), default=0)
    salud = db.Column(db.Numeric(12, 2), default=0)
    cesantia = db.Column(db.Numeric(12, 2), default=0)
    otros_descuentos = db.Column(db.Numeric(12, 2), default=0)

    # Montos calculados
    anios_servicio = db.Column(db.Integer, default=0)
    indemnizacion_anios = db.Column(db.Numeric(14, 2), default=0)
    indemnizacion_aviso = db.Column(db.Numeric(14, 2), default=0)
    vacaciones = db.Column(db.Numeric(14, 2), default=0)
    pago_espera = db.Column(db.Numeric(14, 2), default=0)
    total_haberes = db.Column(db.Numeric(14, 2), default=0)
    total_descuentos = db.Column(db.Numeric(14, 2), default=0)
    total_pagar = db.Column(db.Numeric(14, 2), default=0)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    # Definición de relaciones para navegación entre objetos
    caso = db.relationship(
        "Caso", backref=db.backref("finiquito_calculos", lazy=True)
    )
    trabajador = db.relationship(
        "Trabajador", backref=db.backref("finiquito_calculos", lazy=True)
    )
    empleador = db.relationship(
        "Empleador", backref=db.backref("finiquito_calculos", lazy=True)
    )

    def __repr__(self) -> str:
        return f"<FiniquitoCalculo {self.id}>"

# Consulta SQL para crear la tabla ``finiquito_calculo`` en MySQL
# -----------------------------------------------------------------------------
# USE labfini;
# CREATE TABLE IF NOT EXISTS `finiquito_calculo` (
#   `id` int NOT NULL AUTO_INCREMENT,
#   `caso_id` int DEFAULT NULL,
#   `trabajador_id` int DEFAULT NULL,
#   `empleador_id` int DEFAULT NULL,
#   `fecha_inicio` date NOT NULL,
#   `fecha_termino` date NOT NULL,
#   `causal_termino` varchar(20) NOT NULL,
#   `tipo_jornada` varchar(30) NOT NULL,
#   `remuneracion_base` decimal(12,2) NOT NULL,
#   `gratificacion` decimal(12,2) DEFAULT 0,
#   `comisiones` decimal(12,2) DEFAULT 0,
#   `semana_corrida` decimal(12,2) DEFAULT 0,
#   `bonos` decimal(12,2) DEFAULT 0,
#   `horas_espera` decimal(12,2) DEFAULT 0,
#   `horas_extra` decimal(12,2) DEFAULT 0,
#   `dias_vac_pendientes` int DEFAULT 0,
#   `afp` decimal(12,2) DEFAULT 0,
#   `salud` decimal(12,2) DEFAULT 0,
#   `cesantia` decimal(12,2) DEFAULT 0,
#   `otros_descuentos` decimal(12,2) DEFAULT 0,
#   `anios_servicio` int DEFAULT 0,
#   `indemnizacion_anios` decimal(14,2) DEFAULT 0,
#   `indemnizacion_aviso` decimal(14,2) DEFAULT 0,
#   `vacaciones` decimal(14,2) DEFAULT 0,
#   `pago_espera` decimal(14,2) DEFAULT 0,
#   `total_haberes` decimal(14,2) DEFAULT 0,
#   `total_descuentos` decimal(14,2) DEFAULT 0,
#   `total_pagar` decimal(14,2) DEFAULT 0,
#   `created_at` datetime DEFAULT current_timestamp(),
#   PRIMARY KEY (`id`),
#   CONSTRAINT `fk_fc_caso` FOREIGN KEY (`caso_id`) REFERENCES `caso` (`id`),
#   CONSTRAINT `fk_fc_trabajador` FOREIGN KEY (`trabajador_id`) REFERENCES `trabajador` (`id`),
#   CONSTRAINT `fk_fc_empleador` FOREIGN KEY (`empleador_id`) REFERENCES `empleador` (`id`)
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
