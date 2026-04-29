DROP TABLE IF EXISTS agg_batting_split_stats;

-- Agregados: Estadísticas de bateo desglosadas por splits (lado de bateo, mano del pitcher, situación de bases)
-- Conteos crudos sin métricas derivadas — útil para análisis granular de splits
CREATE TABLE IF NOT EXISTS agg_batting_split_stats (
    -- Dimensiones de agrupación
    majorLeagueId       INTEGER,         -- ID de la liga mayor
    seasonId            INTEGER,         -- Año de la temporada
    gameType2           TEXT,            -- Tipo de juego: "RS", "PS"
    teamId              INTEGER,         -- ID del equipo
    teamType            TEXT,            -- Tipo de equipo: "home" o "away"
    playerId            INTEGER,         -- ID del jugador
    venueId             INTEGER,         -- ID del estadio
    officialId          INTEGER,         -- ID del umpire de home
    opposingTeamId      INTEGER,         -- ID del equipo contrario
    batSide             TEXT,            -- Lado de bateo: "L", "R" o "S"
    pitchHand           TEXT,            -- Mano del pitcher: "L" o "R"
    menOnBase           TEXT,            -- Situación de bases: "Empty", "Men_On", "Loaded", "RISP"
    -- Estadísticas de bateo (de atbats)
    atbats              INTEGER,         -- Turnos al bate (AB)
    balks               INTEGER,         -- Balks
    batterInterferences INTEGER,         -- Interferencias del bateador
    bunts               INTEGER,         -- Toques
    catcherInterferences INTEGER,        -- Interferencias del catcher
    doubles             INTEGER,         -- Dobles (2B)
    fanInterferences    INTEGER,         -- Interferencias de fanáticos
    fieldErrors         INTEGER,         -- Errores de fildeo
    fieldersChoice      INTEGER,         -- Selección del fildeador
    flyouts             INTEGER,         -- Elevados de out
    forceOuts           INTEGER,         -- Force outs
    games               INTEGER,         -- Juegos jugados
    groundedIntoDoublePlays INTEGER,     -- Doble plays (GIDP)
    groundedIntoTriplePlays INTEGER,     -- Triple plays
    groundOuts          INTEGER,         -- Roletazos de out
    hitByPitch          INTEGER,         -- Golpeado por lanzamiento (HBP)
    hits                INTEGER,         -- Hits (H)
    homeRuns            INTEGER,         -- Jonrones (HR)
    intentionalWalks    INTEGER,         -- BB intencionales (IBB)
    lineOuts            INTEGER,         -- Líneas de out
    passedBalls         INTEGER,         -- Bolas pasadas
    popOuts             INTEGER,         -- Pop-ups de out
    runsBattedIn        INTEGER,         -- Carreras impulsadas (RBI)
    sacBunts            INTEGER,         -- Toques de sacrificio
    sacFlies            INTEGER,         -- Elevados de sacrificio (SF)
    singles             INTEGER,         -- Sencillos (1B)
    strikeOuts          INTEGER,         -- Ponches (SO)
    triples             INTEGER,         -- Triples (3B)
    walks               INTEGER,         -- Bases por bolas (BB)
    wildPitches         INTEGER,         -- Lanzamientos descontrolados
    -- Estadísticas de pitcheos (de pitches)
    balls               INTEGER,         -- Total de bolas
    ballsPitchOut       INTEGER,         -- Bolas en pitchouts
    ballsInDirt         INTEGER,         -- Bolas en la tierra
    intentBalls         INTEGER,         -- Bolas intencionales
    fouls               INTEGER,         -- Fouls
    foulBunts           INTEGER,         -- Fouls de toque
    foulTips            INTEGER,         -- Foul tips
    foulPitchOuts       INTEGER,         -- Fouls en pitchouts
    hitIntoPlay         INTEGER,         -- Pelotas puestas en juego
    pitches             INTEGER,         -- Total de pitcheos
    pitchOuts           INTEGER,         -- Pitchouts
    strikes             INTEGER,         -- Total de strikes
    strikesCalled       INTEGER,         -- Strikes cantados
    strikesPitchOuts    INTEGER,         -- Strikes en pitchouts
    missedBunts         INTEGER,         -- Toques fallados
    swingAndMissStrikes INTEGER,         -- Swings fallados (whiffs)
    swingsPitchOuts     INTEGER,         -- Swings en pitchouts
    swings              INTEGER,         -- Total de swings
    -- Swings por conteo
    swingsZeroAndZero   INTEGER,         -- Swings en conteo 0-0
    swingsZeroAndOne    INTEGER,         -- Swings en conteo 0-1
    swingsZeroAndTwo    INTEGER,         -- Swings en conteo 0-2
    swingsOneAndZero    INTEGER,         -- Swings en conteo 1-0
    swingsOneAndOne     INTEGER,         -- Swings en conteo 1-1
    swingsOneAndTwo     INTEGER,         -- Swings en conteo 1-2
    swingsTwoAndZero    INTEGER,         -- Swings en conteo 2-0
    swingsTwoAndOne     INTEGER,         -- Swings en conteo 2-1
    swingsTwoAndTwo     INTEGER,         -- Swings en conteo 2-2
    swingsThreeAndZero  INTEGER,         -- Swings en conteo 3-0
    swingsThreeAndOne   INTEGER,         -- Swings en conteo 3-1
    swingsThreeAndTwo   INTEGER,         -- Swings en conteo 3-2
    -- Trayectorias
    flyBalls            INTEGER,         -- Elevados (fly balls)
    groundBalls         INTEGER,         -- Roletazos (ground balls)
    lineDrives          INTEGER,         -- Líneas (line drives)
    popUps              INTEGER,         -- Elevados cortos (pop-ups)
    groundBunts         INTEGER,         -- Toques de roletazo
    popupBunts          INTEGER,         -- Toques de elevado corto
    lineDriveBunts      INTEGER,         -- Toques de línea
    groupingId          INTEGER,         -- ID del nivel de agrupación
    groupingDescription TEXT             -- Descripción del nivel de agrupación
);

CREATE INDEX IF NOT EXISTS idx_agg_batting_split_stats_groupingId ON agg_batting_split_stats (groupingId);
CREATE INDEX IF NOT EXISTS idx_agg_batting_split_stats_groupingDescription ON agg_batting_split_stats (groupingDescription);
CREATE INDEX IF NOT EXISTS idx_agg_batting_split_stats_majorLeagueId ON agg_batting_split_stats (majorLeagueId);
CREATE INDEX IF NOT EXISTS idx_agg_batting_split_stats_seasonId ON agg_batting_split_stats (seasonId);
CREATE INDEX IF NOT EXISTS idx_agg_batting_split_stats_teamId ON agg_batting_split_stats (teamId);
CREATE INDEX IF NOT EXISTS idx_agg_batting_split_stats_playerId ON agg_batting_split_stats (playerId);
CREATE INDEX IF NOT EXISTS idx_agg_batting_split_stats_venueId ON agg_batting_split_stats (venueId);
CREATE INDEX IF NOT EXISTS idx_agg_batting_split_stats_officialId ON agg_batting_split_stats (officialId);
CREATE INDEX IF NOT EXISTS idx_agg_batting_split_stats_opposingTeamId    ON agg_batting_split_stats (opposingTeamId);
