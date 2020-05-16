SELECT SalesOrderDetailID
, SalesOrderID
, ProductID
, OrderQty
FROM Sales.SalesOrderDetail
WHERE SalesOrderID IN(43659,43664)
GO