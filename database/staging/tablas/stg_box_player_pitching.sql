DROP TABLE IF EXISTS stg_box_player_pitching;

-- Staging: Estadísticas de pitcheo por jugador por juego (fuente: MLB Stats API boxscore)
CREATE TABLE IF NOT EXISTS stg_box_player_pitching (
  airOuts REAL,                  -- Outs por elevado
  atBats REAL,                   -- Turnos al bate enfrentados (AB)
  balls REAL,                    -- Total de bolas lanzadas
  baseOnBalls REAL,              -- Bases por bolas otorgadas (BB)
  battersFaced REAL,             -- Bateadores enfrentados (BF)
  blownSaves REAL,               -- Salvamentos perdidos (BS)
  catchersInterference REAL,     -- Interferencias del catcher
  caughtStealing REAL,           -- Corredores atrapados robando (CS)
  completeGames REAL,            -- Juegos completos (CG)
  doubles REAL,                  -- Dobles permitidos (2B)
  earnedRuns REAL,               -- Carreras limpias (ER)
  gamesFinished REAL,            -- Juegos terminados
  gamesPitched REAL,             -- Juegos lanzados
  gamesPlayed REAL,              -- Juegos jugados (GP)
  gamesStarted REAL,             -- Juegos como abridor (GS)
  groundOuts REAL,               -- Outs por roletazo
  hitBatsmen REAL,               -- Bateadores golpeados (HBP)
  hits REAL,                     -- Hits permitidos (H)
  holds REAL,                    -- Holds (HLD)
  homeRuns REAL,                 -- Jonrones permitidos (HR)
  inheritedRunners REAL,         -- Corredores heredados
  inheritedRunnersScored REAL,   -- Corredores heredados que anotaron
  intentionalWalks REAL,         -- Bases por bolas intencionales (IBB)
  losses REAL,                   -- Derrotas (L)
  numberOfPitches REAL,          -- Número total de pitcheos
  outs REAL,                     -- Outs registrados
  pickoffs REAL,                 -- Pickoffs realizados
  pitchesThrown REAL,            -- Pitcheos lanzados
  rbi REAL,                      -- Carreras impulsadas permitidas
  runs REAL,                     -- Carreras permitidas (R)
  sacBunts REAL,                 -- Toques de sacrificio permitidos
  sacFlies REAL,                 -- Elevados de sacrificio permitidos (SF)
  saveOpportunities REAL,        -- Oportunidades de salvamento (SVO)
  saves REAL,                    -- Salvamentos (SV)
  shutouts REAL,                 -- Blanqueadas (SHO)
  stolenBases REAL,              -- Bases robadas permitidas (SB)
  strikeOuts REAL,               -- Ponches (SO)
  strikes REAL,                  -- Total de strikes lanzados
  triples REAL,                  -- Triples permitidos (3B)
  wildPitches REAL,              -- Lanzamientos descontrolados (WP)
  wins REAL,                     -- Victorias (W)
  gamePk INTEGER,                -- ID único del juego
  teamId INTEGER,                -- ID del equipo
  teamType TEXT,                 -- Tipo de equipo: "home" o "away"
  playerId INTEGER               -- ID del jugador
);
