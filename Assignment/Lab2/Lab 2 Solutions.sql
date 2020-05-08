
-- 2-1

select CustomerID, SalesOrderID, cast(OrderDate as date) 'Order Date',
       round(TotalDue, 2) 'Total Due'
from Sales.SalesOrderHeader
where OrderDate > '5-1-2008' and TotalDue > 50000
order by CustomerID, OrderDate;


-- 2-2

Select CustomerID as 'Customer ID', 
       AccountNumber as 'Account Number', 
       cast(max(OrderDate ) as date) as 'Latest Order Date', 
       count(SalesOrderId) as 'Total Orders'
From Sales.SalesOrderHeader
Group By CustomerID, AccountNumber
Order by CustomerID;


-- 2-3

Select ProductID as 'Product ID', 
       Name as 'Product Name',
       round(ListPrice, 2) as 'List Price'
From Production.Product
Where ListPrice > (Select ListPrice From Production.Product where ProductID = 912)
ORDER BY ListPrice desc;


-- 2-4

Select p.ProductID as 'Product ID',
       p.Name as 'Product Name',
       count(sod.ProductID) as 'Times Sold'
From Production.Product p 
join Sales.SalesOrderDetail sod
on p.ProductID = sod.ProductID
Group By p.ProductID, p.Name
Having count(sod.ProductID) > 5 
Order by count(sod.ProductID) DESC, p.ProductID;


-- 2-5

select distinct CustomerID, AccountNumber
from Sales.SalesOrderHeader
where CustomerID not in
(select CustomerID
 from Sales.SalesOrderHeader
 where OrderDate >'1-1-2008')
order by CustomerID;

/*or*/
SELECT CustomerID, AccountNumber
FROM Sales.Customer
WHERE CustomerID NOT IN
(SELECT CustomerID
FROM Sales.SalesOrderHeader
WHERE OrderDate > '2008-01-01'
GROUP BY CustomerID)
ORDER BY CustomerID ASC;

-- 2-6 

select CustomerID, p.FirstName, p.LastName, e.EmailAddress
from Sales.Customer c
join Person.Person p
on c.PersonID = p.BusinessEntityID
join Person.EmailAddress e
on c.PersonID = e.BusinessEntityID
order by c.CustomerID;

/*or*/
select CustomerID, p.FirstName, p.LastName, e.EmailAddress
from Sales.Customer c
left join Person.Person p
on c.PersonID = p.BusinessEntityID
left join Person.EmailAddress e
on c.PersonID = e.BusinessEntityID
order by c.CustomerID;
