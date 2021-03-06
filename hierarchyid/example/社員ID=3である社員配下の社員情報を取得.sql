
-- 社員ID=3である社員配下の社員情報を取得（親子IDの再帰CTEで取得）
WITH
    HIERARCHY (LoginID, EmployeeID, ManagerID, TreePath, HierarchyLevel) AS (
        SELECT
            ManagerOrg.LoginID,
            ManagerOrg.EmployeeID,
            ManagerOrg.ManagerID,
            ManagerOrg.OrgNode.ToString() TreePath,
            CAST(ManagerOrg.H_Level AS INT) HierarchyLevel
        FROM
            HumanResources.NewOrg ManagerOrg
        WHERE
            ManagerOrg.EmployeeID = 3
        UNION ALL
        SELECT
            NewOrg.LoginID,
            NewOrg.EmployeeID,
            NewOrg.ManagerID,
            NewOrg.OrgNode.ToString() TreePath,
            Hierarchy.HierarchyLevel + 1
        FROM
            HumanResources.NewOrg
            INNER JOIN
            HIERARCHY ON
            Hierarchy.EmployeeID = NewOrg.ManagerID
        )
SELECT
    LoginID,
    EmployeeID,
    ManagerID,
    TreePath [参考_TreePath],
    HierarchyLevel [参考_HierarchyLevel]
FROM
    HIERARCHY
ORDER BY
    EmployeeID
GO

-- 社員ID=3である社員配下の社員情報を取得（ツリー構造パスで取得）
SELECT
    NewOrg.LoginID,
    NewOrg.EmployeeID,
    NewOrg.ManagerID,
    NewOrg.OrgNode.ToString() [参考_TreePath],
    NewOrg.H_Level [参考_HierarchyLevel]
FROM
    HumanResources.NewOrg
    INNER JOIN
    HumanResources.NewOrg ManagerOrg ON
    NewOrg.OrgNode.ToString() LIKE ManagerOrg.OrgNode.ToString() + '%' AND
    ManagerOrg.EmployeeID = 3
ORDER BY
    NewOrg.EmployeeID
GO
