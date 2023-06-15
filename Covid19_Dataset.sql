SELECT *
FROM Covid19_Dataset..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3, 4;

--SELECT *
--FROM Covid19_Dataset..CovidVaccinations
--ORDER BY 3, 4

--Salect the Data

SELECT Location, Date, Total_cases, New_cases, Total_deaths, Population
FROM Covid19_Dataset..CovidDeaths
WHERE Continent IS NOT NULL
ORDER BY 1, 2;

--Total Cases VS Total Deaths
--Death percentage per Country

SELECT Location, Date, Total_cases, Total_deaths, ((total_deaths / total_cases) * 100) AS Death_Percentage
FROM Covid19_Dataset..CovidDeaths
--Specify the location
WHERE Location LIKE '%States%'
AND Continent IS NOT NULL
ORDER BY 1, 2;

--Total Cases vs Population

SELECT Location, Date, Total_cases, Population, ((total_cases / population) * 100) AS Covid_Percentage
FROM Covid19_Dataset..CovidDeaths
WHERE Continent IS NOT NULL
--Specify the location
--WHERE location LIKE '%States%'
ORDER BY 1, 2;

--Countries with Highest infection Rates

SELECT Location, MAX(total_cases) AS Highest_InfectionRate, Population, ((MAX(total_cases) / population) * 100) AS MaxCovid_Percentage
FROM Covid19_Dataset..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location, Population
ORDER BY Location, Highest_InfectionRate DESC;

--Countries with Highest Death Rates

SELECT Location, MAX(CAST(total_deaths AS int)) AS Highest_DeathRate
FROM Covid19_Dataset..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY Location, Highest_DeathRate DESC;

--Break it by Continent
--The Continent with the Highest Death Rate

SELECT Continent, MAX(CAST(total_deaths AS int)) AS Highest_DeathRate
FROM Covid19_Dataset..CovidDeaths
WHERE Continent IS NOT NULL
GROUP BY Continent
ORDER BY Continent, Highest_DeathRate DESC;

--Global Number

SELECT SUM(New_cases) AS Total_cases, SUM(CAST(New_deaths AS INT)) AS Total_deaths, (SUM(CAST(New_deaths AS INT)) / SUM(CAST(New_cases AS INT))) * 100 AS Death_Percentage
FROM Covid19_Dataset..CovidDeaths
WHERE Continent IS NOT NULL
--GROUP BY Date
ORDER BY 1, 2;

--Total Population vs Vaccination
--Vaccinated People

SELECT dea.Continent, dea.Location, dea.Date, dea.Population, vac.New_vaccinations,
	SUM(CONVERT(INT, vac.New_vaccinations)) OVER(PARTITION BY dea.Location ORDER BY dea.Location, dea.Date) AS People_vaccinated
FROM Covid19_Dataset..CovidDeaths dea
JOIN Covid19_Dataset..CovidVaccinations vac
	ON dea.Location = vac.Location
	AND dea.Date = vac.Date
	AND dea.Continent = vac.Continent
WHERE dea.Continent IS NOT NULL
ORDER BY 2, 3;

--Use the CTE(Common Table Expressions)

WITH popvsVac (Continent, Location, Date, Population, New_vaccinations, People_vaccinated)
AS
(
	SELECT dea.Continent, dea.Location, dea.Date, dea.Population, vac.New_vaccinations,
		SUM(CONVERT(INT, vac.New_vaccinations)) OVER(PARTITION BY dea.Location ORDER BY dea.Location, dea.Date) AS People_vaccinated
	FROM Covid19_Dataset..CovidDeaths dea
	JOIN Covid19_Dataset..CovidVaccinations vac
		ON dea.Location = vac.Location
		AND dea.Date = vac.Date
		AND dea.Continent = vac.Continent
	WHERE dea.Continent IS NOT NULL
	--ORDER BY 2, 3;	
)
SELECT *, ((People_vaccinated / Population) * 100) AS Vaccin_percentage
FROM popvsVac

--Temporary Table

DROP TABLE IF EXISTS #Population_Vaccinated
CREATE TABLE #Population_Vaccinated
(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	Population numeric,
	New_vaccinations numeric,
	People_vaccinated numeric
)

INSERT INTO #Population_Vaccinated

SELECT dea.Continent, dea.Location, dea.Date, dea.Population, vac.New_vaccinations,
	SUM(CONVERT(INT, vac.New_vaccinations)) OVER(PARTITION BY dea.Location ORDER BY dea.Location, dea.Date) AS People_vaccinated
FROM Covid19_Dataset..CovidDeaths dea
JOIN Covid19_Dataset..CovidVaccinations vac
	ON dea.Location = vac.Location
	AND dea.Date = vac.Date
	AND dea.Continent = vac.Continent
WHERE dea.Continent IS NOT NULL
--ORDER BY 2, 3;

SELECT *, ((People_vaccinated / Population) * 100) AS Vaccin_percentage
FROM #Population_Vaccinated

--Data for Visualization

CREATE VIEW Population_Vaccinated AS
SELECT dea.Continent,
	   dea.Location,
	   dea.Date,
	   dea.Population,
	   vac.New_vaccinations,
	SUM(CONVERT(INT, vac.New_vaccinations))
		OVER(PARTITION BY dea.Location ORDER BY dea.Location, dea.Date) AS People_vaccinated
FROM Covid19_Dataset..CovidDeaths dea
JOIN Covid19_Dataset..CovidVaccinations vac
	ON dea.Location = vac.Location
	AND dea.Date = vac.Date
	AND dea.Continent = vac.Continent
WHERE dea.Continent IS NOT NULL
--ORDER BY 2, 3;

SELECT * 
FROM Population_Vaccinated