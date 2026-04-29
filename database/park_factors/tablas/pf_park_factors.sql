DROP TABLE IF EXISTS pf_park_factors;

-- Park Factors: Factores de estadio — mide cuánto favorece o penaliza cada estadio a cada tipo de evento
-- Factor > 1.0 = el estadio favorece ese evento, < 1.0 = lo penaliza
-- Fórmula: (stat_home / games_home) / (stat_away / games_away)
CREATE TABLE pf_park_factors (
  groupingId INTEGER,                            -- ID del nivel de agrupación
  groupingDescription TEXT,                      -- Descripción del nivel de agrupación
  majorLeagueId INTEGER,                         -- ID de la liga mayor
  seasonId INTEGER,                              -- Año de la temporada
  venueId INTEGER,                               -- ID del estadio
  teamId INTEGER,                                -- ID del equipo local
  homeGames INTEGER,                             -- Juegos como local
  awayGames INTEGER,                             -- Juegos como visitante
  -- Carreras
  runsScoredHome INTEGER,                        -- Carreras anotadas como local
  runsAllowedHome INTEGER,                       -- Carreras permitidas como local
  runsScoredAway INTEGER,                        -- Carreras anotadas como visitante
  runsAllowedAway INTEGER,                       -- Carreras permitidas como visitante
  -- Sencillos
  singlesScoredHome INTEGER,                     -- Sencillos como local (bateo)
  singlesAllowedHome INTEGER,                    -- Sencillos permitidos como local
  singlesScoredAway INTEGER,                     -- Sencillos como visitante (bateo)
  singlesAllowedAway INTEGER,                    -- Sencillos permitidos como visitante
  -- Dobles
  doublesScoredHome INTEGER,                     -- Dobles como local
  doublesAllowedHome INTEGER,                    -- Dobles permitidos como local
  doublesScoredAway INTEGER,                     -- Dobles como visitante
  doublesAllowedAway INTEGER,                    -- Dobles permitidos como visitante
  -- Triples
  triplesScoredHome INTEGER,                     -- Triples como local
  triplesAllowedHome INTEGER,                    -- Triples permitidos como local
  triplesScoredAway INTEGER,                     -- Triples como visitante
  triplesAllowedAway INTEGER,                    -- Triples permitidos como visitante
  -- Jonrones
  homeRunsScoredHome INTEGER,                    -- Jonrones como local
  homeRunsAllowedHome INTEGER,                   -- Jonrones permitidos como local
  homeRunsScoredAway INTEGER,                    -- Jonrones como visitante
  homeRunsAllowedAway INTEGER,                   -- Jonrones permitidos como visitante
  -- Ponches
  strikeOutsScoredHome INTEGER,                  -- Ponches logrados como local
  strikeOutsAllowedHome INTEGER,                 -- Ponches recibidos como local
  strikeOutsScoredAway INTEGER,                  -- Ponches logrados como visitante
  strikeOutsAllowedAway INTEGER,                 -- Ponches recibidos como visitante
  -- Bases por bolas
  unintentionalWalksScoredHome INTEGER,          -- BB otorgados como local
  unintentionalWalksAllowedHome INTEGER,         -- BB recibidos como local
  unintentionalWalksScoredAway INTEGER,          -- BB otorgados como visitante
  unintentionalWalksAllowedAway INTEGER,         -- BB recibidos como visitante
  -- Fly balls
  flyBallsScoredHome INTEGER,                    -- Fly balls como local (bateo)
  flyBallsAllowedHome INTEGER,                   -- Fly balls permitidos como local
  flyBallsScoredAway INTEGER,                    -- Fly balls como visitante
  flyBallsAllowedAway INTEGER,                   -- Fly balls permitidos como visitante
  -- Ground balls
  groundBallsScoredHome INTEGER,                 -- Ground balls como local
  groundBallsAllowedHome INTEGER,                -- Ground balls permitidos como local
  groundBallsScoredAway INTEGER,                 -- Ground balls como visitante
  groundBallsAllowedAway INTEGER,                -- Ground balls permitidos como visitante
  -- Line drives
  lineDrivesScoredHome INTEGER,                  -- Line drives como local
  lineDrivesAllowedHome INTEGER,                 -- Line drives permitidos como local
  lineDrivesScoredAway INTEGER,                  -- Line drives como visitante
  lineDrivesAllowedAway INTEGER,                 -- Line drives permitidos como visitante
  -- Factores calculados
  runsParkFactor REAL,                           -- Park factor de carreras
  singlesParkFactor REAL,                        -- Park factor de sencillos
  doublesParkFactor REAL,                        -- Park factor de dobles
  triplesParkFactor REAL,                        -- Park factor de triples
  homeRunsParkFactor REAL,                       -- Park factor de jonrones
  strikeOutsParkFactor REAL,                     -- Park factor de ponches
  unintentionalWalksParkFactor REAL,             -- Park factor de bases por bolas
  flyBallsParkFactor REAL,                       -- Park factor de fly balls
  groundBallsParkFactor REAL,                    -- Park factor de ground balls
  lineDrivesParkFactor REAL,                     -- Park factor de line drives
  -- Atributos
  majorLeague TEXT,                              -- Nombre de la liga (atributo)
  venueName TEXT                                 -- Nombre del estadio (atributo)
);

CREATE INDEX IF NOT EXISTS idx_pf_park_factors_groupingId ON pf_park_factors(groupingId);
CREATE INDEX IF NOT EXISTS idx_pf_park_factors_groupingDescription ON pf_park_factors(groupingDescription);
CREATE INDEX IF NOT EXISTS idx_pf_park_factors_majorLeagueId ON pf_park_factors(majorLeagueId);
CREATE INDEX IF NOT EXISTS idx_pf_park_factors_seasonId ON pf_park_factors(seasonId);
CREATE INDEX IF NOT EXISTS idx_pf_park_factors_venueId ON pf_park_factors(venueId);
