/* 2-1 Write a query to retrieve all orders made after May 1, 2008
 and had an total due value greater than $50,000. Include
 the customer id, sales order id, order date and total due columns
 in the returned data.*/
SELECT CustomerID,(CAST(OrderDate AS DATE)) AS 'OrderDate' , SalesOrderID ,(ROUND(TotalDue,2)) AS 'TotalDue'
FROM Sales.SalesOrderHeader
WHERE TotalDue > 50000 AND OrderDate >'2008-05-1';

/* 2-2 List the latest order date and total number of orders for each customer. Include only the customer ID, account number, latest
order date and the total number of orders in the report.
Display date only for the order date. Use column aliases
to make the report more presentable. Sort the returned data
by the customer id. */
SELECT CustomerID, AccountNumber, max(OrderDate) as LatestOrderDate, COUNT(SalesOrderID) AS "TotalNumberOfOrders"
FROM Sales.SalesOrderHeader 
group by CustomerID, AccountNumber
ORDER BY CustomerID;

/* 2-3 Write a query to select the product id, name, and list price
for the product(s) that have a list price greater than the
the list price of the product 912. Display only two decimal
places for the ist price and make sure all columns have a descriptive
heading. Sort the returned data by the list price in descending.*/
SELECT ProductID, Name, (ROUND(ListPrice,2)) AS ListPrice
FROM Production.Product
WHERE ListPrice > (SELECT ListPrice FROM Production.Product WHERE ProductID = 912)
ORDER BY ListPrice DESC;

/* 2-4 Write a query to retrieve the number of times a product has
been sold for each product. Note it's the number of times a
product has been contained in an order, not the sold quantity.
Include only the products that have been sold more than 5 times.
Use a column alias to make the report more presentable. Sort the returned data by the number of times a product
has been sold in the descending order first, then the
product id in the ascending order. Include the product ID,
product name and number of times a product has been sold columns
in the report.*/
select S.ProductID,P.Name,count(1) AS 'NumberOfTimesAProductHasBeenSold'
from Sales.SalesOrderDetail S JOIN Production.Product P
ON S.ProductID = P.ProductID
group by S.ProductID,P.Name
having count(1)>5 
order by 'NumberOfTimesAProductHasBeenSold' DESC, S.ProductID ASC;

 /* 2-5 Write a query to generate a unique list of customer ID's and
 account numbers that have not placed an order after January 1, 2008.*/ 
SELECT DISTINCT CustomerID, AccountNumber FROM Sales.SalesOrderHeader
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Sales.SalesOrderHeader WHERE OrderDate >='2008-01-1')
ORDER BY CustomerID DESC ;

/* Write a query to create a report containing customer id,
first name, last name and email address for all customers.
Sort the returned data by CustomerID in ascending. */

SELECT CustomerID, FirstName, LastName, EmailAddress
FROM Sales.Customer AS C
INNER JOIN Person.Person AS P ON C.PersonID = P.BusinessEntityID
INNER JOIN Person.EmailAddress E ON E.BusinessEntityID = P.BusinessEntityID
ORDER BY CustomerID ASC; 
