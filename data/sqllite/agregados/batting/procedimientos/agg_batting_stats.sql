-- Procedure: agg_batting_stats
-- NOTE: This procedure used dynamic SQL in MySQL. In SQLite, each grouping combination
-- must be called as a separate static SQL statement from the application layer.
-- The template query is preserved below as a reference.

-- Parameters were: p_grouping_fields VARCHAR(255), p_aggregation_type VARCHAR(255)

/*
INSERT INTO agg_batting_stats(
    -- IF p_aggregation_type = 'CUMULATIVE': gameDate,
    {p_grouping_fields},
    aggregationType,
    atBats, balks, batterInterferences, bunts, catcherInterferences,
    caughtStealing, doubles, fanInterferences, fieldErrors, fieldersChoice,
    flyOuts, forceOuts, games, groundedIntoDoublePlays, groundedIntoTriplePlays,
    groundOuts, hitByPitch, hits, homeRuns, intentionalWalks, leftOnBase,
    lineOuts, passedBalls, pickoffs, popOuts, runsBattedIn, runs,
    sacBunts, sacFlies, stolenBases, strikeOuts, triples, walks, wildPitches,
    -- Coming from the pitches tables
    balls, ballsPitchOut, ballsInDirt, intentBalls, fouls, foulBunts,
    foulTips, foulPitchOuts, hitIntoPlay, pitches, pitchOuts, strikes,
    strikesCalled, strikesPitchOuts, missedBunts, swingAndMissStrikes,
    swingsPitchOuts, swings,
    swingsZeroAndZero, swingsZeroAndOne, swingsZeroAndTwo,
    swingsOneAndZero, swingsOneAndOne, swingsOneAndTwo,
    swingsTwoAndZero, swingsTwoAndOne, swingsTwoAndTwo,
    swingsThreeAndZero, swingsThreeAndOne, swingsThreeAndTwo,
    flyBalls, groundBalls, lineDrives, popUps, groundBunts, popupBunts, lineDriveBunts,
    groupingId, groupingDescription
)
WITH game_split_stats AS
(
    SELECT
        gamePk,
        batterId,
        pitchingTeamId AS opposingTeamId,
        SUM(balks) AS balks,
        SUM(batterInterferences) AS batterInterferences,
        SUM(bunts) AS bunts,
        SUM(fanInterferences) AS fanInterferences,
        SUM(fieldErrors) AS fieldErrors,
        SUM(fieldersChoice) AS fieldersChoice,
        SUM(forceOuts) AS forceOuts,
        SUM(lineOuts) AS lineOuts,
        SUM(passedBalls) AS passedBalls,
        SUM(popOuts) AS popOuts,
        SUM(wildPitches) AS wildPitches,
        -- These metrics come from the pitches table
        SUM(balls) AS balls,
        SUM(ballsPitchOut) AS ballsPitchOut,
        SUM(ballsInDirt) AS ballsInDirt,
        SUM(intentBalls) AS intentBalls,
        SUM(fouls) AS fouls,
        SUM(foulBunts) AS foulBunts,
        SUM(foulTips) AS foulTips,
        SUM(foulPitchOuts) AS foulPitchOuts,
        SUM(hitIntoPlay) AS hitIntoPlay,
        SUM(pitches) AS pitches,
        SUM(pitchOuts) AS pitchOuts,
        SUM(strikes) AS strikes,
        SUM(strikesCalled) AS strikesCalled,
        SUM(strikesPitchOuts) AS strikesPitchOuts,
        SUM(missedBunts) AS missedBunts,
        SUM(swingAndMissStrikes) AS swingAndMissStrikes,
        SUM(swingsPitchOuts) AS swingsPitchOuts,
        SUM(swings) AS swings,
        SUM(swingsZeroAndZero) AS swingsZeroAndZero,
        SUM(swingsZeroAndOne) AS swingsZeroAndOne,
        SUM(swingsZeroAndTwo) AS swingsZeroAndTwo,
        SUM(swingsOneAndZero) AS swingsOneAndZero,
        SUM(swingsOneAndOne) AS swingsOneAndOne,
        SUM(swingsOneAndTwo) AS swingsOneAndTwo,
        SUM(swingsTwoAndZero) AS swingsTwoAndZero,
        SUM(swingsTwoAndOne) AS swingsTwoAndOne,
        SUM(swingsTwoAndTwo) AS swingsTwoAndTwo,
        SUM(swingsThreeAndZero) AS swingsThreeAndZero,
        SUM(swingsThreeAndOne) AS swingsThreeAndOne,
        SUM(swingsThreeAndTwo) AS swingsThreeAndTwo,
        SUM(flyBalls) AS flyBalls,
        SUM(groundBalls) AS groundBalls,
        SUM(lineDrives) AS lineDrives,
        SUM(popUps) AS popUps,
        SUM(groundBunts) AS groundBunts,
        SUM(popupBunts) AS popupBunts,
        SUM(lineDriveBunts) AS lineDriveBunts
    FROM game_player_split_stats
    GROUP BY 1, 2, 3
), officials AS
(
    SELECT gamePk, officialId
    FROM game_officials
    WHERE position  = "Home Plate"
),
d AS
(
    SELECT
        -- IF p_aggregation_type = 'CUMULATIVE': gameDate,
        {p_grouping_fields},
        SUM(atBats) AS atBats,
        SUM(balks) AS balks,
        SUM(batterInterferences) AS batterInterferences,
        SUM(bunts) AS bunts,
        SUM(catchersInterference) AS catcherInterferences,
        SUM(caughtStealing) AS caughtStealing,
        SUM(doubles) AS doubles,
        SUM(fanInterferences) AS fanInterferences,
        SUM(fieldErrors) AS fieldErrors,
        SUM(fieldersChoice) AS fieldersChoice,
        SUM(flyOuts) AS flyOuts,
        SUM(forceOuts) AS forceOuts,
        COUNT(DISTINCT g.gamePk) AS games,
        SUM(groundIntoDoublePlay) AS groundedIntoDoublePlays,
        SUM(groundIntoTriplePlay) AS groundedIntoTriplePlays,
        SUM(groundOuts) AS groundOuts,
        SUM(hitByPitch) AS hitByPitch,
        SUM(hits) AS hits,
        SUM(homeRuns) AS homeRuns,
        SUM(intentionalWalks) AS intentionalWalks,
        SUM(leftOnBase) AS leftOnBase,
        SUM(lineOuts) AS lineOuts,
        SUM(passedBalls) AS passedBalls,
        SUM(pickoffs) AS pickoffs,
        SUM(popOuts) AS popOuts,
        SUM(rbi) AS runsBattedIn,
        SUM(runs) AS runs,
        SUM(sacBunts) AS sacBunts,
        SUM(sacFlies) AS sacFlies,
        SUM(stolenBases) AS stolenBases,
        SUM(strikeOuts) AS strikeOuts,
        SUM(triples) AS triples,
        SUM(walks) AS walks,
        SUM(wildPitches) AS wildPitches,
        -- These metrics come from the pitches table
        SUM(balls) AS balls, SUM(ballsPitchOut) AS ballsPitchOut,
        SUM(ballsInDirt) AS ballsInDirt, SUM(intentBalls) AS intentBalls,
        SUM(fouls) AS fouls, SUM(foulBunts) AS foulBunts,
        SUM(foulTips) AS foulTips, SUM(foulPitchOuts) AS foulPitchOuts,
        SUM(hitIntoPlay) AS hitIntoPlay, SUM(pitches) AS pitches,
        SUM(pitchOuts) AS pitchOuts, SUM(strikes) AS strikes,
        SUM(strikesCalled) AS strikesCalled, SUM(strikesPitchOuts) AS strikesPitchOuts,
        SUM(missedBunts) AS missedBunts, SUM(swingAndMissStrikes) AS swingAndMissStrikes,
        SUM(swingsPitchOuts) AS swingsPitchOuts, SUM(swings) AS swings,
        SUM(swingsZeroAndZero) AS swingsZeroAndZero, SUM(swingsZeroAndOne) AS swingsZeroAndOne,
        SUM(swingsZeroAndTwo) AS swingsZeroAndTwo,
        SUM(swingsOneAndZero) AS swingsOneAndZero, SUM(swingsOneAndOne) AS swingsOneAndOne,
        SUM(swingsOneAndTwo) AS swingsOneAndTwo,
        SUM(swingsTwoAndZero) AS swingsTwoAndZero, SUM(swingsTwoAndOne) AS swingsTwoAndOne,
        SUM(swingsTwoAndTwo) AS swingsTwoAndTwo,
        SUM(swingsThreeAndZero) AS swingsThreeAndZero, SUM(swingsThreeAndOne) AS swingsThreeAndOne,
        SUM(swingsThreeAndTwo) AS swingsThreeAndTwo,
        SUM(flyBalls) AS flyBalls, SUM(groundBalls) AS groundBalls,
        SUM(lineDrives) AS lineDrives, SUM(popUps) AS popUps,
        SUM(groundBunts) AS groundBunts, SUM(popupBunts) AS popupBunts,
        SUM(lineDriveBunts) AS lineDriveBunts
    FROM games g
    INNER JOIN game_player_batting_stats bs
        ON g.gamePk = bs.gamePk
    INNER JOIN game_split_stats ss
        ON bs.gamePk = ss.gamePk
        AND bs.playerId = ss.batterId
    LEFT JOIN officials o
        ON g.gamePk = o.gamePk
    WHERE gameType2 IN ("PS","RS")
    GROUP BY
        -- IF p_aggregation_type = 'CUMULATIVE': gameDate,
        {p_grouping_fields}
)
SELECT
    -- IF p_aggregation_type = 'CUMULATIVE': gameDate,
    {p_grouping_fields},
    -- IF p_aggregation_type = 'CUMULATIVE': "CUMULATIVE", ELSE: "AGGREGATED",
    -- NOTE: AGG_OR_CUM_QUERIES() was a MySQL UDF that generated SUM() or cumulative SUM() OVER() expressions
    -- For AGGREGATED: use SUM(col) directly
    -- For CUMULATIVE: use SUM(SUM(col)) OVER (PARTITION BY {p_grouping_fields} ORDER BY gameDate)
    SUM(atBats) AS atBats,
    -- ... (all other SUM columns follow the same pattern) ...
    SUM(lineDriveBunts) AS lineDriveBunts,
    -- NOTE: agg_grouping_id() was a MySQL UDF - replace with appropriate grouping id value
    -- NOTE: agg_grouping_description() was a MySQL UDF - replace with appropriate grouping description value
    {groupingId} AS groupingId,
    {groupingDescription} AS groupingDescription
FROM d
GROUP BY
    -- IF p_aggregation_type = 'CUMULATIVE': gameDate,
    {p_grouping_fields}
*/
