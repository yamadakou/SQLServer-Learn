-- 移動平均
DROP TABLE IF EXISTS #売上
GO

SELECT * 
INTO #売上
FROM
  (
    VALUES
      (N'201910', 100),
      (N'201911', 200),
      (N'201912', 300),
      (N'202001', 200),
      (N'202002', 400),
      (N'202003', 200)
  ) AS Src(年月, 売上額)
GO


SELECT *
FROM
  #売上
GO

-- 移動平均（BETWEENを使う場合）
SELECT *,
  SUM(売上額) OVER(
    ORDER BY
      年月 ROWS BETWEEN 2 PRECEDING
                    AND CURRENT ROW
  ) AS 直近3ヶ月の合計,
  AVG(売上額) OVER(
    ORDER BY
      年月 ROWS BETWEEN 2 PRECEDING
                    AND CURRENT ROW
  ) AS 直近3ヶ月の移動平均
FROM
  #売上
ORDER BY
  年月
GO


-- 移動平均（BETWEENを使わない場合）
SELECT *,
  SUM(売上額) OVER(
    ORDER BY
      年月 ROWS 2 PRECEDING
  ) AS 直近3ヶ月の合計,
  AVG(売上額) OVER(
    ORDER BY
      年月 ROWS 2 PRECEDING
  ) AS 直近3ヶ月の移動平均
FROM
  #売上
ORDER BY
  年月
GO
