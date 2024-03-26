USE CovidDatabase

SELECT *
FROM dbo.[total Death]
ORDER BY 3,4



SELECT *
FROM dbo.[total Vacc]
ORDER BY 3,4

--- For this Demo project, all code is in one file normally I would put view, select and Create in their own file.

--- #Issu: Issue total_deaths Type was varchar
--- 
--SELECT CAST(replace(total_deaths,',','.') as float)
--FROM dbo.[total Death]

--- #Issu: Solution
--ALTER TABLE dbo.[total Death] 
--ALTER COLUMN total_deaths float


-- Base Data for Analysis
SELECT location,date,total_cases,new_cases,total_deaths,population
FROM dbo.[total Death]
WHERE continent is not NULL
ORDER BY location,date


--Total Case / Total Death
SELECT location,date,total_cases,new_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM dbo.[total Death]
WHERE continent is not NULL
ORDER BY location,date

CREATE VIEW DeathtollVSInfectedCase as
SELECT location,date,total_cases,new_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM dbo.[total Death]
WHERE continent is not NULL

--DROP VIEW DeathtollVSInfectedCase


--Total Case / Total Death for Canada
--- Show likelihood of dying for coronavirus Case
SELECT location,date,total_cases,new_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM dbo.[total Death]
WHERE continent is not NULL
AND location LIKE '%canada'
ORDER BY location,date

CREATE VIEW LikelihoodOfSurvivalCanada as
SELECT location,date,total_cases,new_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM dbo.[total Death]
WHERE continent is not NULL
AND location LIKE '%canada'

--DROP VIEW LikelihoodOfSurvivalCanada


-- Total case for population
---Shows what percentage of population affected by covid
SELECT location,date,total_cases,new_cases,population,(total_cases/population)*100 as AffectedPercentage
FROM dbo.[total Death]
WHERE continent is not NULL
AND location like '%canada'
ORDER BY location,date

CREATE VIEW TotalCaseCanada as
SELECT location,date,total_cases,new_cases,population,(total_cases/population)*100 as AffectedPercentage
FROM dbo.[total Death]
WHERE continent is not NULL
AND location like '%canada'

--DROP VIEW TotalCaseCanada

--Countries with the Highest infection rate by population
SELECT location,MAX(total_cases) as HighestInfectionCount,population,MAX((total_cases/population)*100) as AffectedPercentage
FROM dbo.[total Death]
WHERE continent is not NULL
GROUP BY location,population
ORDER BY AffectedPercentage DESC


CREATE VIEW TotalCasebyPopulation as
SELECT location,Max(total_deaths) as Total_Death_Count 
FROM dbo.[total Death]
WHERE continent is NOT NULL
GROUP BY location



--DROP VIEW TotalCasebyPopulation



SELECT location,Max(total_deaths) as Total_Death_Count 
FROM dbo.[total Death]
WHERE continent is NOT NULL
GROUP BY location
ORDER BY Total_Death_Count DESC

CREATE VIEW TotalDeathtoll as
SELECT location,Max(total_deaths) as Total_Death_Count 
FROM dbo.[total Death]
WHERE continent is NOT NULL
GROUP BY location

--DROP VIEW TotalDeathtoll


-- Exploration by Continent
-- Showing countries with most Death count by  population

SELECT location,Max(total_deaths) as Total_Death_Count 
FROM dbo.[total Death]
WHERE continent is  NULL 
AND NOT location like '%income'
AND NOT location like '%world'
AND NOT location like '%union'
GROUP BY location
ORDER BY Total_Death_Count DESC

CREATE VIEW PercentDeathtollbylocation as
SELECT location,Max(total_deaths) as Total_Death_Count 
FROM dbo.[total Death]
WHERE continent is  NULL 
AND NOT location like '%income'
AND NOT location like '%world'
AND NOT location like '%union'
GROUP BY location


--DROP VIEW PercentDeathtollbylocation


-- Exploration by Continent
-- Showing Continent with most Death count by  population
SELECT continent,Max(total_deaths) as Total_Death_Count 
FROM dbo.[total Death]
WHERE continent IS NOT NULL 
AND NOT location like '%income'
AND NOT location like '%world'
AND NOT location like '%union'
GROUP BY continent
ORDER BY Total_Death_Count DESC

CREATE VIEW PercentDeathtollbyContinent as
SELECT continent,Max(total_deaths) as Total_Death_Count 
FROM dbo.[total Death]
WHERE continent IS NOT NULL 
AND NOT location like '%income'
AND NOT location like '%world'
AND NOT location like '%union'
GROUP BY continent


--DROP VIEW PercentDeathtollbyContinent



-- Exploration by Continent
-- Showing world with most Death count by  population
--  Note:First data don't seem right
---2020-01-05 00:00:00.000	2	3	150

SELECT date,SUM(new_cases)as Total_newCase,SUM(new_deaths)as Total_death,SUM(new_deaths)/SUM(new_cases)* 100 as Death_percent_per_day
FROM dbo.[total Death]
WHERE continent IS NOT NULL 
GROUP BY date
HAVING SUM(new_cases) > 0
ORDER BY date,Total_newCase

CREATE VIEW PercentDeathtollbyDay as
SELECT date,SUM(new_cases)as Total_newCase,SUM(new_deaths)as Total_death,SUM(new_deaths)/SUM(new_cases)* 100 as Death_percent_per_day
FROM dbo.[total Death]
WHERE continent IS NOT NULL 
GROUP BY date
HAVING SUM(new_cases) > 0


--DROP VIEW PercentDeathtollbyDay




-- Showing world with most Death 
--  Note:First data don't seem right
---2020-01-05 00:00:00.000	2	3	150
--- 7,007,928 people have died so far from the coronavirus COVID-19 outbreak as of March 25, 2024
--- https://www.worldometers.info/coronavirus/coronavirus-death-toll/
--- 7,040,934 obtain by this Query
SELECT SUM(new_cases)as Total_newCase,SUM(new_deaths)as Total_death,SUM(new_deaths)/SUM(new_cases)* 100 as Death_percent_per_day
FROM dbo.[total Death]
WHERE continent IS NOT NULL 
HAVING SUM(new_cases) > 0

CREATE VIEW PercentDeathtollWorld as
SELECT SUM(new_cases)as Total_newCase,SUM(new_deaths)as Total_death,SUM(new_deaths)/SUM(new_cases)* 100 as Death_percent_per_day
FROM dbo.[total Death]
WHERE continent IS NOT NULL 
HAVING SUM(new_cases) > 0

--DROP VIEW PercentDeathtollWorld



-- join Table by
-- warning no data is primary key
Select *
FROM dbo.[total Death] as dea
Join dbo.[total Vacc] as vacc
	ON dea.location = vacc.location AND dea.date =vacc.date 


-- total population / vaccination population	
Select dea.continent, dea.location,dea.date,dea.population,vacc.new_vaccinations as New_Vaccination_per_Day
FROM dbo.[total Death] as dea
Join dbo.[total Vacc] as vacc
	ON dea.location = vacc.location AND dea.date =vacc.date 
WHERE dea.continent IS NOT NULL 
ORDER BY dea.continent, dea.location,dea.date



-- total population / vaccination population
-- add  Sum overpartition allow to see accumulative data progression
-- note: int memory exceeded  use of big int
Select dea.continent, dea.location,dea.date,dea.population,vacc.new_vaccinations as New_Vaccination_per_Day,
SUM(CAST(vacc.new_vaccinations as bigint)) OVER (PARTITION By dea.location ORDER BY dea.location,dea.date)  as Accumulative_Vaccinated
FROM dbo.[total Death] as dea
Join dbo.[total Vacc] as vacc
	ON dea.location = vacc.location AND dea.date =vacc.date 
WHERE dea.continent IS NOT NULL 
ORDER BY dea.continent, dea.location,dea.date





--- CTE
WITH PopVsVacc (Continent,Location,Date,Population,New_Vaccination_per_Day,Accumulative_Vaccinated)
as
(
Select dea.continent, dea.location,dea.date,dea.population,vacc.new_vaccinations as New_Vaccination_per_Day,
SUM(CAST(vacc.new_vaccinations as bigint)) OVER (PARTITION By dea.location ORDER BY dea.location,dea.date)  as Accumulative_Vaccinated
FROM dbo.[total Death] as dea
Join dbo.[total Vacc] as vacc
	ON dea.location = vacc.location AND dea.date =vacc.date 
WHERE dea.continent IS NOT NULL 

)
--SELECT * 
--FROM PopVsVacc

SELECT *, (Accumulative_Vaccinated/Population)*100 as PErcent_Vaccinated
FROM PopVsVacc


--- Temp Table
DROP TABLE IF Exists #PercentPopulationVaccinated

CREATE TABLE #PercentPopulationVaccinated
(
	continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population int,
	new_Vaccinated  int,
	Accumulative_Vaccinated float
)
INSERT INTO #PercentPopulationVaccinated
Select dea.continent, dea.location,dea.date,dea.population,vacc.new_vaccinations as New_Vaccination_per_Day,
SUM(CAST(vacc.new_vaccinations as bigint)) OVER (PARTITION By dea.location ORDER BY dea.location,dea.date)  as Accumulative_Vaccinated
FROM dbo.[total Death] as dea
Join dbo.[total Vacc] as vacc
	ON dea.location = vacc.location AND dea.date =vacc.date 
WHERE dea.continent IS NOT NULL 

SELECT *, (Accumulative_Vaccinated/Population)*100 as PErcent_Vaccinated
FROM #PercentPopulationVaccinated


--- Note :both versions have data go beyond 100% for multiple version of vaccin was used I think.

CREATE VIEW PercentPopulationVaccinated as
Select dea.continent, dea.location,dea.date,dea.population,vacc.new_vaccinations as New_Vaccination_per_Day,
SUM(CAST(vacc.new_vaccinations as bigint)) OVER (PARTITION By dea.location ORDER BY dea.location,dea.date)  as Accumulative_Vaccinated
FROM dbo.[total Death] as dea
Join dbo.[total Vacc] as vacc
	ON dea.location = vacc.location AND dea.date =vacc.date 
WHERE dea.continent IS NOT NULL 

--DROP VIEW PercentPopulationVaccinated