-- �ݐϏW�v
DROP TABLE IF EXISTS #����
GO

SELECT * 
INTO #����
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
  ) AS Src(����ID, �����, �c�ƒS��, ����z)
GO

SELECT *
FROM
  #����
GO

SELECT
    �c�ƒS��,
	�����,
	����z,
	SUM(����z) OVER (
	    PARTITION BY �c�ƒS��
		ORDER BY �����, ����ID
		ROWS BETWEEN UNBOUNDED PRECEDING
		         AND  CURRENT ROW
				      ) AS �ݐϔ���z
FROM	#����
ORDER BY �c�ƒS��, �����, ����ID
GO



-- ROWS��ł̏�������
-- �@ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
SELECT ROW_NUMBER() OVER(ORDER BY �����, ����ID) AS 'No.',
    �c�ƒS��,
	�����,
	����z,
	SUM(����z) OVER (
			       ORDER BY �����, ����ID
			       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS �ݐϔ���z
FROM	#����
ORDER BY �����, ����ID
GO

-- �AROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING
SELECT ROW_NUMBER() OVER(ORDER BY �����, ����ID) AS 'No.',
    �c�ƒS��,
	�����,
	����z,
	SUM(����z) OVER (
			       ORDER BY �����, ����ID
			       ROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING) AS �ݐϔ���z
FROM	#����
ORDER BY �����, ����ID
GO

-- �BROWS BETWEEN 1 PRECEDING AND 1 PRECEDING
SELECT ROW_NUMBER() OVER(ORDER BY �����, ����ID) AS 'No.',
    �c�ƒS��,
	�����,
	����z,
	SUM(����z) OVER (
			       ORDER BY �����, ����ID
			       ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING) AS �ݐϔ���z
FROM	#����
ORDER BY �����, ����ID
GO
