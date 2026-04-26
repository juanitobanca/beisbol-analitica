#!/usr/bin/env python3
"""
SQLite Agent con Ollama — 100% local, sin costo
Uso: python3 sql_agent.py --db ../baseball.db --contexto ../database

Requiere Ollama instalado: https://ollama.com
Modelos recomendados:
  ollama pull qwen2.5-coder   (5 GB RAM)  ← mejor para SQL  ✓ RECOMENDADO
  ollama pull llama3.2        (4 GB RAM)  ← buena opción general
  ollama pull deepseek-r1     (5 GB RAM)  ← razonamiento fuerte
  ollama pull mistral         (4 GB RAM)  ← alternativa rápida
"""

import sqlite3
import sys
import os
import re
import json
import argparse
import time
import urllib.request

try:
    import requests
except ImportError:
    print("Instala requests: pip install requests")
    sys.exit(1)

# ── Configuración ──────────────────────────────────────────────────────────────
OLLAMA_URL       = "http://localhost:11434"
DEFAULT_MODEL    = "qwen2.5-coder"
MAX_ROWS_PREVIEW = 5
MAX_QUERY_ROWS   = 200
HISTORY_TURNS    = 6

# ── Colores ANSI ───────────────────────────────────────────────────────────────
RESET  = "\033[0m"
BOLD   = "\033[1m"
CYAN   = "\033[36m"
YELLOW = "\033[33m"
GREEN  = "\033[32m"
RED    = "\033[31m"
DIM    = "\033[2m"

def c(text, *codes): return "".join(codes) + str(text) + RESET

# ── Ollama API ─────────────────────────────────────────────────────────────────

def ollama_load_model(model: str) -> bool:
    try:
        resp = requests.post(
            f"{OLLAMA_URL}/api/chat",
            json={"model": model, "messages": [], "keep_alive": -1},
            timeout=(10, 120),
        )
        return resp.status_code == 200
    except Exception:
        return False


def ollama_unload_model(model: str):
    try:
        requests.post(
            f"{OLLAMA_URL}/api/chat",
            json={"model": model, "messages": [], "keep_alive": 0},
            timeout=(10, 30),
        )
    except Exception:
        pass


def ollama_list_models() -> list[str]:
    try:
        r = requests.get(f"{OLLAMA_URL}/api/tags", timeout=5)
        return [m["name"] for m in r.json().get("models", [])]
    except Exception:
        return []


def ollama_chat(model: str, messages: list, system: str) -> str:
    full_text = ""
    token_count = 0
    t_start = time.time()
    t_first_token = None

    print(c("Agente: ", CYAN, BOLD), end="", flush=True)

    try:
        resp = requests.post(
            f"{OLLAMA_URL}/api/chat",
            json={
                "model": model,
                "messages": [{"role": "system", "content": system}] + messages,
                "stream": True,
                "keep_alive": -1,
                "options": {"temperature": 0.1, "num_ctx": 8192},
            },
            stream=True,
            timeout=(10, None),
        )
        resp.raise_for_status()

        for raw_line in resp.iter_lines():
            if not raw_line:
                continue
            try:
                chunk = json.loads(raw_line)
                token = chunk.get("message", {}).get("content", "")
                if token:
                    if t_first_token is None:
                        t_first_token = time.time()
                    full_text += token
                    token_count += 1
                    print(token, end="", flush=True)
                if chunk.get("done"):
                    break
            except json.JSONDecodeError:
                continue

    except requests.exceptions.ConnectionError:
        print(c(f"\nERROR: No se puede conectar con Ollama en {OLLAMA_URL}", RED))
        print(c("Ejecuta: ollama serve", YELLOW))
        return ""
    except requests.exceptions.HTTPError as e:
        print(c(f"\nERROR HTTP: {e}", RED))
        return ""

    t_end = time.time()
    t_total     = t_end - t_start
    t_ttft      = (t_first_token - t_start) if t_first_token else t_total
    t_gen       = (t_end - t_first_token)   if t_first_token else 0
    tok_per_sec = token_count / t_gen if t_gen > 0 else 0

    print()
    print(c(
        f"  ⏱  primer token {t_ttft:.1f}s · generación {t_gen:.1f}s · "
        f"total {t_total:.1f}s · {tok_per_sec:.1f} tok/s · {token_count} tokens",
        DIM
    ))
    return full_text


# ── SQLite helpers ─────────────────────────────────────────────────────────────

def get_schema(conn: sqlite3.Connection) -> str:
    cur = conn.cursor()
    lines = []

    cur.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")
    tables = [r[0] for r in cur.fetchall()]

    if not tables:
        return "La base de datos no contiene tablas."

    for tbl in tables:
        cur.execute(f'SELECT COUNT(*) FROM "{tbl}"')
        count = cur.fetchone()[0]
        lines.append(f"\nTABLA: {tbl}  ({count:,} filas)")

        cur.execute(f'PRAGMA table_info("{tbl}")')
        cols = cur.fetchall()
        for col in cols:
            pk   = "  [PK]"     if col[5] else ""
            nn   = "  NOT NULL" if col[3] else ""
            dflt = f"  DEFAULT {col[4]}" if col[4] is not None else ""
            lines.append(f"  · {col[1]}  {col[2]}{pk}{nn}{dflt}")

        cur.execute(f'PRAGMA foreign_key_list("{tbl}")')
        for fk in cur.fetchall():
            lines.append(f"  → FK: {fk[3]} → {fk[2]}({fk[4]})")

        cur.execute(f'PRAGMA index_list("{tbl}")')
        for idx in cur.fetchall():
            lines.append(f"  ⊡ índice: {idx[1]}{' [UNIQUE]' if idx[2] else ''}")

        try:
            col_names = [col[1] for col in cols]
            cur.execute(f'SELECT * FROM "{tbl}" LIMIT {MAX_ROWS_PREVIEW}')
            rows = cur.fetchall()
            if rows:
                lines.append(f"  Muestra:")
                lines.append("    " + " | ".join(col_names))
                for row in rows:
                    lines.append("    " + " | ".join(
                        "NULL" if v is None else str(v)[:25] for v in row
                    ))
        except Exception:
            pass

    cur.execute("SELECT name FROM sqlite_master WHERE type='view'")
    views = [r[0] for r in cur.fetchall()]
    if views:
        lines.append(f"\nVISTAS: {', '.join(views)}")

    return "\n".join(lines)


def run_query(conn: sqlite3.Connection, sql: str) -> tuple[str, bool]:
    try:
        cur = conn.cursor()
        cur.execute(sql)
        rows = cur.fetchmany(MAX_QUERY_ROWS)
        cols = [d[0] for d in (cur.description or [])]

        if not cols:
            return f"OK — {cur.rowcount} filas afectadas.", True

        lines = [" | ".join(cols), "-" * min(80, sum(len(c) for c in cols) + len(cols) * 3)]
        for row in rows:
            lines.append(" | ".join("NULL" if v is None else str(v)[:35] for v in row))

        extra = ""
        if cur.fetchone():
            extra = f"\n(truncado a {MAX_QUERY_ROWS} filas)"

        return "\n".join(lines) + extra, True
    except Exception as e:
        return f"ERROR: {e}", False


def extract_sql_blocks(text: str) -> list[str]:
    return re.findall(r"```sql\s*([\s\S]*?)```", text, re.IGNORECASE)


def load_sql_context(folder: str, max_bytes_per_file: int = 8000) -> str:
    folder = os.path.expanduser(folder)
    if not os.path.isdir(folder):
        print(c(f"ADVERTENCIA: Carpeta de contexto no encontrada: {folder}", YELLOW))
        return ""

    all_files = []
    for root, _, files in os.walk(folder):
        for fname in sorted(files):
            if fname.endswith(".sql"):
                all_files.append(os.path.join(root, fname))
    all_files.sort()

    if not all_files:
        print(c(f"ADVERTENCIA: No hay archivos .sql en {folder}", YELLOW))
        return ""

    sections = []
    total = 0
    for fpath in all_files:
        fname = os.path.relpath(fpath, folder)
        try:
            with open(fpath, "r", encoding="utf-8", errors="replace") as f:
                raw = f.read(max_bytes_per_file)
            truncated = " [TRUNCADO]" if os.path.getsize(fpath) > max_bytes_per_file else ""
            sections.append(f"-- Archivo: {fname}{truncated}\n{raw.strip()}")
            total += len(raw)
        except Exception as e:
            sections.append(f"-- Archivo: {fname} [ERROR: {e}]")

    print(c(f"  {len(all_files)} archivos SQL cargados (~{total//1000}KB de contexto)", DIM))
    return "\n\n".join(sections)


# ── System Prompt ──────────────────────────────────────────────────────────────

SYSTEM_PROMPT_TEMPLATE = """Eres un agente SQL con acceso DIRECTO y EN VIVO a una base de datos SQLite.

════════════════════════════════════════════════════════
⚠️  REGLA CRÍTICA — LEE ESTO PRIMERO
════════════════════════════════════════════════════════
NUNCA digas frases como:
  ✗ "no tengo acceso a datos en tiempo real"
  ✗ "no puedo consultar la base de datos"
  ✗ "te sugiero visitar un sitio web"
  ✗ "busca en internet"

TODAS ESAS FRASES SON FALSAS. Tienes acceso completo y directo
a la base de datos SQLite. Cuando escribes SQL en bloques ```sql```,
el sistema LO EJECUTA AUTOMÁTICAMENTE y te devuelve los resultados reales.

════════════════════════════════════════════════════════
✅  CÓMO DEBES COMPORTARTE — EJEMPLO
════════════════════════════════════════════════════════
Usuario: "Dame partidos aleatorios"
TÚ DEBES RESPONDER ASÍ:

Voy a consultar la base de datos ahora mismo:

```sql
SELECT * FROM "games" ORDER BY RANDOM() LIMIT 5;
```

(El sistema ejecuta eso y te devuelve filas reales. Luego las interpretas.)

────────────────────────────────────────────────────────
Usuario: "¿Cuántos equipos hay?"
TÚ DEBES RESPONDER ASÍ:

```sql
SELECT COUNT(*) as total_equipos FROM "teams";
```

════════════════════════════════════════════════════════
FLUJO OBLIGATORIO
════════════════════════════════════════════════════════
1. El usuario hace una pregunta sobre datos.
2. Tu analiza la pregunta y la traduzcas a SQL para responder basado en el esquema de la base de datos.
2. TÚ escribes SQL en bloques ```sql ... ```.
3. El sistema ejecuta el SQL y te devuelve resultados REALES.
4. TÚ interpretas esos resultados en español claro y conciso.
5. Nunca te saltes el paso 2. Siempre consulta antes de responder.
6. Nunca modificas la base de datos. SOLO lee y filtra.

════════════════════════════════════════════════════════
REGLAS SQL
════════════════════════════════════════════════════════
- Usa comillas dobles para nombres: "tabla"."columna"
- Usa LIMIT en tablas grandes para no sobrecargar
- Puedes encadenar múltiples consultas en un mismo mensaje
- Para texto parcial: LIKE '%valor%'
- Para aleatorio: ORDER BY RANDOM()

════════════════════════════════════════════════════════
ESQUEMA DE LA BASE DE DATOS (tus tablas disponibles)
════════════════════════════════════════════════════════
{schema}

════════════════════════════════════════════════════════
FORMATO DE RESPUESTA
════════════════════════════════════════════════════════
- Primero el hallazgo principal, luego el detalle.
- Sé conciso y directo.
- Responde SIEMPRE en español.
{sql_context_section}"""


def build_system_prompt(schema: str, sql_context: str = "") -> str:
    sql_section = ""
    if sql_context:
        sql_section = (
            "\n════════════════════════════════════════════════════════\n"
            "PROCEDIMIENTOS Y CONSULTAS DE NEGOCIO (archivos SQL de referencia)\n"
            "════════════════════════════════════════════════════════\n"
            + sql_context
        )
    return SYSTEM_PROMPT_TEMPLATE.format(schema=schema, sql_context_section=sql_section)


# ── Agente principal ───────────────────────────────────────────────────────────

def agent_turn(model: str, history: list, schema: str,
               user_msg: str, conn: sqlite3.Connection,
               sql_context: str = "", silent: bool = False) -> str:
    """Un turno del agente. Itera ejecutando SQL hasta obtener respuesta final."""

    history.append({"role": "user", "content": user_msg})
    system = build_system_prompt(schema, sql_context)

    for _ in range(5):
        ai_text = ollama_chat(model, history[-HISTORY_TURNS * 2:], system)
        if not ai_text:
            return ""

        sql_blocks = extract_sql_blocks(ai_text)

        if not sql_blocks:
            history.append({"role": "assistant", "content": ai_text})
            return ai_text

        results = []
        for sql in sql_blocks:
            sql = sql.strip()
            if not silent:
                print(c(f"\n  ▶ SQL: {sql[:100]}{'…' if len(sql)>100 else ''}", DIM))
            result, ok = run_query(conn, sql)
            icon = c("✓", GREEN) if ok else c("✗", RED)
            preview = result[:400] + ("…" if len(result) > 400 else "")
            if not silent:
                print(f"  {icon} {c(preview, DIM)}\n")
            results.append(f"Consulta:\n```sql\n{sql}\n```\nResultado:\n{result}")

        history.append({"role": "assistant", "content": ai_text})
        feedback = (
            "Resultados de tus consultas SQL:\n\n"
            + "\n\n---\n\n".join(results)
            + "\n\nAhora interpreta estos resultados reales en español."
        )
        history.append({"role": "user", "content": feedback})

    return "⚠ El agente alcanzó el límite de iteraciones."


def warmup_agent(model: str, history: list, schema: str,
                 conn: sqlite3.Connection, sql_context: str = ""):
    """Ejecuta un turno silencioso para verificar que el agente puede consultar la DB."""
    print(c("  Verificando acceso a la base de datos...", DIM), end="", flush=True)

    # Obtenemos la primera tabla del esquema para la prueba
    cur = conn.cursor()
    cur.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name LIMIT 1")
    row = cur.fetchone()
    if not row:
        print(c(" sin tablas.", YELLOW))
        return

    tabla = row[0]
    warmup_msg = (
        f'Confirma que tienes acceso ejecutando: SELECT COUNT(*) FROM "{tabla}". '
        f'Responde SOLO con el número que obtengas.'
    )

    # Ejecutamos silenciosamente (redirigimos stdout temporalmente)
    import io, contextlib
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        agent_turn(model, history, schema, warmup_msg, conn, sql_context, silent=True)

    history.clear()  # Limpiamos el historial del warmup
    print(c(" listo.", GREEN))


# ── Comandos rápidos ───────────────────────────────────────────────────────────

QUICK = {
    "/tablas":     "Lista todas las tablas con el número exacto de filas de cada una.",
    "/nulos":      "Encuentra y cuantifica valores NULL en todas las columnas de todas las tablas. Muestra el porcentaje de nulos por columna.",
    "/duplicados": "Detecta filas completamente duplicadas en cada tabla.",
    "/outliers":   "Detecta valores atípicos en todas las columnas numéricas usando min, max, avg y stddev.",
    "/integridad": "Verifica claves foráneas: busca registros cuyos valores FK no existan en la tabla padre.",
    "/tendencias": "Analiza columnas de tipo fecha o timestamp: distribución por año/mes y tendencias.",
    "/health":     "Health check completo: conteos, nulos, duplicados de PK, integridad FK y estadísticas numéricas.",
}


def print_help(model: str):
    print(c(f"\nModelo activo: {model}", GREEN))
    print(c("Comandos rápidos:", BOLD))
    cmds = list(QUICK.keys()) + ["/esquema", "/modelos", "/salir", "/ayuda"]
    descs = list(QUICK.values()) + [
        "Mostrar esquema de la DB",
        "Listar modelos Ollama disponibles",
        "Salir",
        "Mostrar esta ayuda",
    ]
    for cmd, desc in zip(cmds, descs):
        print(f"  {c(cmd, YELLOW, BOLD):<18} {desc}")
    print()


# ── Main ───────────────────────────────────────────────────────────────────────

def main():
    global OLLAMA_URL
    parser = argparse.ArgumentParser(
        prog="sqlite_agent_ollama",
        description="Agente de análisis SQLite con Ollama — 100% local",
    )
    parser.add_argument(
        "--db", required=True, metavar="RUTA",
        help="Ruta al archivo SQLite (.db / .sqlite / .sqlite3)",
    )
    parser.add_argument(
        "--modelo", default=DEFAULT_MODEL, metavar="NOMBRE",
        help=f"Modelo Ollama a usar (default: {DEFAULT_MODEL})",
    )
    parser.add_argument(
        "--url", default=OLLAMA_URL, metavar="URL",
        help=f"URL del servidor Ollama (default: {OLLAMA_URL})",
    )
    parser.add_argument(
        "--contexto", default=None, metavar="CARPETA",
        help="Carpeta con archivos .sql de contexto (ej: ../database)",
    )
    args = parser.parse_args()

    db_path    = args.db
    model      = args.modelo
    OLLAMA_URL = args.url
    contexto   = args.contexto

    if not os.path.exists(db_path):
        print(c(f"ERROR: No se encontró: {db_path}", RED))
        sys.exit(1)

    print(c(f"\n  SQLite Agent (Ollama) — {os.path.basename(db_path)}", CYAN, BOLD))
    print(c(f"  {db_path}  ({os.path.getsize(db_path)/1e6:.1f} MB)", DIM))

    models_available = ollama_list_models()
    if not models_available:
        print(c("\nERROR: No se puede conectar con Ollama.", RED))
        print("1. Instala Ollama: https://ollama.com")
        print("2. Ejecútalo:      ollama serve")
        print(f"3. Descarga modelo: ollama pull {model}")
        sys.exit(1)

    if model not in models_available:
        print(c(f"\nModelo '{model}' no encontrado.", YELLOW))
        print(f"Modelos disponibles: {', '.join(models_available)}")
        if models_available:
            model = models_available[0]
            print(c(f"Usando: {model}", GREEN))
        else:
            print(c(f"Descarga uno con: ollama pull qwen2.5-coder", YELLOW))
            sys.exit(1)

    conn = sqlite3.connect(db_path)
    conn.execute("PRAGMA journal_mode=WAL")
    conn.execute("PRAGMA foreign_keys=ON")

    print("\nLeyendo esquema...", end="", flush=True)
    schema = get_schema(conn)
    print(c(" listo.", GREEN))

    sql_context = ""
    if contexto:
        print(c(f"Cargando contexto SQL de {contexto}...", DIM))
        sql_context = load_sql_context(contexto)

    print(c("Cargando modelo en memoria...", DIM), end="", flush=True)
    ollama_load_model(model)
    print(c(" listo.", GREEN))

    history: list = []

    # ── Warm-up: verifica que el modelo sabe usar la DB antes de interactuar ──
    warmup_agent(model, history, schema, conn, sql_context)

    print_help(model)

    while True:
        try:
            user_input = input(c("Tú > ", BOLD, CYAN)).strip()
        except (KeyboardInterrupt, EOFError):
            print(c("\nHasta luego.", DIM))
            break

        if not user_input:
            continue

        if user_input == "/salir":
            print(c("Hasta luego.", DIM))
            break
        elif user_input == "/ayuda":
            print_help(model)
            continue
        elif user_input == "/esquema":
            print(c("\n" + schema + "\n", DIM))
            continue
        elif user_input == "/modelos":
            ms = ollama_list_models()
            print(c("\nModelos disponibles:", BOLD))
            for m in ms:
                marker = c(" ◀ activo", GREEN) if m == model else ""
                print(f"  · {m}{marker}")
            print()
            continue
        elif user_input.startswith("/modelo "):
            new_model = user_input.split(" ", 1)[1].strip()
            if new_model in ollama_list_models():
                model = new_model
                history = []
                print(c(f"Modelo cambiado a: {model}", GREEN))
                # Re-ejecutar warmup con el nuevo modelo
                warmup_agent(model, history, schema, conn, sql_context)
            else:
                print(c(f"Modelo no disponible: {new_model}", RED))
            continue
        elif user_input in QUICK:
            user_input = QUICK[user_input]
            print(c(f"  → {user_input}", DIM))

        print()
        agent_turn(model, history, schema, user_input, conn, sql_context)
        print()

    print(c("Liberando modelo de memoria...", DIM), end="", flush=True)
    ollama_unload_model(model)
    print(c(" listo.", GREEN))
    conn.close()


if __name__ == "__main__":
    main()
