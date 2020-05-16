-- サンプル1用テーブル作成
DROP TABLE IF EXISTS 部品調達単価
GO


CREATE TABLE 部品調達単価(
	[ID] int IDENTITY(1,1) NOT NULL,
	部品名 nvarchar(50) NOT NULL,
	調達先名 nvarchar(50) NOT NULL,
	単価 int NOT NULL
) ON [PRIMARY]
GO

INSERT INTO 部品調達単価
           (部品名
           ,調達先名
           ,単価)
     VALUES
         (N'部品A',N'B社',100)
		,(N'部品A',N'A社',140)
		,(N'部品B',N'B社',200)
		,(N'部品C',N'A社',200)
		,(N'部品C',N'B社',180)
GO


SELECT *
FROM
　部品調達単価
GO

-- 『結果セットを部分的に切り出した領域に集約関数を適用できる、
-- 　拡張された SELECT ステートメントである。』とは？
SELECT
　部品名, 調達先名, 単価,
　AVG(単価) OVER(PARTITION BY 部品名) AS 平均
FROM
　部品調達単価
GO

-- 『結果セットの分割と順序を制御できる。』とは？
SELECT
　ID,部品名, 調達先名, 単価,
　ROW_NUMBER() OVER(PARTITION BY 部品名
					ORDER BY 単価) AS 行番号
FROM
　部品調達単価
GO

SELECT
　ID,部品名, 調達先名, 単価,
　ROW_NUMBER() OVER(PARTITION BY 部品名
					ORDER BY 単価 DESC) AS 行番号
FROM
　部品調達単価
GO

-- 順位付け関数
SELECT
　ID,部品名, 調達先名, 単価,
　ROW_NUMBER() OVER(ORDER BY 単価 DESC) AS "ROW_NUMBER",
　RANK() OVER(ORDER BY 単価 DESC) AS "RANK",
　DENSE_RANK() OVER(ORDER BY 単価 DESC) AS "DENSE_RANK"
FROM
　部品調達単価
GO

-- 集計関数
SELECT
　ID,部品名, 調達先名, 単価,
　COUNT(単価) OVER(PARTITION BY 部品名) AS 件数,
　SUM(単価) OVER(PARTITION BY 部品名) AS 合計,
　AVG(単価) OVER(PARTITION BY 部品名) AS 平均,
　MIN(単価) OVER(PARTITION BY 部品名) AS 最小,
　MAX(単価) OVER(PARTITION BY 部品名) AS 最大
FROM
　部品調達単価
GO

-- 分析関数
SELECT
　ID,部品名, 調達先名, 単価,
　LAG(単価,1) OVER(PARTITION BY 部品名 ORDER BY 単価) AS "LAG",
　LEAD(単価,1) OVER(PARTITION BY 部品名 ORDER BY 単価) AS "LEAD",
　FIRST_VALUE(単価) OVER(PARTITION BY 部品名 ORDER BY 単価) AS "FIRST_VALUE",
　LAST_VALUE(単価) OVER(PARTITION BY 部品名 ORDER BY 単価) AS "LAST_VALUE"
FROM
　部品調達単価
GO

-- LAG/LEADに規定値の指定がある場合、NULLの代わりに規定値を返す。
SELECT
　ID,部品名, 調達先名, 単価,
　LAG(単価,1) OVER(PARTITION BY 部品名 ORDER BY 単価) AS "LAG",
　LAG(単価,1, 0) OVER(PARTITION BY 部品名 ORDER BY 単価) AS "LAG(規定値：0)",
　LEAD(単価,1) OVER(PARTITION BY 部品名 ORDER BY 単価) AS "LEAD",
　LEAD(単価,1, 0) OVER(PARTITION BY 部品名 ORDER BY 単価) AS "LEAD(規定値：0)"
FROM
　部品調達単価
GO


-- GROUP BYを使った集計関数との違いは？
SELECT
　部品名, AVG(単価) AS 平均
FROM
　部品調達単価
GROUP BY
　部品名
GO

SELECT
　部品名, 調達先名, 単価,
　AVG(単価)  OVER(PARTITION BY 部品名) AS 平均
FROM
　部品調達単価
GO

-- Window関数と同じクエリをGROUP BYで表現すると。。。
SELECT
　単価.部品名, 単価.調達先名, 単価.単価, 平均単価.平均
FROM 部品調達単価 AS 単価
INNER JOIN (
	SELECT
　	 部品名, AVG(単価) AS 平均
	FROM
　	 部品調達単価
	GROUP BY
　	 部品名
	) AS 平均単価
	ON 単価.部品名 = 平均単価.部品名
GO

-- 評価順
SELECT
　ID,部品名, 調達先名, 単価,
　ROW_NUMBER() OVER(PARTITION BY 部品名
					ORDER BY 単価 DESC) AS "ROW_NUMBER"
FROM
　部品調達単価
ORDER BY 部品名, 単価
GO

SELECT
　ID,部品名, 調達先名, 単価,
　ROW_NUMBER() OVER(PARTITION BY 部品名
					ORDER BY 単価 DESC) AS "ROW_NUMBER"
FROM
　部品調達単価
ORDER BY 部品名, 単価 DESC
GO

SELECT
　ID,部品名, 調達先名, 単価,
　ROW_NUMBER() OVER(PARTITION BY 部品名
					ORDER BY 単価 DESC) AS "ROW_NUMBER"
FROM
　部品調達単価
GO

-- PARTITION BYの有無
-- 例1
SELECT
　部品名, 調達先名, 単価,
　AVG(単価) OVER(PARTITION BY 部品名) AS 平均
FROM
　部品調達単価
GO

SELECT
　部品名, 調達先名, 単価,
　AVG(単価) OVER() AS 平均
FROM
　部品調達単価
GO

-- 例2
SELECT
　ID,部品名, 調達先名, 単価,
　ROW_NUMBER() OVER(PARTITION BY 部品名
				    ORDER BY 単価) AS "ROW_NUMBER"
FROM
　部品調達単価
GO

SELECT
　ID,部品名, 調達先名, 単価,
　ROW_NUMBER() OVER(ORDER BY 単価) AS "ROW_NUMBER"
FROM
　部品調達単価
GO

-- ORDER BYの有無
-- 例1
SELECT
　ID,部品名, 調達先名, 単価,
　SUM(単価) OVER(PARTITION BY 部品名
				 ORDER BY 単価) AS 合計,
　AVG(単価) OVER(PARTITION BY 部品名
				 ORDER BY 単価) AS 平均
FROM
　部品調達単価
GO

SELECT
　ID,部品名, 調達先名, 単価,
　SUM(単価) OVER(PARTITION BY 部品名) AS 合計,
　AVG(単価) OVER(PARTITION BY 部品名) AS 平均
FROM
　部品調達単価
GO

SELECT
　ID,部品名, 調達先名, 単価,
　SUM(単価) OVER(PARTITION BY 部品名
				 ORDER BY 単価
				 RANGE BETWEEN UNBOUNDED PRECEDING
						   AND UNBOUNDED FOLLOWING) AS 合計,
　AVG(単価) OVER(PARTITION BY 部品名
				 ORDER BY 単価
				 RANGE BETWEEN UNBOUNDED PRECEDING
						   AND UNBOUNDED FOLLOWING) AS 平均
FROM
　部品調達単価
GO

-- 例2
SELECT
　ID,部品名, 調達先名, 単価,
　SUM(単価) OVER(ORDER BY 単価) AS 合計,
　AVG(単価) OVER(ORDER BY 単価) AS 平均
FROM
　部品調達単価
GO

SELECT
　ID,部品名, 調達先名, 単価,
　SUM(単価) OVER() AS 合計,
　AVG(単価) OVER() AS 平均
FROM
　部品調達単価
GO

SELECT
　ID,部品名, 調達先名, 単価,
　SUM(単価) OVER(ORDER BY 単価
				 RANGE BETWEEN UNBOUNDED PRECEDING
						   AND UNBOUNDED FOLLOWING) AS 合計,
　AVG(単価) OVER(ORDER BY 単価
				 RANGE BETWEEN UNBOUNDED PRECEDING
						   AND UNBOUNDED FOLLOWING) AS 平均
FROM
　部品調達単価
GO

SELECT
　ID,部品名, 調達先名, 単価,
　SUM(単価) OVER(PARTITION BY 部品名
				 RANGE BETWEEN UNBOUNDED PRECEDING
						   AND UNBOUNDED FOLLOWING) AS 合計,
　AVG(単価) OVER(PARTITION BY 部品名
				 RANGE BETWEEN UNBOUNDED PRECEDING
						   AND UNBOUNDED FOLLOWING) AS 平均
FROM
　部品調達単価
GO
