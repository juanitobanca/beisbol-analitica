DROP TABLE IF EXISTS officials;

-- Base: Catálogo de oficiales (umpires) con datos biográficos (limpiado de stg_officials)
CREATE TABLE officials (
  officialId INTEGER,            -- ID único del oficial
  firstName TEXT,                -- Primer nombre
  lastName TEXT,                 -- Apellido
  birthDate TEXT,                -- Fecha de nacimiento (YYYY-MM-DD)
  birthCity TEXT,                -- Ciudad de nacimiento
  birthStateProvince TEXT,       -- Estado o provincia de nacimiento
  birthCountry TEXT,             -- País de nacimiento
  PRIMARY KEY(officialId)
);
