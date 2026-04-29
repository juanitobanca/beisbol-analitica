DROP TABLE IF EXISTS stg_play_pitch;

-- Staging: Datos de cada pitcheo individual con métricas Statcast (fuente: MLB Stats API play-by-play)
CREATE TABLE IF NOT EXISTS stg_play_pitch (
  callCode TEXT,             -- Código de la llamada del umpire (ej: "B"=bola, "S"=strike, "C"=strike cantado)
  callDescription TEXT,      -- Descripción de la llamada (ej: "Ball", "Called Strike")
  description TEXT,          -- Descripción narrativa del pitcheo
  code TEXT,                 -- Código del resultado del pitcheo
  ballColor TEXT,            -- Color de la pelota en visualización
  trailColor TEXT,           -- Color de la trayectoria en visualización
  isInPlay INTEGER,          -- 1 si la pelota fue puesta en juego
  isStrike INTEGER,          -- 1 si el pitcheo fue strike
  isBall INTEGER,            -- 1 si el pitcheo fue bola
  typeCode TEXT,             -- Código del tipo de pitcheo (ej: "FF"=fastball, "SL"=slider, "CU"=curveball)
  typeDescription TEXT,      -- Descripción del tipo de pitcheo (ej: "Four-Seam Fastball")
  hasReview INTEGER,         -- 1 si hubo revisión de video
  runnerGoing INTEGER,       -- 1 si un corredor intentó robo en este pitcheo
  balls INTEGER,             -- Conteo de bolas después del pitcheo
  strikes INTEGER,           -- Conteo de strikes después del pitcheo
  -- Métricas Statcast de velocidad y movimiento
  startSpeed TEXT,           -- Velocidad inicial del pitcheo (mph)
  endSpeed TEXT,             -- Velocidad al llegar al plato (mph)
  strikeZoneTop REAL,        -- Límite superior de la zona de strike (pies)
  strikeZoneBottom REAL,     -- Límite inferior de la zona de strike (pies)
  aY TEXT,                   -- Aceleración en eje Y (pies/s²)
  aZ TEXT,                   -- Aceleración en eje Z (pies/s²)
  pfxX TEXT,                 -- Movimiento horizontal inducido por spin (pulgadas)
  pfxZ TEXT,                 -- Movimiento vertical inducido por spin (pulgadas)
  pX TEXT,                   -- Posición horizontal al cruzar el plato (pies, 0=centro)
  pZ TEXT,                   -- Posición vertical al cruzar el plato (pies)
  vX0 TEXT,                  -- Velocidad inicial en eje X (pies/s)
  vY0 TEXT,                  -- Velocidad inicial en eje Y (pies/s)
  vZ0 TEXT,                  -- Velocidad inicial en eje Z (pies/s)
  x REAL,                    -- Coordenada X en el gráfico de zona de strike
  y REAL,                    -- Coordenada Y en el gráfico de zona de strike
  x0 TEXT,                   -- Posición inicial en eje X (pies)
  y0 TEXT,                   -- Posición inicial en eje Y (pies)
  z0 TEXT,                   -- Posición inicial en eje Z (pies)
  aX TEXT,                   -- Aceleración en eje X (pies/s²)
  zone TEXT,                 -- Zona de strike (1-14, donde 1-9=zona, 10-14=fuera)
  typeConfidence TEXT,       -- Confianza en la clasificación del tipo de pitcheo (0-1)
  breakAngle TEXT,           -- Ángulo de quiebre del pitcheo (grados)
  breakLength TEXT,          -- Distancia de quiebre (pulgadas)
  breakY TEXT,               -- Distancia desde home donde ocurre el quiebre (pies)
  spinRate TEXT,             -- Tasa de spin (RPM)
  spinDirection TEXT,        -- Dirección del spin (grados, 0-360)
  -- Métricas Statcast de bateo (cuando isInPlay=1)
  launchSpeed TEXT,          -- Velocidad de salida de la pelota (mph) - Exit Velocity
  launchAngle TEXT,          -- Ángulo de lanzamiento de la pelota (grados) - Launch Angle
  totalDistance TEXT,         -- Distancia total recorrida (pies)
  trajectory TEXT,           -- Trayectoria: fly_ball, ground_ball, line_drive, popup
  hardness TEXT,             -- Dureza del contacto: hard, medium, soft
  location TEXT,             -- Ubicación del bateo en el campo
  coordX REAL,               -- Coordenada X donde cayó la pelota en el campo
  coordY REAL,               -- Coordenada Y donde cayó la pelota en el campo
  -- Identificadores
  atBatIndex INTEGER,        -- Índice del turno al bate
  gamePk INTEGER,            -- ID único del juego
  `index` INTEGER,           -- Índice secuencial del pitcheo dentro del turno
  pfxId TEXT,                -- ID del sistema PITCHf/x
  playId TEXT,               -- ID único de la jugada
  pitchNumber INTEGER,       -- Número de pitcheo en el turno al bate
  startTime TEXT,            -- Timestamp de inicio (ISO 8601)
  endTime TEXT,              -- Timestamp de fin (ISO 8601)
  isPitch INTEGER,           -- 1 si es un pitcheo (vs pickoff u otra acción)
  type TEXT                  -- Tipo: "pitch", "pickoff", etc.
);
