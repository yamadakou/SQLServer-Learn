# hierarchyid 型

## 使用可能バージョン
- SQL Server 2008以降

## 公式ドキュメント
- 階層データ (SQL Server)
  - https://docs.microsoft.com/ja-jp/sql/relational-databases/hierarchical-data-sql-server
- hierarchyid データ型の使用 (データベース エンジン)
  - https://technet.microsoft.com/ja-jp/library/bb677173(v=sql.105).aspx
- hierarchyid データ型メソッド リファレンス
  - https://docs.microsoft.com/ja-jp/sql/t-sql/data-types/hierarchyid-data-type-method-reference

## 概要
- hierarchyid データ型を使用することで、階層データの格納とクエリが容易にすることができる。
- hierarchyid データ型は、最も一般的な階層データであるツリー構造を表すために最適化している。
- hierarchyid 関数が用意されており、階層データのクエリや管理で使用するのに便利。

## 特徴
#### 一般的な操作に関する親/子と hierarchyid の比較
- サブツリーのクエリは、 hierarchyidを使用した方がはるかに高速です。
- 直接の子孫のクエリは、 hierarchyidを使用するとわずかに遅くなります。
- 非リーフ ノードの移動は、 hierarchyidを使用すると遅くなります。
- 非リーフ ノードを挿入する場合、およびリーフ ノードを挿入または移動する場合も、 hierarchyidを使用する場合と同様に複雑になります。

#### 次の条件に当てはまるときは、親/子を使用した方がよい場合があります。
- キーのサイズが非常に重要なとき。 同じノード数に対して、 hierarchyid 値が整数系 (smallint、 int、 bigint) の値以上であるとき。 これが、ごくまれに親/子を使用する場合の唯一の理由です。親/子構造の使用時に必要な共通テーブル式よりも、 hierarchyid の方が、I/O の局所性と CPU の複雑さにおいてはるかに優れているためです。
- 階層の複数セクションにわたるクエリをめったに実行しないとき。 つまり、通常のクエリが、階層内の単一ポイントのみを対象とするとき。 このようなケースでは、同じ場所への配置は重要でありません。 たとえば、個々の従業員の給与処理のみに組織テーブルを使用する場合、親/子の方が優れています。
- 非リーフ サブツリーが頻繁に移動し、かつパフォーマンスが非常に重要なとき。 親/子表現では、階層内の行の場所を変更すると、1 行のみが影響を受けます。 hierarchyid 使用時に行の場所を変更すると、 n 行が影響を受けます ( n は移動されるサブツリー内のノード数)。


※MSドキュメント「[階層データ (SQL Server)](https://docs.microsoft.com/ja-jp/sql/relational-databases/hierarchical-data-sql-server)」より抜粋


## 検証目的
- hierarchyid データ型の特徴である階層データの取得のSQLを、親子ID構造の場合に適用する再起CTEでのSQLとのコストを比較する。

## データ準備
- 「NewOrg」テーブルを用意する。
  - MS公式の以下チュートリアルの [「NewOrg テーブルの最適化」の「効率的な検索のため NewOrg テーブルにインデックスを付ける」](https://docs.microsoft.com/ja-jp/sql/relational-databases/tables/lesson-1-converting-a-table-to-a-hierarchical-structure?view=sql-server-2017#create-index-on-neworg-table-for-efficient-searches) まで実施し、以降の手順は行わない。 
  - レッスン 1:テーブルの階層構造への変換
    - https://docs.microsoft.com/ja-jp/sql/relational-databases/tables/lesson-1-converting-a-table-to-a-hierarchical-structure

## データ確認
### 「NewOrg」テーブルに格納されているデータを確認する。
#### 確認用SQL
```sql
SELECT
    OrgNode.ToString() AS TreePath,
    NewOrg.*
FROM
    HumanResources.NewOrg
ORDER BY
    TreePath;
```

## 検証実施
### マネージャーである指定の社員配下の社員情報を取得するSQLを比較
#### 検証用SQL
##### 親子ID構造の再帰CTEで取得するSQL
```sql
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
```

##### ツリー構造パスで取得するSQL
```sql
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
```

### 検証結果
- hierarchyid データ型を利用したツリー構造パスで取得するSQLの方がコストが僅かに低く、性能面では多少は有利と考える。
  - SQL実行時の実行計画（実行プラン）で確認したコスト値
    - 親子ID構造の再帰CTEで取得するSQL
      - 約0.028
    - ツリー構造パスで取得するSQL
      - 約0.022
- hierarchyid データ型を利用したツリー構造パスで取得するSQLの方が少ない実装量、かつ、CTEを使用する必要がないため、保守性が高いと考える。
