-- —ÝÏWŒv
DROP TABLE IF EXISTS #”„ã
GO

SELECT * 
INTO #”„ã
FROM
  (
    VALUES
	   (1, '2020/10/1', N'Yamada', 100),
	   (2, '2020/10/2', N'Yamada', 150),
	   (3, '2020/10/2', N'Suzuki', 120),
	   (4, '2020/10/3', N'Suzuki', 200),
	   (5, '2020/10/5', N'Yamada', 80),
	   (6, '2020/10/4', N'Suzuki', 90),
	   (7, '2020/10/4', N'Tanaka', 110),
	   (8, '2020/10/5', N'Yamada', 50),
	   (9, '2020/10/6', N'Suzuki', 90),
	   (10, '2020/10/6', N'Tanaka', 40)
  ) AS Src(”„ãID, ”„ã“ú, ‰c‹Æ’S“–, ”„ãŠz)
GO

SELECT *
FROM
  #”„ã
GO

SELECT
    ‰c‹Æ’S“–,
	”„ã“ú,
	”„ãŠz,
	SUM(”„ãŠz) OVER (
	    PARTITION BY ‰c‹Æ’S“–
		ORDER BY ”„ã“ú, ”„ãID
		ROWS BETWEEN UNBOUNDED PRECEDING
		         AND  CURRENT ROW
				      ) AS —ÝÏ”„ãŠz
FROM	#”„ã
ORDER BY ‰c‹Æ’S“–, ”„ã“ú, ”„ãID
GO



-- ROWS‹å‚Å‚Ì‘‚«•û—á
-- ‡@ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
SELECT ROW_NUMBER() OVER(ORDER BY ”„ã“ú, ”„ãID) AS 'No.',
    ‰c‹Æ’S“–,
	”„ã“ú,
	”„ãŠz,
	SUM(”„ãŠz) OVER (
			       ORDER BY ”„ã“ú, ”„ãID
			       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS —ÝÏ”„ãŠz
FROM	#”„ã
ORDER BY ”„ã“ú, ”„ãID
GO

-- ‡AROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING
SELECT ROW_NUMBER() OVER(ORDER BY ”„ã“ú, ”„ãID) AS 'No.',
    ‰c‹Æ’S“–,
	”„ã“ú,
	”„ãŠz,
	SUM(”„ãŠz) OVER (
			       ORDER BY ”„ã“ú, ”„ãID
			       ROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING) AS —ÝÏ”„ãŠz
FROM	#”„ã
ORDER BY ”„ã“ú, ”„ãID
GO

-- ‡BROWS BETWEEN 1 PRECEDING AND 1 PRECEDING
SELECT ROW_NUMBER() OVER(ORDER BY ”„ã“ú, ”„ãID) AS 'No.',
    ‰c‹Æ’S“–,
	”„ã“ú,
	”„ãŠz,
	SUM(”„ãŠz) OVER (
			       ORDER BY ”„ã“ú, ”„ãID
			       ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING) AS —ÝÏ”„ãŠz
FROM	#”„ã
ORDER BY ”„ã“ú, ”„ãID
GO
