DROP TABLE IF EXISTS major_leagues;

-- Base: Catálogo de ligas mayores (ej: MLB, LMB)
CREATE TABLE major_leagues (
  majorLeagueId INTEGER,         -- ID único de la liga mayor
  majorLeague TEXT,              -- Nombre de la liga (ej: "MLB", "LMB")
  PRIMARY KEY(majorLeagueId)
);
