# app/routes/__init__.py

from .home import home_bp
# ⬇️ NUEVO: API de búsquedas (trabajadores / empleadores)
from .api import api_bp

# Si en el futuro agregas más blueprints (casos, trabajadores, empleadores),
# los vas sumando aquí:
# from .casos import casos_bp
# from .trabajadores import trabajadores_bp
# from .empleadores import empleadores_bp

# Exportamos una lista y también una función de registro,
# para cubrir ambos estilos de inicialización de la app.
blueprints = [
    home_bp,
    api_bp,
    # casos_bp,
    # trabajadores_bp,
    # empleadores_bp,
]


def register_blueprints(app):
    """Registra todos los blueprints declarados arriba."""
    for bp in blueprints:
        app.register_blueprint(bp)
