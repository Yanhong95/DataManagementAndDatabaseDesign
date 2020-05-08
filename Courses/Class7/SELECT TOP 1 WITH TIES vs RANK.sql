
/* Retrieve the customer(s) who have placed the most orders */

-- Use SELECT TOP 1, but missing ties

SELECT TOP 1 CustomerID, COUNT(SalesOrderID) TotalOrder
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY TotalOrder DESC;

SELECT CustomerID, COUNT(SalesOrderID) TotalOrder
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY TotalOrder DESC;

-- SELECT TOP 1 WITH TIES can pick up a tie

SELECT TOP 1 WITH TIES CustomerID, COUNT(SalesOrderID) TotalOrder
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY TotalOrder DESC;

-- Use RANK

SELECT CustomerID, TotalOrder FROM
(SELECT CustomerID, COUNT(SalesOrderID) TotalOrder,
 RANK() OVER (ORDER BY COUNT(SalesOrderID) DESC) AS CustomerRank 
 FROM Sales.SalesOrderHeader
 GROUP BY CustomerID
 ) temp
WHERE CustomerRank = 1; 


/* Retrieve the customer(s) who have placed the most orders for each sales territory*/

-- SELECT TOP 1, but missing ties

SELECT distinct TERRITORYID,
       (SELECT TOP 1  a.CustomerID
	    FROM Sales.SalesOrderHeader a
		WHERE a.TERRITORYID = b.TERRITORYID
	    GROUP BY TERRITORYID, CustomerID
		ORDER BY  COUNT(SalesOrderID) DESC --a.totaldue desc
	   ) OrderCount
FROM Sales.SalesOrderHeader b
ORDER BY TERRITORYID;

-- SELECT TOP 1 WITH TIES doesn't work

SELECT distinct TERRITORYID,
       (SELECT TOP 1 WITH TIES a.CustomerID
	    FROM Sales.SalesOrderHeader a
		WHERE a.TERRITORYID = b.TERRITORYID
	    GROUP BY TERRITORYID, CustomerID
		ORDER BY  COUNT(SalesOrderID) DESC
	   ) OrderCount
FROM Sales.SalesOrderHeader b
ORDER BY TERRITORYID;

-- RANK works swell with PARTITION BY 

SELECT TERRITORYID, CustomerID FROM
(SELECT TERRITORYID, CustomerID, COUNT(SalesOrderID) TotalOrder,
 RANK() OVER (PARTITION BY TERRITORYID  ORDER BY COUNT(SalesOrderID) DESC) AS CustomerRank 
 FROM Sales.SalesOrderHeader
 GROUP BY TERRITORYID, CustomerID) temp
WHERE CustomerRank = 1;

SELECT TERRITORYID, CustomerID, TotalOrder FROM
(SELECT TERRITORYID, CustomerID, COUNT(SalesOrderID) TotalOrder,
 RANK() OVER (PARTITION BY TERRITORYID  ORDER BY COUNT(SalesOrderID) DESC) AS CustomerRank 
 FROM Sales.SalesOrderHeader
 GROUP BY TERRITORYID, CustomerID) temp
WHERE CustomerRank = 1;


-- Horizontal format (Short list) using SELECT TOP 1 WITH TIES and FOR XML PATH

SELECT distinct TERRITORYID,
       STUFF(
	   (SELECT TOP 1 WITH TIES ', ' + CAST(a.CustomerID AS CHAR(5))
	    FROM Sales.SalesOrderHeader a
		WHERE a.TERRITORYID = b.TERRITORYID
	    GROUP BY TERRITORYID, CustomerID
		ORDER BY  COUNT(SalesOrderID) DESC --a.totaldue desc
		FOR XML PATH('')
	   ), 1, 2, '') OrderCount
FROM Sales.SalesOrderHeader b
ORDER BY TERRITORYID;

-- Horizontal format (Short list) using RANK and FOR XML PATH

WITH temp AS
(SELECT TERRITORYID, CustomerID,
 RANK() OVER (PARTITION BY TERRITORYID  ORDER BY COUNT(SalesOrderID) DESC) AS CustomerRank 
 FROM Sales.SalesOrderHeader
 GROUP BY TERRITORYID, CustomerID)
SELECT DISTINCT TERRITORYID, 
        STUFF((SELECT ', ' + CAST(CustomerID AS CHAR(5)) 
	    FROM temp 
		WHERE TERRITORYID = t1.TERRITORYID AND CustomerRank = 1 
		FOR XML PATH('')), 1,2,'')
FROM temp t1;


-- Use SELECT TOP 1 WITH TIES in a function and CROSS APPLY

create function dbo.ufGetTerritoryTopCustomer
     (@tid int)
	 returns table as
	   return
         SELECT TOP 1 WITH TIES TERRITORYID, CustomerID
	     FROM Sales.SalesOrderHeader
		 WHERE TERRITORYID = @tid
	     GROUP BY TERRITORYID, CustomerID
		 ORDER BY  COUNT(SalesOrderID) DESC;

SELECT distinct s.TERRITORYID, u.CustomerID
FROM Sales.SalesOrderHeader s
CROSS APPLY dbo.ufGetTerritoryTopCustomer(TERRITORYID) u
ORDER BY s.TERRITORYID;



