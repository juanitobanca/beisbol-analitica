DROP TABLE IF EXISTS agg_pitching_stats;

-- Agregados: Estadísticas de pitcheo agregadas con métricas derivadas (ERA, WHIP, FIP, K/9, BB/9)
-- Incluye conteos de pitcheos, swings por conteo, trayectorias y pesos de wOBA/FIP
CREATE TABLE agg_pitching_stats (
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
  batSide TEXT,                                      -- Lado de bateo del oponente: "L", "R" o "S"
  pitchHand TEXT,                                    -- Mano del pitcher: "L" o "R"
  menOnBase TEXT,                                    -- Situación de bases: "Empty", "Men_On", "Loaded", "RISP"
  -- Estadísticas de pitcheo básicas (del boxscore)
  airOuts INTEGER,                                   -- Outs por elevado
  atBats INTEGER,                                    -- Turnos al bate enfrentados (AB)
  battersFaced INTEGER,                              -- Bateadores enfrentados (BF)
  blownSaves INTEGER,                                -- Salvamentos perdidos (BS)
  bunts INTEGER,                                     -- Toques recibidos
  catcherInterferences INTEGER,                      -- Interferencias del catcher
  caughtStealing INTEGER,                            -- Atrapados robando (CS)
  completeGames INTEGER,                             -- Juegos completos (CG)
  doubles INTEGER,                                   -- Dobles permitidos (2B)
  earnedRuns INTEGER,                                -- Carreras limpias (ER)
  gamesFinished INTEGER,                             -- Juegos terminados
  gamesPitched INTEGER,                              -- Juegos lanzados
  gamesPlayed INTEGER,                               -- Juegos jugados (GP)
  gamesStarted INTEGER,                              -- Juegos como abridor (GS)
  groundOuts INTEGER,                                -- Outs por roletazo
  hitBatsmen INTEGER,                                -- Bateadores golpeados (HBP)
  hits INTEGER,                                      -- Hits permitidos (H)
  holds INTEGER,                                     -- Holds (HLD)
  homeRuns INTEGER,                                  -- Jonrones permitidos (HR)
  inheritedRunners INTEGER,                          -- Corredores heredados
  inheritedRunnersScored INTEGER,                    -- Corredores heredados que anotaron
  intentionalWalks INTEGER,                          -- BB intencionales (IBB)
  losses INTEGER,                                    -- Derrotas (L)
  numberOfPitches INTEGER,                           -- Número total de pitcheos
  outs INTEGER,                                      -- Outs registrados
  pickoffs INTEGER,                                  -- Pickoffs realizados
  pitchesThrown INTEGER,                             -- Pitcheos lanzados
  plateAppearances INTEGER,                          -- Apariciones al plato enfrentadas
  rbi INTEGER,                                       -- Carreras impulsadas permitidas
  runs INTEGER,                                      -- Carreras permitidas (R)
  sacBunts INTEGER,                                  -- Toques de sacrificio permitidos
  sacFlies INTEGER,                                  -- Elevados de sacrificio (SF)
  saveOpportunities INTEGER,                         -- Oportunidades de salvamento (SVO)
  saves INTEGER,                                     -- Salvamentos (SV)
  singles INTEGER,                                   -- Sencillos permitidos (1B)
  shutouts INTEGER,                                  -- Blanqueadas (SHO)
  stolenBases INTEGER,                               -- Bases robadas permitidas (SB)
  strikeOuts INTEGER,                                -- Ponches (SO)
  totalBases INTEGER,                                -- Total de bases permitidas (TB)
  triples INTEGER,                                   -- Triples permitidos (3B)
  unintentionalWalks INTEGER,                        -- BB no intencionales
  walks INTEGER,                                     -- BB totales
  wildPitches INTEGER,                               -- Lanzamientos descontrolados (WP)
  wins INTEGER,                                      -- Victorias (W)
  -- Métricas derivadas de pitcheo
  strikeOutsPerNineInnings REAL,                     -- Ponches por 9 innings (K/9)
  walksPerNineInnings REAL,                          -- BB por 9 innings (BB/9)
  homeRunsPerNineInnings REAL,                       -- HR por 9 innings (HR/9)
  runsPerNineInnings REAL,                           -- Carreras por 9 innings (R/9)
  earnedRunsPerNineInnings REAL,                     -- ERA (Earned Run Average)
  walksHitsPerInning REAL,                           -- WHIP (Walks + Hits per Inning Pitched)
  strikeOutPerBattersFaced REAL,                     -- K% (ponches / bateadores enfrentados)
  baseOnBallsPerBattersFaced REAL,                   -- BB% (BB / bateadores enfrentados)
  strikeOutsWalksPercentage REAL,                    -- K-BB% (diferencia porcentual)
  strikeOutsPerWalksPercentage REAL,                 -- K/BB ratio
  leftOnBasePercentage REAL,                         -- LOB% (dejados en base %)
  opponentsBattingAverage REAL,                      -- AVG del oponente (BAA)
  battedBallsInPlayPercentage REAL,                  -- % de pelotas en juego
  sluggingPercentage REAL,                           -- SLG del oponente
  stolenBasePercentage REAL,                         -- SB% permitido
  onBasePercentage REAL,                             -- OBP del oponente
  onBasePlusSluggingPercentage REAL,                 -- OPS del oponente
  isolatedPower REAL,                                -- ISO del oponente
  savePercentage REAL,                               -- Porcentaje de salvamentos (SV%)
  winPercentage REAL,                                -- Porcentaje de victorias (W%)
  inningsPitched REAL,                               -- Innings lanzados (IP)
  -- FIP (Fielding Independent Pitching) — pesos de wOBA
  weightUnintentionalWalk REAL,                      -- Peso de BB para wOBA
  weightHitByPitch REAL,                             -- Peso de HBP para wOBA
  weightSingle REAL,                                 -- Peso de sencillo para wOBA
  weightDouble REAL,                                 -- Peso de doble para wOBA
  weightTriple REAL,                                 -- Peso de triple para wOBA
  weightHomeRun REAL,                                -- Peso de jonrón para wOBA
  weightStrikeout REAL,                              -- Peso de ponche para wOBA
  weightOut REAL,                                    -- Peso de out para wOBA
  weightBallInPlay REAL,                             -- Peso de pelota en juego para wOBA
  -- Totales de liga (para métricas relativas)
  leagueHitBatsmen INTEGER,                          -- HBP de la liga
  leagueStrikeOuts INTEGER,                          -- Ponches de la liga
  leagueUnintentionalWalks INTEGER,                  -- BB de la liga
  leagueSingles INTEGER,                             -- Sencillos de la liga
  leagueDoubles INTEGER,                             -- Dobles de la liga
  leagueTriples INTEGER,                             -- Triples de la liga
  leagueHomeRuns INTEGER,                            -- Jonrones de la liga
  leagueOuts INTEGER,                                -- Outs de la liga
  leagueAtBats INTEGER,                              -- AB de la liga
  leagueInningsPitched REAL,                         -- IP de la liga
  leagueEarnedRunsPerNineInnings REAL,               -- ERA de la liga
  leagueRunsPerTeamPerGame INTEGER,                  -- Carreras por equipo por juego (liga)
  leaguePlateAppearancesPerTeamPerGame INTEGER,       -- PA por equipo por juego (liga)
  leagueRunsPerPlateAppearancePerTeamPerGame REAL,   -- R/PA por equipo por juego (liga)
  -- FIP — pesos y constante
  fipWeightStrikeOut REAL,                           -- Peso de ponches para FIP
  fipWeightUnintentionalWalk REAL,                   -- Peso de BB para FIP
  fipWeightHomeRun REAL,                             -- Peso de HR para FIP
  fipConstant REAL,                                  -- Constante FIP (ajusta a escala de ERA)
  fieldIndepedentPitching REAL,                      -- FIP calculado
  -- Métricas derivadas de pitcheos (de la tabla pitches)
  balls INTEGER,                                     -- Total de bolas lanzadas
  balks INTEGER,                                     -- Balks
  ballsPitchOut INTEGER,                             -- Bolas en pitchouts
  ballsInDirt INTEGER,                               -- Bolas en la tierra
  batterInterferences INTEGER,                       -- Interferencias del bateador
  doublePlays INTEGER,                               -- Doble plays inducidos
  intentBalls INTEGER,                               -- Bolas intencionales
  fanInterferences INTEGER,                          -- Interferencias de fanáticos
  fieldErrors INTEGER,                               -- Errores de fildeo
  fieldersChoice INTEGER,                            -- Selección del fildeador
  flyOuts INTEGER,                                   -- Elevados de out
  forceOuts INTEGER,                                 -- Force outs
  fouls INTEGER,                                     -- Fouls
  foulBunts INTEGER,                                 -- Fouls de toque
  foulTips INTEGER,                                  -- Foul tips
  foulPitchOuts INTEGER,                             -- Fouls en pitchouts
  games INTEGER,                                     -- Juegos jugados
  triplePlays INTEGER,                               -- Triple plays
  hitIntoPlay INTEGER,                               -- Pelotas puestas en juego
  lineOuts INTEGER,                                  -- Líneas de out
  passedBalls INTEGER,                               -- Bolas pasadas
  pitches INTEGER,                                   -- Total de pitcheos
  pitchOuts INTEGER,                                 -- Pitchouts
  popOuts INTEGER,                                   -- Pop-ups de out
  runsBattedIn INTEGER,                              -- RBI permitidas
  strikes INTEGER,                                   -- Total de strikes
  strikesCalled INTEGER,                             -- Strikes cantados
  strikesPitchOuts INTEGER,                          -- Strikes en pitchouts
  missedBunts INTEGER,                               -- Toques fallados
  swingAndMissStrikes INTEGER,                       -- Swings fallados (whiffs)
  swingsPitchOuts INTEGER,                           -- Swings en pitchouts
  swings INTEGER,                                    -- Total de swings del oponente
  -- Swings por conteo
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
  -- Trayectorias
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

CREATE INDEX IF NOT EXISTS idx_agg_pitching_stats_groupingId ON agg_pitching_stats(groupingId);
CREATE INDEX IF NOT EXISTS idx_agg_pitching_stats_groupingDescription ON agg_pitching_stats(groupingDescription);
CREATE INDEX IF NOT EXISTS idx_agg_pitching_stats_majorLeagueId ON agg_pitching_stats(majorLeagueId);
CREATE INDEX IF NOT EXISTS idx_agg_pitching_stats_seasonId ON agg_pitching_stats(seasonId);
CREATE INDEX IF NOT EXISTS idx_agg_pitching_stats_venueId ON agg_pitching_stats(venueId);
CREATE INDEX IF NOT EXISTS idx_agg_pitching_stats_teamId ON agg_pitching_stats(teamId);
CREATE INDEX IF NOT EXISTS idx_agg_pitching_stats_playerId ON agg_pitching_stats(playerId);
CREATE INDEX IF NOT EXISTS idx_agg_pitching_stats_opposingTeamId ON agg_pitching_stats(opposingTeamId);
CREATE INDEX IF NOT EXISTS idx_agg_pitching_stats_officialId ON agg_pitching_stats(officialId);
