DROP TABLE IF EXISTS stg_box_team_pitching;

-- Staging: Totales de pitcheo a nivel de equipo por juego (fuente: MLB Stats API boxscore)
CREATE TABLE IF NOT EXISTS stg_box_team_pitching (
  airOuts INTEGER,                  -- Outs por elevado
  atBats INTEGER,                   -- Turnos al bate enfrentados (AB)
  baseOnBalls INTEGER,              -- Bases por bolas otorgadas (BB)
  battersFaced INTEGER,             -- Bateadores enfrentados (BF)
  catchersInterference INTEGER,     -- Interferencias del catcher
  caughtStealing INTEGER,           -- Corredores atrapados robando (CS)
  completeGames INTEGER,            -- Juegos completos (CG)
  doubles INTEGER,                  -- Dobles permitidos (2B)
  earnedRuns INTEGER,               -- Carreras limpias (ER)
  groundOuts INTEGER,               -- Outs por roletazo
  hitBatsmen INTEGER,               -- Bateadores golpeados (HBP)
  hits INTEGER,                     -- Hits permitidos (H)
  homeRuns INTEGER,                 -- Jonrones permitidos (HR)
  inheritedRunners INTEGER,         -- Corredores heredados
  inheritedRunnersScored INTEGER,   -- Corredores heredados que anotaron
  intentionalWalks INTEGER,         -- Bases por bolas intencionales (IBB)
  outs INTEGER,                     -- Outs registrados
  pickoffs INTEGER,                 -- Pickoffs realizados
  rbi INTEGER,                      -- Carreras impulsadas permitidas
  runs INTEGER,                     -- Carreras permitidas (R)
  sacBunts INTEGER,                 -- Toques de sacrificio permitidos
  sacFlies INTEGER,                 -- Elevados de sacrificio permitidos (SF)
  saveOpportunities INTEGER,        -- Oportunidades de salvamento (SVO)
  shutouts INTEGER,                 -- Blanqueadas (SHO)
  stolenBases INTEGER,              -- Bases robadas permitidas (SB)
  strikeOuts INTEGER,               -- Ponches (SO)
  triples INTEGER,                  -- Triples permitidos (3B)
  wildPitches INTEGER,              -- Lanzamientos descontrolados (WP)
  gamePk INTEGER,                   -- ID único del juego
  teamId INTEGER,                   -- ID del equipo
  teamType TEXT                     -- Tipo de equipo: "home" o "away"
);
