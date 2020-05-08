/*lab3-1*/
 SELECT c.CustomerID, c.TerritoryID,
 COUNT(o.SalesOrderid) [Total Orders],
 CASE
 	WHEN COUNT(o.SalesOrderid) = 0 THEN 'No Order'
 	WHEN COUNT(o.SalesOrderid) = 1 THEN 'One Time'
 	WHEN COUNT(o.SalesOrderid) IN (2,3,4,5) THEN 'Regular'
 	WHEN COUNT(o.SalesOrderid) IN (6,7,8,9,10)  THEN 'Often'
 	ELSE 'Loyal'
 	END AS FrequencyOfOrder
 FROM Sales.Customer c
 LEFT OUTER JOIN Sales.SalesOrderHeader o
 ON c.CustomerID = o.CustomerID
 WHERE DATEPART(year, OrderDate) = 2007
 GROUP BY c.TerritoryID, c.CustomerID;


/*lab3-2*/
SELECT c.CustomerID, c.TerritoryID,
COUNT(o.SalesOrderid) [Total Orders],
DENSE_RANK() OVER (PARTITION BY c.TerritoryID ORDER BY COUNT(o.SalesOrderid) DESC) AS Rank
FROM Sales.Customer c
LEFT OUTER JOIN Sales.SalesOrderHeader o
ON c.CustomerID = o.CustomerID
WHERE DATEPART(year, OrderDate) = 2007
GROUP BY c.TerritoryID, c.CustomerID;

/*lab3-3*/
WITH Cat AS
	(SELECT s.BusinessEntityID, DENSE_RANK() OVER (ORDER BY s.Bonus DESC) AS Ranks
	 FROM Sales.SalesPerson s 
	 JOIN HumanResources.Employee e ON s.BusinessEntityID = e.BusinessEntityID 
     JOIN Sales.SalesTerritory t ON s.TerritoryID = t.TerritoryID
     WHERE e.Gender = 'F' AND t.[Group]='North America') 
SELECT s.BusinessEntityID, s.Bonus
FROM Sales.SalesPerson s 
JOIN Cat  ON s.BusinessEntityID = Cat.BusinessEntityID
WHERE Cat.Ranks = 1;

/*lab3-4*/
WITH temp AS (
	SELECT S.SalesPersonID, SUM(S.TotalDue)AS MonthlyTotalSales, DATEPART(mm,S.OrderDate) AS OrderMonth,
	RANK() OVER (PARTITION BY DATEPART(mm,S.OrderDate) ORDER BY SUM(S.TotalDue) DESC ) AS Ranks
	FROM Sales.SalesOrderHeader S 
	WHERE DATEPART(yy,S.OrderDate) = 2007 AND S.SalesPersonID IS NOT NULL
	GROUP BY S.SalesPersonID, S.OrderDate
	)
SELECT temp.SalesPersonID, P.Bonus, Temp.MonthlyTotalSales, temp.OrderMonth
FROM temp JOIN Sales.SalesPerson P ON temp.SalesPersonID = P.BusinessEntityID
WHERE temp.Ranks = 1 
ORDER BY temp.OrderMonth DESC ;

/*lab3-5*/
WITH 
temp1 AS (
	SELECT D.SalesOrderID, P.ProductID, P.Color
	FROM Sales.SalesOrderDetail D JOIN Production.Product P ON D.ProductID = P.ProductID
	WHERE P.Color = 'Red'
),
temp2 AS (
	SELECT D.SalesOrderID, P.ProductID, P.Color
	FROM Sales.SalesOrderDetail D JOIN Production.Product P ON D.ProductID = P.ProductID
	WHERE P.Color = 'Yellow'	
)
SELECT DISTINCT H.CustomerID, H.AccountNumber
FROM Sales.SalesOrderHeader H
JOIN temp1 ON temp1.SalesOrderID = H.SalesOrderID
JOIN temp2 ON temp1.SalesOrderID = temp2.SalesOrderID
WHERE H.OrderDate >'2008-05-1'
ORDER BY  H.CustomerID DESC;



with a as (
SELECT CustomerID
FROM Sales.SalesOrderDetail D JOIN Production.Product P ON D.ProductID = P.ProductID
join Sales.SalesOrderHeader h
on h.SalesOrderID = d.SalesOrderID
WHERE P.Color = 'Red' and H.OrderDate >'2008-05-1'),
b as (
SELECT CustomerID
FROM Sales.SalesOrderDetail D JOIN Production.Product P ON D.ProductID = P.ProductID
join Sales.SalesOrderHeader h
on h.SalesOrderID = d.SalesOrderID
WHERE P.Color = 'Yellow' and H.OrderDate >'2008-05-1')

select distinct a.CustomerID
from a join b
on a.CustomerID = b.CustomerID
order by a.CustomerID;