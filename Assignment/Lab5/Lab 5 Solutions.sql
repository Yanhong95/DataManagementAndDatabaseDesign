/* Question 1 */
/* Create a function in your own database that takes two
parameters:
1) A year parameter
2) A month parameter
The function then calculates and returns the total sale
for the requested year and month. If there was no sale for the requested period, returns 0.
Hints: a) Use the TotalDue column of the Sales.SalesOrderHeader table in an
AdventureWorks database for
calculating the total sale.
b) The year and month parameters should use
the INT data type.
c) Make sure the function returns 0 if there
was no sale in the database for the requested period. */

create function salesByMonthYear
(@month int, @year int)
returns money
As
Begin 
	Declare @sale money;
	select @sale = isnull( sum(TotalDue) , 0)
	from sales.SalesOrderHeader
	where month(orderDate) = @month AND year(OrderDate) = @year
	return @sale;
End

select dbo.salesByMonthYear(2005, 3);
drop function dbo.salesByMonthYear;

/* Question 2 
Lab 5-2
Write a stored procedure in your own database that accepts two parameters:
1) A starting date
2) The number of the consecutive dates beginning with the starting date
The stored procedure then populates all columns of the DateRange table according to the two provided parameters.
*/


CREATE TABLE DateRange
(DateID INT IDENTITY,
DateValue DATE,
Year INT,
Quarter INT,
Month INT,
DayOfWeek INT);

CREATE PROCEDURE dbo.uspDate
	@StartDate DATE,
	@NumDays INT
AS
	BEGIN
		DECLARE @counter INT;
		SET @counter = @NumDays
		WHILE @counter > 0 
			BEGIN 
				INSERT INTO DateRange (DateValue, Year,Quarter,Month,DayOfWeek)
				VALUES (@StartDate, DATEPART(Year,@startDate), DATEPART(QUARTER,@startDate),
				        DATEPART(MONTH,@startDate), DATEPART(WEEKDAY,@startDate));
				SET @StartDate = DATEADD(DAY,1,@StartDate);
				SET @counter = @counter - 1;
			END	
	END

DECLARE @InputDate Date = '2018-07-01';
DECLARE @IntputNumDays Int = 15;

EXEC uspDate @inputDate, @IntputNumDays;
SELECT * from DateRange;
DROP PROC dbo.uspDate;
DROP TABLE DateRange;

/* Question 3 */
/* Using an AdventureWorks database, create a function that accepts a customer id and returns the full name (last name + first name) of the customer, as isted below. 
-- 

Create a table-valued function create function uf_GetCustomerName (@CustID int)
returns @tbl table (name varchar(200))
begin
declare @fullname varchar(200) = '' ;
select @fullname = p.FirstName + ' ' + p.LastName from Sales.Customer c
join Person.Person p
on c.PersonID = p.BusinessEntityID
where c.CustomerID = @custID;
insert into @tbl values (@fullname);
return; end
-- Test run the function
select * from dbo.uf_GetCustomerName(11000)


/* Use the new function, SalesOrderHeader and SalesOrderDetail
to return all customers, with each customer's id, full name,
total number of orders and total number of unique products
a customer has purchased. Sort the returned data by CustomerID. */


-- Create a table-valued function
create function uf_GetCustomerName
(@CustID int)
returns @tbl table  (name varchar(200))
  begin
     declare @fullname varchar(200) = '' ;

     select @fullname = p.FirstName + ' ' + p.LastName
     from AdventureWorks2008R2.Sales.Customer c
     join AdventureWorks2008R2.Person.Person p
     on c.PersonID = p.BusinessEntityID
     where c.CustomerID = @custID;

     insert into @tbl values (@fullname);

     return;
  end

-- Test run the function
select * from dbo.uf_GetCustomerName(11000);

select s.CustomerID, n.name,
count(distinct s.SalesOrderID) OrderTotal,
count(distinct d.ProductID) UniqueProductTotal
from Sales.SalesOrderHeader s
join Sales.SalesOrderDetail d
on s.SalesOrderID = d.SalesOrderID
cross apply dbo.uf_GetCustomerName(s.CustomerID) n
group by s.CustomerID, n.name
order by s.CustomerID;

drop function dbo.uf_GetCustomerName

/* Question 4 */

/* Write a trigger to put the change date and time in 
the LastModified column of the Order table whenever an order item in SaleOrderDetail is changed. */

CREATE TABLE Customer
(CustomerID INT PRIMARY KEY,
CustomerLName VARCHAR(30),
CustomerFName VARCHAR(30));

CREATE TABLE SaleOrder
(OrderID INT IDENTITY PRIMARY KEY,
CustomerID INT REFERENCES Customer(CustomerID),
OrderDate DATE,
LastModified datetime);

CREATE TABLE SaleOrderDetail
(OrderID INT REFERENCES SaleOrder(OrderID),
ProductID INT,
Quantity INT,
UnitPrice INT,
PRIMARY KEY (OrderID, ProductID));

CREATE TRIGGER dbo.utrLastModified
ON dbo.SaleOrderDetail 
AFTER INSERT, UPDATE, DELETE
AS  BEGIN
    DECLARE @oid INT;
	SET @oid = ISNULL((SELECT OrderID FROM Inserted), (SELECT OrderID FROM Deleted));
    UPDATE dbo.SaleOrder SET LastModified = GETDATE()
	WHERE OrderID = @oid
	END

