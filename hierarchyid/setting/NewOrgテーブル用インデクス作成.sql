ALTER TABLE HumanResources.NewOrg   
   ADD H_Level AS OrgNode.GetLevel() ;  
CREATE UNIQUE INDEX EmpBFInd   
   ON HumanResources.NewOrg(H_Level, OrgNode) ;  
GO

CREATE UNIQUE INDEX EmpIDs_unq ON HumanResources.NewOrg(EmployeeID) ;  
GO