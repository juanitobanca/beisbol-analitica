DROP TABLE IF EXISTS stg_box_team;

-- Staging: Metadatos de equipos por juego (fuente: MLB Stats API boxscore)
CREATE TABLE IF NOT EXISTS stg_box_team (
  abbreviation TEXT,       -- Abreviatura del equipo (ej: "NYY", "LAD")
  active INTEGER,          -- 1 si el equipo está activo
  allStarStatus TEXT,      -- Estado de All-Star
  fileCode TEXT,           -- Código de archivo del equipo
  firstYearOfPlay TEXT,    -- Primer año de juego
  locationName TEXT,       -- Ciudad del equipo (ej: "New York", "Los Angeles")
  parentOrgId INTEGER,     -- ID de la organización padre (para ligas menores)
  parentOrgName TEXT,      -- Nombre de la organización padre
  season INTEGER,          -- Temporada
  shortName TEXT,          -- Nombre corto del equipo
  teamCode TEXT,           -- Código interno del equipo
  teamName TEXT,           -- Nombre del equipo (ej: "Yankees", "Dodgers")
  id INTEGER,              -- ID del equipo en la API
  name TEXT,               -- Nombre completo (ej: "New York Yankees")
  link TEXT,               -- Enlace API del equipo
  leagueId INTEGER,        -- ID de la liga (ej: AL=103, NL=104)
  leagueName TEXT,         -- Nombre de la liga
  leagueLink TEXT,         -- Enlace API de la liga
  venueId INTEGER,         -- ID del estadio
  venueName TEXT,          -- Nombre del estadio
  venueLink TEXT,          -- Enlace API del estadio
  divisionId INTEGER,      -- ID de la división
  divisionName TEXT,       -- Nombre de la división (ej: "AL East")
  divisionLink TEXT,       -- Enlace API de la división
  gamePk INTEGER,          -- ID único del juego
  teamId INTEGER,          -- ID del equipo en este juego
  teamType TEXT            -- Tipo de equipo: "home" o "away"
);
