-- EXERCISE 4: Querie 1

WITH Target_Date AS (
	SELECT YK.year_week AS DK
	FROM dm_week_to_date AS YK
	WHERE '2020-07-31' BETWEEN YK.yw_week_first_day AND YK.yw_week_last_day
),
Country_Rate AS (
	SELECT 
		*,
		(CASES.CUMULATIVE_COUNT / (CASES.POPULATION /1000)::REAL) AS PPRATE
	FROM
		CASES, Target_Date
	WHERE
		CASES.year_week = Target_Date.DK
	AND CASES.indicator = 'cases'
),
C_Filter AS (
	SELECT COUNTRY FROM Country_Rate
	WHERE Country_Rate.PPRATE = (SELECT MAX(PPRATE) FROM Country_Rate)
)
SELECT * FROM C_Filter

-- EXERCISE 4: Querie 2

WITH Target_Date AS (
	SELECT YK.year_week AS DK
	FROM dm_week_to_date AS YK
	WHERE '2020-07-31' BETWEEN YK.yw_week_first_day AND YK.yw_week_last_day
),
Country_Rate AS (
	SELECT 
		*,
		(CASES.CUMULATIVE_COUNT / (CASES.POPULATION /1000)::REAL) AS PPRATE
	FROM
		CASES, Target_Date
	WHERE
		CASES.year_week = Target_Date.DK
	AND CASES.indicator = 'cases'
),
C_Filter AS (
	
	SELECT 
		COUNTRY,
		PPRATE,
		RANK() OVER(PARTITION BY indicator ORDER BY PPRATE DESC) AS RN
	FROM Country_Rate
)
SELECT COUNTRY FROM C_Filter
WHERE RN <= 10

-- EXERCISE 4: Querie 3

WITH Country_Rate AS (
	SELECT TB.*,
		RANK() OVER(PARTITION BY COUNTRY ORDER BY PPRATE DESC) AS PP_RK
	FROM (
		SELECT 
			*,
			(CASES.CUMULATIVE_COUNT / (CASES.POPULATION /1000)::REAL) AS PPRATE
		FROM
			CASES
		WHERE
			CASES.indicator = 'cases'
		AND CASES.CUMULATIVE_COUNT >0 ) TB
),
Twenty_Richest AS (
	SELECT
		TB.*,
		RANK() OVER(ORDER BY GDP DESC) AS RK
	FROM
		(SELECT
			COUNTRY,
			GDP
		FROM 
			countries) AS TB
),
C_Filter AS (
	SELECT 
		TR.*,
		CT.PPRATE
	FROM Twenty_Richest AS TR LEFT JOIN Country_Rate CT ON (TR.COUNTRY LIKE CT.COUNTRY)
	WHERE TR.RK <= 20
	AND CT.PP_RK = 1
)
SELECT COUNTRY FROM C_Filter
ORDER BY
C_Filter.RK

-- EXERCISE 4: Querie 4

WITH Target_Date AS (
	SELECT YK.year_week AS DK
	FROM dm_week_to_date AS YK
	WHERE '2020-07-31' BETWEEN YK.yw_week_first_day AND YK.yw_week_last_day
),
Region_Group AS (
	SELECT 
		CT.REGION,
		SUM(CS.CUMULATIVE_COUNT)::REAL AS CASES,
		SUM(CT.POPULATION) AS POP,
		SUM(CT.POP_DENSITY) AS DENSITY
	FROM Target_Date AS DT, CASES AS CS JOIN COUNTRIES AS CT ON (CS.COUNTRY = CT.COUNTRY)
	WHERE CS.year_week = DT.DK
	GROUP BY (CT.REGION)
)
SELECT *,
	(CASES / POP)::REAL * 1000000 AS CASES_P_MI
FROM Region_Group

-- EXERCISE 4: Querie 5 FROM CASES TABLE

WITH Find_DPT AS (
	SELECT *,
		MD5(country::text || country_code::text || continent::text || population::text || indicator::text || year_week::text || source::text || note::text || weekly_count::text || cumulative_count::text || rate_14_day::text) AS HASH
	FROM CASES
),
Group_by_HASH AS (
	SELECT
		HASH
	FROM Find_DPT
	GROUP BY HASH
    HAVING COUNT(*) > 1
),
Identify AS (
	SELECT
		FD.ID,
		FD.HASH
	FROM Group_by_HASH AS GH, Find_DPT AS FD
	where FD.HASH = GH.HASH
),
To_delete AS (
	SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY HASH) AS RN
	FROM Identify
)

DELETE FROM CASES
WHERE ID IN (SELECT id FROM To_delete WHERE RN >1)

-- EXERCISE 4: Querie 5 FROM COUNTRIES TABLE
WITH Find_DPT AS (
	SELECT
		MD5(id::text || country::text || region::text || population::text || area::text || pop_density::text || coastline::text || net_migration::text || infant_mortality::text || gdp::text || literacy::text || phones::text || arable::text || crops::text || other::text || climate::text || birthrate::text || deathrate::text || agriculture::text || industry::text || service::text) AS HASH
	FROM countries
),
Group_by_HASH AS (
	SELECT
		HASH
	FROM Find_DPT
	GROUP BY HASH
    HAVING COUNT(*) > 1
),
Identify AS (
	SELECT
		FD.ID,
		FD.HASH
	FROM Group_by_HASH AS GH, Find_DPT AS FD
	where FD.HASH = GH.HASH
),
To_delete AS (
	SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY HASH) AS RN
	FROM Identify
)

DELETE FROM countries
WHERE ID IN (SELECT id FROM To_delete WHERE RN >1)

