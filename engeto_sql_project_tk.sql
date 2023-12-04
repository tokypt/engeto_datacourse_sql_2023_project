-- czechia_payroll_filled
CREATE OR REPLACE VIEW czechia_payroll_filled AS
SELECT
	cp.value
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
SELECT cpf.*, cpr.* 
FROM czechia_payroll_filled AS cpf 
LEFT JOIN czechia_price_recount AS cpr
	ON cpf.payroll_year = cpr.price_year
	AND cpf.payroll_quarter = cpr.price_quarter;

-- 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
SELECT 
FROM t_tomas_kypta_project_sql_primary_final AS ttkpspf 
GROUP BY industry


