DROP TABLE IF EXISTS game_battery_fielding_stats;

-- Base: Estadísticas de fildeo de la batería (pitcher+catcher) por juego — robos, pickoffs, bolas pasadas
CREATE TABLE game_battery_fielding_stats (
  gamePk INTEGER,                              -- ID único del juego
  teamId INTEGER,                              -- ID del equipo
  pitcherId INTEGER,                           -- ID del pitcher
  catcherId INTEGER,                           -- ID del catcher
  caughtStealingSecondBase INTEGER,            -- Atrapados robando segunda base
  caughtStealingThirdBase INTEGER,             -- Atrapados robando tercera base
  caughtStealingHome INTEGER,                  -- Atrapados robando home
  caughtStealing INTEGER,                      -- Total de atrapados robando
  passedBalls INTEGER,                         -- Bolas pasadas del catcher
  pickoffFirstBase INTEGER,                    -- Pickoffs en primera base
  pickoffSecondBase INTEGER,                   -- Pickoffs en segunda base
  pickoffThirdBase INTEGER,                    -- Pickoffs en tercera base
  pickOffs INTEGER,                            -- Total de pickoffs
  pickoffCaughtStealingFirstBase INTEGER,      -- Pickoff + atrapado robando en primera
  pickoffCaughtStealingSecondBase INTEGER,     -- Pickoff + atrapado robando en segunda
  pickoffCaughtStealingThirdBase INTEGER,      -- Pickoff + atrapado robando en tercera
  pickoffCaughtStealing INTEGER,               -- Total de pickoff + atrapado robando
  pickoffErrorFirstBase INTEGER,               -- Errores de pickoff en primera
  pickoffErrorSecondBase INTEGER,              -- Errores de pickoff en segunda
  pickoffErrorThirdBase INTEGER,               -- Errores de pickoff en tercera
  pickoffErrors INTEGER,                       -- Total de errores de pickoff
  stolenSecondBase INTEGER,                    -- Bases robadas a segunda permitidas
  stolenThirdBase INTEGER,                     -- Bases robadas a tercera permitidas
  stolenHome INTEGER,                          -- Robos de home permitidos
  stolenBases INTEGER,                         -- Total de bases robadas permitidas
  wildPitches INTEGER                          -- Lanzamientos descontrolados (wild pitches)
);

CREATE INDEX IF NOT EXISTS idx_game_battery_fielding_stats_gamePk ON game_battery_fielding_stats(gamePk);
