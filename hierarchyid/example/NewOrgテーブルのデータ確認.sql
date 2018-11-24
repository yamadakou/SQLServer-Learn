SELECT
    OrgNode.ToString() AS TreePath,
    NewOrg.*
FROM
    HumanResources.NewOrg
ORDER BY
    TreePath;
