/*
NAME: James Stevenson
COURSE: DBMS
ASGN: #5
DESCRIPTION: Queries based upon homework instructions
    with insertions to return at least two results for
    each query
*/

USE jstevenson4_DB;

-- create band(band_name, start_year)
CREATE OR REPLACE TABLE band (
    band_name VARCHAR(256) NOT NULL,
    start_year INT UNSIGNED,
    PRIMARY KEY (band_name)
);

-- create artist(first_name, last_name, birth_year)
CREATE OR REPLACE TABLE artist (
    first_name VARCHAR(256) NOT NULL,
    last_name VARCHAR(256) NOT NULL,
    birth_year INT UNSIGNED,
    PRIMARY KEY (first_name, last_name)
);

-- create performs_with(band_name, first_name, last_name, year_joined, year_left)
CREATE OR REPLACE TABLE performs_with (
    band_name VARCHAR(256) NOT NULL,
    first_name VARCHAR(256) NOT NULL,
    last_name VARCHAR(256) NOT NULL,
    year_joined INT UNSIGNED NOT NULL,
    year_left INT UNSIGNED NOT NULL,
    PRIMARY KEY (band_name, first_name, last_name, year_joined),
    FOREIGN KEY (band_name) REFERENCES band (band_name),
    FOREIGN KEY (first_name, last_name) REFERENCES artist (first_name, last_name)
);

-- create label(label_name, label_type, founded_year)
CREATE OR REPLACE TABLE label (
    label_name VARCHAR(256) NOT NULL,
    label_type VARCHAR(256),
    founded_year INT UNSIGNED,
    PRIMARY KEY (label_name)
);

-- create album(album_name, band_name, label_name, recorded_year)
CREATE OR REPLACE TABLE album (
    album_name VARCHAR(256) NOT NULL,
    band_name VARCHAR(256) NOT NULL,
    label_name VARCHAR(256),
    recorded_year INT UNSIGNED,
    PRIMARY KEY (album_name, band_name),
    FOREIGN KEY (label_name) REFERENCES label (label_name)
);

-- create song(song_name, album_name, band_name)
CREATE OR REPLACE TABLE song (
    song_name VARCHAR(256) NOT NULL,
    album_name VARCHAR(256) NOT NULL,
    band_name VARCHAR(256) NOT NULL,
    PRIMARY KEY (song_name, album_name, band_name),
    FOREIGN KEY (album_name) REFERENCES album (album_name),
    FOREIGN KEY (band_name) REFERENCES band (band_name)
);

-- create genre(genre_name)
CREATE OR REPLACE TABLE genre (
    genre_name VARCHAR(256) NOT NULL,
    PRIMARY KEY (genre_name)
);

--create band_genres(band_name, genre_name)
CREATE OR REPLACE TABLE band_genres (
    band_name VARCHAR(256) NOT NULL,
    genre_name VARCHAR(256) NOT NULL,
    PRIMARY KEY (band_name, genre_name),
    FOREIGN KEY (band_name) REFERENCES band (band_name),
    FOREIGN KEY (genre_name) REFERENCES genre (genre_name)
);

--create influence(influencer_band, influenced_band)
CREATE OR REPLACE TABLE influence (
    influencer_band VARCHAR(256) NOT NULL,
    influenced_band VARCHAR(256) NOT NULL,
    PRIMARY KEY (influencer_band, influenced_band),
    FOREIGN KEY (influencer_band) REFERENCES band (band_name),
    FOREIGN KEY (influenced_band) REFERENCES band (band_name)
);

-- Fill tables to test edge cases
INSERT INTO band VALUES 
('KISS', 1976), 
('The Beatles', 1962), 
('Elvis Presley', 1954), 
('Example Band', 1962);

INSERT INTO artist VALUES 
('Paul', 'Stanley', 1952), 
('Paul', 'McCartney', 1942), 
('Elvis', 'Presley', 1935), 
('Elvis', 'Jones', 1970), 
('Example', 'Person', 2000);

INSERT INTO performs_with VALUES 
('KISS', 'Paul', 'Stanley', 1976, 2019), 
('The Beatles', 'Paul', 'McCartney', 1962, 2019), 
('Elvis Presley', 'Elvis', 'Presley', 1954, 1972), 
('Example Band', 'Elvis', 'Jones', 1970, 2000), 
('Example Band', 'Example', 'Person', 1970, 2000),
('Example Band', 'Elvis', 'Jones', 2010, 2019);

INSERT INTO label VALUES 
('Label A', 'Blues', 1800), 
('Label B', 'Greens', 1800), 
('Label C', 'Reds', 1900);

INSERT INTO album VALUES 
('KISS', 'KISS', 'Label A', 1976),
('White Album', 'The Beatles', 'Label B', 1968),
('Moody Blue', 'Elvis Presley', 'Label C', 1960),
('Example Album', 'Example Band', 'Label A', 1990),
('KISS Pt. 2', 'KISS', 'Label A', 1990);

INSERT INTO song VALUES
('All Night Long', 'KISS', 'KISS'),
('Yellow Sumarine', 'White Album', 'The Beatles'),
('Jailhouse Rock', 'Moody Blue', 'Elvis Presley'),
('examplesong1', 'Example Album', 'Example Band'),
('examplesong2', 'Example Album', 'Example Band');

INSERT INTO genre VALUES
('blues'),
('jazz'),
('rock');

INSERT INTO band_genres VALUES
('KISS', 'blues'),
('KISS', 'rock'),
('The Beatles', 'rock'),
('Elvis Presley', 'blues'),
('Example Band', 'jazz');

INSERT INTO influence VALUES
('Elvis Presley', 'KISS'),
('Example Band', 'The Beatles'),
('Elvis Presley', 'The Beatles');

INSERT INTO album VALUES 
('KISS Pt. 2', 'KISS', 'Label A', 1990),
('Unplugged', 'Eric Clapton', 'Label C', 1992);

INSERT INTO label VALUES 
('Label D', 'Blues', 1982),
('Label E', 'Greens', 1982),
('Label F', 'Reds', 1900);

INSERT INTO band VALUES
('Eric Clapton', 1962);

INSERT INTO artist VALUES
('Ringo', 'Starr', 1940),
('Person', 'A', 1950),
('Person', 'B', 1942),
('Eric', 'Clapton', 1945);

INSERT INTO performs_with VALUES
('The Beatles', 'Ringo', 'Starr', 1962, 2019),
('The Beatles', 'Person', 'A', 1970, 1971),
('KISS', 'Person', 'B', 1972, 1973),
('Example Band', 'Person', 'A', 1973, 2019),
('Example Band', 'Person', 'B', 1975, 2019),
('Eric Clapton', 'Eric', 'Clapton', 1962, 2019);

INSERT INTO band_genres VALUES
('KISS', 'jazz'),
('The Beatles', 'blues'),
('The Beatles', 'jazz');

INSERT INTO song VALUES
('Jailhouse Rock', 'White Album', 'The Beatles'),
('Jailhouse Rock', 'KISS', 'KISS');

-- #1
SELECT album_name
FROM album
WHERE recorded_year = 1990;

-- #2
SELECT label_name
FROM label
WHERE label_type = 'Reds' and founded_year = 1900;

-- #3
SELECT label_name
FROM label
WHERE label_type IN ('Blues', 'GREENS') AND founded_year BETWEEN 1980 AND 1989;

-- #4
SELECT DISTINCT first_name, last_name
FROM performs_with
WHERE band_name = 'Example Band';

-- #5
SELECT DISTINCT p1.first_name, p1.last_name
FROM performs_with p1, performs_with p2
WHERE p1.first_name = p2.first_name
AND p1.last_name = p2.last_name
AND p1.band_name != p2.band_name;
/*
SELECT first_name, last_name
FROM performs_with
GROUP BY first_name, last_name
HAVING COUNT(DISTINCT band_name) > 1;
*/

-- #6
SELECT DISTINCT bg1.band_name, b.start_year 
FROM band_genres bg1, band_genres bg2, band_genres bg3, band b
WHERE bg1.band_name = bg2.band_name 
AND bg2.band_name = bg3.band_name 
AND bg3.band_name = b.band_name
AND bg1.genre_name != bg2.genre_name 
AND bg1.genre_name != bg3.genre_name 
AND bg2.genre_name != bg3.genre_name;
/*
SELECT band_name, start_year
FROM band
NATURAL JOIN band_genres
GROUP BY band_name
HAVING count(genre_name) > 2;
*/

-- #7
SELECT influenced_band
FROM influence
WHERE influencer_band = 'Elvis Presley';

-- #8
SELECT album_name
FROM album
NATURAL JOIN performs_with
WHERE CONCAT(first_name, ' ', last_name) = band_name 
AND recorded_year BETWEEN 1900 AND 2000;
    
-- #9
SELECT DISTINCT p1.first_name, p1.last_name, p1.band_name
FROM performs_with p1, band_genres bg1, band_genres bg2 
WHERE p1.band_name = bg1.band_name 
AND p1.band_name = bg2.band_name 
AND bg1.genre_name != bg2.genre_name
AND year_joined > 1960
AND year_left > 2010 OR year_left IS NULL;
/*
SELECT first_name, last_name, band_name
FROM performs_with
NATURAL JOIN band_genres
WHERE band_name IN ('The Beatles', 'KISS') 
AND year_joined > 1960 
AND year_left = 2019
GROUP BY band_name, first_name, last_name
HAVING count(genre_name) > 2;
*/

-- #10
SELECT s1.song_name, s1.band_name, s2.band_name
FROM song s1, song s2, influence
WHERE s1.song_name = s2.song_name
AND s1.band_name != s2.band_name
AND s1.band_name = influence.influenced_band
AND s2.band_name = influence.influencer_band;

-- #11
/* 
Return all albums recorded more than 10 years after the founding of the band
with a band name start with the letter 'E'
*/

SELECT album.album_name
FROM album, band 
WHERE album.band_name = band.band_name
AND album.recorded_year - band.start_year > 10
AND band.band_name LIKE 'e%';