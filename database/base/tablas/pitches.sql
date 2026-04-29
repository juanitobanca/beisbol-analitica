DROP TABLE IF EXISTS pitches;

-- Base: Pitcheos individuales con métricas Statcast y datos de bateo (limpiado de stg_play_pitch)
CREATE TABLE pitches (
  gamePk INTEGER,                -- ID único del juego
  atBatIndex INTEGER,            -- Índice del turno al bate
  playIndex INTEGER,             -- Índice secuencial del pitcheo dentro del turno
  inning INTEGER,                -- Número de inning
  halfInning TEXT,               -- Mitad del inning: "top" o "bottom"
  battingTeamId INTEGER,         -- ID del equipo al bate
  pitchingTeamId INTEGER,        -- ID del equipo que pitchea
  batterId INTEGER,              -- ID del bateador
  pitcherId INTEGER,             -- ID del pitcher
  pitchNumber INTEGER,           -- Número de pitcheo en el turno al bate
  startBalls INTEGER,            -- Conteo de bolas antes del pitcheo
  startStrikes INTEGER,          -- Conteo de strikes antes del pitcheo
  endBalls INTEGER,              -- Conteo de bolas después del pitcheo
  endStrikes INTEGER,            -- Conteo de strikes después del pitcheo
  callCode TEXT,                 -- Código de la llamada del umpire (ej: "B"=bola, "S"=strike, "C"=strike cantado)
  callDescription TEXT,          -- Descripción de la llamada (ej: "Ball", "Called Strike")
  callDescription2 TEXT,         -- Descripción alternativa de la llamada
  code TEXT,                     -- Código del resultado del pitcheo
  isInPlay INTEGER,              -- 1 si la pelota fue puesta en juego
  isStrike INTEGER,              -- 1 si el pitcheo fue strike
  isBall INTEGER,                -- 1 si el pitcheo fue bola
  typeCode TEXT,                 -- Código del tipo de pitcheo (ej: "FF"=fastball, "SL"=slider, "CU"=curveball)
  typeDescription TEXT,          -- Descripción del tipo de pitcheo (ej: "Four-Seam Fastball")
  hasReview INTEGER,             -- 1 si hubo revisión de video
  runnerGoing INTEGER,           -- 1 si un corredor intentó robo en este pitcheo
  strikeZoneTop REAL,            -- Límite superior de la zona de strike (pies)
  strikeZoneBottom REAL,         -- Límite inferior de la zona de strike (pies)
  x REAL,                        -- Coordenada X en el gráfico de zona de strike
  y REAL,                        -- Coordenada Y en el gráfico de zona de strike
  x0 REAL,                       -- Posición inicial en eje X (pies)
  y0 REAL,                       -- Posición inicial en eje Y (pies)
  trajectory TEXT,               -- Trayectoria: fly_ball, ground_ball, line_drive, popup
  hardness TEXT,                 -- Dureza del contacto: hard, medium, soft
  location INTEGER,              -- Ubicación del bateo en el campo
  batSide TEXT,                  -- Lado de bateo: "L", "R" o "S"
  pitchHand TEXT,                -- Mano del pitcher: "L" o "R"
  menOnBase TEXT,                -- Situación de bases: "Empty", "Men_On", "Loaded", "RISP"
  coordX REAL,                   -- Coordenada X donde cayó la pelota en el campo
  coordY REAL,                   -- Coordenada Y donde cayó la pelota en el campo
  ballColor TEXT,                -- Color de la pelota en visualización
  trailColor TEXT,               -- Color de la trayectoria en visualización
  -- Métricas Statcast de velocidad y movimiento
  startSpeed TEXT,               -- Velocidad inicial del pitcheo (mph)
  endSpeed TEXT,                 -- Velocidad al llegar al plato (mph)
  aY TEXT,                       -- Aceleración en eje Y (pies/s²)
  aZ TEXT,                       -- Aceleración en eje Z (pies/s²)
  pfxX TEXT,                     -- Movimiento horizontal inducido por spin (pulgadas)
  pfxZ TEXT,                     -- Movimiento vertical inducido por spin (pulgadas)
  pX TEXT,                       -- Posición horizontal al cruzar el plato (pies, 0=centro)
  pZ TEXT,                       -- Posición vertical al cruzar el plato (pies)
  vX0 TEXT,                      -- Velocidad inicial en eje X (pies/s)
  vY0 TEXT,                      -- Velocidad inicial en eje Y (pies/s)
  vZ0 TEXT,                      -- Velocidad inicial en eje Z (pies/s)
  z0 TEXT,                       -- Posición inicial en eje Z (pies)
  aX TEXT,                       -- Aceleración en eje X (pies/s²)
  zone TEXT,                     -- Zona de strike (1-14, donde 1-9=zona, 10-14=fuera)
  typeConfidence TEXT,           -- Confianza en la clasificación del tipo de pitcheo (0-1)
  breakAngle TEXT,               -- Ángulo de quiebre del pitcheo (grados)
  breakLength TEXT,              -- Distancia de quiebre (pulgadas)
  breakY TEXT,                   -- Distancia desde home donde ocurre el quiebre (pies)
  spinRate TEXT,                 -- Tasa de spin (RPM)
  spinDirection TEXT,            -- Dirección del spin (grados, 0-360)
  -- Métricas Statcast de bateo (cuando isInPlay=1)
  launchSpeed TEXT,              -- Velocidad de salida de la pelota (mph) - Exit Velocity
  launchAngle TEXT,              -- Ángulo de lanzamiento de la pelota (grados) - Launch Angle
  totalDistance TEXT,             -- Distancia total recorrida (pies)
  pfxId TEXT,                    -- ID del sistema PITCHf/x
  playId TEXT,                   -- ID único de la jugada
  startTime TEXT,                -- Timestamp de inicio (ISO 8601)
  endTime TEXT,                  -- Timestamp de fin (ISO 8601)
  isPitch INTEGER,               -- 1 si es un pitcheo (vs pickoff u otra acción)
  type TEXT,                     -- Tipo: "pitch", "pickoff", etc.
  HM4 TEXT,                      -- Zona de heat map en 4 cuadrantes donde cayó la pelota
  HM8 TEXT                       -- Zona de heat map en 8 octantes donde cayó la pelota
);

CREATE INDEX IF NOT EXISTS idx_pitches_gamePk_atBatIndex ON pitches(gamePk, atBatIndex);

-- For Run Expectancy
CREATE INDEX IF NOT EXISTS idx_pitches_game_atbat_play ON pitches(gamePk, atBatIndex, playIndex);
