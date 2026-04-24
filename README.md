# MLB Stats API Scraper

## Overview

Este proyecto implementa un pipeline de extracción de datos (ETL) para la MLB Stats API. Su objetivo es recolectar, transformar y persistir datos de juegos de béisbol en una base de datos (SQLite u otra vía SQLAlchemy).

El sistema está diseñado con separación de responsabilidades, concurrencia y modularidad para facilitar mantenimiento y escalabilidad.

---

## Arquitectura

El sistema está dividido en tres capas principales:

### 1. Coordinación
Responsable del flujo general del programa.

- `orchestrator.py`: Punto de entrada y coordinación del pipeline
- `scheduler.py`: Obtiene los `game_pk` desde la API
- `pipeline.py`: Ejecuta scraping concurrente
- `db_writer.py`: Inserta datos en la base de datos

### 2. Scrapers
Encargados de consumir endpoints específicos y transformar respuestas en datasets.

- `Boxscore`
- `PlayByPlay`
- `ContextMetrics`
- `People`
- `Transactions`
- `BaseScraper` (clase abstracta base)

### 3. Infraestructura
Componentes reutilizables y configuración.

- `http_client`
- `endpoints`
- `config`
- `dataset`
- `extractor`
- `mappings`
- `table_names`
- `const/` (package modularizado)

---

## Flujo de ejecución

1. El usuario ejecuta:

```bash
python orchestrator.py --lg MLB --date 2024-04-01
