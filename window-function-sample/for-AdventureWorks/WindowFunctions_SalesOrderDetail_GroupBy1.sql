SELECT SalesOrderID
    , SUM(OrderQty) AS Total
    , AVG(OrderQty) AS "Avg"
    , COUNT(OrderQty) AS "Count"
    , MIN(OrderQty) AS "Min"
    , MAX(OrderQty)  AS "Max"
FROM Sales.SalesOrderDetail
WHERE SalesOrderID IN(43659,43664)
GROUP BY SalesOrderID
GO