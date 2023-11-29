# sql_exercise_dataprojects
ENGETO SQL DATA ANALYSIS PROJECT DESCRIPTION

In English:
Project Assignment: Salary and Food Prices Data Analysis Using SQL

In your analytical department at an independent company focusing on the standard of living of citizens, you have agreed to attempt to answer a few defined research questions addressing the availability of basic food items to the general public. Your colleagues have already outlined the key questions that you will try to answer and provide this information to the public relations department. The PR department will present the results at an upcoming conference focused on this area.

They need you to prepare robust data sets that show a comparison of food availability based on average incomes over specific time periods.

As additional material, prepare a table with GDP, GINI coefficient, and population of other European countries during the same period as the primary overview for the Czech Republic.

Primary Tables:
  czechia_payroll: Information about salaries in various industries over several years. The dataset comes from the Czech Republic's Open Data Portal.
  czechia_payroll_calculation: Numeric calculations reference table in the payroll table.
  czechia_payroll_industry_branch: Industry branch code reference table in the payroll table.
  czechia_payroll_unit: Unit code reference table in the payroll table.
  czechia_payroll_value_type: Value type code reference table in the payroll table.
  czechia_price: Information about prices of selected foods over several years. The dataset comes from the Czech Republic's Open Data Portal.
  czechia_price_category: Food category code reference table used in the overview.

Shared Information Codebooks for the Czech Republic:
  czechia_region: Codebook for regions in the Czech Republic according to the CZ-NUTS 2 standard.
  czechia_district: Codebook for districts in the Czech Republic according to the LAU standard.

Additional Tables:
  countries: Comprehensive information about countries worldwide, such as capital, currency, national food, or average population height.
  economies: GDP, GINI, tax burden, etc., for a given country and year.

Research Questions:
  Do salaries in all industries increase over the years, or do some experience a decline?
  How much milk and bread can one buy for the first and last comparable periods in the available price and salary data?
  Which food category has the slowest price increase (lowest percentage year-over-year growth)?
  Is there a year where the year-over-year increase in food prices is significantly higher than the growth in salaries (greater than 10%)?
  Does the GDP have an impact on changes in salaries and food prices? In other words, if GDP increases significantly in one year, does it result in a more pronounced increase in food prices or salaries in the same or subsequent years?

Project Output:
Assist your colleagues with the given task. The output should be two tables in the database from which the required data can be obtained. Name the tables: 
  t_{firstname}{lastname}_project_SQL_primary_final (for data on salaries and food prices for the Czech Republic unified over the same comparable period - common years)       t_{firstname}{lastname}_project_SQL_secondary_final (for additional data on other European countries).

Additionally, prepare a set of SQL queries that retrieve the data for answering the defined research questions from the tables you have prepared. Note that the questions/hypotheses may either support or refute your outputs! It depends on what the data says.

Create a repository on your GitHub account (can be private) where you store all project-related information - especially the SQL script generating the final table, a description of interim results (accompanying documentation), and information about the output data (e.g., where values are missing, etc.).

Do not modify data in primary tables! If transformation of values is needed, do it in tables or views that you create.

In Czech:
Zadání projektu: Data o mzdách a cenách potravin a jejich zpracování pomocí SQL

Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, jste se dohodli, 
že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veřejnosti. 
Kolegové již vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. 
Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast.

Potřebují k tomu od vás připravit robustní datové podklady, ve kterých bude možné vidět porovnání dostupnosti potravin 
na základě průměrných příjmů za určité časové období.

Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, 
jako primární přehled pro ČR.

Primární tabulky:
  czechia_payroll – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
  czechia_payroll_calculation – Číselník kalkulací v tabulce mezd.
  czechia_payroll_industry_branch – Číselník odvětví v tabulce mezd.
  czechia_payroll_unit – Číselník jednotek hodnot v tabulce mezd.
  czechia_payroll_value_type – Číselník typů hodnot v tabulce mezd.
  czechia_price – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
  czechia_price_category – Číselník kategorií potravin, které se vyskytují v našem přehledu.

Číselníky sdílených informací o ČR:
  czechia_region – Číselník krajů České republiky dle normy CZ-NUTS 2.
  czechia_district – Číselník okresů České republiky dle normy LAU.

Dodatečné tabulky:
  countries - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.
  economies - HDP, GINI, daňová zátěž, atd. pro daný stát a rok.

Výzkumné otázky
  Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
  Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
  Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
  Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
  Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

Výstup projektu
Pomozte kolegům s daným úkolem. Výstupem by měly být dvě tabulky v databázi, ze kterých se požadovaná data dají získat. Tabulky pojmenujte:
  t_{jmeno}_{prijmeni}_project_SQL_primary_final (pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky) 
  t_{jmeno}_{prijmeni}_project_SQL_secondary_final (pro dodatečná data o dalších evropských státech).

Dále připravte sadu SQL, které z vámi připravených tabulek získají datový podklad k odpovězení na vytyčené výzkumné otázky. 
Pozor, otázky/hypotézy mohou vaše výstupy podporovat i vyvracet! Záleží na tom, co říkají data.

Na svém GitHub účtu vytvořte repozitář (může být soukromý), kam uložíte všechny informace k projektu – hlavně SQL skript generující výslednou tabulku, 
popis mezivýsledků (průvodní listinu) a informace o výstupních datech (například kde chybí hodnoty apod.).

Neupravujte data v primárních tabulkách! Pokud bude potřeba transformovat hodnoty, dělejte tak až v tabulkách nebo pohledech, které si nově vytváříte.
