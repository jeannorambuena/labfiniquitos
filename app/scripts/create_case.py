#!/usr/bin/env python3
import os
import json
import sys
import re
import uuid
import pymysql
from datetime import datetime

# === Configura tu conexión ===
DB_CFG = dict(
    host="127.0.0.1",
    user="root",
    password="tu_clave",
    database="labfini",
    charset="utf8mb4",
    cursorclass=pymysql.cursors.DictCursor,
    autocommit=True,
)

BASE_UPLOADS = os.path.join("uploads", "casos")


def slugify(s):
    s = s.lower().strip()
    s = re.sub(r"[^\w\s\-\.\/]", "", s)
    s = re.sub(r"\s+", "-", s)
    s = re.sub(r"-{2,}", "-", s)
    return s


def short_code(trabajador_nombre, empleador_razon, correlativo):
    # iniciales trabajador (nombre + ap. paterno si existe)
    partes = (trabajador_nombre or "").split()
    ini = "".join(p[0] for p in partes[:2]).lower() or "cx"
    return f"{ini}-{correlativo:04d}"


def main(trabajador_id, empleador_id, tipo="autodespido"):
    with pymysql.connect(**DB_CFG) as con:
        with con.cursor() as cur:
            # 1) Trae nombres para armar el "nombre_caso"
            cur.execute("""
                SELECT CONCAT_WS(' ', t.nombre, t.apellido_paterno) AS trabajador,
                       e.razon_social AS empresa
                FROM trabajador t, empleador e
                WHERE t.id=%s AND e.id=%s
                """, (trabajador_id, empleador_id))
            row = cur.fetchone()
            if not row:
                print("Error: trabajador_id / empleador_id no válidos")
                sys.exit(1)

            trabajador = row["trabajador"] or ""
            empresa = row["empresa"] or ""

            # 2) Obtén correlativo simple: max(id)+1 para formar short_code
            cur.execute("SELECT COALESCE(MAX(id),0)+1 AS next_id FROM caso")
            next_id = cur.fetchone()["next_id"]
            codigo_corto = short_code(trabajador, empresa, next_id)

            nombre_caso = f"{trabajador.split()[-1]}/{empresa} - {codigo_corto}"

            # 3) Inserta el caso
            cur.execute("""
                INSERT INTO caso (trabajador_id, empleador_id, fecha_inicio, estado, tipo, fecha_creacion, codigo, nombre_caso)
                VALUES (%s,%s,CURDATE(),'abierto',%s,NOW(),%s,%s)
            """, (trabajador_id, empleador_id, tipo, codigo_corto, nombre_caso))

            case_id = cur.lastrowid

            # 4) Crea estructura de carpetas
            root = os.path.join(BASE_UPLOADS, codigo_corto)
            subdirs = ["fuentes", "ocr", "extracciones", "outputs"]
            for sd in subdirs:
                os.makedirs(os.path.join(root, sd), exist_ok=True)

            # 5) Manifest con checklist para el tipo "autodespido"
            manifest = {
                "case_id": case_id,
                "codigo": codigo_corto,
                "nombre_caso": nombre_caso,
                "tipo": tipo,
                "checklist_autodespido": [
                    {"tipo_documento": "autodespido_comunicacion", "destino": "fuentes",
                        "requerido": True,  "ejemplo": "COMUNICA AUTODESPIDO.docx"},
                    {"tipo_documento": "autodespido_protocolo",    "destino": "fuentes",
                        "requerido": True,  "ejemplo": "PROTOCOLO AUTODESPIDO - CARTA.docx"},
                    {"tipo_documento": "proyecto_finiquito_borrador", "destino": "fuentes",
                        "requerido": False, "ejemplo": "PROYECTO DE FINIQUITO.docx"},
                    {"tipo_documento": "cartola_historica",        "destino": "fuentes",
                        "requerido": False, "ejemplo": "CARTOLA HISTORICA.pdf"},
                    {"tipo_documento": "resumen_semana_corrida",   "destino": "fuentes",
                        "requerido": False, "ejemplo": "JUAN LUIS VALENZUELA ORELLANA - SEMANA CORRIDA.docx"}
                ],
                "instrucciones_subida": "Copia los archivos a uploads/casos/{codigo}/fuentes y luego usa el importador para registrarlos en documento_fuente."
            }
            with open(os.path.join(root, "manifest.json"), "w", encoding="utf-8") as f:
                json.dump(manifest, f, ensure_ascii=False, indent=2)

            print("OK")
            print("case_id:", case_id)
            print("codigo:", codigo_corto)
            print("carpeta:", root)


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print(
            "Uso: python scripts/create_case.py <trabajador_id> <empleador_id> [tipo]")
        sys.exit(1)
    trabajador_id = int(sys.argv[1])
    empleador_id = int(sys.argv[2])
    tipo = sys.argv[3] if len(sys.argv) > 3 else "autodespido"
    main(trabajador_id, empleador_id, tipo)
