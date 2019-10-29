/*
NAME: James Stevenson
COURSE: DBMS
ASGN: #6
DESCRIPTION: Queries based upon homework instructions
    See problem numbers for description of each creation/
    insertion/selection
*/

use jstevenson4_DB;

DROP TABLE IF EXISTS Border, City, Province, Country;

-- #1
CREATE TABLE Country (
country_code VARCHAR(256) NOT NULL,
country_name VARCHAR(256) NOT NULL,
gdp BIGINT UNSIGNED,
inflation DOUBLE(4,1),
PRIMARY KEY (country_code)
);

CREATE TABLE Province (
province_name VARCHAR(256) NOT NULL,
country_code VARCHAR(256) NOT NULL,
area INT UNSIGNED,
PRIMARY KEY (province_name, country_code),
FOREIGN KEY (country_code) REFERENCES Country(country_code)
);

CREATE TABLE City (
city_name VARCHAR(256) NOT NULL,
province_name VARCHAR(256) NOT NULL,
country_code VARCHAR(256) NOT NULL,
population INT UNSIGNED,
PRIMARY KEY (city_name, province_name, country_code),
FOREIGN KEY (province_name, country_code) REFERENCES Province(province_name, country_code)
);

CREATE TABLE Border (
country_code_1 VARCHAR(256) NOT NULL,
country_code_2 VARCHAR(256) NOT NULL,
border_length INT UNSIGNED,
PRIMARY KEY (country_code_1, country_code_2),
FOREIGN KEY (country_code_1) REFERENCES Country(country_code),
FOREIGN KEY (country_code_2) REFERENCES Country(country_code)
);

INSERT INTO Country VALUES
 ('A', 'Albania', 3000000000000,  2.5),
 ('B', 'Belgium', 26000000000000, 2),
 ('C', 'Chile', 10000, 10),
 ('D', 'Denmark', 20000, 8);
 
 INSERT INTO Province VALUES
 ('Prov A', 'A', 3000),
 ('Prov B', 'A', 2000),
 ('Prov C', 'B', 10000),
 ('Prov D', 'B', 6000),
 ('Prov E', 'C', 4500),
 ('Prov F', 'D', 7000);
 
 INSERT INTO City VALUES
 ('City A1', 'Prov A', 'A', 2000),
 ('City A2', 'Prov A', 'A', 500),
 ('City B1', 'Prov B', 'A', 600),
 ('City C1', 'Prov C', 'B', 5000),
 ('City C2', 'Prov C', 'B', 5000),
 ('City D1', 'Prov D', 'B', 200),
 ('City E1', 'Prov E', 'C', 300),
 ('City E2', 'Prov E', 'C', 4000),
 ('City E3', 'Prov E', 'C', 7500),
 ('City F1', 'Prov F', 'D', 800);

INSERT INTO Border VALUES
('C', 'B', 1700),
('C', 'A', 2000),
('B', 'A', 1000);

-- #2
SET @inflation = 3;
SET @gdp = 2 * 10^12;
SET @area = 8000;

SELECT DISTINCT c.country_name, c.country_code, c.gdp, c.inflation
FROM Country c, Province p
WHERE p.area < @area
AND c.gdp > @gdp
AND c.inflation < @inflation
AND p.country_code = c.country_code;

-- #3
SELECT DISTINCT country_name, Country.country_code, gdp, inflation
FROM Country
JOIN Province ON Country.country_code = Province.country_code
WHERE area < @area
AND gdp > @gdp
AND inflation < @inflation;

-- #4
SET @population = 1000;

SELECT p.country_code, country_name, ci.province_name, city_name, population, area
FROM Country co, Province p, City ci
WHERE ci.population > @population
AND ci.province_name = p.province_name
AND p.country_code = co.country_code;

-- #5
SELECT p.country_code, country_name, ci.province_name, city_name, population, area
FROM Country co
JOIN Province p ON co.country_code = p.country_code
JOIN City ci ON p.province_name = ci.province_name
WHERE ci.population > @population;

-- #6
SET @upperGDP = 40000000000000;
SET @lowerGDP = 100000;

SELECT p.province_name
FROM Province p
JOIN Country c ON p.country_code = c.country_code
WHERE c.gdp < @upperGDP
AND c.gdp > @lowerGDP;

-- #7
SELECT MAX(gdp), MIN(gdp), AVG(gdp), MAX(inflation), MIN(inflation), AVG(inflation)
FROM Country;

-- #8
SET @country_code = 'B';

SELECT COUNT(city_name), AVG (population)
FROM City ci
JOIN Province p ON ci.province_name = p.province_name
JOIN Country c ON p.country_code = c.country_code
WHERE c.country_code = @country_code;

-- #9
SET @city_name = 'City E1';

SELECT AVG(ci2.population)
FROM City ci1, City ci2, Province p, Country c
WHERE ci1.province_name = p.province_name
AND p.country_code = c.country_code
AND ci1.city_name = @city_name
AND ci1.city_name != ci2.city_name
AND ci2.province_name = p.province_name
AND ci2.country_code = c.country_code;

-- #11
SET @country_code = 'C';

SELECT COUNT(country_code_2), AVG(border_length)
FROM Border b, Country c
WHERE c.country_code = @country_code
AND b.country_code_1 = c.country_code;

-- #12
SELECT DISTINCT c1.country_code
FROM Border b, Country c1, Country c2
WHERE b.country_code_1 = c1.country_code
AND b.country_code_2 = c2.country_code
AND c1.gdp < c2.gdp
AND c1.inflation > c2.inflation
UNION
SELECT DISTINCT c1.country_code
FROM Border b, Country c1, Country c2
WHERE b.country_code_2 = c1.country_code
AND b.country_code_1 = c2.country_code
AND c1.gdp < c2.gdp
AND c1.inflation > c2.inflation;