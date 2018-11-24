CREATE TABLE HumanResources.NewOrg  
(  
  OrgNode hierarchyid,  
  EmployeeID int,  
  LoginID nvarchar(50),  
  ManagerID int  
CONSTRAINT PK_NewOrg_OrgNode  
  PRIMARY KEY CLUSTERED (OrgNode)  
);  
GO  