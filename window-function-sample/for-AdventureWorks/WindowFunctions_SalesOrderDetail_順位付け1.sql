SELECT SalesOrderID, ProductID, OrderQty
    ,ROW_NUMBER() OVER (ORDER BY OrderQty DESC) AS "Row Number"  
    ,RANK() OVER (ORDER BY OrderQty DESC) AS "Rank"
    ,DENSE_RANK() OVER (ORDER BY OrderQty DESC) AS "Dense Rank"  
    ,NTILE(4) OVER (ORDER BY OrderQty DESC) AS Quartile
FROM Sales.SalesOrderDetail   
WHERE SalesOrderID IN(43659,43664)
GO