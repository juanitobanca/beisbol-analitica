-- Procedure: agg_batting_split_stats
-- NOTE: This procedure used dynamic SQL in MySQL. In SQLite, each grouping combination
-- must be called as a separate static SQL statement from the application layer.
-- The template query is preserved below as a reference.

-- Parameters were: p_grouping_fields VARCHAR(255)

/*
INSERT INTO agg_batting_stats (
    {p_grouping_fields},
    atbats, balks, batterInterferences, bunts, catcherInterferences, doubles,
    fanInterferences, fieldErrors, fieldersChoice, flyouts, forceOuts, games,
    groundedIntoDoublePlays, groundedIntoTriplePlays, groundOuts, hitByPitch,
    hits, homeRuns, intentionalWalks, lineOuts, passedBalls, popOuts,
    runsBattedIn, sacBunts, sacFlies, singles, strikeOuts, triples, walks, wildPitches,
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
WITH bs AS (
    SELECT
        *, pitchingTeamId as opposingTeamId
    FROM game_player_split_stats
),
g AS (
    SELECT
        majorLeagueId, seasonId, gamePk, gameType2, venueId, homeTeamId
    FROM games
    WHERE gameType2 IN ("PS","RS")
),
officials AS (
    SELECT gamePk, officialId
    FROM game_officials
    WHERE position  = "Home Plate"
),
data AS (
    SELECT
        g.majorLeagueId, g.seasonId, g.gamePk, g.gameType2, g.venueId,
        CASE WHEN g.homeTeamId = bs.battingTeamId THEN "home" ELSE "away" END AS teamType,
        bs.battingTeamId AS teamId,
        bs.batterId AS playerId,
        bs.opposingTeamId,
        o.officialId,
        batSide, pitchHand, menOnBase,
        batterInterferences + bunts + doubles + fanInterferences + fieldErrors + fieldersChoice
          + flyouts + forceOuts + groundedIntoDoublePlays + triplePlays + groundOuts + homeRuns
          + lineOuts + popOuts + singles + strikeOuts + triples AS atbats,
        balks, batterInterferences, bunts, catcherInterferences, doubles,
        fanInterferences, fieldErrors, fieldersChoice, flyouts, forceOuts,
        groundedIntoDoublePlays, groundOuts, hitByPitch, homeRuns, intentionalWalks,
        lineOuts, passedBalls, popOuts, runsBattedIn, sacBunts, sacFlies,
        singles, strikeOuts, triples, triplePlays, walks, wildPitches,
        -- Coming from the pitches tables
        balls, ballsPitchOut, ballsInDirt, intentBalls, fouls, foulBunts,
        foulTips, foulPitchOuts, hitIntoPlay, pitches, pitchOuts, strikes,
        strikesCalled, strikesPitchOuts, missedBunts, swingAndMissStrikes,
        swingsPitchOuts, swings,
        swingsZeroAndZero, swingsZeroAndOne, swingsZeroAndTwo,
        swingsOneAndZero, swingsOneAndOne, swingsOneAndTwo,
        swingsTwoAndZero, swingsTwoAndOne, swingsTwoAndTwo,
        swingsThreeAndZero, swingsThreeAndOne, swingsThreeAndTwo,
        flyBalls, groundBalls, lineDrives, popUps, groundBunts, popupBunts, lineDriveBunts
    FROM g
    INNER JOIN bs ON g.gamePk = bs.gamePk
    LEFT JOIN officials o ON g.gamePk = o.gamePk
)
SELECT
    {p_grouping_fields},
    SUM(atbats) AS atbats,
    SUM(balks) AS balks,
    SUM(batterInterferences) AS batterInterferences,
    SUM(bunts) AS bunts,
    SUM(catcherInterferences) AS catcherInterferences,
    SUM(doubles) AS doubles,
    SUM(fanInterferences) AS fanInterferences,
    SUM(fieldErrors) AS fieldErrors,
    SUM(fieldersChoice) AS fieldersChoice,
    SUM(flyouts) AS flyouts,
    SUM(forceOuts) AS forceOuts,
    COUNT(DISTINCT gamePk) AS games,
    SUM(groundedIntoDoublePlays) AS groundedIntoDoublePlays,
    SUM(triplePlays) AS groundedIntoTriplePlays,
    SUM(groundOuts) AS groundOuts,
    SUM(hitByPitch) AS hitByPitch,
    SUM(singles) + SUM(doubles) + SUM(triples) + SUM(homeRuns) hits,
    SUM(homeRuns) AS homeRuns,
    SUM(intentionalWalks) AS intentionalWalks,
    SUM(lineOuts) AS lineOuts,
    SUM(passedBalls) AS passedBalls,
    SUM(popOuts) AS popOuts,
    SUM(runsBattedIn) as runsBattedIn,
    SUM(sacBunts) AS sacBunts,
    SUM(sacFlies) AS sacFlies,
    SUM(singles) AS singles,
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
    SUM(lineDriveBunts) AS lineDriveBunts,
    -- NOTE: agg_grouping_id() was a MySQL UDF - replace with appropriate grouping id value
    -- NOTE: agg_grouping_description() was a MySQL UDF - replace with appropriate grouping description value
    {groupingId} AS groupingId,
    {groupingDescription} AS groupingDescription
FROM data
GROUP BY {p_grouping_fields}
*/
