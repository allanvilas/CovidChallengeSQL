-- EXERCISE 3
CREATE OR REPLACE VIEW Cumulative_number_for_14_days_of_COVID_19_cases_per_100000 AS
SELECT VW.* FROM (	
	SELECT 
		TB.*
		,ROW_NUMBER() OVER(PARTITION BY TB.country,TB.Indicator ORDER BY TB.country,TB.WFD DESC) AS RN
	FROM 	
		(SELECT
			CASES.*
			,YK.yw_week_first_day AS WFD
			,YK.yw_week_last_day AS WLD
		FROM
			CASES
		LEFT JOIN dm_week_to_date AS YK ON (CASES.year_week = YK.year_week)
		WHERE 
		CASES.cumulative_count != 0
		AND indicator = 'cases'
		) AS TB
	) AS VW WHERE VW.RN = 1
