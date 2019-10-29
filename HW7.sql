/*
NAME: James Stevenson
COURSE: DBMS
ASGN: #7
DESCRIPTION: Queries based upon homework instructions
	Specifically working with views, prepared statements,
    joins and group by statements
*/

use jstevenson4_DB;

DROP TABLE IF EXISTS Border, City, Province, Country;
DROP VIEW IF EXISTS sym_borders;

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
 ('C', 'Chile', 100000000000, 10),
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
 ('City C3', 'Prov C', 'B', 6000),
 ('City D1', 'Prov D', 'B', 200),
 ('City E1', 'Prov E', 'C', 300),
 ('City E2', 'Prov E', 'C', 40000000),
 ('City E3', 'Prov E', 'C', 7500),
 ('City E4', 'Prov E', 'C', 800),
 ('City F1', 'Prov F', 'D', 800000000);

INSERT INTO Border VALUES
('C', 'B', 1700),
('C', 'A', 2000),
('B', 'A', 1000),
('D', 'A', 5000),
('D', 'B', 2700);

-- #1
SELECT co.country_code, co.country_name, co.gdp, co.inflation, SUM(population)
FROM Country co
JOIN City ci ON co.country_code = ci.country_code
GROUP BY (country_code);

-- #2
SET @population = 5000000;

SELECT p.province_name, p.country_code, p.area, SUM(population)
FROM Province p
JOIN City c ON p.province_name = c.province_name
GROUP BY (province_name)
HAVING SUM(population) > @population;

-- #3
SELECT co.country_code, co.country_name, COUNT(city_name)
FROM Country co
JOIN City ci ON co.country_code = ci.country_code
GROUP BY (country_code)
ORDER BY COUNT(city_name) DESC;

-- #4
SELECT c.country_code, c.country_name, SUM(area)
FROM Country c
JOIN Province p ON p.country_code = c.country_code
GROUP BY (country_code)
ORDER BY SUM(area) DESC;

-- #5
SET @city_num = 3;

SELECT co.country_name
FROM Country co
JOIN Province p ON co.country_code = p.country_code
JOIN City ci ON ci.province_name = p.province_name
GROUP BY (ci.province_name)
HAVING COUNT(city_name) >= @city_num;

-- #6
SET @area = 6000;
SET @gdp = 100000;

SELECT co.country_code, co.gdp, SUM(area), COUNT(city_name)
FROM Country co
JOIN Province p ON co.country_code = p.country_code
JOIN City ci ON ci.province_name = p.province_name
WHERE co.gdp > @gdp
GROUP BY (p.province_name)
HAVING SUM(area) > @area
ORDER BY COUNT(city_name) DESC, co.gdp DESC;

-- #7
CREATE VIEW sym_borders AS
SELECT country_code_1, country_code_2, border_length
FROM Border
UNION
SELECT country_code_2, country_code_1, border_length
FROM Border;

-- #8
SELECT DISTINCT c1.country_code
FROM sym_borders s, Country c1, Country c2
WHERE s.country_code_1 = c1.country_code
AND s.country_code_2 = c2.country_code
AND c1.gdp < c2.gdp
AND c1.inflation > c2.inflation;

-- #9
SELECT DISTINCT s.country_code_2, AVG (c.gdp), AVG (c.inflation)
FROM sym_borders s
JOIN Country c ON s.country_code_1 = c.country_code
GROUP BY (country_code_2)
ORDER BY AVG (c.gdp); 

-- #10
-- Provinces and total area of provinces with total area greater than argument amount
PREPARE stmt1 FROM 
    'SELECT p.province_name, SUM(population)
    FROM Province p
    JOIN City c ON c.province_name = p.province_name
    GROUP BY (c.province_name)
    HAVING SUM(c.population) > ?';

-- Country bordering a number of countries greater than or equal to the argument
PREPARE stmt2 FROM 
	'SELECT country_code_1
    FROM sym_borders
    GROUP BY (country_code_1)
    HAVING Count(country_code_1) >= ?';

-- Testing prepared statement 1
EXECUTE stmt1 USING 1000;
EXECUTE stmt1 USING 16000;

-- Testing prepared statement 2
EXECUTE stmt2 USING 1;
EXECUTE stmt2 USING 3;