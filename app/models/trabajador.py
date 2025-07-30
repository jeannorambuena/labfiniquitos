from app import db


class Trabajador(db.Model):
    """
    Modelo de Trabajador para la base de datos.

    Representa a un trabajador, con todos los datos personales y de contacto requeridos
    para el proceso de cálculo y documentación laboral.

    Atributos:
        id (int): Clave primaria, autoincremental.
        rut (str): RUT chileno único.
        nombre (str): Nombres del trabajador.
        apellido_paterno (str): Apellido paterno.
        apellido_materno (str): Apellido materno.
        fecha_nacimiento (date): Fecha de nacimiento.
        email (str): Correo electrónico.
        telefono (str): Teléfono de contacto.
        direccion (str): Dirección particular.
        fecha_creacion (datetime): Fecha de registro en el sistema.
        fecha_actualizacion (datetime): Última actualización del registro.
    """

    __tablename__ = 'trabajador'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    rut = db.Column(db.String(12), unique=True)
    nombre = db.Column(db.String(80))
    apellido_paterno = db.Column(db.String(60))
    apellido_materno = db.Column(db.String(60))
    fecha_nacimiento = db.Column(db.Date)
    email = db.Column(db.String(120))
    telefono = db.Column(db.String(20))
    direccion = db.Column(db.String(180))
    fecha_creacion = db.Column(db.DateTime)
    fecha_actualizacion = db.Column(db.DateTime)
