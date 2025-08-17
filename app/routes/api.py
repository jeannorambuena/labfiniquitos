from flask import Blueprint, request, jsonify
from sqlalchemy import func, or_
from app.extensions.extensions import db
from app.models.trabajador import Trabajador
from app.models.empleador import Empleador

api_bp = Blueprint('api', __name__, url_prefix='/api')


def _clean(s: str) -> str:
    return (s or '').strip()


def _norm_rut(s: str):
    """
    Normaliza un texto a componentes de RUT:
    - body: solo dígitos
    - dv: '0-9' o 'K' si venía al final
    """
    import re
    c = re.sub(r'[^0-9kK]', '', s or '').upper()
    body = ''.join(ch for ch in c if ch.isdigit())
    dv = ''
    if len(c) > len(body):
        last = c[-1]
        if last.isdigit() or last == 'K':
            dv = last
    return body, dv


@api_bp.get('/trabajadores')
def buscar_trabajadores():
    q = _clean(request.args.get('q', ''))
    if len(q) < 2:
        return jsonify([])

    ilike = f"%{q.lower()}%"

    filters = [
        func.lower(Trabajador.nombre).like(ilike),
        func.lower(Trabajador.apellido_paterno).like(ilike),
        func.lower(Trabajador.apellido_materno).like(ilike),
        func.lower(
            func.concat(
                Trabajador.nombre, ' ',
                Trabajador.apellido_paterno, ' ',
                func.coalesce(Trabajador.apellido_materno, '')
            )
        ).like(ilike),
    ]

    body, dv = _norm_rut(q)
    if body:
        filters.append(Trabajador.rut_cuerpo.like(f"{body}%"))
    if dv:
        filters.append(func.upper(Trabajador.rut_dv) == dv)

    rs = (Trabajador.query
          .filter(or_(*filters))
          .order_by(Trabajador.nombre.asc(), Trabajador.apellido_paterno.asc())
          .limit(10)
          .all())

    data = []
    for t in rs:
        full_name = f"{t.nombre} {t.apellido_paterno} {t.apellido_materno or ''}".strip()
        data.append({
            "id": t.id,
            "nombre": full_name,
            "rut": f"{t.rut_cuerpo}-{t.rut_dv}",
        })
    return jsonify(data)


@api_bp.get('/empleadores')
def buscar_empleadores():
    q = _clean(request.args.get('q', ''))
    if len(q) < 2:
        return jsonify([])

    ilike = f"%{q.lower()}%"

    filters = [
        func.lower(Empleador.razon_social).like(ilike),
    ]

    body, dv = _norm_rut(q)
    if body:
        filters.append(Empleador.rut_cuerpo.like(f"{body}%"))
    if dv:
        filters.append(func.upper(Empleador.rut_dv) == dv)

    rs = (Empleador.query
          .filter(or_(*filters))
          .order_by(Empleador.razon_social.asc())
          .limit(10)
          .all())

    data = []
    for e in rs:
        data.append({
            "id": e.id,
            "nombre": e.razon_social,
            "rut": f"{e.rut_cuerpo}-{e.rut_dv}",
        })
    return jsonify(data)
