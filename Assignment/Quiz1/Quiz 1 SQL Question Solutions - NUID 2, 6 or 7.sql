

--------- Question 3 (2 points) ---------

select (select sum(OrderQty)
from Sales.SalesOrderDetail sd
join Sales.SalesOrderHeader sh
on sd.SalesOrderID = sh.SalesOrderID
where sh.TerritoryID = 1)
-
(select sum(OrderQty)
from Sales.SalesOrderDetail sd
join Sales.SalesOrderHeader sh
on sd.SalesOrderID = sh.SalesOrderID
where sh.TerritoryID = 2);



-------- Question 4 (2 points) --------

select t.TerritoryID, Name, round(max(TotalDue), 2) HighestOrderValue
from Sales.SalesTerritory t
join Sales.SalesOrderHeader sh
on t.TerritoryID = sh.TerritoryID
where t.TerritoryID not in
(select TerritoryID
 from Sales.SalesOrderHeader
 where TotalDue > 120000)
group by t.TerritoryID, name
order by t.TerritoryID;



 -------- Question 5 (3 points) --------

with temp as 
(select Color, p.ProductID, Name, sum(OrderQty) TotalSoldQuantity,
        rank() over (partition by color order by sum(OrderQty) desc) Popularity
from Sales.SalesOrderDetail sd
join Production.Product p
on sd.ProductID = p.ProductID
where Color is not null
group by Color, p.ProductID, Name)

select * from temp where Popularity = 1
order by color;

