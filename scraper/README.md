# Beisbol Analítica — Scraper

Scraper de datos de béisbol que extrae información estructurada desde la [MLB Stats API](http://statsapi.mlb.com/api/v1) y la carga en una base de datos relacional. Cubre MLB y múltiples ligas latinoamericanas e internacionales.

## Ligas soportadas

| Código | Liga |
|--------|------|
| MLB | Major League Baseball |
| LMB | Liga Mexicana de Béisbol |
| LMP | Liga Mexicana del Pacífico |
| LIDOM | Liga Dominicana de Béisbol Invernal |
| LVBP | Liga Venezolana de Béisbol Profesional |
| LBPRC | Liga de Béisbol Profesional de Puerto Rico |
| DSL | Dominican Summer League |
| VSL | Venezuelan Summer League |
| WBC | World Baseball Classic |
| WBCQ | World Baseball Classic Qualifiers |
| SDC | Serie del Caribe |

## Datos que extrae

Para cada juego se extraen **18 tablas staging**:

- **Boxscore** — información del juego, oficiales, estadísticas de equipo (bateo/pitcheo/fildeo), estadísticas de jugador (bateo/pitcheo/fildeo), orden al bat, posiciones.
- **Play-by-play** — turnos al bat, pitcheos (con datos Statcast: velocidad de salida, ángulo de lanzamiento, spin rate, coordenadas), acciones, pickoffs, corredores, créditos de fildeo.
- **Context metrics** — metadatos del juego (fecha, estadio, equipos, récords, estado del juego).
- **People** — datos biográficos de jugadores (nombre, fecha de nacimiento, estatura, peso, mano de bateo/lanzamiento, posición).
- **Transactions** — transacciones de equipos (cambios, firmas, etc.).

## Requisitos

- Python 3.10+
- Dependencias: `requests`, `pandas`, `sqlalchemy`, `pydantic-settings`, `pyyaml`

## Instalación

```bash
pip install .

# Para desarrollo (incluye ruff y mypy)
pip install -e ".[dev]"
```

## Configuración

El archivo `config.yaml` en la raíz del proyecto contiene los valores por defecto:

```yaml
base_url: "http://statsapi.mlb.com/api/v1"
retry_delay_seconds: 20
people_batch_size: 100
default_batch_size: 500
default_workers: 10
default_db_connection: "sqlite:///baseball.db"
```

Cualquier valor se puede sobreescribir con variables de entorno usando el prefijo `SCRAPPER_` (ej. `SCRAPPER_DEFAULT_DB_CONNECTION`).

## Uso

```bash
# Juegos de MLB de ayer (comportamiento por defecto)
python orchestrator.py --lg MLB

# Fecha específica
python orchestrator.py --lg MLB --date 2024_07_15

# Rango de fechas
python orchestrator.py --lg MLB --startDate 2024_04_01 --endDate 2024_04_30

# Otra liga
python orchestrator.py --lg LMB --startDate 2024_04_01 --endDate 2024_09_30

# Base de datos diferente
python orchestrator.py --lg MLB --con "postgresql://user:pass@host/dbname"

# Ajustar batch size y workers
python orchestrator.py --lg MLB --batch 200 --workers 5
```

### Argumentos CLI

| Argumento | Default | Descripción |
|-----------|---------|-------------|
| `--lg` | (requerido) | Código de liga |
| `--date` | Ayer (`YYYY_MM_DD`) | Fecha única a scrapear |
| `--startDate` | — | Inicio del rango de fechas |
| `--endDate` | — | Fin del rango de fechas |
| `--con` | `sqlite:///baseball.db` | Connection string de SQLAlchemy |
| `--batch` | 500 | Juegos por batch antes de insertar en BD |
| `--workers` | 10 | Hilos concurrentes para scraping |

## Arquitectura

```
orchestrator.py          # Punto de entrada CLI
pipeline.py              # Scraping concurrente con ThreadPoolExecutor
scheduler.py             # Obtiene game PKs del API de schedule

core/                    # Infraestructura
├── config.py            # Settings (YAML + env vars via pydantic-settings)
├── http_client.py       # Cliente HTTP con reintentos
├── endpoints.py         # Constructores de URLs del API
├── dataset.py           # Tipo Dataset y utilidades
└── extractor.py         # Extracción de campos JSON

scrapers/                # Scrapers por dominio
├── base.py              # Clase base abstracta
├── boxscore.py          # Boxscore (11 tablas)
├── play_by_play.py      # Play-by-play (6 tablas)
├── context_metrics.py   # Contexto del juego (1 tabla)
├── people.py            # Biografía de jugadores (1 tabla)
└── transactions.py      # Transacciones (1 tabla)

constants/               # Definiciones de campos y mapeos
db/                      # Capa de base de datos (inserción con Pandas + SQLAlchemy)
```

## Flujo de datos

1. Se consulta el endpoint de **schedule** para obtener los game PKs del rango de fechas y liga.
2. Se scrapean **boxscore**, **play-by-play** y **context metrics** de cada juego en paralelo usando un pool de hilos.
3. Los resultados se insertan por batches en las **18 tablas staging** de la base de datos.
4. Se obtienen datos biográficos de **jugadores/oficiales** nuevos.
5. Se obtienen las **transacciones** de los equipos vistos.


```mermaid

sequenceDiagram

    participant CLI as CLI / main

    participant ORCH as Orchestrator

    participant SCH as Scheduler

    participant PIPE as Pipeline

    participant SCR as Scrapers

    participant DB as DB Writer

    participant SQL as Database

    CLI->>ORCH: run(date, league, batch)

    ORCH->>SCH: get_schedule()

    SCH-->>ORCH: list(game_pk)

    ORCH->>ORCH: split into chunks

    loop each chunk

        ORCH->>PIPE: scrape_chunk(chunk)

        par concurrent scraping

            PIPE->>SCR: Boxscore

            PIPE->>SCR: PlayByPlay

            PIPE->>SCR: ContextMetrics

        end

        SCR-->>PIPE: datasets

        PIPE-->>ORCH: ChunkResult

        ORCH->>DB: insert_dataset(ChunkResult)

        DB->>SQL: to_sql append

        DB->>SCR: People (new ids)

        DB->>SCR: Transactions (new ids)

    end
```
