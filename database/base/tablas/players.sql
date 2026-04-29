DROP TABLE IF EXISTS players;

-- Base: Catálogo de jugadores con datos biográficos esenciales (limpiado de stg_players)
 CREATE TABLE players (
  playerId INTEGER,            -- ID único del jugador
  firstName TEXT,              -- Primer nombre
  lastName TEXT,               -- Apellido
  fullName TEXT,               -- Nombre completo
  birthDate TEXT,              -- Fecha de nacimiento (YYYY-MM-DD)
  birthCity TEXT,              -- Ciudad de nacimiento
  birthStateProvince TEXT,     -- Estado o provincia de nacimiento
  birthCountry TEXT,           -- País de nacimiento
  strikeZoneTop REAL,          -- Límite superior personalizado de zona de strike (pies)
  strikeZoneBottom REAL,       -- Límite inferior personalizado de zona de strike (pies)
  positionAbbrev TEXT,         -- Abreviatura de posición principal (ej: "SS", "P", "CF")
  batSide TEXT,                -- Lado de bateo: "L", "R" o "S" (switch)
  pitchHand TEXT,              -- Mano de pitcheo: "L" o "R"
  PRIMARY KEY(playerId)
);
