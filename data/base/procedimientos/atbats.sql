-- Procedure: atbats
INSERT INTO atbats(
    gamePk,
    inning,
    halfInning,
    atBatIndex,
    endOuts,
    endBalls,
    endStrikes,
    batterId,
    pitcherId,
    hasOut,
    hasReview,
    isScoringPlay,
    rbi,
    awayScore,
    homeScore,
    event,
    eventType,
    batSide,
    pitchHand,
    menOnBase,
    description
  )
SELECT DISTINCT
  gamePk,
  inning,
  halfInning,
  atBatIndex,
  outs AS endOuts,
  balls AS endBalls,
  strikes AS endStrikes,
  batterId,
  pitcherId,
  hasOut,
  hasReview,
  isScoringPlay,
  rbi,
  awayScore,
  homeScore,
  event,
  eventType,
  batterSideCode AS batSide,
  pitcherHandCode AS pitchHand,
  menOnBase,
  description
FROM stg_play_atbat
WHERE
  1 = 1
  AND (gamePk, atBatIndex) NOT IN (
    SELECT
      gamePk,
      atBatIndex
    FROM atbats
  );

-- Stats from pitching
UPDATE atbats
SET pitches = (
    SELECT COUNT(1)
    FROM pitches p
    WHERE atbats.gamePk = p.gamePk AND atbats.atBatIndex = p.atBatIndex
)
WHERE (gamePk, atBatIndex) NOT IN (
    SELECT gamePk, atBatIndex FROM atbats WHERE pitches IS NOT NULL
)
AND EXISTS (
    SELECT 1 FROM pitches p WHERE atbats.gamePk = p.gamePk AND atbats.atBatIndex = p.atBatIndex
);

-- Update batting/pitching teams
UPDATE atbats
SET pitchingTeamId = CASE WHEN halfInning = 'top' THEN (SELECT g.homeTeamId FROM games g WHERE atbats.gamePk = g.gamePk) ELSE (SELECT g.awayTeamId FROM games g WHERE atbats.gamePk = g.gamePk) END,
    battingTeamId  = CASE WHEN halfInning = 'top' THEN (SELECT g.awayTeamId FROM games g WHERE atbats.gamePk = g.gamePk) ELSE (SELECT g.homeTeamId FROM games g WHERE atbats.gamePk = g.gamePk) END
WHERE (pitchingTeamId IS NULL OR battingTeamId IS NULL)
AND EXISTS (SELECT 1 FROM games g WHERE atbats.gamePk = g.gamePk);

-- Update Where the BIP landed ( HM4, HM8 )
UPDATE atbats
SET HM4 = (SELECT p.HM4 FROM pitches p WHERE atbats.gamePk = p.gamePk AND atbats.atBatIndex = p.atBatIndex AND atbats.pitches = p.pitchNumber),
    HM8 = (SELECT p.HM8 FROM pitches p WHERE atbats.gamePk = p.gamePk AND atbats.atBatIndex = p.atBatIndex AND atbats.pitches = p.pitchNumber)
WHERE HM8 IS NULL
AND EXISTS (SELECT 1 FROM pitches p WHERE atbats.gamePk = p.gamePk AND atbats.atBatIndex = p.atBatIndex AND atbats.pitches = p.pitchNumber);
