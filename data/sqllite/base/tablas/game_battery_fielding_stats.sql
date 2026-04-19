DROP TABLE IF EXISTS game_battery_fielding_stats;

CREATE TABLE game_battery_fielding_stats (
  gamePk INTEGER,
  teamId INTEGER,
  pitcherId INTEGER,
  catcherId INTEGER,
  caughtStealingSecondBase INTEGER,
  caughtStealingThirdBase INTEGER,
  caughtStealingHome INTEGER,
  caughtStealing INTEGER,
  passedBalls INTEGER,
  pickoffFirstBase INTEGER,
  pickoffSecondBase INTEGER,
  pickoffThirdBase INTEGER,
  pickOffs INTEGER,
  pickoffCaughtStealingFirstBase INTEGER,
  pickoffCaughtStealingSecondBase INTEGER,
  pickoffCaughtStealingThirdBase INTEGER,
  pickoffCaughtStealing INTEGER,
  pickoffErrorFirstBase INTEGER,
  pickoffErrorSecondBase INTEGER,
  pickoffErrorThirdBase INTEGER,
  pickoffErrors INTEGER,
  stolenSecondBase INTEGER,
  stolenThirdBase INTEGER,
  stolenHome INTEGER,
  stolenBases INTEGER,
  wildPitches INTEGER
);

CREATE INDEX IF NOT EXISTS idx_game_battery_fielding_stats_gamePk ON game_battery_fielding_stats(gamePk);
