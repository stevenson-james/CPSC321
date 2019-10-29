/* 
    Author: James Stevenson
    Filename: hw4.sql  
    Class: CPSC 321 
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

-- output newly created tables
SELECT * FROM band;
SELECT * FROM artist;
SELECT * FROM performs_with;
SELECT * FROM label;
SELECT * FROM album;
SELECT * FROM song;
SELECT * FROM genre;
SELECT * FROM band_genres;
SELECT * FROM influence;