DROP TABLE IF EXISTS game_player_split_stats;

-- Base: Estadísticas desglosadas por turno al bate — splits por lado de bateo, mano del pitcher y situación de bases
CREATE TABLE game_player_split_stats (
  gamePk INTEGER,                    -- ID único del juego
  atBatIndex INTEGER,                -- Índice del turno al bate
  battingTeamId INTEGER,             -- ID del equipo al bate
  batterId INTEGER,                  -- ID del bateador
  batSide TEXT,                      -- Lado de bateo: "L", "R" o "S"
  pitchingTeamId INTEGER,            -- ID del equipo que pitchea
  pitcherId INTEGER,                 -- ID del pitcher
  pitchHand TEXT,                    -- Mano del pitcher: "L" o "R"
  menOnBase TEXT,                    -- Situación de bases: "Empty", "Men_On", "Loaded", "RISP"
  -- Métricas derivadas de turnos al bate (atbats)
  balks INTEGER,                     -- Balks
  batterInterferences INTEGER,       -- Interferencias del bateador
  bunts INTEGER,                     -- Toques (bunts)
  catcherInterferences INTEGER,      -- Interferencias del catcher
  doubles INTEGER,                   -- Dobles (2B)
  fanInterferences INTEGER,          -- Interferencias de fanáticos
  fieldErrors INTEGER,               -- Errores de fildeo
  fieldersChoice INTEGER,            -- Jugadas de selección del fildeador
  flyouts INTEGER,                   -- Elevados de out
  forceOuts INTEGER,                 -- Force outs
  groundedIntoDoublePlays INTEGER,   -- Doble plays por roletazo (GIDP)
  groundOuts INTEGER,                -- Roletazos de out
  hitByPitch INTEGER,                -- Golpeado por lanzamiento (HBP)
  homeRuns INTEGER,                  -- Jonrones (HR)
  intentionalWalks INTEGER,          -- Bases por bolas intencionales (IBB)
  lineOuts INTEGER,                  -- Líneas de out
  passedBalls INTEGER,               -- Bolas pasadas (PB)
  popOuts INTEGER,                   -- Elevados cortos de out (pop-ups)
  runsBattedIn INTEGER,              -- Carreras impulsadas (RBI)
  sacBunts INTEGER,                  -- Toques de sacrificio
  sacFlies INTEGER,                  -- Elevados de sacrificio (SF)
  singles INTEGER,                   -- Sencillos (1B)
  strikeOuts INTEGER,                -- Ponches (SO)
  triples INTEGER,                   -- Triples (3B)
  triplePlays INTEGER,               -- Triple plays
  walks INTEGER,                     -- Bases por bolas (BB)
  wildPitches INTEGER,               -- Lanzamientos descontrolados (WP)
  -- Métricas derivadas de pitcheos (pitches)
  balls INTEGER,                     -- Total de bolas
  ballsPitchOut INTEGER,             -- Bolas en pitchouts
  ballsInDirt INTEGER,               -- Bolas en la tierra
  intentBalls INTEGER,               -- Bolas intencionales
  fouls INTEGER,                     -- Fouls
  foulBunts INTEGER,                 -- Fouls de toque
  foulTips INTEGER,                  -- Foul tips
  foulPitchOuts INTEGER,             -- Fouls en pitchouts
  hitIntoPlay INTEGER,               -- Pelotas puestas en juego
  pitches INTEGER,                   -- Total de pitcheos
  pitchOuts INTEGER,                 -- Pitchouts
  strikes INTEGER,                   -- Total de strikes
  strikesCalled INTEGER,             -- Strikes cantados
  strikesPitchOuts INTEGER,          -- Strikes en pitchouts
  missedBunts INTEGER,               -- Toques fallados
  swingAndMissStrikes INTEGER,       -- Swings fallados (whiffs)
  swingsPitchOuts INTEGER,           -- Swings en pitchouts
  swings INTEGER,                    -- Total de swings
  -- Swings por conteo de bolas y strikes
  swingsZeroAndZero INTEGER,         -- Swings en conteo 0-0
  swingsZeroAndOne INTEGER,          -- Swings en conteo 0-1
  swingsZeroAndTwo INTEGER,          -- Swings en conteo 0-2
  swingsOneAndZero INTEGER,          -- Swings en conteo 1-0
  swingsOneAndOne INTEGER,           -- Swings en conteo 1-1
  swingsOneAndTwo INTEGER,           -- Swings en conteo 1-2
  swingsTwoAndZero INTEGER,          -- Swings en conteo 2-0
  swingsTwoAndOne INTEGER,           -- Swings en conteo 2-1
  swingsTwoAndTwo INTEGER,           -- Swings en conteo 2-2
  swingsThreeAndZero INTEGER,        -- Swings en conteo 3-0
  swingsThreeAndOne INTEGER,         -- Swings en conteo 3-1
  swingsThreeAndTwo INTEGER,         -- Swings en conteo 3-2
  -- Trayectorias de pelotas en juego
  flyBalls INTEGER,                  -- Elevados (fly balls)
  groundBalls INTEGER,               -- Roletazos (ground balls)
  lineDrives INTEGER,                -- Líneas (line drives)
  popUps INTEGER,                    -- Elevados cortos (pop-ups)
  groundBunts INTEGER,               -- Toques de roletazo
  popupBunts INTEGER,                -- Toques de elevado corto
  lineDriveBunts INTEGER             -- Toques de línea
);

CREATE INDEX IF NOT EXISTS idx_game_player_split_stats_gamePk_atBatIndex ON game_player_split_stats(gamePk, atBatIndex);
