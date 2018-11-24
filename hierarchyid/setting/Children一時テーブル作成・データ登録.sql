if OBJECT_ID('#Children') is not null
  drop table #Children

CREATE TABLE #Children
(  
    EmployeeID int,  
    ManagerID int,  
    Num int  
);  
GO 

CREATE CLUSTERED INDEX tmpind ON #Children(ManagerID, EmployeeID);  
GO

INSERT #Children (EmployeeID, ManagerID, Num)  
SELECT EmployeeID, ManagerID,  
  ROW_NUMBER() OVER (PARTITION BY ManagerID ORDER BY ManagerID)   
FROM HumanResources.EmployeeDemo  
GO

SELECT * FROM #Children ORDER BY ManagerID, Num  
GO

WITH paths(path, EmployeeID)   
AS (  
-- This section provides the value for the root of the hierarchy  
SELECT hierarchyid::GetRoot() AS OrgNode, EmployeeID   
FROM #Children AS C   
WHERE ManagerID IS NULL   

UNION ALL   
-- This section provides values for all nodes except the root  
SELECT   
CAST(p.path.ToString() + CAST(C.Num AS varchar(30)) + '/' AS hierarchyid),   
C.EmployeeID  
FROM #Children AS C   
JOIN paths AS p   
   ON C.ManagerID = P.EmployeeID   
)  
INSERT HumanResources.NewOrg (OrgNode, O.EmployeeID, O.LoginID, O.ManagerID)  
SELECT P.path, O.EmployeeID, O.LoginID, O.ManagerID  
FROM HumanResources.EmployeeDemo AS O   
JOIN Paths AS P   
   ON O.EmployeeID = P.EmployeeID  
GO