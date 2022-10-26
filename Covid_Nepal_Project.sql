--Table of everything
SELECT *
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4;


--SELECT *
--FROM Covid_vaccine cv
--where continent is not null
--order by 3,4;



--What Percent of Nepal got Covid?
--Answer= 1.1%


SELECT location, population, max(total_cases), (max(total_cases)/population) *100 AS Population_Percent_Infected
FROM CovidDeaths cd
WHERE location LIKE "%nepal%"
AND continent IS NOT NULL
GROUP BY location;



--Total Cases vs. Population
--Answer= population of 29,136,808, total_cases = 323,187


SELECT location, date, population, new_cases,
SUM(new_cases) OVER (PARTITION BY location ORDER BY location, date) AS Rolling_cases
From CovidDeaths cd
WHERE continent IS NOT NULL
AND location LIKE "%nepal%"
ORDER BY 2,3 DESC;



--What percent of Population has been tested?
--Answer 8.27% of Nepal has been tested, with total tested of 2,410,604 people tested

SELECT cd.location, cd.date, cd.population, sum(cv.new_tests), ((sum(cv.new_tests))/cd.population) *100 AS Population_Percent_Tested
FROM CovidDeaths cd
JOIN Covid_vaccine cv
	ON cd.location = cv.location 
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
and cd.location like "%Nepal%"
GROUP BY cd.location;



--Using CTE to find the sum of people tested by date in Nepal


WITH people_tested (location,date,population, new_tests, Rolling_People_Tested)
AS 
(
SELECT cd.location, cd.date, cd.population, cv.new_tests,
SUM(cv.new_tests) OVER (PARTITION BY cd.location ORDER by cd.location, cd.date) as Rolling_People_Tested
FROM CovidDeaths cd
JOIN Covid_vaccine cv
	ON cd.location = cv.location 
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
)
SELECT *, (Rolling_People_Tested/population) *100 AS Percent_Population_Tested
FROM people_tested
WHERE location LIKE "%nepal%";



--Creating TEMP TABLE to percentage of people tested by date in Nepal

DROP TABLE IF exist Percent_People_Tested
CREATE TABLE Percent_People_Tested 
( 
location varchar(255),
date date,
population numeric,
new_tests numeric,
Rolling_People_Tested numeric
)

INSERT INTO Percent_People_Tested
SELECT cd.location, cd.date, cd.population, cv.new_tests,
SUM(cv.new_tests) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as Rolling_People_Tested
FROM CovidDeaths cd
JOIN Covid_vaccine cv
	ON cd.location = cv.location 
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL

SELECT *,(CAST (Rolling_People_Tested AS FLOAT)/population) * 100 AS Percent_Nepalese_Tested
FROM Percent_People_Tested
WHERE location LIKE "%Nepal%";

--What percent increase in Test was there compared to the previous total tested in Nepal by date

DROP TABLE IF exists Percent_People_Tested
CREATE table Percent_People_Tested 
( 
location varchar(255),
date date,
population numeric,
new_tests numeric,
Rolling_People_Tested numeric
)

INSERT INTO Percent_People_Tested
SELECT cd.location, cd.date, cd.population, cv.new_tests,
sum(cv.new_tests) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS Rolling_People_Tested
FROM CovidDeaths cd
JOIN Covid_vaccine cv
	ON cd.location = cv.location 
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL

SELECT *,(CAST(new_tests AS FLOAT)/Rolling_People_Tested) * 100 AS Percent_Nepalese_Tested
FROM Percent_People_Tested
WHERE location LIKE "%Nepal%";



--Creating Views

CREATE VIEW Percent_Nepalese_Tested as 
SELECT cd.location, cd.date, cd.population, cv.new_tests,
SUM(cv.new_tests) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as Rolling_People_Tested
From CovidDeaths cd
JOIN Covid_vaccine cv
	ON cd.location = cv.location 
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
AND cd.location LIKE "%Nepal%";



