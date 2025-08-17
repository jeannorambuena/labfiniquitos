"""
Módulo principal de inicialización de la aplicación Flask.

- Carga las variables de entorno desde `.env`
- Configura la aplicación y la base de datos SQLAlchemy
- Registra los blueprints del sistema
"""

import os
from flask import Flask
from dotenv import load_dotenv

# Importa la instancia global de db centralizada
from app.extensions.extensions import db


def create_app():
    """
    Crea y configura la instancia principal de la aplicación Flask.

    Returns:
        Flask: instancia de la aplicación Flask con configuración, BD y blueprints registrados.
    """
    # Cargar variables de entorno desde .env si existe
    load_dotenv()

    app = Flask(__name__)

    # Configuración de base de datos y claves secretas
    app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv(
        'DATABASE_URL',
        'mysql://root:password@localhost/labfini'
    )
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'clave_supersecreta')

    # Inicialización de la base de datos con la app
    db.init_app(app)

    # Importación de modelos (obligatorio para inicializar relaciones y migraciones)
    try:
        from app.models import Trabajador
    except Exception:
        from app.models.trabajador import Trabajador  # noqa: F401

    # Importación y registro de Blueprints (rutas modulares)
    from app.routes.home import home_bp
    from app.routes.trabajadores import trabajadores_bp
    from app.routes.empleador import empleador_bp
    from app.routes.casos import casos_bp
    from app.routes.api import api_bp

    app.register_blueprint(casos_bp)
    app.register_blueprint(home_bp)
    app.register_blueprint(trabajadores_bp)
    app.register_blueprint(empleador_bp)
    app.register_blueprint(api_bp)

    return app
