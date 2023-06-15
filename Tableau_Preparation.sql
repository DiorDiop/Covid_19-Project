/*
Queries for Tableau
*/

--Tableau_1

SELECT SUM(New_cases) AS Total_cases,
	   SUM(CAST(New_deaths AS INT)) AS Total_deaths,
	   (SUM(CAST(New_deaths AS INT)) / SUM(New_cases) * 100) AS Death_percentage
FROM Covid19_Dataset..CovidDeaths
WHERE Continent IS NOT NULL
--GROUP BY Continent
ORDER BY 1, 2;

--Table_2

SELECT Continent, SUM(CAST(New_deaths AS INT)) AS Total_deaths_count
FROM Covid19_Dataset..CovidDeaths
WHERE Continent IS NOT NULL
--AND location NOT IN ('World', 'European Union', 'International')
GROUP BY Continent
ORDER BY Total_deaths_count DESC;

--Table_3

SELECT Location, Population,
	   MAX(Total_cases) AS Highest_infection,
	   MAX((Total_cases / Population) * 100) AS Infection_rate
FROM Covid19_Dataset..CovidDeaths
WHERE Continent IS NOT NULL
GROUP BY Location, Population
ORDER BY Infection_rate DESC;

--Table_4

SELECT Location, Population, Date,
	   MAX(Total_cases) AS Highest_infection,
	   MAX((Total_cases / Population) * 100) AS Infection_rate
FROM Covid19_Dataset..CovidDeaths
WHERE Continent IS NOT NULL
GROUP BY Location, Population, Date
ORDER BY Infection_rate DESC;