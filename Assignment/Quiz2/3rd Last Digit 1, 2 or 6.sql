
/*     3rd Last Digit 1, 2 or 6     */

/*     Your NUID: 001814656         */


---------  Question 1 (2 points)  --------------------

/* Rewrite the following query to present the same data in the format
   listed below using the SQL PIVOT command. */

SELECT TerritoryID, month(OrderDate) [Month], COUNT(SalesOrderID) AS [Order Count]
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID, month(OrderDate)
ORDER BY TerritoryID, month(OrderDate);

/*
TerritoryID		 1		 2		 3		 4		 5		 6		 7		 8		 9		 10		 11		 12
	1			366		368		391		401		465		451		329		350		313		325		395		440
	2			 19		 40		 28		 20		 44		 27		 18		 41		 24		 21		 42		 28
	3			 20		 38		 35		 20		 44		 36		 19		 39		 34		 21		 41		 38
*/


  
SELECT TerritoryID,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
FROM (SELECT TerritoryID, OrderDate, SalesOrderID
      FROM Sales.SalesOrderHeader) AS S
PIVOT
 (COUNT(SalesOrderID) FOR month(OrderDate)[Month] IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12] ))AS P 

SELECT * 
FROM (SELECT TerritoryID, month(OrderDate) [Month], SalesOrderID
      FROM Sales.SalesOrderHeader) AS S
PIVOT
     (COUNT(SalesOrderID) FOR [Month] IN
    ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])) AS P;

------------   Question 2 (3 points)  --------------------

/* Write a query to retrieve the top five customers, based on the total purchase,
   for each year. Use TotalDue of SalesOrderHeader to calculate the total purchase.
   Also calculate the top five customer's purchase as a percentage of the total
   regional sale. Return the data in the following format.

	Year	% of Total Sale		Top5Customers
	2007		4.17			29913, 29818, 29701, 30117, 29641
	2005		8.91			29624, 29861, 29562, 29690, 29525
	2006		5.26			29614, 29716, 29722, 29715, 29562
	2008		3.84			29923, 29641, 29617, 29913, 29818
*/


USE AdventureWorks2008R2;

with temp as
(SELECT year(OrderDate) [year], CustomerID,
    rank() over(partition by  year(OrderDate)  order by sum(TotalDue) desc) [rank]
from Sales.SalesOrderHeader 
group by year(OrderDate), CustomerID )

select distinct year, 
STUFF((SELECT  ', ' + cast(CustomerID AS varchar(10))
       FROM temp t1
       WHERE t1.year = t2.year and rank <=5
       FOR XML PATH('')) , 1, 2, '') AS Top5Customers
from temp t2
order by year desc;

WITH Temp1 AS

   (select year(OrderDate) Year, CustomerID, sum(TotalDue) ttl,
    rank() over (partition by year(OrderDate) order by sum(TotalDue) desc) as TopCustomer
    from Sales.SalesOrderHeader
    group by year(OrderDate), CustomerID) ,

Temp2 AS

   (select year(OrderDate) Year, sum(TotalDue) ttl
  from Sales.SalesOrderHeader
    group by year(OrderDate))

select t1.Year, sum(t1.ttl) / t2.ttl * 100 [% of Total Sale],

STUFF((SELECT  ', '+RTRIM(CAST(CustomerID as char))  
       FROM temp1 
       WHERE Year = t1.Year and TopCustomer <=5
       FOR XML PATH('')) , 1, 2, '') AS Top5Customers

from temp1 t1
join temp2 t2
on t1.Year=t2.Year
where t1.topcustomer <= 5
group by t1.Year, t2.ttl;

---------------   Question 3 (3 points)  -------------------

/* Please write a stored procedure that will take a project id
   and delete the specified project from the table defined below.
   The stored procedure needs to give the user some feedback
   on the status of the delete operation, such as whether
   there was an error and whether the specified project
   has been deleted. */

CREATE TABLE Project
(ProjectID INT PRIMARY KEY,
 Name VARCHAR(50),
 DepartmentID INT,
 StartDate DATE,
 EndDate DATE);

CREATE PROCEDURE dbo.Project
  @ProjectID INT
AS
  BEGIN
    DECLARE @ID INT;
    DECLARE @status (varchar(10));
    SET @ID = @ProjectID
       IF EXISTS 
            (
              SELECT 'DELETE' 
              FROM Project 
              WHERE ProjectID = @ID
            )
           BEGIN
             DELETE FROM Project WHERE ProjectID = @ID 
           END
       SET @status = "delete successful"  

         ELSE SET @status = "delete failed" 
   END

create proc uspDeleteProject
@projid int
as
begin
  delete Project
  where ProjectID = @projid;

  if @@ERROR != 0
  print 'Something unexpected happened!';

  if @@ROWCOUNT = 0
  print 'The requested project was not found.';
end

exec uspDeleteProject 3;
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

 /* Create a new computed column, named ActiveProjects,
    in the Department table to display the number of
	active projects a department has. An active project
	is a project which has not ended. */

CREATE FUNCTION activeProjects(@DepartmentID)
 RETURNS int
 BEGIN
    DECLARE @activeProjectsNum int;
    SELECT @activeProjectsNum = (
        SELECT COUNT (DISTINCT a.ProjectID) 
        FROM dbo.Assignment a JOIN dbo.Project p
        ON a.ProjectID = p.ProjectID 
        JOIN  dbo.Department d
        ON P.DepartmentID =d.DepartmentID
        WHERE enddate is null AND P.DepartmentID = @DepartmentID)
    RETURN @activeProjectsNum
 END

ALTER TABLE Department ADD activeProjects AS(activeProjects(DepartmentID));

CREATE FUNCTION fn_CountProjects(@DepID INT)
RETURNS INT
AS
BEGIN
      DECLARE @total INT =
         (SELECT COUNT(ProjectID)
          FROM dbo.Project
          WHERE DepartmentID = @DepID AND EndDate IS NULL);
      RETURN @total;
END

-- Add a computed column to the Department

ALTER TABLE dbo.Department
ADD ActiveProjects AS (dbo.fn_CountProjects(DepartmentID));

---------------------   Question 5 (4 points)  -------------------------

/* The view below is based on multiple tables. Please write
   a trigger that can make the AppointmentDate column of the view updatable.
*/

CREATE TABLE Customer
(CustomerID INT IDENTITY PRIMARY KEY,
 LastName VARCHAR(50),
 FirstName VARCHAR(50));

CREATE TABLE Appointment
(AppointmentID INT IDENTITY PRIMARY KEY,
 CustomerID INT REFERENCES Customer(CustomerID),
 AppointmentDate DATE);

CREATE VIEW vAppointment
AS SELECT TOP 100 PERCENT c.CustomerID, a.AppointmentID, a.AppointmentDate
   FROM Customer c
   JOIN Appointment a
   ON c.CustomerID = a.CustomerID
   ORDER BY c.CustomerID, AppointmentDate;


   
CREATE TRIGGER trAppointmentUpdate
ON vAppointment
INSTEAD OF UPDATE
AS
BEGIN
    -- Check to see whether the UPDATE actually tried to feed us any rows
    -- (A WHERE clause might have filtered everything out)
    IF (SELECT COUNT(*) FROM Deleted) > 0
    BEGIN
        UPDATE Appointment
        SET AppointmentDate = i.AppointmentDate
      FROM Appointment a
            JOIN Inserted i
                ON i.AppointmentID = a.AppointmentID;

        -- Check result            
        IF @@ROWCOUNT = 0
            RAISERROR('Cannot perform UPDATE',10,1);
    END
END


