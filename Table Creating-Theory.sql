--creating table--
create table Student(
   ID int PRIMARY KEY,
   StudentName varchar(50) Not Null,
   NIC char(12) unique,
   Grade varchar(10),

);
 -- insert nsert sample data into Student table --
 INSERT INTO Student values (100,'Amal Gunathilaka','200569301894','10');
 INSERT INTO Student (ID,StudentName, NIC, Grade) values (1002,'Nimal Athanayake', '200514204785','10');

 --display Table--
 select * 
 From Student

 --Adding a new column to a table
 ALTER TABLE Student ADD Age int

 --Removing a Column from a table
ALTER TABLE Student DROP column Age 