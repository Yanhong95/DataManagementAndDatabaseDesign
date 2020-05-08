
/*     3rd Last Digit 0 or 5      */

/*     Your NUID:          */


---------  Question 1 (2 points)  --------------------


/* Rewrite the following query to present the same data in the format
   listed below using the SQL PIVOT command. */

SELECT TerritoryID, year(OrderDate) [Year], COUNT(SalesOrderID) AS [Order Count]
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID, year(OrderDate)
ORDER BY TerritoryID, year(OrderDate);

/*
TerritoryID		2005	2006	2007	2008
	1			184		489		1789	2132
	2			 40		100		 135	  77
	3			 45		114		 149	  77
*/



------------   Question 2 (3 points)  --------------------

/* Write a query to retrieve the top five customers, based on the total purchase,
   for each region. Use TotalDue of SalesOrderHeader to calculate the total purchase.
   Also calculate the top five customer's purchase as a percentage of the total
   regional sale. Return the data in the following format.

	territoryid		% of Total Sale		Top5Customers
		1				22.58			29818, 29617, 29580, 29497, 30107
		2				35.12			29701, 29966, 29844, 29724, 29594
		3				36.44			29827, 29913, 29924, 29486, 29861
		4				14.49			30117, 29646, 29716, 29957, 29523
		5				32.60			29715, 29507, 29624, 29825, 29707
*/




---------------   Question 3 (3 points)  -------------------

/* Please write a stored procedure that will take an employee id
   and delete the specified employee from the table defined below.
   The stored procedure needs to give the user some feedback
   on the status of the delete operation, such as whether
   there was an error and whether the specified employee
   has been deleted. */

CREATE TABLE Employee
(EmployeeID INT PRIMARY KEY,
 LastName VARCHAR(50),
 FirsName VARCHAR(50),
 Salary DECIMAL(10,2),
 DepartmentID INT,
 StartDate DATE,
 TerminateDate DATE);




 ------------------   Question 4 (3 points)  -----------------------
 
/* Given five tables as defined below */

CREATE TABLE Department
 (DepartmentID INT PRIMARY KEY,
  Name VARCHAR(50));

CREATE TABLE Employee
(EmployeeID INT PRIMARY KEY,
 LastName VARCHAR(50),
 FirsName VARCHAR(50),
 Salary DECIMAL(10,2),
 DepartmentID INT REFERENCES Department(DepartmentID),
 StartDate DATE,
 TerminateDate DATE);

CREATE TABLE Project
(ProjectID INT PRIMARY KEY,
 Name VARCHAR(50),
 DepartmentID INT REFERENCES Department(DepartmentID),
 StartDate DATE,
 EndDate DATE);

CREATE TABLE Assignment
(EmployeeID INT REFERENCES Employee(EmployeeID),
 ProjectID INT REFERENCES Project(ProjectID),
 StartDate DATE,
 EndDate DATE
 PRIMARY KEY (EmployeeID, ProjectID, StartDate));

CREATE TABLE Training
(TrainingID INT IDENTITY,
 EmployeeID INT,
 CourseID INT,
 CompletionDate DATE);


 /* Create a new computed column, named ActiveEmployees,
    in the Department table to display the number of
	active employees a department has. An active employee
	is an employee who is not terminated. */




---------------------   Question 5 (4 points)  -------------------------

/* The view below is based on multiple tables. Please write
   a trigger that can make the Quantity column of the view updatable.
*/

CREATE TABLE SalesORDER
(OrderID INT IDENTITY PRIMARY KEY,
 OrderDate DATE);

CREATE TABLE OrderItem
(OrderID INT REFERENCES SalesOrder(OrderID),
 ItemID INT,
 ProductID INT,
 Quantity INT
 PRIMARY KEY (OrderID, ItemID));


CREATE VIEW vORDERS
AS SELECT TOP 100 PERCENT s.OrderID, OrderDate, ItemID, ProductID, Quantity
   FROM SalesOrder s
   JOIN OrderItem i
   ON s.OrderID = i.OrderID
   ORDER BY s.OrderID, ProductID;


