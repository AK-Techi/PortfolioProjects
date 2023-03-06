SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidPortfolioProject.dbo.CovidDeaths
ORDER BY 1,2

-- Total Cases V/S Total Deaths (likelihood of dying countrywise)
SELECT location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidPortfolioProject.dbo.CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2

-- Total Cases V/S Population
SELECT location, date, total_cases, population,(total_cases/population)*100 AS InfectedPercentage
FROM CovidPortfolioProject.dbo.CovidDeaths
WHERE location LIKE '%india%'
ORDER BY 1,2

-- Countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, 
	MAX(total_cases/population)*100 AS HighestInfectedPercentage
FROM CovidPortfolioProject.dbo.CovidDeaths
GROUP BY location, population
ORDER BY 4 DESC

-- Check this o/p Countries with Highest Death Count per population
SELECT location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM CovidPortfolioProject.dbo.CovidDeaths
WHERE continent is NULL
GROUP BY location
ORDER BY 2 DESC

-- Continents with Highest Death Count per population
SELECT continent, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM CovidPortfolioProject.dbo.CovidDeaths
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY 2 DESC

-- Global numbers

SELECT date, SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths,
	SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidPortfolioProject.dbo.CovidDeaths
WHERE continent is NOT NULL
GROUP BY date
ORDER BY 1,2

-- Rolling Vaccinations by location and date

SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
	SUM(CONVERT(BIGINT, v.new_vaccinations)) OVER (PARTITION BY d.location ORDER BY d.location, d.date)
	AS RollingVaccinations
FROM CovidPortfolioProject.dbo.CovidDeaths d
JOIN CovidPortfolioProject.dbo.CovidVaccinations v
	ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY 2,3

-- USING CTE

WITH CTE1 (continent, location, date, population, new_vaccinations, rollingVaccinations)
AS
(SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
	SUM(CONVERT(BIGINT, v.new_vaccinations)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingVaccinations
FROM CovidPortfolioProject.dbo.CovidDeaths d
JOIN CovidPortfolioProject.dbo.CovidVaccinations v
	ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL
--ORDER BY d.location, d.date
)

SELECT *, (RollingVaccinations/population)*100 AS RollingVaccinationPercentage
FROM CTE1

-- TEMP TABLE

DROP TABLE IF EXISTS #PrecentPopulationVaccinated
CREATE TABLE #PrecentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingVaccinations numeric
)

INSERT INTO #PrecentPopulationVaccinated
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
	SUM(CONVERT(BIGINT, v.new_vaccinations)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingVaccinations
FROM CovidPortfolioProject.dbo.CovidDeaths d
JOIN CovidPortfolioProject.dbo.CovidVaccinations v
	ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL
--ORDER BY d.location, d.date

SELECT *, (RollingVaccinations/population)*100 AS RollingVaccinationPercentage
FROM #PrecentPopulationVaccinated

-- Creating view to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
	SUM(CONVERT(BIGINT, v.new_vaccinations)) OVER (PARTITION BY d.location ORDER BY d.location, d.date)
	AS RollingVaccinations
FROM CovidPortfolioProject.dbo.CovidDeaths d
JOIN CovidPortfolioProject.dbo.CovidVaccinations v
	ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL
-- ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated
