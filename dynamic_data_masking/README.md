# 動的データマスキング / Dynamic Data Masking（DDM）

## 使用可能バージョン
- SQL Server 2016以降

## 公式ドキュメント
- 動的データマスキング (SQL Server)
  - https://docs.microsoft.com/ja-jp/sql/relational-databases/security/dynamic-data-masking
- 権限 (データベース エンジン)
  - https://docs.microsoft.com/ja-jp/sql/relational-databases/security/permissions-database-engine
- GRANT (Transact-SQL)
  - https://docs.microsoft.com/ja-jp/sql/t-sql/statements/grant-transact-sql

## 概要
- 動的データマスキング (DDM) にて指定フィールドをマスクすることにより、データベースのユーザーもしくはロールごとにクエリ結果のデータを制限できる。
- DDMは、クエリの結果にマスクルールが適用されるため、多くのアプリケーションは既存のクエリを変更せずに、デリケートなデータをマスクすることができる。
  - 例えば、クレジットカードの番号やマインナンバーなどシステム上は必要だが情報漏洩時のリスクが高い機密データにDDMを設定することで、データベースの権限レベルでアクセス可能なユーザーのみ機密データを参照可能とするシステムをアプリケーション側を考慮することなく実現できる。
- DDMでは、フルマスク、Email用マスク、数値データ用のランダムマスク、部分マスクなどに使用するカスタムマスクの4種類のマスク関数が存在し、テーブルの列定義で設定する。

## DDMの設定
#### マスクの種類
| 機能 | 説明 | 使用例 |
|----------------|-----------------------------------|--------------------------------------------------|
| 既定 | 指定のフィールドのデータ型に応じたフルマスクを行う。 | 列定義の構文例: `Phone#   varchar(12) MASKED WITH (FUNCTION = 'default()') NULL` |
| 　 | 文字列データ型 (char、 nchar、 varchar、 nvarchar、 text、 ntext) のフィールドのサイズが 4 文字未満の場合は、XXXX   またはそれ未満の数の X を使用する。  | `ALTER 構文例: ALTER COLUMN   Gender ADD MASKED WITH (FUNCTION = 'default()')` |
| 　 | 数値データ型 (bigint、 bit、 decimal、 int、 money、 numeric、smallint、 smallmoney、 tinyint、 float、 real) の場合は値 0 を使用する。 | 　 |
| 　 | 日付/時刻のデータ型 (date、 datetime2、 datetime、 datetimeoffset、smalldatetime、 time)   の場合は、01.01.1900 00:00:00.0000000 を使用する。 | 　 |
| 　 | バイナリデータ型 (binary、 varbinary、 image) の場合は、ASCII 値 0 のシングルバイトを使用する。 | 　 |
| Email | メールアドレスの最初の 1 文字と定数サフィックスの ".com" でメールアドレスをマスクする。（aXXX@XXXX.com） | 定義の構文例: `Email   varchar(100) MASKED WITH (FUNCTION = 'email()') NULL` |
| 　 | 　 | ALTER 構文例: `ALTER COLUMN   Email ADD MASKED WITH (FUNCTION = 'email()')` |
| ランダム | ランダムマスク関数は任意の数字型に使用でき、指定した範囲内で生成したランダムな値でオリジナルの値をマスクする。 | 定義の構文例: `Account_Number   bigint MASKED WITH (FUNCTION = 'random([start range], [end range])')` |
| 　 | 　 | ALTER 構文例: `ALTER COLUMN   [Month] ADD MASKED WITH (FUNCTION = 'random(1, 12)')` |
| カスタム文字列 | 間にカスタム埋め込み文字列を追加し、最初と最後の文字を除きマスク方する。 prefix,[padding],suffix | 定義の構文例: `FirstName   varchar(100) MASKED WITH (FUNCTION = 'partial(prefix,[padding],suffix)') NULL` |
| 　 | 注:元の文字列が全体をマスクするには短すぎる場合、プレフィックスまたはサフィックスの一部は公開されません。 | ALTER 構文例: `ALTER COLUMN   [Phone Number] ADD MASKED WITH (FUNCTION =   'partial(1,"XXXXXXX",0)')` |
| 　 | 　 | その他の例: |
| 　 | 　 | `ALTER COLUMN [Phone Number] ADD   MASKED WITH (FUNCTION = 'partial(5,"XXXXXXX",0)')` |
| 　 | 　 | `ALTER COLUMN [Social Security   Number] ADD MASKED WITH (FUNCTION = 'partial(0,"XXX-XX-",4)')` |

#### アクセス許可
- DDMを設定するために必要なアクセス許可
  - DDMでテーブルを作成するには、スキーマ アクセス許可に対する CREATE TABLE と ALTER のみ必要
  - 列のマスクを追加、置換、削除するには、 ALTER ANY MASK アクセス許可と、テーブルに対する ALTER アクセス許可が必要
- マスクが定義された列から、マスクを解除したデータを取得するために必要なアクセス許可
  - テーブルに対する SELECT アクセス許可と、UNMASK アクセス許可が必要
    - UNMASK アクセス許可を持たないユーザーは、マスクされたデータが表示される
- データベースに対する CONTROL アクセス許可には、 ALTER ANY MASK と UNMASK の両方のアクセス許可が含まれる

#### 制限事項と制約事項
- 次の列の型には、マスクルールを定義することはできない。
  - 暗号化された列 (常に暗号化されます)
  - FILESTREAM
  - COLUMN_SET、または列セットの一部であるスパース列
  - 計算列。ただし、計算列が MASK を所有する列に依存する場合は、計算列がマスクされたデータを返す。
- データマスクを持つ列を FULLTEXT インデックスのキーにできない。
- UNMASK アクセス許可のないユーザーの場合、非推奨とされている READTEXT、 UPDATETEXT、および WRITETEXT ステートメントは、DDM用に構成された列で適切に動作しない。
- DDMの追加は基になっているテーブルでのスキーマ変更として実装されるため、依存関係を持つ列では実行でない。
  - この制限を回避するには、最初に依存関係を削除してから、DDMを追加した後、依存関係を再作成する。
  - たとえば、依存関係がその列に依存するインデックスによるものである場合は、インデックスを削除し、マスクを追加してから、依存するインデックスを再作成する。
  
