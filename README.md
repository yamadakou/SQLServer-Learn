# SQL Server 技術獲得用リポジトリ

## 目的
- ソフトウェアの開発者視点で気になる `SQL Server` 固有の技術について、学習した内容を展開する。

## 対象技術（随時更新）
### データ型
  - hierarchyid（SQL Server 2008以降）
    - 参考：http://d.hatena.ne.jp/matu_tak/20100205/1265299001

  - ユーザー定義テーブル型（User-Defined Table Type）とテーブル値パラメータ（Table-Valued Parameters）
    - 参考：http://d.hatena.ne.jp/matu_tak/20100204/1265298788
    - 参考：http://d.hatena.ne.jp/matu_tak/20100204/1265298789

### ステートメント
  - MERGE ステートメント（SQL Server 2008以降）
    - 参考：http://d.hatena.ne.jp/matu_tak/20100124/1264361341

### 関数
  - GROUPING SETS 関数（SQL Server 2008以降）
    - 参考：http://d.hatena.ne.jp/matu_tak/20100203/1265298337
    - 参考：http://d.hatena.ne.jp/matu_tak/20100203/1265298338

  - ウィンドウ操作（OVER句）（SQL Server 2012以降）
    - 参考：https://docs.microsoft.com/ja-jp/previous-versions/sql/sql-server-2012/ms189461(v%3dsql.110)

### JSON対応（SQL Server 2016以降）
  - 参考：https://qiita.com/tenn25/items/ce562c5447ffcbb8149c

### 動的データマスク（SQL Server 2016以降）
  - 参考：https://qiita.com/tenn25/items/ce562c5447ffcbb8149c

### 並列クエリ
- 参考：https://technet.microsoft.com/ja-jp/library/ms178065(v=sql.105).aspx

- [SELECT]や[SELECT INTO]のパラレル化（SQL Server 2014以降）
  - 参考：https://sqlperformance.com/2013/08/t-sql-queries/parallel-select-into
  - 参考：https://blog.engineer-memo.com/2013/06/29/sql-server-2014-ctp-1-%E3%81%AE%E6%96%B0%E6%A9%9F%E8%83%BD%E3%82%92%E4%BD%BF%E3%81%A3%E3%81%A6%E3%81%BF%E3%82%8B-tsql-%E3%81%AE%E6%8B%A1%E5%BC%B5/

- [INSERT～SELECT]のパラレル化（SQL Server 2016以降）
  - 参考：https://qiita.com/tenn25/items/ce562c5447ffcbb8149c
  - 参考：https://blogs.msdn.microsoft.com/dataplatjp/2016/10/05/sql-server-2016-%E6%96%B0%E6%A9%9F%E8%83%BD-%E3%80%80insertselect-%E3%81%AE%E3%83%91%E3%83%A9%E3%83%AC%E3%83%AB%E5%87%A6%E7%90%86/

### グラフ処理（SQL Server 2017以降）
  - 参考：https://docs.microsoft.com/ja-jp/sql/relational-databases/graphs/sql-graph-overview

## 展開先
- サンプル用DBは基本的にMS公式の「AdventureWorks」を使用する。
  - 準備方法はMS Doc「[AdventureWorks のインストールと構成](https://docs.microsoft.com/ja-jp/sql/samples/adventureworks-install-configure)」を参照
    - https://docs.microsoft.com/ja-jp/sql/samples/adventureworks-install-configure

- hierarchyid
  - hierarchyid([hierarchyidのページ])
