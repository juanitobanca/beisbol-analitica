DROP TABLE IF EXISTS stg_box_player_batting;

-- Staging: Estadísticas de bateo por jugador por juego (fuente: MLB Stats API boxscore)
CREATE TABLE stg_box_player_batting (
  atBats REAL,     -- Turnos al bate (AB)
  baseOnBalls REAL,       -- Bases por bolas (BB)
  catchersInterference REAL,     -- Interferencias del catcher
  caughtStealing REAL,    -- Atrapado robando base (CS)
  doubles REAL,    -- Dobles (2B)
  flyOuts REAL,    -- Elevados de out
  groundIntoDoublePlay REAL,     -- Doble plays por roletazo (GIDP)
  groundIntoTriplePlay REAL,     -- Triple plays por roletazo
  groundOuts REAL,  -- Roletazos de out
  hitByPitch REAL,  -- Golpeado por lanzamiento (HBP)
  hits REAL,       -- Hits (H)
  homeRuns REAL,    -- Jonrones (HR)
  intentionalWalks REAL,  -- Bases por bolas intencionales (IBB)
  leftOnBase REAL,  -- Dejados en base (LOB)
  pickoffs REAL,    -- Sorprendido en base (pickoff)
  rbi REAL,  -- Carreras impulsadas (RBI)
  runs REAL,       -- Carreras anotadas (R)
  sacBunts REAL,    -- Toques de sacrificio
  sacFlies REAL,    -- Elevados de sacrificio (SF)
  stolenBases REAL,       -- Bases robadas (SB)
  strikeOuts REAL,  -- Ponches (SO)
  totalBases REAL,  -- Total de bases (TB)
  triples REAL,    -- Triples (3B)
  gamePk INTEGER,   -- ID único del juego
  teamId INTEGER,   -- ID del equipo
  teamType TEXT,    -- Tipo de equipo: "home" o "away"
  playerId INTEGER  -- ID del jugador
);
