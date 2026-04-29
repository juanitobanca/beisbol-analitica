DROP TABLE IF EXISTS agg_batting_stats;

-- Agregados: Estadísticas de bateo agregadas con métricas derivadas (AVG, OBP, SLG, wOBA, wRAA, wRC, OPS+)
-- Incluye conteos de pitcheos, swings por conteo, y trayectorias de pelotas en juego
CREATE TABLE agg_batting_stats (
  -- Dimensiones de agrupación
  groupingId INTEGER,                                -- ID del nivel de agrupación (OLAP cube)
  groupingDescription TEXT,                          -- Descripción del nivel de agrupación
  aggregationType TEXT,                              -- Tipo de agregación: "SUM", "AVG", etc.
  majorLeagueId INTEGER,                             -- ID de la liga mayor
  seasonId INTEGER,                                  -- Año de la temporada
  gameDate TEXT,                                     -- Fecha del juego (si aplica)
  gameType2 TEXT,                                    -- Tipo de juego: "RS", "PS"
  teamType TEXT,                                     -- Tipo de equipo: "home" o "away"
  venueId INTEGER,                                   -- ID del estadio
  teamId INTEGER,                                    -- ID del equipo
  opposingTeamId INTEGER,                            -- ID del equipo contrario
  officialId INTEGER,                                -- ID del umpire de home
  playerId INTEGER,                                  -- ID del jugador
  batSide TEXT,                                      -- Lado de bateo: "L", "R" o "S"
  pitchHand TEXT,                                    -- Mano del pitcher: "L" o "R"
  menOnBase TEXT,                                    -- Situación de bases: "Empty", "Men_On", "Loaded", "RISP"
  -- Estadísticas de bateo básicas
  games INTEGER,                                     -- Juegos jugados
  atBats INTEGER,                                    -- Turnos al bate (AB)
  balks INTEGER,                                     -- Balks
  batterInterferences INTEGER,                       -- Interferencias del bateador
  bunts INTEGER,                                     -- Toques (bunts)
  catcherInterferences INTEGER,                      -- Interferencias del catcher
  caughtStealing INTEGER,                            -- Atrapados robando (CS)
  doubles INTEGER,                                   -- Dobles (2B)
  fanInterferences INTEGER,                          -- Interferencias de fanáticos
  fieldErrors INTEGER,                               -- Errores de fildeo
  fieldersChoice INTEGER,                            -- Selección del fildeador
  forceOuts INTEGER,                                 -- Force outs
  flyOuts INTEGER,                                   -- Elevados de out
  groundedIntoDoublePlays INTEGER,                   -- Doble plays por roletazo (GIDP)
  groundedIntoTriplePlays INTEGER,                   -- Triple plays por roletazo
  groundOuts INTEGER,                                -- Roletazos de out
  hitByPitch INTEGER,                                -- Golpeado por lanzamiento (HBP)
  hits INTEGER,                                      -- Hits (H)
  homeRuns INTEGER,                                  -- Jonrones (HR)
  intentionalWalks INTEGER,                          -- Bases por bolas intencionales (IBB)
  leftOnBase INTEGER,                                -- Dejados en base (LOB)
  lineOuts INTEGER,                                  -- Líneas de out
  passedBalls INTEGER,                               -- Bolas pasadas
  plateAppearances INTEGER,                          -- Apariciones al plato (PA)
  popOuts INTEGER,                                   -- Pop-ups de out
  runsBattedIn INTEGER,                              -- Carreras impulsadas (RBI)
  runs INTEGER,                                      -- Carreras anotadas (R)
  sacBunts INTEGER,                                  -- Toques de sacrificio
  sacFlies INTEGER,                                  -- Elevados de sacrificio (SF)
  singles INTEGER,                                   -- Sencillos (1B)
  stolenBases INTEGER,                               -- Bases robadas (SB)
  stolenBaseAttempts INTEGER,                        -- Intentos de robo de base
  strikeOuts INTEGER,                                -- Ponches (SO)
  totalBases INTEGER,                                -- Total de bases (TB)
  triples INTEGER,                                   -- Triples (3B)
  unintentionalWalks INTEGER,                        -- Bases por bolas no intencionales
  walks INTEGER,                                     -- Bases por bolas totales (BB)
  wildPitches INTEGER,                               -- Lanzamientos descontrolados
  -- Métricas derivadas de bateo
  battingAverage REAL,                               -- Promedio de bateo (AVG = H/AB)
  isolatedPower REAL,                                -- Poder aislado (ISO = SLG - AVG)
  secondBattingAverage REAL,                         -- Segundo promedio de bateo (SecA)
  extraBaseHitPercentage REAL,                       -- Porcentaje de extra-bases
  sluggingPercentage REAL,                           -- Porcentaje de slugging (SLG = TB/AB)
  stolenBasePercentage REAL,                         -- Porcentaje de robos exitosos (SB%)
  atBatsPerHomeRunsPercentage REAL,                  -- AB por jonrón
  walksPerStrikeOutsPercentage REAL,                 -- Ratio BB/SO
  onBasePercentage REAL,                             -- Porcentaje en base (OBP)
  onBasePlusSluggingPercentage REAL,                 -- OPS (OBP + SLG)
  walksPerPlateAppearancesPercentage REAL,           -- Porcentaje BB/PA
  strikeOutsPerPlateAppearancesPercentage REAL,      -- Porcentaje SO/PA
  homeRunsPerPlateAppearancesPercentage REAL,        -- Porcentaje HR/PA
  onFirstBasePercentage REAL,                        -- Porcentaje de llegar a primera
  singlesPercentage REAL,                            -- Porcentaje de sencillos
  doublesPercentage REAL,                            -- Porcentaje de dobles
  triplesPercentage REAL,                            -- Porcentaje de triples
  homeRunsPercentage REAL,                           -- Porcentaje de jonrones
  walksPercentage REAL,                              -- Porcentaje de bases por bolas
  hitsPercentage REAL,                               -- Porcentaje de hits
  strikeOutsPercentage REAL,                         -- Porcentaje de ponches
  extraBasePercentage REAL,                          -- Porcentaje de extra-bases
  inPlayPercentage REAL,                             -- Porcentaje de pelotas en juego
  runsCreated REAL,                                  -- Carreras creadas (RC)
  powerSpeed REAL,                                   -- Número Power-Speed
  runScoredPercentage REAL,                          -- Porcentaje de carreras anotadas
  battingAverageOnBallsInPlay REAL,                  -- BABIP (AVG en pelotas en juego)
  strikeOutsOverBaseOnBallsPercentage REAL,          -- Ratio SO/BB
  homeRunPercentage REAL,                            -- HR% sobre fly balls
  -- wOBA (Weighted On-Base Average)
  weightedOnBaseAverage REAL,                        -- wOBA calculado
  weightedOnBaseAverageRelativeToOuts REAL,          -- wOBA relativo a outs
  weightUnintentionalWalk REAL,                      -- Peso de BB no intencional para wOBA
  weightHitByPitch REAL,                             -- Peso de HBP para wOBA
  weightSingle REAL,                                 -- Peso de sencillo para wOBA
  weightDouble REAL,                                 -- Peso de doble para wOBA
  weightTriple REAL,                                 -- Peso de triple para wOBA
  weightHomeRun REAL,                                -- Peso de jonrón para wOBA
  weightOut REAL,                                    -- Peso de out para wOBA
  -- wRAA (Weighted Runs Above Average)
  weightedOnBaseAverageScale REAL,                   -- Escala de wOBA para wRAA
  leagueWeightedOnBaseAverageRelativeToOuts REAL,    -- wOBA de liga para wRAA
  weightedRunsAboveAverage REAL,                     -- wRAA calculado
  -- wRC (Weighted Runs Created)
  leagueRuns INTEGER,                                -- Carreras totales de la liga
  leaguePlateAppearances INTEGER,                    -- PA totales de la liga
  weightedRunsCreated REAL,                          -- wRC calculado
  -- OPS+ (On-Base Plus Slugging Plus)
  leagueOnBasePercentage REAL,                       -- OBP de la liga
  leagueSluggingPercentage REAL,                     -- SLG de la liga
  onBasePlusSluggingPercentagePlus REAL,             -- OPS+ (100 = promedio de liga)
  -- Métricas derivadas de pitcheos
  balls INTEGER,                                     -- Total de bolas recibidas
  ballsPitchOut INTEGER,                             -- Bolas en pitchouts
  ballsInDirt INTEGER,                               -- Bolas en la tierra
  intentBalls INTEGER,                               -- Bolas intencionales
  fouls INTEGER,                                     -- Fouls
  foulBunts INTEGER,                                 -- Fouls de toque
  foulTips INTEGER,                                  -- Foul tips
  foulPitchOuts INTEGER,                             -- Fouls en pitchouts
  hitIntoPlay INTEGER,                               -- Pelotas puestas en juego
  pitches INTEGER,                                   -- Total de pitcheos recibidos
  pitchOuts INTEGER,                                 -- Pitchouts recibidos
  strikes INTEGER,                                   -- Total de strikes recibidos
  strikesCalled INTEGER,                             -- Strikes cantados
  strikesPitchOuts INTEGER,                          -- Strikes en pitchouts
  missedBunts INTEGER,                               -- Toques fallados
  swingAndMissStrikes INTEGER,                       -- Swings fallados (whiffs)
  swingsPitchOuts INTEGER,                           -- Swings en pitchouts
  swings INTEGER,                                    -- Total de swings
  -- Swings por conteo de bolas y strikes
  swingsZeroAndZero INTEGER,                         -- Swings en conteo 0-0
  swingsZeroAndOne INTEGER,                          -- Swings en conteo 0-1
  swingsZeroAndTwo INTEGER,                          -- Swings en conteo 0-2
  swingsOneAndZero INTEGER,                          -- Swings en conteo 1-0
  swingsOneAndOne INTEGER,                           -- Swings en conteo 1-1
  swingsOneAndTwo INTEGER,                           -- Swings en conteo 1-2
  swingsTwoAndZero INTEGER,                          -- Swings en conteo 2-0
  swingsTwoAndOne INTEGER,                           -- Swings en conteo 2-1
  swingsTwoAndTwo INTEGER,                           -- Swings en conteo 2-2
  swingsThreeAndZero INTEGER,                        -- Swings en conteo 3-0
  swingsThreeAndOne INTEGER,                         -- Swings en conteo 3-1
  swingsThreeAndTwo INTEGER,                         -- Swings en conteo 3-2
  -- Trayectorias de pelotas en juego
  flyBalls INTEGER,                                  -- Elevados (fly balls)
  groundBalls INTEGER,                               -- Roletazos (ground balls)
  lineDrives INTEGER,                                -- Líneas (line drives)
  popUps INTEGER,                                    -- Elevados cortos (pop-ups)
  groundBunts INTEGER,                               -- Toques de roletazo
  popupBunts INTEGER,                                -- Toques de elevado corto
  lineDriveBunts INTEGER,                            -- Toques de línea
  -- Porcentaje de swing por conteo
  zeroAndZeroSwingPercentage REAL,                   -- % swing en conteo 0-0
  zeroAndOneSwingPercentage REAL,                    -- % swing en conteo 0-1
  zeroAndTwoSwingPercentage REAL,                    -- % swing en conteo 0-2
  oneAndZeroSwingPercentage REAL,                    -- % swing en conteo 1-0
  oneAndOneSwingPercentage REAL,                     -- % swing en conteo 1-1
  oneAndTwoSwingPercentage REAL,                     -- % swing en conteo 1-2
  twoAndZeroSwingPercentage REAL,                    -- % swing en conteo 2-0
  twoAndOneSwingPercentage REAL,                     -- % swing en conteo 2-1
  twoAndTwoSwingPercentage REAL,                     -- % swing en conteo 2-2
  threeAndZeroSwingPercentage REAL,                  -- % swing en conteo 3-0
  threeAndOneSwingPercentage REAL,                   -- % swing en conteo 3-1
  threeAndTwoSwingPercentage REAL,                   -- % swing en conteo 3-2
  -- Atributos de nombres (poblados por update_table_attributes)
  majorLeague TEXT,                                  -- Nombre de la liga
  playerName TEXT,                                   -- Nombre del jugador
  teamName TEXT,                                     -- Nombre del equipo
  venueName TEXT,                                    -- Nombre del estadio
  officialName TEXT,                                 -- Nombre del umpire
  opposingTeamName TEXT                              -- Nombre del equipo contrario
);

CREATE INDEX IF NOT EXISTS idx_agg_batting_stats_groupingId ON agg_batting_stats(groupingId);
CREATE INDEX IF NOT EXISTS idx_agg_batting_stats_groupingDescription ON agg_batting_stats(groupingDescription);
CREATE INDEX IF NOT EXISTS idx_agg_batting_stats_majorLeagueId ON agg_batting_stats(majorLeagueId);
CREATE INDEX IF NOT EXISTS idx_agg_batting_stats_seasonId ON agg_batting_stats(seasonId);
CREATE INDEX IF NOT EXISTS idx_agg_batting_stats_venueId ON agg_batting_stats(venueId);
CREATE INDEX IF NOT EXISTS idx_agg_batting_stats_teamId ON agg_batting_stats(teamId);
CREATE INDEX IF NOT EXISTS idx_agg_batting_stats_playerId ON agg_batting_stats(playerId);
CREATE INDEX IF NOT EXISTS idx_agg_batting_stats_opposingTeamId ON agg_batting_stats(opposingTeamId);
CREATE INDEX IF NOT EXISTS idx_agg_batting_stats_officialId ON agg_batting_stats(officialId);
