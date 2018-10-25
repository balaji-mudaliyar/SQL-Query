--Lab 2 questions

--2.1
/* Select product id, name and selling start date for all products
 that started selling after 01/01/2005 and had a red color.
 Use the CAST function in the SELECT clause to display the date
 only for the selling start date. Use an alias to create a
 meaningful column heading if a column heading is missing.
 Sort the returned data by the selling start date.
 Hint: a: You need to work with the Production.Product table.
 b: The syntax for CAST is CAST(expression AS data_type),
 where expression is the column name we want to format and
 we can use DATE as data_type for this question to display
 just the date. */
USE AdventureWorks2008R2;
SELECT ProductID,Color, cast(SellStartDate as DATE ) as 'Date', Name[Product]
FROM Production.Product
WHERE Color IN ('Red') AND
SellStartDate > '2005-01-01'
ORDER BY SellStartDate;

--2-2
/* Write a query to retrieve the number of products that take two days
 to manufacture and have the black color. Use an alias to create a
 meaningful column haeding if a column heading is missing.

 Hint: Use the Production.Product table */
USE AdventureWorks2008R2;
SELECT COUNT(ProductID) as 'Number of Product'
FROM Production.Product
WHERE Color IN ('Black') AND
DaysToManufacture = 2;


--2-3
/* Write a query to select the product id, name, and list price
 for the product(s) that have a list price greater than the
 average list price plus $10. Sort the returned data by the
 list price in descending.
 Hint: You’ll need to use a simple subquery to get the average
 list price and use it in a WHERE clause. */
USE AdventureWorks2008R2;
SELECT ProductID, Name[Product], ListPrice
FROM Production.Product
WHERE ListPrice > (SELECT AVG(ListPrice) from Production.Product) +10
ORDER BY ListPrice DESC;

--2-4
/* Write a query to retrieve the total quantity sold for the
 product(s) that have the red color. Include only products that have
 a total quantity sold greater than 2000. Include the product ID,
 product name, and total quantity sold columns in the report. Sort
 the returned data by the total quantity sold in the descending
 order.
 Hint: Use the Sales.SalesOrderDetail and Production.Product tables.
*/ 

USE AdventureWorks2008R2;
SELECT p.ProductID,
	   Name[product],
	   SUM(s.OrderQty) as TotalQuantitySold,
	   p.Color	   
FROM Production.Product as p INNER JOIN Sales.SalesOrderDetail as s
ON s.ProductID = p.ProductID
WHERE Color IN ('Red') 
GROUP BY p.ProductID, p.color,p.name
HAVING SUM(s.OrderQty) > 2000
ORDER BY TotalQuantitySold DESC;

--2-5
/* Write a query to retrieve the unique customers who have purchased
both Product ID 710 and Product ID 715 but have never purchased
Product ID 716. Include only the customer id in the returned data.
Sort the returned data by the customer id. */

--Answer 1 - Main Answer
SELECT
	oh.CustomerID
FROM 
	Sales.SalesOrderDetail AS od 
INNER JOIN Sales.SalesOrderHeader AS oh ON
	od.SalesOrderID = oh.SalesOrderID
WHERE 
	od.productID IN ('710','715')
	AND od.SalesOrderID NOT IN (
	SELECT
		SalesOrderID
	FROM
		Sales.SalesOrderDetail
	WHERE
		ProductID IN (716))
GROUP BY
	CustomerID
HAVING 
	COUNT(DISTINCT productID) = 2
ORDER BY
	oh.CustomerID;


-- Answer 2	- tried in different way
SELECT
	oh.CustomerID
FROM 
	Sales.SalesOrderDetail AS od 
INNER JOIN Sales.SalesOrderHeader AS oh ON
	od.SalesOrderID = oh.SalesOrderID
WHERE 
	od.productID IN ('710','715')	
GROUP BY CustomerID
HAVING COUNT(DISTINCT productID) = 2
EXCEPT
SELECT oh.CustomerID
FROM Sales.SalesOrderDetail as od INNER JOIN Sales.SalesOrderHeader as oh
ON od.SalesOrderID = oh.SalesOrderID
WHERE productID in ('716')


--2-6 
/* Write a query to retrieve the highest and lowest order values for each customer.
Include the customer id, customer's lastname, firstname, lowest and highest order values in the report.
Sort the returned data by the customer id. */


SELECT oh.CustomerID,
 	   pp.FirstName,
	   pp.LastName,	   
	   MIN(Totaldue) AS "Lowest Order",	
	   MAX(Totaldue) AS "Highest Order"
FROM Sales.SalesOrderHeader as oh INNER JOIN Sales.Customer as sc
ON oh.CustomerID = sc.CustomerID
INNER JOIN Person.Person as pp
    ON pp.BusinessEntityID = sc.PersonID
GROUP By pp.FirstName, oh.CustomerID,sc.PersonID, pp.BusinessEntityID,pp.LastName
ORDER BY oh.CustomerID;


