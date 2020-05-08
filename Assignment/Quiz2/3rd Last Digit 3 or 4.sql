
/*       3rd Last Digit 3 or 4       */

/*       Your NUID:           */


---------  Question 1 (2 points)  --------------------

/* Rewrite the following query to present the same data in the format
   listed below using the SQL PIVOT command. */

SELECT TerritoryID, datepart(qq, OrderDate) [Quarter], COUNT(SalesOrderID) AS [Order Count]
FROM Sales.SalesOrderHeader s
GROUP BY TerritoryID, datepart(qq, OrderDate)
ORDER BY TerritoryID, datepart(qq, OrderDate);

/*
TerritoryID	  1		  2		 3		  4
	1		1125	1317	992		1160
	2		  87	  91	 83		  91
	3		  93	 100	 92		 100
*/



------------   Question 2 (3 points)  --------------------

/* Write a query to retrieve the top five products for each year.
   Use OrderQty of SalesOrderDetail to calculate the total quantity sold.
   The top five products have the five highest sold quantities.
   Also calculate the top five products' sold quantity as a percentage
   of the total quantity sold for a year. Return the data in the following format.

	Year	% of Total Sale		Top5Products
	2005	19.58980418600		709, 712, 715, 770, 760
	2006	13.70859187700		863, 715, 712, 711, 852
	2007	12.39464630800		712, 870, 711, 708, 715
	2008	15.68128704000		870, 712, 711, 708, 707

*/



---------------   Question 3 (3 points)  -------------------

/* Please write a stored procedure that will delete all inactive assignments
   from the table defined below. An inactive assignment has an end date.
   The stored procedure needs to give the user some feedback on the status
   of the delete operation, such as whether there was an error and
   how many inactive assignments have been deleted. */

CREATE TABLE Assignment
(EmployeeID INT,
 ProjectID INT,
 StartDate DATE,
 EndDate DATE
 PRIMARY KEY (EmployeeID, ProjectID, StartDate));



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

 /* Create a new computed column, named ActiveAssignments,
    in the Employee table to display the number of
	active assignments an employee has. An active assignment
	is an assignment which has not ended. */
 



---------------------   Question 5 (4 points)  -------------------------

/* The view below is based on multiple tables. Please write
   a trigger that can make the Appointment column of the view updatable.
*/

CREATE TABLE dbo.Patient
    (
    PatientID int IDENTITY NOT NULL PRIMARY KEY ,
    PatientLName varchar(50) NOT NULL,
	PatientFName varchar(50) NOT NULL
    );

CREATE TABLE dbo.Therapist
    (
    TherapistID int IDENTITY NOT NULL PRIMARY KEY ,
    TherapistLName varchar(50) NOT NULL,
	TherapistFName varchar(50) NOT NULL
    );

CREATE TABLE dbo.Appointment
     (
    AppointmentID int IDENTITY NOT NULL PRIMARY KEY,
    PatientID int NOT NULL
        REFERENCES Patient(PatientID),
	TherapistID int NOT NULL
        REFERENCES Therapist(TherapistID),
    Appointment datetime NOT NULL
    );

CREATE UNIQUE INDEX UniqueAppt   
ON dbo.Appointment (PatientID, TherapistID, Appointment);   
GO 

CREATE VIEW dbo.vAppointment
AS
SELECT   TOP 100 PERCENT 
         p.PatientLName,
         p.PatientFName,
         t.TherapistLName,
         t.TherapistFName,
		 a.AppointmentID,
		 a.Appointment
FROM dbo.Appointment a
JOIN   dbo.Patient p
ON a.PatientID = p.PatientID
JOIN dbo.Therapist t
ON a.TherapistID = t.TherapistID
ORDER BY a.PatientID, a.Appointment;

