--5-1
CREATE FUNCTION returnTotalSale (@y INT, @m INT)
RETURNS INT
AS 
BEGIN
	DECLARE @totalSale INT;
	SELECT @totalSale = SUM(s.TotalDue)  
	FROM AdventureWorks2008R2.Sales.SalesOrderHeader s
	WHERE YEAR(s.OrderDate) = @y and MONTH(s.OrderDate) = @m;
	IF (@totalSale IS NULL)
		SET @totalSale = 0;
	RETURN @totalSale;
END;

SELECT dbo.returnTotalSale(2008,5);
SELECT dbo.returnTotalSale(2018,5);

DROP FUNCTION returnTotalSale;

--5-2
CREATE TABLE DateRange (
	DateID INT IDENTITY,
	DateValue DATE, 
	Year INT, 
	Quarter INT, 
	Month INT, 
	DayOfWeek INT);

CREATE PROCEDURE updateDate
@d DATE, @n INT
AS
BEGIN
  WHILE @n <>0
    BEGIN
      INSERT INTO dbo.DateRange (DateValue,Year,Quarter,Month,DayOfWeek)
	  SELECT @d,YEAR(@d),DATEPART(quarter, @d),MONTH(@d), DATEPART(weekday, @d)
      SET @d = DATEADD(Day, 1, @d);
      SET @n = @n -1;
    END
END

DECLARE @date DATE;
DECLARE @number INT;
SET  @date = '2019/08/1';
SET  @number = 10;
EXEC updateDate @date,@number;
SELECT * FROM dbo.DateRange;

DROP TABLE DateRange;
DROP PROCEDURE dbo.updateDate;

--5-3
CREATE FUNCTION GetTable()
RETURNS TABLE
AS
RETURN (
	WITH temp1 AS
	(SELECT CustomerID, count(SalesOrderID) TotalOrderCount
	 FROM AdventureWorks2008R2.Sales.SalesOrderHeader
	 GROUP BY CustomerID),

	temp2 AS
	(SELECT CustomerID, count(distinct d.ProductID) TotalUniqueProducts
 	 FROM AdventureWorks2008R2.Sales.SalesOrderHeader h
	 JOIN AdventureWorks2008R2.Sales.SalesOrderDetail d
	 ON h.SalesOrderID = d.SalesOrderID
	 GROUP BY CustomerID)

	SELECT TOP(100) PERCENT c.CustomerID, name = p.FirstName + ' ' + p.LastName, temp1.TotalOrderCount, temp2.TotalUniqueProducts
	FROM AdventureWorks2008R2.Sales.Customer c
	JOIN AdventureWorks2008R2.Person.Person p
	ON c.PersonID = p.BusinessEntityID
	JOIN temp1
	ON c.CustomerID = temp1.CustomerID
	JOIN temp2
	ON c.CustomerID = temp2.CustomerID
	ORDER BY c.CustomerID
);

SELECT * FROM GetTable();
DROP FUNCTION GetTable;

/* Question 3 */

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

--5-4
CREATE TABLE Customer (
	CustomerID INT PRIMARY KEY,
	CustomerLName VARCHAR(30),
	CustomerFName VARCHAR(30));

CREATE TABLE SaleOrder(
	OrderID INT IDENTITY PRIMARY KEY,
	CustomerID INT REFERENCES Customer(CustomerID), 
	OrderDate DATE,
	LastModified datetime);

CREATE TABLE SaleOrderDetail(
	OrderID INT REFERENCES SaleOrder(OrderID),
	ProductID INT,
	Quantity INT,
	UnitPrice INT,
	PRIMARY KEY (OrderID, ProductID));


/* Write a trigger to put the change date and time in the LastModified column of the Order table 
   whenever an order item in SaleOrderDetail is changed. */
          
/*基本语句*/
           create trigger trigger_name
           on {table_name | view_name}
           {for | After | Instead of }
           [ insert, update,delete ]
           as
           sql_statement

INSERT dbo.Customer VALUES (1, 'Lihai','Zhen');
INSERT dbo.Customer VALUES (2, 'Lihai','Wo');
INSERT dbo.Customer VALUES (3, 'Lihai','Ni');

INSERT dbo.SaleOrder VALUES(1,'2018-1-1','2018-1-1 11:11:11');
INSERT dbo.SaleOrder VALUES(2,'2018-1-2','2018-1-2 11:12:12');
INSERT dbo.SaleOrder VALUES(3,'2018-1-3','2018-1-3 11:13:13');

INSERT dbo.SaleOrderDetail VALUES(1,111,111,111);
INSERT dbo.SaleOrderDetail VALUES(2,222,222,333);
INSERT dbo.SaleOrderDetail VALUES(3,333,333,333);

CREATE TRIGGER updateLastModifiedDate
    ON dbo.SaleOrderDetail
    AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	SET NOCOUNT ON;
    UPDATE SaleOrder
    SET LastModified = GETDATE()
    FROM dbo.SaleOrder o
    JOIN INSERTED i ON i.orderid = o.orderid
END 
--- solution 
CREATE TRIGGER dbo.utrLastModified
ON dbo.SaleOrderDetail 
AFTER INSERT, UPDATE, DELETE
AS  BEGIN
    DECLARE @oid INT;
	SET @oid = ISNULL((SELECT OrderID FROM Inserted), (SELECT OrderID FROM Deleted));
    UPDATE dbo.SaleOrder SET LastModified = GETDATE()
	WHERE OrderID = @oid
	END

UPDATE dbo.SaleOrderDetail SET UnitPrice = 444 WHERE ProductID = 333;
INSERT dbo.SaleOrderDetail VALUES(3,444,444,444);
DELETE dbo.SaleOrderDetail WHERE ProductID = 444;


DROP TABLE dbo.Customer;
DROP TABLE dbo.SaleOrder;
DROP TABLE dbo.SaleOrderDetail;
DROP TRIGGER updateLastModifiedDate;


/*相关示例*/
--1﹕在Orders表中建立触发器﹐当向Orders表中插入一条订单记录时﹐检查goods表的货品状态status是否为1(正在整理)﹐是﹐则不能往Orders表加入该订单。
create trigger orderinsert
on orders
after insert
as 
if (select status from goods,inserted
where goods.name=inserted.goodsname)=1
begin
print 'the goods is being processed'
print 'the order cannot be committed'
rollback transaction   --回滚﹐避免加入
end
--2﹕在Orders表建立一个插入触发器﹐在添加一条订单时﹐减少Goods表相应的货品记录中的库存。
create trigger orderinsert1
on orders
after insert
as
update goods set storage=storage-inserted.quantity
from goods,inserted
where
goods.name=inserted.goodsname
--3﹕在Goods表建立删除触发器﹐实现Goods表和Orders表的级联删除。
create trigger goodsdelete
on goods
after delete
as
delete from orders 
where goodsname in
(select name from deleted)
--4﹕在Orders表建立一个更新触发器﹐监视Orders表的订单日期(OrderDate)列﹐使其不能手工修改.
create trigger orderdateupdate
on orders
after update
as
if update(orderdate)
begin
raiserror(' orderdate cannot be modified',10,1)
rollback transaction
end
--5﹕在Orders表建立一个插入触发器﹐保证向Orders表插入的货品名必须要在Goods表中一定存在。
create trigger orderinsert3
on orders
after insert
as 
if (select count(*) from goods,inserted where goods.name=inserted.goodsname)=0
begin
print ' no entry in goods for this order'
rollback transaction
end

--6：Orders表建立一个插入触发器，保证向Orders表插入的货品信息要在Order表中添加
alter trigger addOrder
on Orders
for insert 
as
insert into Order
select inserted.Id, inserted.goodName,inserted.Number from inserted
