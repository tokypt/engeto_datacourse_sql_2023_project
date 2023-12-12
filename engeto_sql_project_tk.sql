-- czechia_payroll_filled
CREATE OR REPLACE VIEW czechia_payroll_filled AS
SELECT
	cp.value
	, cpvt.code AS value_code
	, cpvt.name AS value_name
	, cpu.name AS unit_name
	, cpc.name AS employee_calculation
	, cpib.name AS industry
	, cp.payroll_year
	, cp.payroll_quarter
FROM
	czechia_payroll AS cp
LEFT JOIN czechia_payroll_industry_branch AS cpib 
	ON	cp.industry_branch_code = cpib.code
LEFT JOIN czechia_payroll_calculation AS cpc 
	ON cp.calculation_code = cpc.code
LEFT JOIN czechia_payroll_unit AS cpu 
	ON cp.unit_code = cpu.code
LEFT JOIN czechia_payroll_value_type AS cpvt 
	ON cp.value_type_code = cpvt.code;

-- czechia_price_recount
CREATE OR REPLACE VIEW czechia_price_recount AS
SELECT 
	round(avg(cp.value), 2) AS commodity_value
	, cp.category_code AS commodity_code
	, cpc.name AS commodity_name
	, cpc.price_value AS commodity_volume
	, cpc.price_unit AS commodity_volume_unit
	, YEAR(cp.date_from) AS price_year
	, CASE 
			WHEN MONTH(cp.date_from) >= 10 THEN 4
			WHEN MONTH(cp.date_from) >= 7 THEN 3
			WHEN MONTH(cp.date_from) >= 4 THEN 2
			WHEN MONTH(cp.date_from) >= 1 THEN 1
			ELSE 'missing'
		END AS price_quarter
FROM czechia_price AS cp
LEFT JOIN czechia_price_category AS cpc 	
	ON cp.category_code = cpc.code
GROUP BY commodity_code, price_year, price_quarter

-- combining views
CREATE OR REPLACE TABLE t_tomas_kypta_project_SQL_primary_final AS
SELECT cpf.value, cpf.value_code, cpf.value_name, cpf.unit_name AS unit
, cpf.industry AS industry_or_measurement, cpf.payroll_year AS year, cpf.payroll_quarter AS quarter
FROM czechia_payroll_filled AS cpf 
UNION 
SELECT cpr.*
FROM czechia_price_recount AS cpr 

-- or like this (not equivalent):
CREATE OR REPLACE TABLE t_tomas_kypta_project_SQL_primary_final AS 
SELECT cpf.*, cpr.* 
FROM czechia_payroll_filled AS cpf 
LEFT JOIN czechia_price_recount AS cpr
	ON cpf.payroll_year = cpr.price_year
	AND cpf.payroll_quarter = cpr.price_quarter;

-- 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
SELECT
	value
	, LAG(value) OVER (PARTITION BY industry_or_measurement ORDER BY year) AS prev_year_value
   , value - LAG(value) OVER (PARTITION BY industry_or_measurement ORDER BY year) AS yearly_difference
	, value_name
	, unit
	, industry_or_measurement
	, year
FROM
	t_tomas_kypta_project_sql_primary_final AS dat
WHERE
	value_code = 5958
	AND industry_or_measurement IS NOT NULL
GROUP BY
	industry_or_measurement
	, year;

/* 
 * 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné 
 * období v dostupných datech cen a mezd?
 */
-- searching for bread and milk codes
SELECT *
FROM t_tomas_kypta_project_sql_primary_final
WHERE value_name LIKE '%chléb%';
SELECT *
FROM t_tomas_kypta_project_sql_primary_final
WHERE value_name LIKE '%mléko%';


SELECT 
	round(value / (SELECT value FROM t_tomas_kypta_project_sql_primary_final
	WHERE value_code = 111301 
	AND year = 2006 
	AND quarter = 1)) AS bread_for_wage
	, round(value / (SELECT value FROM t_tomas_kypta_project_sql_primary_final
	WHERE value_code = 114201 
	AND year = 2006 
	AND quarter = 1)) AS milk_for_wage
	, dat.*
FROM t_tomas_kypta_project_sql_primary_final AS dat
WHERE 
	year = 2006 
	AND quarter = 1
	AND value_code = 5958
UNION
SELECT 
	round(value / (SELECT value FROM t_tomas_kypta_project_sql_primary_final
	WHERE value_code = 111301 
	AND year = 2018 
	AND quarter = 2)) AS bread_for_wage
	, round(value / (SELECT value FROM t_tomas_kypta_project_sql_primary_final
	WHERE value_code = 114201 
	AND year = 2018 
	AND quarter = 2)) AS milk_for_wage
	, dat.*
FROM t_tomas_kypta_project_sql_primary_final AS dat
WHERE 
	year = 2018
	AND quarter = 2
	AND value_code = 5958
	
-- version with industry wages averaged for that time
SELECT 
	round(avg(value) / (SELECT value FROM t_tomas_kypta_project_sql_primary_final
	WHERE value_code = 111301 
	AND year = 2006 
	AND quarter = 1)) AS bread_for_wage
	, round(avg(value) / (SELECT value FROM t_tomas_kypta_project_sql_primary_final
	WHERE value_code = 114201 
	AND year = 2006 
	AND quarter = 1)) AS milk_for_wage
	, avg(value)
	, dat.value_name
	, dat.unit
	, dat.`year`
	, dat.quarter
FROM t_tomas_kypta_project_sql_primary_final AS dat
WHERE 
	year = 2006 
	AND quarter = 1
	AND value_code = 5958
GROUP BY 'year', quarter
UNION
SELECT 
	round(avg(value) / (SELECT value FROM t_tomas_kypta_project_sql_primary_final
	WHERE value_code = 111301 
	AND year = 2018 
	AND quarter = 2)) AS bread_for_wage
	, round(avg(value) / (SELECT value FROM t_tomas_kypta_project_sql_primary_final
	WHERE value_code = 114201 
	AND year = 2018 
	AND quarter = 2)) AS milk_for_wage
	, avg(value)
	, dat.value_name
	, dat.unit
	, dat.`year`
	, dat.quarter
FROM t_tomas_kypta_project_sql_primary_final AS dat
WHERE 
	year = 2018
	AND quarter = 2
	AND value_code = 5958
GROUP BY 'year', quarter;

/*
 * 3. Která kategorie potravin zdražuje nejpomaleji 
 * (je u ní nejnižší percentuální meziroční nárůst)?
 */

SELECT DISTINCT value_code
FROM t_tomas_kypta_project_sql_primary_final AS ttkpspf
WHERE value_code NOT IN (316, 5958);

SELECT round(sum(growth_percent),2) AS avg_growth, MIN(growth_percent) min_year_growth, value_name, unit, industry_or_measurement
FROM (
		SELECT
			 round(AVG(dat.value),2) AS avg_value
			, dat2.year_value
			, round( ( round(AVG(dat.value),2) - dat2.year_value ) / dat2.year_value * 100, 2 ) as growth_percent
			, dat.value_name
			, dat.unit
			, dat.industry_or_measurement
			, dat.year
			, dat2.YEAR AS prev_year
		FROM
			t_tomas_kypta_project_sql_primary_final AS dat
		LEFT JOIN 
			(SELECT
				round(avg(value),2) AS year_value
				, value_name
				, unit
				, industry_or_measurement
				, year
			FROM
				t_tomas_kypta_project_sql_primary_final
			WHERE
				value_code NOT IN (316, 5958)
				AND industry_or_measurement IS NOT NULL
				GROUP BY YEAR,value_name) AS dat2
			ON dat.value_name = dat2.value_name
			AND dat.year = dat2.year + 1
		WHERE
			dat.value_code NOT IN (316, 5958)
			AND dat.year >= 2007
		GROUP BY dat.`year`, dat.value_name
	) AS prices
GROUP BY value_name
ORDER BY avg_growth;
-- Banány žluté

-- round( ( e.GDP - e2.GDP ) / e2.GDP * 100, 2 ) as GDP_growth	
	

/*
 * 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin 
 * výrazně vyšší než růst mezd (větší než 10 %)?
 */
SELECT avg(growth_percent) AS fprice_growth_percent, year
FROM (SELECT
			 round(AVG(dat.value),2) AS avg_value
			, dat2.year_value
			, round( ( round(AVG(dat.value),2) - dat2.year_value ) / dat2.year_value * 100, 2 ) as growth_percent
			, dat.value_name
			, dat.unit
			, dat.industry_or_measurement
			, dat.year
			, dat2.YEAR AS prev_year
		FROM
			t_tomas_kypta_project_sql_primary_final AS dat
		LEFT JOIN 
			(SELECT
				round(avg(value),2) AS year_value
				, value_name
				, unit
				, industry_or_measurement
				, year
			FROM
				t_tomas_kypta_project_sql_primary_final
			WHERE
				value_code NOT IN (316, 5958)
				AND industry_or_measurement IS NOT NULL
				GROUP BY YEAR,value_name) AS dat2
			ON dat.value_name = dat2.value_name
			AND dat.year = dat2.year + 1
		WHERE
			dat.value_code NOT IN (316, 5958)
			AND dat.year >= 2007
		GROUP BY dat.`year`, dat.value_name) AS food_prices
GROUP BY YEAR
ORDER BY fprice_growth_percent DESC;



/*
 * Vytvoření tabulky t_tomas_kypta_project_SQL_secondary_final 
 * (pro dodatečná data o dalších evropských státech).
 */
CREATE OR REPLACE TABLE t_tomas_kypta_project_SQL_secondary_final AS
SELECT dat.*, eco.country, eco.GDP
FROM t_tomas_kypta_project_sql_primary_final AS dat
LEFT JOIN (SELECT country, GDP, year
				FROM economies
				WHERE country LIKE '%czech%') AS eco
	ON dat.year = eco.year;


/*
 * 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? 
 * Neboli, pokud HDP vzroste výrazněji v jednom roce, 
 * projeví se to na cenách potravin či mzdách ve stejném nebo 
 * následujícím roce výraznějším růstem?
 */


SELECT 
	round(AVG(dat.value),2) AS avg_value
	, dat2.year_value
	, round( ( round(AVG(dat.value),2) - dat2.year_value ) / dat2.year_value * 100, 2 ) as growth_percent
	, dat.value_name
	, dat.unit
	, dat.industry_or_measurement
	, dat.year
	, dat2.YEAR AS prev_year
	, dat.country 
	, dat.GDP
FROM t_tomas_kypta_project_sql_secondary_final AS dat
LEFT JOIN 
			(SELECT
				round(avg(value),2) AS year_value
				, value_name
				, unit
				, industry_or_measurement
				, YEAR
				, country
				, GDP
			FROM
				t_tomas_kypta_project_sql_secondary_final
			WHERE
				value_code != 5958
				AND industry_or_measurement IS NOT NULL
				GROUP BY year,value_name
			) AS dat2
	ON dat.value_name = dat2.value_name
	AND dat.year = dat2.year + 1
WHERE
	dat.value_code != 5958
	AND dat.year >= 2007
GROUP BY dat.`year`, dat.value_name;