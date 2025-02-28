/*
Q1) 
How do you create an object type with attributes for project number and project name, 
define a collection type to store multiple project objects, and create an object-relational
table that includes a nested table to store multiple projects for each employee along with 
employee details like employee number and employee name?
*/

CREATE TYPE proj_t AS OBJECT (
pno NUMBER(2),
pname VARCHAR(20)
)
/

CREATE TYPE proj_list AS TABLE OF proj_t 
/

CREATE TYPE employee_t AS OBJECT (
eno NUMBER(2),
ename  VARCHAR(15),
projects proj_list 
)
/

CREATE TABLE employee OF employee_t (
eno PRIMARY KEY 
) NESTED TABLE projects STORE AS proj_table 
;

-- Q2)
-- insert an employee along with their associated projects into the employee table

INSERT INTO employee VALUES (employee_t(10,'anne', proj_list(proj_t(1,'Aaaa'), proj_t(2,'Bbb'))));

INSERT INTO employee VALUES (employee_t(11,'Jane', proj_list(proj_t(5,'Cccc'), proj_t(4,'Ddd'))));

INSERT INTO employee VALUES (employee_t(12,'Jhon', proj_list(proj_t(3,'Eeee'), proj_t(6,'Fff'))));

-- Q3)
-- Write a query to retrieve all projects assigned to the employee with eno = 10

SELECT * 
FROM TABLE (SELECT e.projects
            FROM employee e 
            where e.eno = 10)
;

-- Q4)
-- How can you list all employees along with their project details by expanding the nested table?

SELECT e.eno, p.*
FROM employee e, TABLE(e.projects) p
;


-- Q5)
-- How do you add a new project (pno = 7, pname = 'Gggg') to the project list of the employee with eno = 10?
INSERT INTO TABLE( SELECT e. projects
                   FROM employee e
                   where e.eno = 10 )
VALUES (7,'Gggg')
;


-- Q6)
-- How do you add a new project (pno = 7, pname = 'Gggg') to the project list of the employee with eno = 11?

INSERT INTO TABLE( SELECT e. projects
                   FROM employee e
                   where e.eno = 11 )
VALUES (7,'Gggg')
;

-- Q7)
-- How do you update the project name to 'ABab' for the project with pno = 7 in the project list of employee eno = 10?

UPDATE TABLE (SELECT e.projects
              FROM employee e
              where e.eno = 10 ) p
SET p.pname = 'ABab'
WHERE p.pno = 7 
;

-- Q8)
--Write a query to remove the project with pno = 7 from the projects of the employee with eno = 11

DELETE FROM TABLE ( SELECT e. projects
                   FROM employee e
                   where e.eno = 11 ) P
WHERE p.pno = 7
;




