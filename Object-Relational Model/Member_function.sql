/* 
Object types: 
Depend_t (depname: varchar2(12), gender: char(1), bdate: date, relationship:varchar2(10)) 
Dependtb_t table of Depend_t 
Emp_t (eno: number(4), ename: varchar2(15), edept: ref dept_t, salary: number(8,2),  
dependents: dependtb_t) 
Dept_t (dno: number(2), dname: varchar2(12), mgr ref emp_t) 
Proj_t (pno: number(4), pname: varchar2(15), pdept ref dept_t, budget: number(10,2)) 
Work_t (wemp: ref emp_t, wproj: ref proj_t, since: date, hours: number(4,2)) 

Tables: 
Emp of Emp_t (eno primary key, edept references dept, nested table dependents store as dependent_tb) 
Dept of Dept_t (dno primary key, mgr references emp) 
Proj of Proj_t (pno primary key, pdept references dept) 
Works of Works_t (wemp references emp, wproj references proj) 

The Emp, Dept, and Proj tables contain tuples for all employees, departments and projects respectively. The 
attributes of Emp are employee number (eno), name (ename), employee’s department (edept), salary and the 
set of dependents stored as a nested table. The relationship attribute may have only ‘SPOUSE’ or ‘CHILD’ as 
values, gender may be ‘M’ or ‘F’, and bdate records the birth date of the dependant. Attributes of Dept are 
department number (dno), department name (dname), manager (mgr). Attributes of Proj are project number 
(pno), project name (pname), department in charge (pdept) and budget. Works table contains tuples to 
indicate the assignment of employees to projects, the date on which the employee was assigned, and hours per 
week.
*/

CREATE TYPE Depend_t AS OBJECT (
depname VARCHAR2(12),
gender CHAR(1),
bdate DATE,
relationship VARCHAR2(10)
)
/

CREATE TYPE Dependtb_t AS TABLE OF Depend_t
/

CREATE TYPE Dept_t 
/

CREATE TYPE Emp_t AS OBJECT(
 eno NUMBER(4),
 ename VARCHAR2(15),
 edept REF Dept_t,
 salary NUMBER(8,2),
 dependents Dependtb_t
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

CREATE TYPE Work_t AS OBJECT (
wemp REF Emp_t,
wproj REF Proj_t,
since DATE,
hours NUMBER(4,2)
)
/

CREATE TABLE Dept OF Dept_t (
 dno PRIMARY KEY
 );

CREATE TABLE Emp OF Emp_t (
 eno PRIMARY KEY,
 constraint emp_fk foreign key (edept) references Dept
)NESTED TABLE dependents STORE AS dependent_tb
;

ALTER TABLE Dept
ADD CONSTRAINT fk_mgr FOREIGN KEY (mgr) REFERENCES Emp;

CREATE TABLE Proj OF Proj_t (
 pno PRIMARY KEY,
 CONSTRAINT proj_fk FOREIGN KEY (pdept) references Dept
);

CREATE TABLE Works OF Work_t (
CONSTRAINT Worke_fk FOREIGN KEY (wemp) references Emp,
CONSTRAINT Workp_fk FOREIGN KEY (wproj) references Proj
)
;


INSERT INTO Dept VALUES (Dept_t(10, 'HR', NULL));
INSERT INTO Dept VALUES (Dept_t(20, 'Finance', NULL));
INSERT INTO Dept VALUES (Dept_t(30, 'IT', NULL));
INSERT INTO Dept VALUES (Dept_t(40, 'Marketing', NULL));
INSERT INTO Dept VALUES (Dept_t(50, 'Data Mining', NULL));

INSERT INTO Emp VALUES (Emp_t(101, 'Alice', (SELECT REF(d) FROM Dept d WHERE d.dno = 10), 75000.00,
    Dependtb_t(Depend_t('Anne', 'F', '02-FEB-2005','CHILD'))));

INSERT INTO Emp VALUES (Emp_t(102, 'Bob', (SELECT REF(d) FROM Dept d WHERE d.dno = 20), 68000.00, 
    Dependtb_t(Depend_t('Emma', 'F', '18-AUG-1985', 'SPOUSE'), 
               Depend_t('Mike', 'M', '15-MAR-2010', 'CHILD'))));

INSERT INTO Emp VALUES (Emp_t(103, 'Charlie', (SELECT REF(d) FROM Dept d WHERE d.dno = 30), 72000.00, 
    Dependtb_t(Depend_t('Sophia', 'F', '05-JUL-2014', 'CHILD'))));

INSERT INTO Emp VALUES (Emp_t(104, 'Diana', (SELECT REF(d) FROM Dept d WHERE d.dno = 40), 80000.00, 
    Dependtb_t(Depend_t('Lucas', 'M', '10-NOV-2016', 'CHILD'), 
               Depend_t('Oliver', 'M', '08-MAY-1983', 'SPOUSE'), 
               Depend_t('James', 'M', '22-DEC-2018', 'CHILD'))));

INSERT INTO Emp VALUES (Emp_t(105, 'Ethan', (SELECT REF(d) FROM Dept d WHERE d.dno = 50), 65000.00, 
    Dependtb_t(Depend_t('Liam', 'M', '03-SEP-2018', 'CHILD'), 
               Depend_t('Sophia', 'F', '25-JUN-1987', 'SPOUSE'))));

INSERT INTO Emp VALUES (Emp_t(106, 'Fiona', (SELECT REF(d) FROM Dept d WHERE d.dno = 30), 71000.00, 
    Dependtb_t(Depend_t('William', 'M', '17-JAN-2012', 'CHILD'), 
               Depend_t('Ella', 'F', '25-OCT-2015', 'CHILD'))));

INSERT INTO Emp VALUES (Emp_t(107, 'George', (SELECT REF(d) FROM Dept d WHERE d.dno = 20), 69000.00, 
    Dependtb_t(Depend_t('Ava', 'F', '30-JUN-2011', 'CHILD'), 
               Depend_t('Mia', 'F', '12-APR-1989', 'SPOUSE'))));

INSERT INTO Emp VALUES (Emp_t(108, 'Hannah', (SELECT REF(d) FROM Dept d WHERE d.dno = 10), 73000.00, 
    Dependtb_t(Depend_t('Daniel', 'M', '22-JUL-2019', 'CHILD'), 
               Depend_t('Jake', 'M', '05-AUG-2016', 'CHILD'), 
               Depend_t('Olivia', 'F', '20-OCT-1990', 'SPOUSE'))));

INSERT INTO Emp VALUES (Emp_t(2143, 'Jhone', (SELECT REF(d) FROM Dept d WHERE d.dno = 10), 73000.00, 
    Dependtb_t()));


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
INSERT INTO Proj VALUES (Proj_t(1006, 'Cloud', (SELECT REF(d) FROM Dept d WHERE d.dno = 30), 450000.00));
INSERT INTO Proj VALUES (Proj_t(1007, 'E-Commerce', (SELECT REF(d) FROM Dept d WHERE d.dno = 20), 350000.00));
INSERT INTO Proj VALUES (Proj_t(1008, 'Cybersecurity', (SELECT REF(d) FROM Dept d WHERE d.dno = 50), 280000.00));
INSERT INTO Proj VALUES (Proj_t(1009, 'CRM System', (SELECT REF(d) FROM Dept d WHERE d.dno = 10), 220000.00));

INSERT INTO Works VALUES ((SELECT REF(e) FROM Emp e WHERE e.eno = 101), 
                          (SELECT REF(p) FROM Proj p WHERE p.pno = 1004), 
                          '10-JAN-2013', 40.0);

INSERT INTO Works VALUES ((SELECT REF(e) FROM Emp e WHERE e.eno = 102), 
                          (SELECT REF(p) FROM Proj p WHERE p.pno = 1002), 
                          '15-FEB-2014', 35.5);

INSERT INTO Works VALUES ((SELECT REF(e) FROM Emp e WHERE e.eno = 103), 
                          (SELECT REF(p) FROM Proj p WHERE p.pno = 1001), 
                          '20-MAR-2015', 38.0);

INSERT INTO Works VALUES ((SELECT REF(e) FROM Emp e WHERE e.eno = 104), 
                          (SELECT REF(p) FROM Proj p WHERE p.pno = 1005), 
                          '25-APR-2016', 42.5);

INSERT INTO Works VALUES ((SELECT REF(e) FROM Emp e WHERE e.eno = 105), 
                          (SELECT REF(p) FROM Proj p WHERE p.pno = 1003), 
                          '05-MAY-2017', 30.0);

INSERT INTO Works VALUES ((SELECT REF(e) FROM Emp e WHERE e.eno = 106), 
                          (SELECT REF(p) FROM Proj p WHERE p.pno = 1006), 
                          '12-JUN-2018', 45.0);

INSERT INTO Works VALUES ((SELECT REF(e) FROM Emp e WHERE e.eno = 107), 
                          (SELECT REF(p) FROM Proj p WHERE p.pno = 1007), 
                          '18-JUL-2019', 36.0);

INSERT INTO Works VALUES ((SELECT REF(e) FROM Emp e WHERE e.eno = 108), 
                          (SELECT REF(p) FROM Proj p WHERE p.pno = 1009), 
                          '22-AUG-2020', 40.0);

INSERT INTO Works VALUES ((SELECT REF(e) FROM Emp e WHERE e.eno = 101), 
                          (SELECT REF(p) FROM Proj p WHERE p.pno = 1008), 
                         '30-SEP-2021', 33.0);

INSERT INTO Works VALUES ((SELECT REF(e) FROM Emp e WHERE e.eno = 103), 
                          (SELECT REF(p) FROM Proj p WHERE p.pno = 1006), 
                          '08-OCT-2022', 41.5);





/*
(a) Add a member method to compute the child allowance payable to employees with dependent children. The 
allowance is calculated at the rate of 5% of salary for each dependent child. Write Oracle SQL statements to 
modify the object type emp_t.
*/ 
ALTER TYPE Emp_t
ADD MEMBER FUNCTION child_allowance(rate IN FLOAT)
RETURN FLOAT CASCADE
;

CREATE OR REPLACE TYPE BODY Emp_t
MEMBER FUNCTION child_allowance(rate IN FLOAT)
RETURN FLOAT IS
   child_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO child_count
  FROM TABLE(SELF.dependents) d 
  WHERE d.relationship = 'CHILD';
  
  RETURN child_count * rate * SELF.salary ;
END child_allowance;
END;
/

/*
(b) Using the method defined above, write an Oracle SQL statement to display the employee name, salary and 
the child allowance payable for all eligible employees.
*/
SELECT 
    e.ename, e.salary, e.child_allowance(0.05) AS child_allowance
FROM Emp e;

/*
(c) Write an SQL statement to insert a dependent child for the employee whose eno is 2143. The name of the 
child is Jeremy, gender ‘M’, and the date of birth 12 March 2001. 
*/
INSERT INTO TABLE( SELECT e.dependents
                   FROM Emp e 
                   WHERE e.eno = 2143)
VALUES (Depend_t('Jeremy', 'M', '12-MAR-2001', 'CHILD'));

/*
(d) Assuming the same object relational schema as above, write a method to compute the bonus amount of 
employees, assuming that it is to be calculated by multiplying the salary with a rate percentage given as a 
parameter
*/
ALTER TYPE Emp_t
ADD MEMBER FUNCTION bonus(rate IN FLOAT)
RETURN FLOAT CASCADE
;

CREATE OR REPLACE TYPE BODY Emp_t AS
MEMBER FUNCTION child_allowance(rate IN FLOAT)
RETURN FLOAT IS
   child_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO child_count
  FROM TABLE(SELF.dependents) d 
  WHERE d.relationship = 'CHILD';
  
  RETURN child_count * rate * SELF.salary ;
END child_allowance;

MEMBER FUNCTION bonus(rate IN FLOAT)
RETURN FLOAT IS
BEGIN  
  RETURN  rate * SELF.salary;
END bonus;

END;
/

/* 
(e)All employees in the department named ‘Data Mining’ are to be given a bonus at the rate of 12%. Write an 
SQL statement to display the name of each eligible employee and the bonus, using the method for computing 
bonus that was declared above.
*/

SELECT 
  e.eno, e.ename, e.bonus(.12) AS Bonus
FROM Emp e
WHERE e.edept.dname = 'Data Mining' ;



drop table Works;
drop table Proj ;
drop table Emp cascade constraint;
drop table Dept cascade constraint;

drop type body Emp_t;
drop type Emp_t force ;
drop type Proj_t force ;
drop type Dept_t force ;
drop type Works_t force;


