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