
-- SELECT TOP WITH TIES and CROSS APPLY

/* Retrieve the customer(s) who have placed the most orders for each sales territory*/

-- SELECT TOP 1 WITH TIES doesn't work
-- The correlated subquery could return more than one row

SELECT DISTINCT TERRITORYID,
       (SELECT TOP 1 WITH TIES a.CustomerID
	    FROM Sales.SalesOrderHeader a
		WHERE a.TERRITORYID = b.TERRITORYID
	    GROUP BY TERRITORYID, CustomerID
		ORDER BY  COUNT(SalesOrderID) DESC
	   ) OrderCount
FROM Sales.SalesOrderHeader b
ORDER BY TERRITORYID;

-- Use SELECT TOP 1 WITH TIES in a derived table created by the correlated subquery and CROSS APPLY

SELECT DISTINCT s.TERRITORYID, u.CustomerID
FROM Sales.SalesOrderHeader s
CROSS APPLY
(   SELECT TOP 1 WITH TIES TERRITORYID, CustomerID
	FROM Sales.SalesOrderHeader
	WHERE TERRITORYID = s.TERRITORYID
	GROUP BY TERRITORYID, CustomerID
	ORDER BY  COUNT(SalesOrderID) DESC) u;

-- Use SELECT TOP 1 WITH TIES in a function and CROSS APPLY

CREATE FUNCTION dbo.ufGetTerritoryTopCustomer
     (@tid int)
	 RETURNS TABLE AS
	   RETURN
         SELECT TOP 1 WITH TIES TERRITORYID, CustomerID
	     FROM Sales.SalesOrderHeader
		 WHERE TERRITORYID = @tid
	     GROUP BY TERRITORYID, CustomerID
		 ORDER BY  COUNT(SalesOrderID) DESC;

-- Use the function and CROSS APPLY

SELECT DISTINCT s.TERRITORYID, u.CustomerID
FROM Sales.SalesOrderHeader s
CROSS APPLY dbo.ufGetTerritoryTopCustomer(TERRITORYID) u
ORDER BY s.TERRITORYID;

-- DROP FUNCTION dbo.ufGetTerritoryTopCustomer


