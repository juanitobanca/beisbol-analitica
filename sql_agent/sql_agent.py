"""
Agente SQL (solo SELECT) con LangGraph + Ollama (llama3.2) + SQLite3.

Uso:
    1. pip install -r requirements.txt
    2. ollama pull llama3.2
    3. python create_db.py
    4. python agent.py
"""

import re
import sqlite3
from pathlib import Path

from langchain_ollama import ChatOllama
from langchain_core.tools import tool
from langgraph.prebuilt import create_react_agent

# ──────────────────────────────────────────────
# Configuración
# ──────────────────────────────────────────────
DB_PATH = "../baseball.db"
OLLAMA_MODEL = "llama3.2"
OLLAMA_BASE_URL = "http://localhost:11434"


# ──────────────────────────────────────────────
# Validación de solo lectura
# ──────────────────────────────────────────────
def _is_select_only(sql: str) -> bool:
    cleaned = sql.strip().upper()
    if not (cleaned.startswith("SELECT") or cleaned.startswith("WITH")):
        return False
    forbidden = re.compile(
        r"\b(INSERT|UPDATE|DELETE|DROP|CREATE|ALTER|REPLACE|TRUNCATE|ATTACH|DETACH|PRAGMA)\b"
    )
    return not forbidden.search(cleaned)


# ──────────────────────────────────────────────
# Herramientas (@tool — API moderna de LangChain)
# ──────────────────────────────────────────────
@tool
def get_db_schema() -> str:
    """
    Devuelve el esquema completo de la base de datos SQLite:
    tablas y sus columnas. Llama a esta herramienta ANTES de
    escribir cualquier consulta SQL.
    """
    if not Path(DB_PATH).exists():
        return f"❌ No se encontró '{DB_PATH}'. Ejecuta create_db.py primero."

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;")
    tables = [row[0] for row in cursor.fetchall()]

    parts = []
    for table in tables:
        cursor.execute(f"PRAGMA table_info({table});")
        cols = cursor.fetchall()
        cols_desc = ", ".join(
            f"{c[1]} {c[2]}{'(PK)' if c[5] else ''}" for c in cols
        )
        parts.append(f"  • {table}({cols_desc})")

    conn.close()
    return "Esquema:\n" + "\n".join(parts)


@tool
def run_select_query(sql: str) -> str:
    """
    Ejecuta una consulta SQL SELECT en la base de datos SQLite local
    y devuelve los resultados. Solo se permiten sentencias SELECT.
    El argumento debe ser la sentencia SQL como texto plano.
    """
    sql = re.sub(r"```(?:sql)?", "", sql).strip().rstrip(";").strip()

    if not sql:
        return "❌ No se recibió ninguna consulta."

    if not _is_select_only(sql):
        return (
            "⛔ Rechazada: solo se permiten sentencias SELECT. "
            "INSERT, UPDATE, DELETE, DROP, etc. están deshabilitados."
        )

    if not Path(DB_PATH).exists():
        return f"❌ Base de datos no encontrada en '{DB_PATH}'."

    try:
        conn = sqlite3.connect(DB_PATH)
        conn.row_factory = sqlite3.Row
        cursor = conn.cursor()
        cursor.execute(sql)
        rows = cursor.fetchall()
        conn.close()

        if not rows:
            return "ℹ️ La consulta no devolvió resultados."

        headers = list(rows[0].keys())
        col_w = 20
        header_line = " | ".join(f"{h:<{col_w}}" for h in headers)
        separator   = "-+-".join("-" * col_w for _ in headers)
        data_lines  = [
            " | ".join(f"{str(row[h]):<{col_w}}" for h in headers)
            for row in rows
        ]
        return "\n".join([header_line, separator] + data_lines) + f"\n({len(rows)} fila(s))"

    except sqlite3.Error as e:
        return f"❌ Error SQLite: {e}"


# ──────────────────────────────────────────────
# Construcción del agente (LangGraph)
# ──────────────────────────────────────────────
def build_agent():
    llm = ChatOllama(
        model=OLLAMA_MODEL,
        base_url=OLLAMA_BASE_URL,
        temperature=0,
    )

    system_prompt = (
    "Eres un asistente experto en SQL y en béisbol, especializado en consultar una base de datos SQLite local. "
    "Tu objetivo es responder preguntas sobre béisbol de forma clara, precisa y en español. "

    "## REGLAS DE COMPORTAMIENTO\n"
    "1. SIEMPRE ejecuta get_db_schema al inicio de cada conversación o antes de construir cualquier consulta SQL. "
    "2. Solo puedes ejecutar sentencias SELECT. Está estrictamente prohibido INSERT, UPDATE, DELETE o cualquier modificación de datos. "
    "3. Si una consulta no devuelve resultados, inténtalo con criterios más amplios antes de declarar que no hay datos. "
    "4. Si ocurre un error de SQL, analiza el esquema nuevamente y corrige la consulta. "

    "## MANEJO DE IDIOMA\n"
    "Los nombres de tablas y columnas están en inglés, pero el usuario escribe en español. "
    "Antes de construir el SQL, traduce mentalmente los términos clave del español al inglés para mapearlos correctamente con el esquema. "
    "Ejemplo: 'jonrones' → home_runs, 'promedio de bateo' → batting_average, 'carreras impulsadas' → rbi. "

    "## FORMATO DE RESPUESTA\n"
    "- Responde siempre en español claro y comprensible. "
    "- Cuando presentes datos numéricos o estadísticas, usa formato de tabla si son múltiples registros. "
    "- Explica brevemente qué consulta realizaste y qué significa el resultado en contexto de béisbol. "
    "- Si el resultado puede tener múltiples interpretaciones, menciónalas. "
    )

    return create_react_agent(
        model=llm,
        tools=[get_db_schema, run_select_query],
        prompt=system_prompt,
    )


# ──────────────────────────────────────────────
# Bucle de conversación
# ──────────────────────────────────────────────
EJEMPLOS = [
    "¿Cuántos empleados hay en total?",
    "¿Cuál es el salario promedio por departamento?",
    "Muéstrame los proyectos activos con su presupuesto",
    "¿Quién tiene el salario más alto?",
]


def main():
    print("=" * 60)
    print("  Agente SQL — SQLite3 + LangGraph + Ollama (llama3.2)")
    print("=" * 60)
    print("\nEscribe tu pregunta en lenguaje natural.")
    print("Comandos: 'salir' | 'esquema' | 'ejemplos'\n")

    if not Path(DB_PATH).exists():
        print(f"⚠️  Base de datos no encontrada: '{DB_PATH}'")
        print("   Ejecuta primero: python create_db.py\n")

    agent = build_agent()

    while True:
        try:
            user_input = input("🧑 Tú: ").strip()
        except (EOFError, KeyboardInterrupt):
            print("\n👋 ¡Hasta luego!")
            break

        if not user_input:
            continue
        if user_input.lower() in ("salir", "exit", "quit"):
            print("👋 ¡Hasta luego!")
            break
        if user_input.lower() == "esquema":
            print(get_db_schema.invoke({}))
            continue
        if user_input.lower() == "ejemplos":
            for i, ej in enumerate(EJEMPLOS, 1):
                print(f"  {i}. {ej}")
            continue

        print()
        try:
            result = agent.invoke({"messages": [("user", user_input)]})
            answer = result["messages"][-1].content
            print(f"🤖 Agente: {answer}\n")
        except Exception as e:
            print(f"❌ Error: {e}\n")

        print("-" * 60)


if __name__ == "__main__":
    main()
