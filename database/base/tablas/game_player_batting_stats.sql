DROP TABLE IF EXISTS game_player_batting_stats;

-- Base: Estadísticas de bateo por jugador por juego (limpiado de stg_box_player_batting)
CREATE TABLE game_player_batting_stats (
  gamePk INTEGER,                -- ID único del juego
  teamId INTEGER,                -- ID del equipo
  teamType TEXT,                 -- Tipo de equipo: "home" o "away"
  playerId INTEGER,              -- ID del jugador
  atBats INTEGER,                -- Turnos al bate (AB)
  walks INTEGER,                 -- Bases por bolas (BB)
  catchersInterference INTEGER,  -- Interferencias del catcher
  caughtStealing INTEGER,        -- Atrapado robando base (CS)
  doubles INTEGER,               -- Dobles (2B)
  flyOuts INTEGER,               -- Elevados de out
  groundIntoDoublePlay INTEGER,  -- Doble plays por roletazo (GIDP)
  groundIntoTriplePlay INTEGER,  -- Triple plays por roletazo
  groundOuts INTEGER,            -- Roletazos de out
  hitByPitch INTEGER,            -- Golpeado por lanzamiento (HBP)
  hits INTEGER,                  -- Hits (H)
  homeRuns INTEGER,              -- Jonrones (HR)
  intentionalWalks INTEGER,      -- Bases por bolas intencionales (IBB)
  leftOnBase INTEGER,            -- Dejados en base (LOB)
  pickoffs INTEGER,              -- Sorprendido en base (pickoff)
  plateAppearances INTEGER,      -- Apariciones al plato (PA)
  rbi INTEGER,                   -- Carreras impulsadas (RBI)
  runs INTEGER,                  -- Carreras anotadas (R)
  sacBunts INTEGER,              -- Toques de sacrificio
  sacFlies INTEGER,              -- Elevados de sacrificio (SF)
  singles INTEGER,               -- Sencillos (1B)
  stolenBases INTEGER,           -- Bases robadas (SB)
  strikeOuts INTEGER,            -- Ponches (SO)
  totalBases INTEGER,            -- Total de bases (TB)
  triples INTEGER,               -- Triples (3B)
  unintentionalWalks INTEGER,    -- Bases por bolas no intencionales
  PRIMARY KEY(gamePk, teamId, playerId)
);
