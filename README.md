MLB Stats API Scraper

Overview

Este proyecto implementa un pipeline de extracción de datos (ETL) para la MLB Stats API. Su objetivo es recolectar, transformar y persistir datos de juegos de béisbol en una base de datos (SQLite u otra vía SQLAlchemy).

El sistema está diseñado con separación de responsabilidades, concurrencia y modularidad para facilitar mantenimiento y escalabilidad.

⸻

Arquitectura

El sistema está dividido en tres capas principales:

1. Coordinación

Responsable del flujo general del programa.

* orchestrator.py: Punto de entrada y coordinación del pipeline
* scheduler.py: Obtiene los game_pk desde la API
* pipeline.py: Ejecuta scraping concurrente
* db_writer.py: Inserta datos en la base de datos

2. Scrapers

Encargados de consumir endpoints específicos y transformar respuestas en datasets.

* Boxscore
* PlayByPlay
* ContextMetrics
* People
* Transactions
* BaseScraper (clase abstracta base)

3. Infraestructura

Componentes reutilizables y configuración.

* http_client
* endpoints
* config
* dataset
* extractor
* mappings
* table_names
* const/ (package modularizado)

⸻

Flujo de ejecución

1. El usuario ejecuta:

python orchestrator.py --lg MLB --date 2024-04-01

2. scheduler.get_schedule() obtiene los game_pk desde /schedule
3. orchestrator.run() divide los juegos en chunks
4. pipeline.scrape_chunk() ejecuta scraping concurrente usando threads
5. Cada scraper produce datasets:
    * Boxscore (~12 datasets)
    * PlayByPlay (~6 datasets)
    * ContextMetrics (1 dataset)
6. Los resultados se combinan en ChunkResult
7. db_writer.insert_dataset():
    * Convierte a pandas.DataFrame
    * Inserta usando to_sql(if_exists="append")
8. Se escriben ~19 tablas en staging
9. Se disparan scrapers adicionales:
    * People
    * Transactions

⸻

Refactor reciente

Problema 1: Orquestador monolítico

Solución: separación en módulos independientes:

* scheduler
* pipeline
* db_writer
* orchestrator

Problema 2: const.py monolítico

Solución: convertido en package:

const/
  ├── endpoints.py
  ├── context_metrics.py
  ├── people.py
  ├── transactions.py
  ├── play_by_play.py
  ├── boxscore.py
  └── __init__.py

⸻

Problemas pendientes

1. Estado mutable en scrapers
    * Los scrapers acumulan estado interno
    * Riesgo de sobrescritura silenciosa
2. Merge manual de datasets
    * ChunkResult reduce el problema pero no lo elimina
3. Manejo de errores inconsistente
    * Mezcla de excepciones y logs sin política clara
4. Duplicación de Dataset
    * Definido en múltiples módulos
5. Configuración duplicada
    * config.yaml vs Settings
6. Falta de transacciones en BD
    * Riesgo de datos parciales

⸻

Cómo ejecutar

Requisitos

* Python 3.10+
* pandas
* SQLAlchemy

Ejecución

python orchestrator.py --lg MLB --date YYYY-MM-DD --batch 10

⸻

Diseño clave

* Separación estricta de responsabilidades
* Concurrencia con ThreadPoolExecutor
* Scrapers desacoplados de persistencia
* Infraestructura reutilizable

⸻

Próximos pasos sugeridos

* Hacer scrapers stateless
* Implementar transacciones en BD
* Centralizar manejo de errores
* Eliminar duplicación de modelos (Dataset)
* Validación de datos antes de persistencia

⸻

Notas

Este documento refleja el estado actual después de los refactors principales y sirve como base para futuras mejoras de arquitectura.
