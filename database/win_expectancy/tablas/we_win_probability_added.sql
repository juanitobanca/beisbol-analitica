DROP TABLE IF EXISTS we_win_probability_added;

-- Win Expectancy: WPA (Win Probability Added) por jugador
-- Mide cuánto contribuyó cada jugador a la probabilidad de ganar de su equipo
-- WPA positivo = el jugador ayudó a ganar, WPA negativo = perjudicó
CREATE TABLE IF NOT EXISTS we_win_probability_added (
  groupingId INTEGER,                          -- ID del nivel de agrupación
  groupingDescription TEXT,                    -- Descripción del nivel de agrupación
  groupingFields TEXT,                         -- Campos usados para la agrupación
  majorLeagueId INTEGER,                       -- ID de la liga
  seasonId INTEGER,                            -- Año de la temporada
  gameType2 TEXT,                              -- Tipo de juego: "RS", "PS", etc.
  teamId INTEGER,                              -- ID del equipo
  playerId INTEGER,                            -- ID del jugador
  offensiveWinProbabilityAdded REAL,           -- WPA ofensivo (contribución bateando/corriendo)
  defensiveWinProbabilityAdded REAL            -- WPA defensivo (contribución pitcheando/fildeando)
);

CREATE INDEX IF NOT EXISTS idx_we_win_probability_added_groupingId ON we_win_probability_added(groupingId);
CREATE INDEX IF NOT EXISTS idx_we_win_probability_added_majorLeagueId ON we_win_probability_added(majorLeagueId);
CREATE INDEX IF NOT EXISTS idx_we_win_probability_added_teamId ON we_win_probability_added(teamId);
CREATE INDEX IF NOT EXISTS idx_we_win_probability_added_playerId ON we_win_probability_added(playerId);
