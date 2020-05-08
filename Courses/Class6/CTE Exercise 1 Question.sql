
USE Northwind;

/*
CTE Exercise 1
  1. Use a CTE to gather the following information:
	* CategoryID
    * CategoryName
    * Average price of all Products in that category
	HINT: You will need to incorporate either a join or correlated
	      subquery in the CTE itself to get the info.
  2. Join the CTE with Products in the SELECT statement below to
		include the category name and average price in the SELECT
		statement.
  3. Add an additional expression in the SELECT statement to show
		the difference between the Product Price (UnitPrice) and the
        category average price.
*/

SELECT ProductID
	  ,ProductName
	  ,CategoryID
	  ,UnitPrice
FROM Products;
----------------------------------------------------------------------------------

