--To view the entire table

SELECT *
From CovidDeaths cd 
WHERE continent is not null
order by 3,4;


--SELECT *
--FROM Covid_vaccine cv 
--ORDER BY 3,4;


--Selecting data we are going to be using

SELECT location, date, total_cases,new_cases, total_deaths,population 
From CovidDeaths cd 
order by 1,2;


--Looking at Total Cases vs Total Deaths

SELECT location, date, total_cases, total_deaths , (total_deaths/total_cases) * 100 as DeathPercentage
From CovidDeaths cd
--WHERE location like "%state%"
order by 1,2;

--Total Cases vs. Population
--What Population got Covid

SELECT location, date, population, total_cases, (total_cases/population)* 100 as Percent_Population_Infected
FROM CovidDeaths cd 
WHERE location LIKE "%canada%"
ORDER BY 1,2;

--Looking at Countries with the Highest Infection Rate compared to Population

SELECT location, date, population, MAX(total_cases) as Highest_Infection_Count,MAX((total_cases/population))* 100 as Max_CovidPercentage
FROM CovidDeaths cd 
GROUP BY location, population
ORDER BY Max_CovidPercentage desc;


--Showing Countries with the Highest Death Count per Population

SELECT location, MAX(total_deaths) as Highest_death_count
FROM CovidDeaths cd 
WHERE continent is not null
GROUP BY location
ORDER BY Highest_death_count desc;

-- Order the Continent Total Covid Death 

SELECT continent , MAX(total_deaths) as Total_death_count
FROM CovidDeaths cd 
WHERE  continent is not NULL
GROUP BY continent  
ORDER BY Total_death_count desc;

-- Global Numbers by date 

SELECT date, SUM(new_cases) as Total_cases,SUM(new_deaths) as Total_Deaths, (SUM(new_deaths))/(SUM(new_cases))*100 as DeathPercentage
From CovidDeaths cd
WHERE continent is not NULL
Group by date 
order by 1,2;

-- Global Cases to Death Percentage

SELECT SUM(new_cases) as Total_cases,SUM(new_deaths) as Total_Deaths, (SUM(new_deaths))/(SUM(new_cases))*100 as DeathPercentage
From CovidDeaths cd
WHERE continent is not NULL
order by 1,2;

--Joning the CovidDeath table and CovidVaccination TABLE 

Select *
FROM CovidDeaths cd 
JOIN Covid_vaccine cv 
	ON cd.location = cv.location 
	AND cd.date = cv.date;

-- Looking at Total Population vs. Vaccination

Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(cv.new_vaccinations) OVER (PARTITION by cd.location ORDER BY cd.location, cd.date) as Rolling_People_Vaccinated
FROM CovidDeaths cd  
JOIN Covid_vaccine cv 
	ON cd.location = cv.location
	AND cd.date=cv.date
WHERE cd.continent is not null
ORDER By 2,3;



-- Using CTE to find the percent population vaccinated by location and date 

With PopvsVac (continent, location, date, population, new_vaccinations, Rolling_People_Vaccinated)
as
(
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(cv.new_vaccinations) OVER (PARTITION by cd.location ORDER BY cd.location, cd.date) as Rolling_People_Vaccinated
FROM CovidDeaths cd  
JOIN Covid_vaccine cv 
	ON cd.location = cv.location
	AND cd.date=cv.date
WHERE cd.continent is not null
-- ORDER By 2,3
)
Select *, (Rolling_People_Vaccinated/population) * 100 as Percent_Population_Vaccinated
FROM PopvsVac pv;


-- TEMP TABLE to find the percent population vaccinated by location and date

DROP TABLE IF exist PercentPopulationVaccinated -- drop table first if you want to alter this table after created
CREATE TABLE PercentPopulationVaccinated
(
continent varchar(255),
location varchar(255),
date date,
population numeric,
new_vaccinations numeric,
Rolling_people_Vaccinated numeric
);

Insert into PercentPopulationVaccinated
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(cv.new_vaccinations) OVER (PARTITION by cd.location ORDER BY cd.location, cd.date) as Rolling_People_Vaccinated
FROM CovidDeaths cd  
JOIN Covid_vaccine cv 
	ON cd.location = cv.location
	AND cd.date=cv.date
WHERE cd.continent is not null
--ORDER By 2,3

Select *, (cast(Rolling_People_Vaccinated as float)/population) * 100 as Percent_Population_Vaccinated
FROM PercentPopulationVaccinated;


--CREATING VIEW TO STORE DATA FOR LATER VISUALIZATION
--(View creates permenant table unlike temp table and CTE)

CREATE VIEW Percent_Population_Vaccinated as 
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(cv.new_vaccinations) OVER (PARTITION by cd.location ORDER BY cd.location, cd.date) as Rolling_People_Vaccinated
FROM CovidDeaths cd  
JOIN Covid_vaccine cv 
	ON cd.location = cv.location
	AND cd.date=cv.date
WHERE cd.continent is not null
--ORDER By 2,3
