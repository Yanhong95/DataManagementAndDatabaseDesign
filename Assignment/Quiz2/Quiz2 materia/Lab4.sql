--Part A
--step 1: create database
CREATE DATABASE Chen_Yanhong_TEST;
GO
USE Chen_Yanhong_TEST;

--step 2: 20 queries
CREATE TABLE dbo.Parent (
ParentID int IDENTITY NOT NULL PRIMARY KEY, 
ParentFName varchar(40) NOT NULL,
ParentLName varchar(40) NOT NULL,
Phone varchar(20) NOT NULL,
Address varchar(40) NOT NULL
);


Create TABLE dbo.Team(
TeamID int IDENTITY NOT NULL PRIMARY KEY, 
TeamName varchar(40) NOT NULL,
TeamColor varchar(40) NOT NULL
);


CREATE TABLE dbo.Player(
PlayerID int IDENTITY NOT NULL PRIMARY KEY, 
PlayerFName varchar(40) NOT NULL,
PlayerLName varchar(40) NOT NULL,
TeamID int NOT NULL REFERENCES dbo.Team(TeamID)
);


CREATE TABLE dbo.Registers(
ParentID int NOT NULL REFERENCES dbo.Parent(ParentID),
PlayerID int NOT NULL REFERENCES dbo.Player(PlayerID),
CONSTRAINT PKRegisters PRIMARY KEY CLUSTERED (ParentID, PlayerID)
);


CREATE TABLE dbo.Coach (CoachID int IDENTITY);
ALTER TABLE dbo.Coach ALTER COLUMN CoachID int not null;
ALTER TABLE dbo.Coach ADD CONSTRAINT key1 PRIMARY KEY (CoachID);
ALTER TABLE dbo.Coach ADD CName varchar(50);


INSERT dbo.Parent VALUES ('Dawei', 'Chen', '1345567865','7154 Heritage Court Flint, MI 48504');
INSERT dbo.Parent VALUES ('Wei', 'Wen', '5647868165','540 Cross Road Green Cove, FL 32043');
INSERT dbo.Parent VALUES ('Mei', 'Wu', '5784569087','649 Heather Street Cumberland, RI 02864');
INSERT dbo.Team VALUES('Bear','Brown');
INSERT dbo.Team VALUES('Crab','Red');
INSERT dbo.Team VALUES('Monkey','Gold');
INSERT dbo.Player VALUES('Li','Chen', 1);
INSERT dbo.Player VALUES('Lihai','Wen', 2);
INSERT dbo.Player VALUES('Keai','Wu', 3);
INSERT dbo.Registers VALUES(1,1);
INSERT dbo.Registers VALUES(2,2);
INSERT dbo.Registers VALUES(3,3);
INSERT dbo.Coach VALUES('Lihai,Chao');
INSERT dbo.Coach VALUES('Niu,Zei');
INSERT dbo.Coach VALUES('Di,Wu');


UPDATE Chen_Yanhong_TEST.dbo.Parent
SET ParentFName='Meng', ParentLName='Zhang', Phone='5647545365', Address='64 Johnson Lane Melbourne, FL 32904'WHERE ParentID=4;
DELETE FROM Chen_Yanhong_TEST.dbo.Parent WHERE ParentID=4;
SELECT * FROM dbo.Parent ORDER BY ParentID DESC;
SELECT STUFF((SELECT Address FROM dbo.Parent WHERE ParentID=4), 2, 3, 'whatever');
SELECT LEN(Address) FROM dbo.Parent;
SELECT Player.PlayerID, Player.PlayerFName, Player.PlayerLName,Player.TeamID,Team.TeamName,Team.TeamColor 
FROM dbo.Player JOIN dbo.Team ON Player.TeamID = Team.TeamID;
SELECT Address AS Addr FROM dbo.Parent;
SELECT Address FROM dbo.Parent WHERE ParentID  BETWEEN 3 AND 4;
SELECT * FROM dbo.Parent WHERE Address LIKE '[7]%';
SELECT * FROM dbo.Parent WHERE Address NOT LIKE '%lon%';
SELECT TOP 25 PERCENT * FROM dbo.Parent ;


DROP TABLE dbo.Parent;
DROP TABLE dbo.Team;
DROP TABLE dbo.Player;
DROP TABLE dbo.Registers;
DROP TABLE dbo.Coach;


CREATE TABLE dbo.TargetCustomers(
TargetID int IDENTITY NOT NULL PRIMARY KEY, 
FirstName varchar(40) NOT NULL,
LastName varchar(40) NOT NULL,
Address varchar(40) NOT NULL,
State varchar(40) NOT NULL,
City varchar(40) NOT NULL,
ZipCode varchar(40) NOT NULL
);


CREATE TABLE dbo.MailingLists(
MailingListID int IDENTITY NOT NULL PRIMARY KEY, 
MailingLists varchar(40) NOT NULL
);


CREATE TABLE dbo.TargetMailingLists(
TargetID int NOT NULL REFERENCES dbo.TargetCustomers(TargetID),
MailingListID int NOT NULL REFERENCES dbo.MailingLists(MailingListID),
CONSTRAINT PKTargetMailingLists PRIMARY KEY CLUSTERED (TargetID, MailingListID)
);


/* Using the content of AdventureWorks, write a query to retrieve
all unique customers with all salespersons each customer has dealt with. Exclude the customers who have never worked with a salesperson.
Sort the returned data by CustomerID in the descending order.
The result should have the following format.
Hint: Use the SalesOrderHeadrer table.
 
CustomerID SalesPersonID 
30118 275, 277 
30117 275, 277 
30116 276
30115 289 
30114 290 
30113 282 
30112 280, 284 */

--Part B
SELECT DISTINCT CustomerID,
 STUFF((SELECT  ','+RTRIM(CAST(SalesPersonID as char))
       FROM Sales.SalesOrderHeader a
       where a.CustomerID = b.CustomerID
       GROUP By SalesPersonID,CustomerID
       FOR XML PATH('')) , 1, 1, '') AS SalesPersonID 
FROM Sales.SalesOrderHeader b
WHERE SalesPersonID  is not null
ORDER BY CustomerID DESC ;



/* Bill of Materials - Recursive */
 
/* The following code retrieves the components required for manufacturing
the "Mountain-500 Black, 48" (Product 992). Modify the code to retrieve the most expensive component(s) that cannot be manufactured internally.
Use the list price of a component to determine the most expensive
component.
If there is a tie, your solutions must retrieve it. */
 -- Starter code

 
--Part C

IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
DROP TABLE #TempTable;

WITH Parts(AssemblyID, ComponentID, PerAssemblyQty, EndDate, ComponentLevel) AS
(
    -- Top-level compoments
	SELECT b.ProductAssemblyID, b.ComponentID, b.PerAssemblyQty,
        b.EndDate, 0 AS ComponentLevel
    FROM Production.BillOfMaterials AS b
    WHERE b.ProductAssemblyID = 992
          AND b.EndDate IS NULL

    UNION ALL

	-- All other sub-compoments
    SELECT bom.ProductAssemblyID, bom.ComponentID, p.PerAssemblyQty,
        bom.EndDate, ComponentLevel + 1
    FROM Production.BillOfMaterials AS bom 
        INNER JOIN Parts AS p
        ON bom.ProductAssemblyID = p.ComponentID
        AND bom.EndDate IS NULL
)
SELECT AssemblyID, ComponentID, Name, ListPrice, PerAssemblyQty, 
       ListPrice * PerAssemblyQty SubTotal, ComponentLevel

INTO #TempTable

FROM Parts AS p
    INNER JOIN Production.Product AS pr
    ON p.ComponentID = pr.ProductID
ORDER BY ComponentLevel, AssemblyID, ComponentID;

WITH temp1 AS
(
SELECT ListPrice,ComponentID FROM #TempTable
WHERE ComponentLevel = 0 AND ComponentID NOT IN (SELECT AssemblyID FROM #TempTable WHERE ComponentLevel = 1) 
UNION ALL
SELECT ListPrice,ComponentID FROM #TempTable
WHERE ComponentLevel = 1 AND ComponentID NOT IN (SELECT AssemblyID FROM #TempTable WHERE ComponentLevel = 2)
UNION ALL
SELECT ListPrice,ComponentID FROM #TempTable 
WHERE ComponentLevel = 2 AND ComponentID NOT IN (SELECT AssemblyID FROM #TempTable WHERE ComponentLevel = 3)
UNION ALL
SELECT ListPrice,AssemblyID FROM #TempTable WHERE ComponentLevel = 4
), 
temp2 AS(
SELECT ComponentID, ListPrice, RANK() OVER (ORDER BY ListPrice DESC) AS rankNumber
FROM temp1
)
SELECT * FROM temp2 where rankNumber = 1;
