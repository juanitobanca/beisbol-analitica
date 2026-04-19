-- Procedure: agg_pitching_stats
-- NOTE: This procedure used dynamic SQL in MySQL. In SQLite, each grouping combination
-- must be called as a separate static SQL statement from the application layer.
-- The template query is preserved below as a reference.

-- Parameters were: p_grouping_fields VARCHAR(255), p_aggregation_type VARCHAR(255)

/*
INSERT INTO agg_pitching_stats (
    -- IF p_aggregation_type = 'CUMULATIVE': gameDate,
    {p_grouping_fields},
    aggregationType,
    airOuts, atBats, walks, battersFaced, blownSaves, catcherInterferences,
    caughtStealing, completeGames, doubles, earnedRuns, gamesFinished, gamesPitched,
    gamesPlayed, gamesStarted, groundOuts, hitBatsmen, hits, holds, homeRuns,
    inheritedRunners, inheritedRunnersScored, intentionalWalks, losses, numberOfPitches,
    outs, pickoffs, pitchesThrown, plateAppearances, rbi, runs, sacBunts, sacFlies,
    saveOpportunities, saves, singles, shutouts, stolenBases, strikeOuts, triples,
    unintentionalWalks, wildPitches, wins,
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
        gamePk, pitcherId,
        battingTeamId AS opposingTeamId,
        SUM(balks) AS balks, SUM(batterInterferences) AS batterInterferences,
        SUM(bunts) AS bunts, SUM(fanInterferences) AS fanInterferences,
        SUM(fieldErrors) AS fieldErrors, SUM(fieldersChoice) AS fieldersChoice,
        SUM(forceOuts) AS forceOuts, SUM(lineOuts) AS lineOuts,
        SUM(passedBalls) AS passedBalls, SUM(popOuts) AS popOuts,
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
    FROM game_player_split_stats
    GROUP BY 1, 2, 3
),
officials AS
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
        SUM(airOuts) airOuts, SUM(atBats) atBats, SUM(walks) walks,
        SUM(battersFaced) battersFaced, SUM(blownSaves) blownSaves,
        SUM(catchersInterference) AS catcherInterferences,
        SUM(caughtStealing) caughtStealing, SUM(completeGames) completeGames,
        SUM(doubles) doubles, SUM(earnedRuns) earnedRuns,
        SUM(gamesFinished) gamesFinished, SUM(gamesPitched) gamesPitched,
        SUM(gamesPlayed) gamesPlayed, SUM(gamesStarted) gamesStarted,
        SUM(groundOuts) groundOuts, SUM(hitBatsmen) hitBatsmen,
        SUM(hits) hits, SUM(holds) holds, SUM(homeRuns) homeRuns,
        SUM(inheritedRunners) inheritedRunners, SUM(inheritedRunnersScored) inheritedRunnersScored,
        SUM(intentionalWalks) intentionalWalks, SUM(losses) losses,
        SUM(numberOfPitches) numberOfPitches, SUM(outs) outs,
        SUM(pickoffs) pickoffs, SUM(pitchesThrown) pitchesThrown,
        SUM(plateAppearances) plateAppearances, SUM(rbi) rbi, SUM(runs) runs,
        SUM(sacBunts) sacBunts, SUM(sacFlies) sacFlies,
        SUM(saveOpportunities) saveOpportunities, SUM(saves) saves,
        SUM(singles) singles, SUM(shutouts) shutouts,
        SUM(stolenBases) stolenBases, SUM(strikeOuts) strikeOuts,
        SUM(triples) triples, SUM(unintentionalWalks) unintentionalWalks,
        SUM(ss.wildPitches) wildPitches, SUM(wins) wins,
        -- These metrics come from the pitches table
        SUM(ss.balls) AS balls, SUM(ballsPitchOut) AS ballsPitchOut,
        SUM(ballsInDirt) AS ballsInDirt, SUM(intentBalls) AS intentBalls,
        SUM(fouls) AS fouls, SUM(foulBunts) AS foulBunts,
        SUM(foulTips) AS foulTips, SUM(foulPitchOuts) AS foulPitchOuts,
        SUM(hitIntoPlay) AS hitIntoPlay, SUM(pitches) AS pitches,
        SUM(pitchOuts) AS pitchOuts, SUM(ss.strikes) AS strikes,
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
        SUM(lineDriveBunts) AS lineDriveBunts,
        -- NOTE: agg_grouping_id() was a MySQL UDF - replace with appropriate grouping id value
        -- NOTE: agg_grouping_description() was a MySQL UDF - replace with appropriate grouping description value
        {grouping_id} AS grouping_id,
        {grouping_description} AS grouping_description
    FROM games g
    INNER JOIN game_player_pitching_stats bs
        ON g.gamePk = bs.gamePk
    INNER JOIN game_split_stats ss
        ON bs.gamePk = ss.gamePk
        AND bs.playerId = ss.pitcherId
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
    SUM(airOuts) airOuts,
    SUM(atBats) atBats,
    -- ... (all other SUM columns follow the same pattern) ...
    SUM(lineDriveBunts) AS lineDriveBunts,
    grouping_id,
    grouping_description
FROM d
GROUP BY
    -- IF p_aggregation_type = 'CUMULATIVE': gameDate,
    {p_grouping_fields}
*/
