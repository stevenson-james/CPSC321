/*
NAME: James Stevenson
COURSE: DBMS
ASGN: #10
DESCRIPTION: Create table for asgn 10
*/

use jstevenson4_DB;

CREATE OR REPLACE TABLE Employee (
employee_id INT NOT NULL,
salary INT,
title VARCHAR(256),
PRIMARY KEY (employee_id)
);

CREATE INDEX idx_salary
ON Employee (salary);