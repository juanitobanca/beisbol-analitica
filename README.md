# Beisbol Analitica

Plataforma de datos para analisis de beisbol profesional. Extrae datos de la [MLB Stats API](http://statsapi.mlb.com/api/v1), los almacena en una base de datos relacional y los transforma en metricas analiticas avanzadas.

Cubre MLB y multiples ligas latinoamericanas e internacionales (LMB, LMP, LIDOM, LVBP, LBPRC, DSL, VSL, WBC, Serie del Caribe).

## Componentes

El proyecto se divide en dos componentes principales:

### Scraper (`scraper/`)

Pipeline ETL en Python que consume la MLB Stats API para extraer datos de juegos de beisbol. Para cada juego obtiene boxscore, play-by-play (incluyendo datos Statcast), contexto del juego, datos biograficos de jugadores y transacciones.

- Scraping concurrente con `ThreadPoolExecutor`
- Configurable por liga, rango de fechas, batch size y workers
- Inserta datos en ~18 tablas staging via Pandas + SQLAlchemy
- Compatible con SQLite, PostgreSQL y cualquier backend de SQLAlchemy

```bash
python scraper/orchestrator.py --lg MLB --startDate 2024_04_01 --endDate 2024_09_30
```

Ver [`scraper/README.md`](scraper/README.md) para documentacion completa.

### Database (`database/`)

Base de datos SQLite con arquitectura de data warehouse por capas. Los datos crudos del scraper aterrizan en staging, se limpian y normalizan en tablas base, y se transforman en metricas agregadas y modelos analiticos.

```
Staging (datos crudos) → Base (datos limpios) → Agregados y modelos analiticos
```

**Capas analiticas:**

- **Agregados** — estadisticas acumuladas de bateo, pitcheo, fildeo y rendimiento de equipos, con metricas derivadas (wOBA, wRAA, wRC, OPS+, FIP)
- **Park Factors** — ajuste de estadisticas por estadio y zona del campo
- **Run Expectancy** — matriz RE24 y valor en carreras por tipo de evento
- **Win Expectancy** — probabilidad de victoria por situacion de juego y WPA por jugada

Ver [`database/README.md`](database/README.md) para documentacion completa.

## Requisitos

- Python 3.10+
- Dependencias: `requests`, `pandas`, `sqlalchemy`, `pydantic-settings`, `pyyaml`

## Instalacion

```bash
cd scraper
pip install .
```

## Uso rapido

```bash
# 1. Crear las tablas
sqlite3 baseball.db < database/setup/tables.sql

# 2. Scrapear datos
python scraper/orchestrator.py --lg MLB --date 2024_07_15

# 3. Transformar staging → base → agregados
sqlite3 baseball.db < database/setup/procedures.sql
```
