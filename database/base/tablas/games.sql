DROP TABLE IF EXISTS games;

-- Base: Catálogo de juegos con resultados, equipos y metadatos (limpiado de stg_game_context y stg_box_info)
CREATE TABLE games (
  gamePk INTEGER,                    -- ID único del juego en MLB Stats API
  gameType TEXT,                     -- Tipo de juego: "R"=regular, "P"=postemporada, "S"=spring training
  gameType2 TEXT,                    -- Tipo de juego secundario: "RS"=temporada regular, "PS"=postemporada
  seasonId INTEGER,                  -- Año de la temporada
  gameDate TEXT,                     -- Fecha del juego (YYYY-MM-DD)
  isTie INTEGER,                     -- 1 si el juego terminó en empate
  gameNumber INTEGER,                -- Número de juego (1 o 2 para doubleheaders)
  majorLeague TEXT,                  -- Nombre de la liga mayor (ej: "LMB", "MLB")
  majorLeagueId INTEGER,             -- ID de la liga mayor
  doubleHeader TEXT,                 -- "Y" si es doubleheader, "N" si no
  dayNight TEXT,                     -- "day" o "night"
  scheduledInnings INTEGER,          -- Innings programados (normalmente 9)
  gamesInSeries INTEGER,             -- Total de juegos en la serie
  seriesDescription TEXT,            -- Descripción de la serie (ej: "Regular Season")
  ifNecessaryDescription TEXT,       -- Descripción si el juego es "si es necesario" (postemporada)
  gameId TEXT,                       -- ID alternativo del juego (formato fecha/equipos)
  abstractGameState TEXT,            -- Estado abstracto: "Final", "Live", "Preview"
  codedGameState TEXT,               -- Estado codificado: "F", "I", "P"
  detailedState TEXT,                -- Estado detallado: "Final", "In Progress", etc.
  awayWins INTEGER,                  -- Victorias del equipo visitante en la temporada
  awayLosses INTEGER,                -- Derrotas del equipo visitante en la temporada
  awayPct REAL,                      -- Porcentaje de victorias del visitante
  awayScore INTEGER,                 -- Carreras del equipo visitante
  awayTeamId INTEGER,                -- ID del equipo visitante
  awayIsWinner INTEGER,              -- 1 si el visitante ganó
  homeWins INTEGER,                  -- Victorias del equipo local en la temporada
  homeLosses INTEGER,                -- Derrotas del equipo local en la temporada
  homePct REAL,                      -- Porcentaje de victorias del local
  homeScore INTEGER,                 -- Carreras del equipo local
  homeTeamId INTEGER,                -- ID del equipo local
  homeIsWinner INTEGER,              -- 1 si el local ganó
  venueId INTEGER,                   -- ID del estadio
  homeTeamName TEXT,                 -- Nombre del equipo local
  awayTeamName TEXT,                 -- Nombre del equipo visitante
  venueName TEXT,                    -- Nombre del estadio
  weather TEXT,                      -- Condiciones climáticas (ej: "72 degrees, Partly Cloudy")
  wind TEXT,                         -- Condiciones de viento (ej: "8 mph, Out To CF")
  attendance INTEGER,                -- Asistencia del público al juego
  PRIMARY KEY (gamePk, majorLeagueId)
);

CREATE INDEX IF NOT EXISTS idx_games_seasonId ON games(seasonId);
CREATE INDEX IF NOT EXISTS idx_games_homeTeamId ON games(homeTeamId);
CREATE INDEX IF NOT EXISTS idx_games_awayTeamId ON games(awayTeamId);
CREATE INDEX IF NOT EXISTS idx_games_venueId ON games(venueId);
