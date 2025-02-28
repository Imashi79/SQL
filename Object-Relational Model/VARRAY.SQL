-- Q1)
/*
Write Oracle OR-SQL statements to develop the following schema:

Define a VARRAY SkillList to store multiple skills for each employee.
Define an object type Employee_t with employee number, name, department, salary, and a VARRAY attribute for skills.
Create an Employee table using this object type.
*/

CREATE TYPE SkillList AS VARRAY(5) OF VARCHAR(20)
 /

CREATE TYPE Employee_t AS OBJECT (
eno NUMBER(4),
ename VARCHAR(15),
edept VARCHAR(15),
salary NUMBER(7,2),
skills SkillList
)
/

CREATE TABLE Employee OF Employee_t (
    eno PRIMARY KEY
)
;

-- Q2)
-- Insert sample data into the Employee table, ensuring that each employee has multiple 
-- skills stored in the VARRAY.

INSERT INTO Employee VALUES (Employee_t(101, 'Alice', 'IT', 75000.00, SkillList('Python', 'SQL', 'Java')));
INSERT INTO Employee VALUES (Employee_t(102, 'Bob', 'Finance', 85000.00, SkillList('Excel', 'SQL')));
INSERT INTO Employee VALUES (Employee_t(103, 'Charlie', 'IT', 90000.00, SkillList('Python', 'ML', 'AI', 'SQL')));
INSERT INTO Employee VALUES (Employee_t(104, 'David', 'HR', 70000.00, SkillList('Communication', 'Recruitment')));
INSERT INTO Employee VALUES (Employee_t(105, 'Eve', 'IT', 72000.00, SkillList('C++', 'Java', 'SQL', 'Python')));

-- Q3)
--Write a query to display each employee’s name and their list of skills

SELECT e.ename, e.skills
FROM Employee e
;


-- Q4)
-- Retrieve the employees who have more than 2 skills listed

SELECT e.eno, e.ename
FROM Employee e, TABLE(e.skills) s  
GROUP BY e.eno, e.ename
HAVING COUNT(*) > 2   
;

-- Q5)
-- Find employees who have ‘Python’ as one of their skills.

SELECT e.eno, e.ename 
FROM Employee e
WHERE 'Python' IN (SELECT COLUMN_VALUE FROM TABLE(e.skills));

-- Q6)
-- Find employees in the IT department who have ‘Machine Learning’ as one of their skills.

SELECT e.eno, e.ename
FROM Employee e 
WHERE 'ML' IN (SELECT COLUMN_VALUE FROM TABLE(e.skills))
AND  e.edept = 'IT'
;

