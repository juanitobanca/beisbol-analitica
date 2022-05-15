USE baseball;

DROP PROCEDURE agg_pitching_split_stats;

DELIMITER //

CREATE PROCEDURE agg_pitching_split_stats( IN p_grouping_fields VARCHAR(255), OUT insert_stmt VARCHAR(16000))
BEGIN

SET @insert_stmt = CONCAT('INSERT INTO agg_pitching_stats (', p_grouping_fields,',',
                          ' atbats,
                            balks,
                            batterInterferences,
                            bunts,
                            catcherInterferences,
                            doubles,
                            fanInterferences,
                            fieldErrors,
                            fieldersChoice,
                            flyouts,
                            forceOuts,
                            games,
                            doublePlays,
                            triplePlays,
                            groundOuts,
                            hitBatsmen,
                            hits,
                            homeRuns,
                            intentionalWalks,
                            lineOuts,
                            passedBalls,
                            popOuts,
                            runsBattedIn,
                            sacBunts,
                            sacFlies,
                            singles,
                            strikeOuts,
                            triples,
                            walks,
                            wildPitches,
                            -- Coming from the pitches tables
                            balls,
                            ballsPitchOut,
                            ballsInDirt,
                            intentBalls,
                            fouls,
                            foulBunts,
                            foulTips,
                            foulPitchOuts,
                            hitIntoPlay,
                            pitches,
                            pitchOuts,
                            strikes,
                            strikesCalled,
                            strikesPitchOuts,
                            missedBunts,
                            swingAndMissStrikes,
                            swingsPitchOuts,
                            swings,
                            swingsZeroAndZero,
                            swingsZeroAndOne,
                            swingsZeroAndTwo,
                            swingsOneAndZero,
                            swingsOneAndOne,
                            swingsOneAndTwo,
                            swingsTwoAndZero,
                            swingsTwoAndOne,
                            swingsTwoAndTwo,
                            swingsThreeAndZero,
                            swingsThreeAndOne,
                            swingsThreeAndTwo,
                            flyBalls,
                            groundBalls,
                            lineDrives,
                            popUps,
                            groundBunts,
                            popupBunts,
                            lineDriveBunts,
                            groupingId,
                            groupingDescription
                            )
                        WITH bs AS (
                            SELECT
                                *, battingTeamId AS opposingTeamId
                            FROM game_player_split_stats
                            ),
                            g AS (
                            SELECT
                                majorLeagueId,
                                seasonId,
                                gamePk,
                                gameType2,
                                venueId,
                                homeTeamId
                            FROM games
                            WHERE gameType2 IN ("PS","RS")
                            ), officials AS
                            (
                                SELECT gamePk, officialId
                                FROM game_officials
                                WHERE position  = "Home Plate"
                            ),
                            data AS (
                            SELECT
                                g.majorLeagueId,
                                g.seasonId,
                                g.gamePk,
                                g.gameType2,
                                g.venueId,
                                IF( g.homeTeamId = bs.battingTeamId, "home", "away" ) teamType,
                                bs.battingTeamId AS teamId,
                                bs.opposingTeamId,
                                bs.batterId AS playerId,
                                o.officialId,
                                batSide,
                                pitchHand,
                                menOnBase,
                                batterInterferences + bunts + doubles + fanInterferences + fieldErrors + fieldersChoice
                              + flyouts + forceOuts + groundedIntoDoublePlays + triplePlays + groundOuts + homeRuns
                              + lineOuts + popOuts + singles + strikeOuts + triples AS atbats,
                                balks,
                                batterInterferences,
                                bunts,
                                catcherInterferences,
                                doubles,
                                fanInterferences,
                                fieldErrors,
                                fieldersChoice,
                                flyouts,
                                forceOuts,
                                groundedIntoDoublePlays,
                                groundOuts,
                                hitByPitch,
                                homeRuns,
                                intentionalWalks,
                                lineOuts,
                                passedBalls,
                                popOuts,
                                runsBattedIn,
                                sacBunts,
                                sacFlies,
                                singles,
                                strikeOuts,
                                triples,
                                triplePlays,
                                walks,
                                wildPitches,
                                -- Coming from the pitches tables
                                balls,
                                ballsPitchOut,
                                ballsInDirt,
                                intentBalls,
                                fouls,
                                foulBunts,
                                foulTips,
                                foulPitchOuts,
                                hitIntoPlay,
                                pitches,
                                pitchOuts,
                                strikes,
                                strikesCalled,
                                strikesPitchOuts,
                                missedBunts,
                                swingAndMissStrikes,
                                swingsPitchOuts,
                                swings,
                                swingsZeroAndZero,
                                swingsZeroAndOne,
                                swingsZeroAndTwo,
                                swingsOneAndZero,
                                swingsOneAndOne,
                                swingsOneAndTwo,
                                swingsTwoAndZero,
                                swingsTwoAndOne,
                                swingsTwoAndTwo,
                                swingsThreeAndZero,
                                swingsThreeAndOne,
                                swingsThreeAndTwo,
                                flyBalls,
                                groundBalls,
                                lineDrives,
                                popUps,
                                groundBunts,
                                popupBunts,
                                lineDriveBunts
                            FROM g
                            INNER JOIN bs
                                ON g.gamePk = bs.gamePk
                            LEFT JOIN officials o
                                ON g.gamePk = o.gamePk
                            )
                            SELECT ', p_grouping_fields, ',',
                            '   SUM(atbats) AS atbats,
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
                                SUM(groundedIntoDoublePlays) AS doublePlays,
                                SUM(triplePlays) AS triplePlays,
                                SUM(groundOuts) AS groundOuts,
                                SUM(hitByPitch) AS hitBatsmen,
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
                                -- Swings Per Ball and Strikes
                                -- 0 Ball(s)
                                SUM(swingsZeroAndZero) AS swingsZeroAndZero,
                                SUM(swingsZeroAndOne) AS swingsZeroAndOne,
                                SUM(swingsZeroAndTwo) AS swingsZeroAndTwo,
                                -- 1 Ball(s)
                                SUM(swingsOneAndZero) AS swingsOneAndZero,
                                SUM(swingsOneAndOne) AS swingsOneAndOne,
                                SUM(swingsOneAndTwo) AS swingsOneAndTwo,
                                -- 2 Ball(s)
                                SUM(swingsTwoAndZero) AS swingsTwoAndZero,
                                SUM(swingsTwoAndOne) AS swingsTwoAndOne,
                                SUM(swingsTwoAndTwo) AS swingsTwoAndTwo,
                                -- 3 Ball(s)
                                SUM(swingsThreeAndZero) AS swingsThreeAndZero,
                                SUM(swingsThreeAndOne) AS swingsThreeAndOne,
                                SUM(swingsThreeAndTwo) AS swingsThreeAndTwo,
                                -- Trajectories
                                SUM(flyBalls) AS flyBalls,
                                SUM(groundBalls) AS groundBalls,
                                SUM(lineDrives) AS lineDrives,
                                SUM(popUps) AS popUps,
                                SUM(groundBunts) AS groundBunts,
                                SUM(popupBunts) AS popupBunts,
                                SUM(lineDriveBunts) AS lineDriveBunts,
                                agg_grouping_id("', p_grouping_fields, '") groupingId,
                                agg_grouping_description("', p_grouping_fields, '") groupingDescription
                                FROM data
                                GROUP BY ',
                                p_grouping_fields
                    );

SELECT @insert_stmt;
PREPARE insert_stmt_sql FROM @insert_stmt;
EXECUTE insert_stmt_sql;

END //

DELIMITER ;
