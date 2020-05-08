
-----------------   QUIZ 2       NUID Last Digit 3 or 4   -----------------

-- Your Name: WENQING LIANG
-- Your NUID: 001873144

------------------------- Question 1 (2 points) ----------------

/* Rewrite the following query to present the same data in a horizontal format
   using the SQL PIVOT command. Your report should have the format listed below.
   
TerritoryID		2008-3-1	2008-3-2	2008-3-3	2008-3-4	2008-3-5
	1				34			7			9			8			12
	2				12			0			0			0			0
	3				13			0			0			0			0
	4				46			14			10			10			13
	5				15			0			0			0			0    
*/

USE AdventureWorks2008R2;

SELECT TerritoryID, CAST(OrderDate AS DATE) [Order Date], COUNT(CustomerID) AS [Customer Count]
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '3-1-2008' AND '3-5-2008'
GROUP BY TerritoryID, OrderDate
ORDER BY TerritoryID, OrderDate;

SELECT  TerritoryID, [2008-3-1], [2008-3-2], [2008-3-3], [2008-3-4], [2008-3-5]
FROM (SELECT TerritoryID, OrderDate, CustomerID
    FROM Sales.SalesOrderHeader) as S
PIVOT
  (COUNT (CustomerID) FOR OrderDate IN ([2008-3-1], [2008-3-2], [2008-3-3], [2008-3-4], [2008-3-5]))AS P

--pivot table

SELECT *
FROM (SELECT TerritoryID, OrderDate, CustomerID
      FROM Sales.SalesOrderHeader
      WHERE OrderDate BETWEEN '2008-3-1' AND '2008-3-5') AS S
PIVOT
     (COUNT(CustomerID) FOR OrderDate IN
    ([2008-3-1], [2008-3-2], [2008-3-3], [2008-3-4], [2008-3-5]) )AS P

-------------
    
SELECT year as 年份, Q1 as 一季度, Q2 as 二季度, Q3 as 三季度, Q4 as 四季度 
FROM SalesByQuarter 
PIVOT 
(SUM (amount) FOR quarter IN (Q1, Q2, Q3, Q4) ) AS P ORDER BY YEAR DESC
     
SELECT [星期一],[星期二],[星期三],[星期四],[星期五],[星期六],[星期日]
  --这里是PIVOT第三步（选择行转列后的结果集的列）这里可以用“*”表示选择所有列，也可以只选择某些列(也就是某些天)
FROM WEEK_INCOME 
  --这里是PIVOT第二步骤(准备原始的查询结果，因为PIVOT是对一个原始的查询结果集进行转换操作，
  --所以先查询一个结果集出来)这里可以是一个select子查询，但为子查询时候要指定别名，否则语法错误
PIVOT
(
    SUM(INCOME) for [week] in([星期一],[星期二],[星期三],[星期四],[星期五],[星期六],[星期日])
    --这里是PIVOT第一步骤，也是核心的地方，进行行转列操作。聚合函数SUM表示你需要怎样处理转换后的列的值，
    --是总和(sum)，还是平均(avg)还是min,max等等。例如如果week_income表中有两条数据并且其week都是“星期一”，
    --其中一条的income是1000,另一条income是500，那么在这里使用sum，行转列后“星期一”这个列的值当然是1500了。
    --后面的for [week] in([星期一],[星期二])中 for [week]就是说将week列的值分别转换成一个个列，也就是“以值变列”。
    --但是需要转换成列的值有可能有很多，我们只想取其中几个值转换成列，那么怎样取呢？就是在in里面了，比如我此刻只想看工作日的收入，
    --在in里面就只写“星期一”至“星期五”（注意，in里面是原来week列的值,"以值变列"）。
    --总的来说，SUM(INCOME) for [week] in([星期一],[星期二],[星期三],[星期四],[星期五],[星期六],[星期日])这句的意思如果直译出来，
    --就是说：将列[week]值为"星期一","星期二","星期三","星期四","星期五","星期六","星期日"分别转换成列，这些列的值取income的总和。
)TBL
  --别名一定要写




------------------------- Question 2 (3 points) ----------------------

/* Write a query to retrieve the top five customers of each territory.
   Use the sum of TotalDue in SalesOrderHeader to determine the total purchase amounts.
   The top 5 customers have the five highest total purchase amounts. Your solution
   should retrieve a tie if there is any. The report should have the following format.
   Sort the report by TerritoryID.

TerritoryID	Top5Customers
	1		Harui Roger, Camacho Lindsey, Bready Richard, Ferrier Fran�ois, Vanderkamp Margaret
	2		DeGrasse Kirk, Lum Richard, Hirota Nancy, Duerr Bernard, Browning Dave
	3		Hendricks Valerie, Kirilov Anton, Kennedy Mitch, Abercrombie Kim, Huntsman Phyllis
	4		Vessa Robert, Cereghino Stacey, Dockter Blaine, Liu Kevin, Arthur John
	5		Dixon Andrew, Allen Phyllis, Cantoni Joseph, Hendergart James, Dennis Helen   
*/

USE AdventureWorks2008R2;

with temp as
(select sh.TerritoryID,  (p.LastName + ' ' + p.FirstName) as FullName,
     rank() over (partition by sh.TerritoryID order by sum(sh.TotalDue) desc) Position
from Sales.SalesOrderHeader sh
join Sales.Customer c
on sh.CustomerID = c.CustomerID
join Person.Person p
on c.PersonID = p.BusinessEntityID
group by sh.TerritoryID, p.LastName, p.FirstName)

select distinct TerritoryID,

STUFF((SELECT  ', ' + FullName  
       FROM temp t1
       WHERE t1.TerritoryID = t2.TerritoryID and Position <=5
       FOR XML PATH('')) , 1, 2, '') AS Top5Customers

from temp t2
order by TerritoryID;




------------------------- Question 3 (2 points) ----------------------

/* Use the function below and Person.Person to create a report.
   Include the SalespersonID, LastName, FirstName, SalesOrderID, OrderDate and TotalDue
   columns in the report. Don't modify the function.
   Sort he report by SalespersonID. */

-- Get a salesperson's orders
create function dbo.ufGetSalespersonOrders
(@spid int)
returns table
as return
select SalespersonID, SalesOrderID, OrderDate, TotalDue
from Sales.SalesOrderHeader
where SalespersonID=@spid;


select SalespersonID, p.LastName, p.FirstName, o.SalesOrderID, o.OrderDate, o.TotalDue
from Person.Person p
cross apply dbo.ufGetSalespersonOrders (BusinessEntityID) o
order by o.SalespersonID;




/* Given five tables as defined below for Questions 4 and 5 */
USE LIANG_WENQING_TEST;

CREATE SCHEMA quiz2;

CREATE TABLE quiz2.Department
 (DepartmentID INT PRIMARY KEY,
  Name VARCHAR(50));

CREATE TABLE quiz2.Employee
(EmployeeID INT PRIMARY KEY,
 LastName VARCHAR(50),
 FirsName VARCHAR(50),
 Salary DECIMAL(10,2),
 DepartmentID INT REFERENCES Department(DepartmentID),
 TerminateDate DATE);

CREATE TABLE quiz2.Project
(ProjectID INT PRIMARY KEY,
 Name VARCHAR(50));

CREATE TABLE quiz2.Assignment
(EmployeeID INT REFERENCES Employee(EmployeeID),
 ProjectID INT REFERENCES Project(ProjectID),
 StartDate DATE,
 EndDate DATE
 PRIMARY KEY (EmployeeID, ProjectID, StartDate));

CREATE TABLE quiz2.SalaryAudit
(LogID INT IDENTITY,
 EmployeeID INT,
 OldSalary DECIMAL(10,2),
 NewSalary DECIMAL(10,2),
 ChangedBy VARCHAR(50) DEFAULT original_login(),
 ChangeTime DATETIME DEFAULT GETDATE());


------------------------- Question 4 (4 points) ----------------------

/* There is a business rule that the company can not have have more than 10 active projects at the same time 
   and an active project team average size can not be greater than 50 empoyees. 
   An active project is a project which has at least one employee working on it. 
   Write a SINGLE table-level constraint to implement the rule. */



--int 0 = success, 1 = fail

create function ufCheckRule2
()
 returns smallint
 begin
    declare @status smallint;
    if (select count(distinct ProjectID) from Assignment where enddate is null) > 10
  or cast(((select count(EmployeeID) from Assignment where enddate is null) / 
     (select count(distinct ProjectID) from Assignment where enddate is null)) as decimal(3,2)) > 50
    
    set @status = 1
    else set @status = 0

  return @status
 end

ALTER TABLE Assignment ADD CONSTRAINT AssignmentRule2 CHECK (dbo.ufCheckRule2() = 0);

ALTER TABLE dbo.Assignment drop CONSTRAINT AssignmentRule2





------------------------- Question 5 (4 points) ----------------------

/* There is a business rule a salary adjustment cannot be greater than 10%.
   Also, any allowed adjustment must be logged in the SalaryAudit table.
   Please write a trigger to implement the rule. 
   Assume only one update takes place at a time. */


CREATE TRIGGER utrSalaryAudit ON Employee  
AFTER UPDATE
AS  
BEGIN
 
  IF UPDATE(Salary)
  begin

     declare @perc decimal(3, 2)
     select @perc = (i.salary - d.salary)/d.salary
         FROM inserted AS i 
       FULL JOIN deleted d
       ON i.EmployeeID = d.EmployeeID;

     IF @perc > 0.1

         ROLLBACK Transaction

     ELSE
        INSERT INTO SalaryAudit (EmployeeID, OldSalary, NewSalary) 
      (SELECT isnull(i.EmployeeID, d.EmployeeID), d.Salary, i.Salary
       FROM inserted AS i 
       FULL JOIN deleted d
       ON i.EmployeeID = d.EmployeeID);   
    end
END

drop TRIGGER utrSalaryAudit






