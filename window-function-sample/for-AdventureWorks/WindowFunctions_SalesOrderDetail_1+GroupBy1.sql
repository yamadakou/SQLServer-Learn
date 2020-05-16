SELECT SalesOrderDetailID
, Sales.SalesOrderDetail.SalesOrderID
, ProductID
, OrderQty
, SalesOrderSummary.Total
, SalesOrderSummary.[Avg]
, SalesOrderSummary.[Count]
, SalesOrderSummary.[Min]
, SalesOrderSummary.[Max]
FROM Sales.SalesOrderDetail
    INNER JOIN (
	SELECT SalesOrderID
		, SUM(OrderQty) AS Total
		, AVG(OrderQty) AS "Avg"
		, COUNT(OrderQty) AS "Count"
		, MIN(OrderQty) AS "Min"
		, MAX(OrderQty)  AS "Max"
    FROM Sales.SalesOrderDetail
    WHERE SalesOrderID IN(43659,43664)
    GROUP BY SalesOrderID
	) AS SalesOrderSummary
    ON SalesOrderSummary.SalesOrderID = Sales.SalesOrderDetail.SalesOrderID
WHERE Sales.SalesOrderDetail.SalesOrderID IN(43659,43664)
GO