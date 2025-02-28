/* 
Object Relational Model 
Consider the following object relational database schema: 

Object types: 
Emp_t (eno: number(4), ename: varchar2(15), edept: ref dept_t, salary: number(8,2)) 
Dept_t (dno: number(2), dname: varchar2(12), mgr ref emp_t) 
Proj_t (pno: number(4), pname: varchar2(15), pdept ref dept_t, budget: number(10,2)) 

Tables: 
Emp of Emp_t (eno primary key, edept references dept) 
Dept of Dept_t (dno primary key, mgr references emp) 
Proj of Proj_t (pno primary key, pdept references dept) 

The Emp, Dept, and Proj tables contain tuples for all employees, departments and projects 
respectively. The attributes of Emp are employee number (eno), name (ename), employee’s 
department (edept) and salary. Attributes of Dept are department number (dno), department name 
(dname), manager (mgr).Attributes of Proj are project number (pno), project name (pname), 
department in charge (pdept) and budget. 

*/

-- a
--  Write Oracle OR-SQL statements to develop the above database schema.

CREATE TYPE Dept_t 
/

CREATE TYPE Emp_t AS OBJECT(
 eno NUMBER(4),
 ename VARCHAR2(15),
 edept REF Dept_t,
 salary NUMBER(8,2)
)
/

CREATE TYPE Dept_t AS OBJECT(
 dno NUMBER(2),
 dname VARCHAR2(12),
 mgr REF Emp_t 
)
/

CREATE TYPE Proj_t AS OBJECT(
 pno NUMBER(4),
 pname VARCHAR2(12),
 pdept REF Dept_t,
 budget NUMBER(10,2)
)
/


CREATE TABLE Dept OF Dept_t (
 dno PRIMARY KEY
 );

CREATE TABLE Emp OF Emp_t (
 eno PRIMARY KEY,
 constraint emp_fk foreign key (edept) references Dept
);

ALTER TABLE Dept
ADD CONSTRAINT fk_mgr FOREIGN KEY (mgr) REFERENCES Emp;


CREATE TABLE Proj OF Proj_t (
 pno PRIMARY KEY,
 constraint proj_fk foreign key (pdept) references Dept
);

-- b
-- Insert sample data to Emp, Dept and Proj tables in the above schema.

INSERT INTO Dept VALUES (Dept_t(10, 'HR', NULL));
INSERT INTO Dept VALUES (Dept_t(20, 'Finance', NULL));
INSERT INTO Dept VALUES (Dept_t(30, 'IT', NULL));
INSERT INTO Dept VALUES (Dept_t(40, 'Sales', NULL));
INSERT INTO Dept VALUES (Dept_t(50, 'Marketing', NULL));

INSERT INTO Emp VALUES (Emp_t(101, 'Alice', (SELECT REF(d) FROM Dept d WHERE d.dno = 10), 75000.00));
INSERT INTO Emp VALUES (Emp_t(102, 'Bob', (SELECT REF(d) FROM Dept d WHERE d.dno = 20), 85000.00));
INSERT INTO Emp VALUES (Emp_t(103, 'Charlie', (SELECT REF(d) FROM Dept d WHERE d.dno = 30), 90000.00));
INSERT INTO Emp VALUES (Emp_t(104, 'David', (SELECT REF(d) FROM Dept d WHERE d.dno = 40), 70000.00));
INSERT INTO Emp VALUES (Emp_t(105, 'Eve', (SELECT REF(d) FROM Dept d WHERE d.dno = 50), 72000.00));

UPDATE Dept d SET d.mgr = (SELECT REF(e) FROM Emp e WHERE e.eno = 101) WHERE d.dno = 10;
UPDATE Dept d SET d.mgr = (SELECT REF(e) FROM Emp e WHERE e.eno = 102) WHERE d.dno = 20;
UPDATE Dept d SET d.mgr = (SELECT REF(e) FROM Emp e WHERE e.eno = 103) WHERE d.dno = 30;
UPDATE Dept d SET d.mgr = (SELECT REF(e) FROM Emp e WHERE e.eno = 104) WHERE d.dno = 40;
UPDATE Dept d SET d.mgr = (SELECT REF(e) FROM Emp e WHERE e.eno = 105) WHERE d.dno = 50;

INSERT INTO Proj VALUES (Proj_t(1001, 'AI System', (SELECT REF(d) FROM Dept d WHERE d.dno = 30), 500000.00));
INSERT INTO Proj VALUES (Proj_t(1002, 'ERP Upgrade', (SELECT REF(d) FROM Dept d WHERE d.dno = 20), 300000.00));
INSERT INTO Proj VALUES (Proj_t(1003, 'Marketing', (SELECT REF(d) FROM Dept d WHERE d.dno = 50), 200000.00));
INSERT INTO Proj VALUES (Proj_t(1004, 'HRMS Dev', (SELECT REF(d) FROM Dept d WHERE d.dno = 10), 150000.00));
INSERT INTO Proj VALUES (Proj_t(1005, 'SalesA', (SELECT REF(d) FROM Dept d WHERE d.dno = 40), 180000.00));


-- c
-- Find the name and salary of managers of all departments. Display the department number, manager name and salary.

select d.dno , d.mgr.ename AS manager, d.mgr.salary AS salary
from Dept d ;


-- d
-- For projects that have budgets over $50000, get the project name, and the name of the manager of the department in charge of the project.

select p.pname As Project_Name, p.pdept.mgr.ename As Manager
from Proj p
where p.budget > 50000 ;


-- e
-- For departments that are in charge of projects, find the department number, department name and total budget of all its projects together

select p.pdept.dno AS Dept_No, p.pdept.dname AS Dept_Name, sum(p.budget) AS total_budget
from Proj p
group by p.pdept.dno, p.pdept.dname ;


--f
-- Find the manager’s name who is controlling the project with the largest budget

SELECT p.pdept.mgr.ename AS manager_name
FROM Proj p
WHERE p.budget = (SELECT MAX(p2.budget) FROM Proj p2);


--g
/* Find the managers who control budget above $60,000. (Hint: The total amount a manager control 
is the sum of budgets of all projects belonging to the dept(s) for which the he/she is managing). Print 
the manager’s employee number and the total controlling budget. 
*/

select p.pdept.mgr.eno As employee_number, sum(p.budget) As total_budget
from Proj p
group by p.pdept.mgr.eno
having sum(p.budget)> 60000;


--h
-- Find the manager who controls the largest amount. Print the manager’s employee number and the 
-- total controlling budget.

SELECT p.pdept.mgr.eno AS manager_eno, sum(p.budget) AS Total_budget
FROM Proj p
group by p.pdept.mgr.eno
having sum(p.budget) = (SELECT MAX(total_budget)
                        FROM (SELECT SUM(p2.budget) AS total_budget
                              FROM Proj p2
                              GROUP BY p2.pdept.mgr.eno)
    )
;





