DROP TABLE IF EXISTS stg_game_context;

-- Staging: Contexto y metadatos completos de cada juego (fuente: MLB Stats API schedule/game)
 CREATE TABLE stg_game_context (
  gamePk INTEGER,                  -- ID único del juego en MLB Stats API
  gameType TEXT,                   -- Tipo de juego: "R"=regular, "P"=postemporada, "S"=spring training, etc.
  majorLeague TEXT,                -- Nombre de la liga mayor (ej: "LMB", "MLB")
  majorLeagueId INTEGER,           -- ID de la liga mayor
  season TEXT,                     -- Temporada (año)
  gameDate TEXT,                   -- Fecha del juego (YYYY-MM-DD)
  isTie INTEGER,                   -- 1 si el juego terminó en empate
  gameNumber INTEGER,              -- Número de juego (1 o 2 para doubleheaders)
  publicFacing INTEGER,            -- 1 si el juego es público
  doubleHeader TEXT,               -- "Y" si es doubleheader, "N" si no
  gamedayType TEXT,                -- Tipo de gameday
  tiebreaker TEXT,                 -- "Y" si es juego de desempate
  calendarEventID TEXT,            -- ID del evento en el calendario
  seasonDisplay TEXT,              -- Temporada para visualización
  dayNight TEXT,                   -- "day" o "night"
  description TEXT,                -- Descripción del juego (ej: para juegos especiales)
  scheduledInnings INTEGER,        -- Innings programados (normalmente 9, puede ser 7 en doubleheaders)
  gamesInSeries INTEGER,           -- Total de juegos en la serie
  seriesGameNumber INTEGER,        -- Número del juego dentro de la serie
  seriesDescription TEXT,          -- Descripción de la serie (ej: "Regular Season")
  recordSource TEXT,               -- Fuente del récord
  ifNecessary TEXT,                -- "Y" si el juego es "si es necesario" (postemporada)
  ifNecessaryDescription TEXT,     -- Descripción del juego si es necesario
  gameId TEXT,                     -- ID alternativo del juego (formato fecha/equipos)
  abstractGameState TEXT,          -- Estado abstracto: "Final", "Live", "Preview"
  codedGameState TEXT,             -- Estado codificado: "F", "I", "P"
  detailedState TEXT,              -- Estado detallado: "Final", "In Progress", etc.
  statusCode TEXT,                 -- Código de estado
  abstractGameCode TEXT,           -- Código abstracto del estado
  awayWins INTEGER,                -- Victorias del equipo visitante en la temporada
  awayLosses INTEGER,              -- Derrotas del equipo visitante en la temporada
  awayPct TEXT,                    -- Porcentaje de victorias del visitante
  awayScore INTEGER,               -- Carreras del equipo visitante
  awayId INTEGER,                  -- ID del equipo visitante
  awayName TEXT,                   -- Nombre del equipo visitante
  awayIsWinner INTEGER,            -- 1 si el visitante ganó
  homeWins INTEGER,                -- Victorias del equipo local en la temporada
  homeLosses INTEGER,              -- Derrotas del equipo local en la temporada
  homePct TEXT,                    -- Porcentaje de victorias del local
  homeScore INTEGER,               -- Carreras del equipo local
  homeId INTEGER,                  -- ID del equipo local
  homeName TEXT,                   -- Nombre del equipo local
  homeIsWinner INTEGER,            -- 1 si el local ganó
  venueId INTEGER,                 -- ID del estadio
  venueName TEXT,                  -- Nombre del estadio
  venueLink TEXT                   -- Enlace API del estadio
);
