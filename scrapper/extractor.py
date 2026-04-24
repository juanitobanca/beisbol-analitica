"""
extractor.py — utilidad central de extracción de campos JSON.

Reemplaza los ~10 métodos set* dispersos en boxscore.py, playByPlay.py
y contextMetrics.py con una sola función parametrizable.

CONCEPTO
--------
Cada método set* original hacía lo mismo:
    para cada campo en una lista:
        navegar el JSON de una forma específica al contexto
        hacer append del valor (o None si no existe)

La variación entre métodos estaba únicamente en *cómo navegar* el nodo
raíz hasta llegar al dict que contiene el campo.  Esa navegación se
expresa ahora como un callable `resolver(node, field) -> value` que se
pasa como argumento.  extract_fields no sabe nada de MLB; solo itera
campos, llama al resolver y hace append.

USO
---
    from extractor import extract_fields, nav, nav_id, nav_code

    # Extraer campos directamente de un nodo
    extract_fields(node, fields, dataset, nav)

    # Extraer el sub-campo 'id' de un nodo anidado
    extract_fields(node['person'], ['personId'], dataset,
                   lambda n, f: nav_id(n))

Resolvers predefinidos (los más comunes):
    nav(node, field)        -> node.get(field)          caso base
    nav_id(node, field)     -> node.get('id')           para claves *Id
    nav_code(node, field)   -> node.get('code')         para claves *Code
    nav_name(node, field)   -> node.get('name')
    nav_link(node, field)   -> node.get('link')
"""


def extract_fields(node, fields, dataset, resolver):
    """
    Para cada campo en `fields` llama resolver(node, field),
    hace append del resultado en dataset[field].

    Parámetros
    ----------
    node     : dict | None   — nodo JSON ya navegado hasta el nivel correcto
    fields   : list[str]     — nombres de columna destino
    dataset  : dict[str, list] — acumulador (mismo formato que createDataset)
    resolver : callable(node, field) -> value
                 Debe devolver el valor deseado o None.
                 Nunca debe lanzar excepciones — usa .get() o try/except interno.
    """
    for field in fields:
        try:
            value = resolver(node, field)
        except Exception:
            value = None
        dataset[field].append(value)


# ---------------------------------------------------------------------------
# Resolvers estándar
# ---------------------------------------------------------------------------

def nav(node, field):
    """Acceso directo: node.get(field)."""
    if node is None:
        return None
    return node.get(field)


def nav_id(node, field=None):
    """Extrae la clave 'id' del nodo (ignora field)."""
    if node is None:
        return None
    return node.get('id')


def nav_code(node, field=None):
    """Extrae la clave 'code' del nodo."""
    if node is None:
        return None
    return node.get('code')


def nav_name(node, field=None):
    if node is None:
        return None
    return node.get('name')


def nav_link(node, field=None):
    if node is None:
        return None
    return node.get('link')


def nav_description(node, field=None):
    if node is None:
        return None
    return node.get('description')
