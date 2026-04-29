DROP TABLE IF EXISTS stg_officials;

-- Staging: Catálogo de oficiales/umpires con datos biográficos (fuente: MLB Stats API people)
CREATE TABLE IF NOT EXISTS stg_officials (
  abbreviation TEXT,         -- Abreviatura de la posición
  batSideCode TEXT,          -- Código del lado de bateo (no aplica para oficiales)
  pitchHandCode TEXT,        -- Código de mano de pitcheo (no aplica para oficiales)
  id INTEGER,                -- ID único del oficial
  fullName TEXT,             -- Nombre completo
  link TEXT,                 -- Enlace API del oficial
  firstName TEXT,            -- Primer nombre
  lastName TEXT,             -- Apellido
  birthDate TEXT,            -- Fecha de nacimiento (YYYY-MM-DD)
  currentAge INTEGER,        -- Edad actual
  birthCity TEXT,            -- Ciudad de nacimiento
  birthStateProvince TEXT,   -- Estado o provincia de nacimiento
  birthCountry TEXT,         -- País de nacimiento
  height TEXT,               -- Estatura
  weight INTEGER,            -- Peso en libras
  active INTEGER,            -- 1 si el oficial está activo
  useName TEXT,              -- Nombre de uso
  middleName TEXT,           -- Segundo nombre
  boxscoreName TEXT,         -- Nombre en el boxscore
  nameFirstLast TEXT,        -- Nombre formato "Nombre Apellido"
  nameSlug TEXT,             -- Slug del nombre para URLs
  firstLastName TEXT,        -- Nombre completo formato "Nombre Apellido"
  lastFirstName TEXT,        -- Nombre completo formato "Apellido, Nombre"
  lastInitName TEXT,         -- Formato "Apellido, N."
  initLastName TEXT,         -- Formato "N. Apellido"
  fullFMLName TEXT,          -- Nombre completo con segundo nombre
  fullLFMName TEXT,          -- Nombre completo formato "Apellido, Nombre Segundo"
  strikeZoneTop REAL,        -- Límite superior de zona de strike (no aplica)
  strikeZoneBottom REAL      -- Límite inferior de zona de strike (no aplica)
);
