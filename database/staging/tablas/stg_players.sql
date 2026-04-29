DROP TABLE IF EXISTS stg_players;

-- Staging: Catálogo de jugadores con datos biográficos (fuente: MLB Stats API people)
CREATE TABLE IF NOT EXISTS stg_players (
  abbreviation TEXT,         -- Abreviatura de la posición principal
  batSideCode TEXT,          -- Código del lado de bateo: "L", "R" o "S" (switch)
  pitchHandCode TEXT,        -- Código de la mano de pitcheo: "L" o "R"
  id INTEGER,                -- ID único del jugador
  fullName TEXT,             -- Nombre completo
  link TEXT,                 -- Enlace API del jugador
  firstName TEXT,            -- Primer nombre
  lastName TEXT,             -- Apellido
  birthDate TEXT,            -- Fecha de nacimiento (YYYY-MM-DD)
  currentAge INTEGER,        -- Edad actual
  birthCity TEXT,            -- Ciudad de nacimiento
  birthStateProvince TEXT,   -- Estado o provincia de nacimiento
  birthCountry TEXT,         -- País de nacimiento
  height TEXT,               -- Estatura (ej: "6' 2\"")
  weight INTEGER,            -- Peso en libras
  active INTEGER,            -- 1 si el jugador está activo
  useName TEXT,              -- Nombre de uso
  middleName TEXT,           -- Segundo nombre
  boxscoreName TEXT,         -- Nombre en el boxscore (ej: "Ohtani, S")
  nameFirstLast TEXT,        -- Nombre en formato "Nombre Apellido"
  nameSlug TEXT,             -- Slug del nombre para URLs
  firstLastName TEXT,        -- Nombre completo formato "Nombre Apellido"
  lastFirstName TEXT,        -- Nombre completo formato "Apellido, Nombre"
  lastInitName TEXT,         -- Formato "Apellido, N."
  initLastName TEXT,         -- Formato "N. Apellido"
  fullFMLName TEXT,          -- Nombre completo con segundo nombre
  fullLFMName TEXT,          -- Nombre completo formato "Apellido, Nombre Segundo"
  strikeZoneTop REAL,        -- Límite superior personalizado de zona de strike (pies)
  strikeZoneBottom REAL      -- Límite inferior personalizado de zona de strike (pies)
);
