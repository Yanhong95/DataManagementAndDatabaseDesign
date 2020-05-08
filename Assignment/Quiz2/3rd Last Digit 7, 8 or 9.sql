
/*         3rd Last Digit 7, 8 or 9         */

/*         Your NUID:           */


---------  Question 1 (2 points)  --------------------

/* Rewrite the following query to present the same data in the format
   listed below using the SQL PIVOT command. */

SELECT TerritoryID, month(OrderDate) [Month], COUNT(SalesOrderID) AS [Order Count]
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID, month(OrderDate)
HAVING month(OrderDate) <= 6
ORDER BY TerritoryID, month(OrderDate);

/*
TerritoryID		 1		 2		 3		 4		 5		 6
	1			366		368		391		401		465		451
	2			 19		 40		 28		 20		 44		 27
	3			 20		 38		 35		 20		 44		 36
*/




------------   Question 2 (3 points)  --------------------

/* Write a query to retrieve the top five products for each year.
   Use UnitPrice * OrderQty (both are in SalesOrderDetail) to calculate
   the sale amount. The top five products have the five highest 
   sale amounts of a year.

   Also calculate the top five products' total sale amount as a percentage
   of the overall sale amount of all products for a year.

   Return the data in the following format.

   Year		% of Total Sale		Top5Products
	2005	33.699509341498		753, 749, 777, 775, 771
	2006	15.019871402302		753, 749, 783, 782, 751
	2007	21.566928101913		782, 783, 779, 784, 781
	2008	21.845655081857		782, 783, 779, 781, 780
*/




---------------   Question 3 (3 points)  -------------------

/* Please write a stored procedure that will take a training id
   and delete the specified training from the table defined below.
   The stored procedure needs to give the user some feedback
   on the status of the delete operation, such as whether
   there was an error and whether the specified training
   has been deleted. */

CREATE TABLE Training
(TrainingID INT IDENTITY PRIMARY KEY,
 EmployeeID INT,
 CourseID INT,
 CompletionDate DATE);




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

 /* Create a new computed column, named YearlyTraining,
    in the Employee table to display the number of
	training courses an employee has completed for the
	current year. */




---------------------   Question 5 (4 points)  -------------------------

/* The view below is based on multiple tables. Please write
   a trigger that can make the EndDate column of the view updatable.
*/

CREATE TABLE Customer
(CustomerID INT IDENTITY PRIMARY KEY,
 LastName VARCHAR(50),
 FirstName VARCHAR(50));

CREATE TABLE Item
(ItemID INT IDENTITY PRIMARY KEY,
 ItemName VARCHAR(50),
 ItemDescription VARCHAR(100));

CREATE TABLE CheckOut
(CheckOutID INT IDENTITY PRIMARY KEY,
 CustomerID INT REFERENCES Customer(CustomerID),
 ItemID INT REFERENCES Item(ItemID),
 CheckOutDate DATE,
 EndDate DATE);

CREATE VIEW vCheckOut
AS SELECT TOP 100 PERCENT c.CustomerID, c.LastName, c.FirstName,
          k.CheckOutID, t.ItemID, t.ItemDescription, k.CheckOutDate, k.EndDate
   FROM Customer c
   JOIN CheckOut k
   ON c.CustomerID = k.CustomerID
   JOIN Item t
   ON k.ItemID = t.ItemID
   ORDER BY c.CustomerID, t.ItemID;


