"""Extensiones compartidas de la aplicación Flask.

Aquí se definen e inicializan las instancias globales que
serán utilizadas en diferentes partes del sistema.
"""

from flask_sqlalchemy import SQLAlchemy

# Instancia global de la base de datos
db = SQLAlchemy()
