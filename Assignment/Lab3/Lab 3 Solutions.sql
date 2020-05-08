
Lab 3-1

SELECT c.CustomerID,
       c.TerritoryID,
	   COUNT(soh.SalesOrderID) [Total Orders],
	   CASE
		  WHEN COUNT(soh.SalesOrderID) = 0
			 THEN 'No Order'
		  WHEN COUNT(soh.SalesOrderID) = 1
			 THEN 'One Time'
		  WHEN COUNT(soh.SalesOrderID) BETWEEN 2 AND 5
			 THEN 'Regular'
		  WHEN COUNT(soh.SalesOrderID) BETWEEN 6 AND 10
			 THEN 'Often'
		  ELSE 'Loyal'
	   END AS [Order Frequency]
FROM Sales.Customer c
LEFT OUTER JOIN Sales.SalesOrderHeader soh
ON c.CustomerID = soh.CustomerID
WHERE DATEPART(year, OrderDate) = 2007
GROUP BY c.TerritoryID, c.CustomerID;


Lab 3-2

SELECT c.CustomerID, c.TerritoryID,
	  COUNT(o.SalesOrderid) [Total Orders],
	  DENSE_RANK() OVER (PARTITION BY c.TerritoryID ORDER BY COUNT(o.SalesOrderid) DESC) [Rank]
FROM Sales.Customer c 
LEFT OUTER JOIN Sales.SalesOrderHeader o
	  ON c.CustomerID = o.CustomerID
WHERE DATEPART(year, OrderDate) = 2007 
GROUP BY c.TerritoryID, c.CustomerID;


Lab 3-3

SELECT TOP 1 WITH TIES  SP.BusinessEntityID, SP.Bonus AS HighestBonus
FROM [Sales].[SalesPerson] SP
JOIN [Sales].[SalesTerritory] ST
ON SP.TerritoryID = ST.TerritoryID
JOIN [HumanResources].[Employee] E
ON SP.BusinessEntityID = E.BusinessEntityID
WHERE E.Gender = 'F' AND ST.[Group] = 'North America'
ORDER BY SP.Bonus DESC;


Lab 3-4

select month, temp.SalesPersonID, round(TotalSale, 2) [Total Sales], Bonus from
(
  select month(OrderDate) Month, SalesPersonID, sum(TotalDue) TotalSale,
         rank() over (partition by month(OrderDate) order by sum(TotalDue) desc) as rank
  from Sales.SalesOrderHeader
  where SalesPersonID is not null and year(OrderDate) = 2007
  group by month(OrderDate), SalesPersonID) temp
join Sales.SalesPerson s
on temp.SalesPersonID = s.BusinessEntityID
where rank =1
order by month;


Lab 3-5

select sh.CustomerID, sh.AccountNumber
   from Sales.SalesOrderHeader sh
   join Sales.SalesOrderDetail sd
   on sh.SalesOrderID = sd.SalesOrderID
   join Production.Product p
   on sd.ProductID = p.ProductID
   where sh.OrderDate > '5-1-2008'
         and p.Color = 'Red'
intersect
   select sh.CustomerID, sh.AccountNumber
   from Sales.SalesOrderHeader sh
   join Sales.SalesOrderDetail sd
   on sh.SalesOrderID = sd.SalesOrderID
   join Production.Product p
   on sd.ProductID = p.ProductID
   where sh.OrderDate > '5-1-2008'
         and p.Color = 'Yellow'
order by CustomerID;


