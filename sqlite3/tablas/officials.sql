DROP TABLE IF EXISTS officials; 

CREATE TABLE officials (
officialId INTEGER,
firstName TEXT,
lastName TEXT,
birthDate TEXT,
birthCity TEXT,
birthStateProvince TEXT,
birthCountry TEXT
);

CREATE INDEX officialId_officials ON officials(officialId);