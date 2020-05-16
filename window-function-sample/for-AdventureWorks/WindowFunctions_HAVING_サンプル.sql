SELECT SalesOrderID
, SUM(OrderQty) AS SubTotal  
FROM Sales.SalesOrderDetail  
WHERE SalesOrderID IN(43659,43664)
GROUP BY SalesOrderID  
HAVING SUM(OrderQty) > 20  
ORDER BY SalesOrderID
GO