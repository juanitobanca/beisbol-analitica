# Database - Beisbol Analitica

Base de datos SQLite para almacenar y analizar datos de beisbol profesional. Sigue una arquitectura de data warehouse por capas: los datos crudos aterrizan en **staging**, se limpian y normalizan en **base**, y se transforman en **agregados** y modelos analiticos.

## Estructura de directorios

```
database/
├── setup/                  # Script maestro para crear todas las tablas
├── staging/                # Capa de aterrizaje (datos crudos de la API)
│   ├── tablas/             #   DDL de las 22 tablas stg_*
│   └── procedimientos/     #   Limpieza de tablas staging
├── base/                   # Capa de datos limpios y normalizados
│   ├── tablas/             #   DDL de las 22 tablas base
│   └── procedimientos/     #   Transformaciones staging -> base
├── agregados/              # Estadisticas agregadas por jugador/equipo/temporada
│   ├── batting/            #   Bateo: stats, splits, heatmaps
│   ├── pitching/           #   Pitcheo: stats, splits, heatmaps
│   ├── fielding/           #   Fildeo: stats
│   └── team_performance/   #   Rendimiento de equipos
├── park_factors/           # Factores de parque (ajuste por estadio)
├── run_expectancy/         # Matriz de expectativa de carreras (RE24)
├── win_expectancy/         # Expectativa de victoria (WPA)
├── commons/                # Scripts compartidos (update_table_attributes)
└── erd_diagram.png         # Diagrama entidad-relacion
```

Cada subcarpeta contiene dos directorios:
- **tablas/** - DDL (`CREATE TABLE`, `CREATE INDEX`)
- **procedimientos/** - DML (`INSERT`, `UPDATE`) que transforman y cargan datos

## Flujo de datos

```
API de beisbol
     │
     ▼
┌──────────┐     ┌──────────┐     ┌─────────────────────────┐
│ Staging  │────▶│   Base   │────▶│  Agregados / Analiticos │
│ (stg_*)  │     │          │     │                         │
└──────────┘     └──────────┘     └─────────────────────────┘
 Datos crudos     Datos limpios    Metricas derivadas
 sin validar      normalizados     por temporada/jugador
```

### 1. Staging (`staging/`)

Tablas temporales que reciben datos crudos. Todas usan el prefijo `stg_` y se dividen en tres grupos segun la fuente:

| Grupo | Tablas | Descripcion |
|-------|--------|-------------|
| Box score | `stg_box_info`, `stg_box_team`, `stg_box_officials`, `stg_box_player_*`, `stg_box_team_*` | Datos del box score (estadisticas de juego, equipos, jugadores) |
| Play-by-play | `stg_play_atbat`, `stg_play_pitch`, `stg_play_runner`, `stg_play_action`, `stg_play_credit`, `stg_play_pickoff` | Datos jugada a jugada |
| Catalogos | `stg_players`, `stg_officials`, `stg_transactions`, `stg_game_context` | Jugadores, oficiales, transacciones |

### 2. Base (`base/`)

Datos limpios con tipos correctos y relaciones definidas. Las tablas centrales son:

| Tabla | Descripcion |
|-------|-------------|
| `games` | Juegos (fecha, equipos, marcador, estadio, clima) |
| `players` | Catalogo de jugadores |
| `officials` | Catalogo de oficiales (umpires) |
| `major_leagues` | Ligas (MLB, ligas invernales, etc.) |
| `atbats` | Turnos al bate (resultado, conteo, bateador, pitcher) |
| `pitches` | Lanzamientos individuales (tipo, ubicacion, resultado) |
| `runners` | Movimiento de corredores por jugada |
| `actions` | Acciones del juego (sustituciones, revisiones) |
| `pickoffs` | Intentos de pickoff |
| `fielding_credits` | Creditos defensivos por jugada |
| `transactions` | Transacciones (trades, asignaciones, DFA) |
| `game_player_batting_stats` | Estadisticas de bateo por jugador por juego |
| `game_player_pitching_stats` | Estadisticas de pitcheo por jugador por juego |
| `game_player_fielding_stats` | Estadisticas de fildeo por jugador por juego |
| `game_player_positions` | Posiciones jugadas por jugador por juego |
| `game_player_split_stats` | Splits por jugada (vs. zurdo/derecho, conteo, etc.) |
| `game_player_fielding_outs` | Outs realizados por posicion |
| `game_player_balls_in_play_heatmaps` | Heatmaps de batazos en juego por zona |
| `game_batting_orders` | Orden al bate por juego |
| `game_battery_fielding_stats` | Estadisticas de bateria (pitcher-catcher) |
| `game_officials` | Oficiales asignados a cada juego |
| `defensive_substitutions` | Sustituciones defensivas |

### 3. Agregados (`agregados/`)

Estadisticas acumuladas por temporada con multiples niveles de agrupacion (liga, equipo, jugador, estadio, etc.) usando un sistema de `groupingId`/`groupingDescription`.

#### Batting (`agregados/batting/`)
- `agg_batting_stats` - Estadisticas acumuladas de bateo
- `agg_batting_split_stats` - Splits (vs. LHP/RHP, por conteo, hombres en base)
- `agg_batting_balls_in_play_heatmaps` - Heatmaps agregados de batazos

Metricas derivadas calculadas: **wOBA**, **wRAA**, **wRC**, **OPS+**

#### Pitching (`agregados/pitching/`)
- `agg_pitching_stats` - Estadisticas acumuladas de pitcheo
- `agg_pitching_split_stats` - Splits de pitcheo
- `agg_pitching_balls_in_play_heatmaps` - Heatmaps agregados de batazos permitidos

Metricas derivadas calculadas: **FIP**

#### Fielding (`agregados/fielding/`)
- `agg_fielding_stats` - Estadisticas acumuladas de fildeo

#### Team Performance (`agregados/team_performance/`)
- `agg_team_performance_stats` - Rendimiento de equipos por temporada

### 4. Park Factors (`park_factors/`)

Calcula cuanto influye cada estadio en las estadisticas:

- `pf_park_factors` - Factores de parque por estadio y temporada
- `pf_heat_map_park_factors` - Factores de parque por zona del campo

### 5. Run Expectancy (`run_expectancy/`)

Modelo de expectativa de carreras basado en la situacion del juego (outs + corredores en base):

- `rem_play_by_play` - Reconstruccion jugada a jugada con estado del juego (corredores, outs, carreras antes/durante/despues)
- `rem_run_expectancy_matrix` - Matriz RE24: carreras esperadas por combinacion de outs y corredores
- `rem_event_run_value` - Valor en carreras de cada tipo de evento

### 6. Win Expectancy (`win_expectancy/`)

Modelo de probabilidad de victoria basado en la situacion del juego:

- `we_win_expectancy` - Probabilidad de ganar del equipo local por inning, outs, corredores y marcador
- `we_win_probability_added` - WPA (Win Probability Added) por jugada

### 7. Commons (`commons/`)

- `update_table_attributes` - Script que denormaliza nombres de jugadores, equipos, estadios y ligas en las tablas agregadas para facilitar consultas.

## Setup

El archivo `setup/tables.sql` crea todas las tablas en orden. Se ejecuta desde la raiz del proyecto:

```bash
sqlite3 beisbol.db < database/setup/tables.sql
```

> **Nota:** Este script ejecuta `DROP TABLE IF EXISTS` antes de cada `CREATE TABLE`, por lo que destruye datos existentes si se vuelve a ejecutar.

## Diagrama entidad-relacion

Ver `erd_diagram.png` para una vista visual de las relaciones entre las tablas base.
