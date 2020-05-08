/* 3 */
WITH temp1 AS(
	SELECT SUM(S.OrderQty) AS TotalQuantitySold 
	FROM Sales.SalesOrderDetail S 
	JOIN Sales.SalesOrderHeader O ON S.SalesOrderID = O.SalesOrderID
	JOIN Sales.SalesPerson P ON O.SalesPersonID = P.BusinessEntityID
	WHERE P.TerritoryID = 1),
temp2 AS(
	SELECT SUM(S.OrderQty) AS TotalQuantitySold 
	FROM Sales.SalesOrderDetail S 
	JOIN Sales.SalesOrderHeader O ON S.SalesOrderID = O.SalesOrderID
	JOIN Sales.SalesPerson P ON O.SalesPersonID = P.BusinessEntityID
	WHERE P.TerritoryID = 2
)
SELECT  (SELECT  TotalQuantitySold from temp2) - (select TotalQuantitySold from temp1)  as 'Difference';

/* 4 */

SELECT DISTINCT T.TerritoryID, T.Name, MAX(O.TotalDue) AS hishestOderValue
FROM Sales.SalesOrderDetail S 
JOIN Sales.SalesOrderHeader O ON S.SalesOrderID = O.SalesOrderID
JOIN Sales.SalesPerson P ON O.SalesPersonID = P.BusinessEntityID
JOIN Sales.SalesTerritory T ON P.TerritoryID = T.TerritoryID
GROUP BY T.TerritoryID, T.Name
HAVING  MAX(O.TotalDue) < 120000 
ORDER BY T.TerritoryID ASC;


/* 5 */
WITH Temp AS(
SELECT p.Color, p.ProductID, p.Name,SUM(od.OrderQty) AS totalQuantitySold,
RANK( )OVER (PARTITION BY p.Color ORDER BY SUM(od.OrderQty) DESC)  AS Popular
FROM Production.Product p
JOIN Sales.SalesOrderDetail od
ON p.ProductID = od.ProductID
JOIN Sales.SalesOrderHeader o
ON od.SalesOrderID = o.SalesOrderID
WHERE p.Color IS NOT NULL
GROUP BY p.Color, p.ProductID, p.Name
)
SELECT * FROM Temp
WHERE Popular = 1
ORDER BY Temp.Color;
