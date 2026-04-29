DROP TABLE IF EXISTS stg_box_team_batting;

-- Staging: Totales de bateo a nivel de equipo por juego (fuente: MLB Stats API boxscore)
CREATE TABLE IF NOT EXISTS stg_box_team_batting (
  atBats INTEGER,                -- Turnos al bate del equipo (AB)
  baseOnBalls INTEGER,           -- Bases por bolas (BB)
  catchersInterference INTEGER,  -- Interferencias del catcher
  caughtStealing INTEGER,        -- Atrapados robando base (CS)
  doubles INTEGER,               -- Dobles (2B)
  flyOuts INTEGER,               -- Elevados de out
  groundIntoDoublePlay INTEGER,  -- Doble plays por roletazo (GIDP)
  groundIntoTriplePlay INTEGER,  -- Triple plays por roletazo
  groundOuts INTEGER,            -- Roletazos de out
  hitByPitch INTEGER,            -- Golpeados por lanzamiento (HBP)
  hits INTEGER,                  -- Hits (H)
  homeRuns INTEGER,              -- Jonrones (HR)
  intentionalWalks INTEGER,      -- Bases por bolas intencionales (IBB)
  leftOnBase INTEGER,            -- Dejados en base (LOB)
  pickoffs INTEGER,              -- Sorprendidos en base
  rbi INTEGER,                   -- Carreras impulsadas (RBI)
  runs INTEGER,                  -- Carreras anotadas (R)
  sacBunts INTEGER,              -- Toques de sacrificio
  sacFlies INTEGER,              -- Elevados de sacrificio (SF)
  stolenBases INTEGER,           -- Bases robadas (SB)
  strikeOuts INTEGER,            -- Ponches (SO)
  totalBases INTEGER,            -- Total de bases (TB)
  triples INTEGER,               -- Triples (3B)
  gamePk INTEGER,                -- ID único del juego
  teamId INTEGER,                -- ID del equipo
  teamType TEXT                  -- Tipo de equipo: "home" o "away"
);
