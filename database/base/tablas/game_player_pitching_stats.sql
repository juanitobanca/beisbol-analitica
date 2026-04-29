DROP TABLE IF EXISTS game_player_pitching_stats;

-- Base: Estadísticas de pitcheo por jugador por juego (limpiado de stg_box_player_pitching)
CREATE TABLE game_player_pitching_stats (
  gamePk INTEGER,                        -- ID único del juego
  teamId INTEGER,                        -- ID del equipo
  teamType TEXT,                         -- Tipo de equipo: "home" o "away"
  playerId INTEGER,                      -- ID del jugador
  airOuts INTEGER,                       -- Outs por elevado
  atBats INTEGER,                        -- Turnos al bate enfrentados (AB)
  balls INTEGER,                         -- Total de bolas lanzadas
  walks INTEGER,                         -- Bases por bolas otorgadas (BB)
  battersFaced INTEGER,                  -- Bateadores enfrentados (BF)
  blownSaves INTEGER,                    -- Salvamentos perdidos (BS)
  catchersInterference INTEGER,          -- Interferencias del catcher
  caughtStealing INTEGER,                -- Corredores atrapados robando (CS)
  completeGames INTEGER,                 -- Juegos completos (CG)
  doubles INTEGER,                       -- Dobles permitidos (2B)
  earnedRuns INTEGER,                    -- Carreras limpias (ER)
  gamesFinished INTEGER,                 -- Juegos terminados
  gamesPitched INTEGER,                  -- Juegos lanzados
  gamesPlayed INTEGER,                   -- Juegos jugados (GP)
  gamesStarted INTEGER,                  -- Juegos como abridor (GS)
  groundOuts INTEGER,                    -- Outs por roletazo
  hitBatsmen INTEGER,                    -- Bateadores golpeados (HBP)
  hits INTEGER,                          -- Hits permitidos (H)
  holds INTEGER,                         -- Holds (HLD)
  homeRuns INTEGER,                      -- Jonrones permitidos (HR)
  inheritedRunners INTEGER,              -- Corredores heredados
  inheritedRunnersScored INTEGER,        -- Corredores heredados que anotaron
  intentionalWalks INTEGER,              -- Bases por bolas intencionales (IBB)
  losses INTEGER,                        -- Derrotas (L)
  numberOfPitches INTEGER,               -- Número total de pitcheos
  outs INTEGER,                          -- Outs registrados
  pickoffs INTEGER,                      -- Pickoffs realizados
  pitchesThrown INTEGER,                 -- Pitcheos lanzados
  plateAppearances INTEGER,              -- Apariciones al plato enfrentadas
  rbi INTEGER,                           -- Carreras impulsadas permitidas
  runs INTEGER,                          -- Carreras permitidas (R)
  sacBunts INTEGER,                      -- Toques de sacrificio permitidos
  sacFlies INTEGER,                      -- Elevados de sacrificio permitidos (SF)
  saveOpportunities INTEGER,             -- Oportunidades de salvamento (SVO)
  saves INTEGER,                         -- Salvamentos (SV)
  singles INTEGER,                       -- Sencillos permitidos (1B)
  shutouts INTEGER,                      -- Blanqueadas (SHO)
  stolenBases INTEGER,                   -- Bases robadas permitidas (SB)
  strikeOuts INTEGER,                    -- Ponches (SO)
  strikes INTEGER,                       -- Total de strikes lanzados
  triples INTEGER,                       -- Triples permitidos (3B)
  unintentionalWalks INTEGER,            -- Bases por bolas no intencionales
  wildPitches INTEGER,                   -- Lanzamientos descontrolados (WP)
  wins INTEGER,                          -- Victorias (W)
  PRIMARY KEY(gamePk, teamId, playerId)
);
