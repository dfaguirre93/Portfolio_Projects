
--G20 Covid Project
--Total cases, deaths, and death rate by country
SELECT
	location,
	SUM(new_cases) AS total_cases,
	SUM(new_deaths) AS total_deaths,
	SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM
	dbo.deaths
WHERE
	location IN ('United States','South Africa','China','Australia','Germany','Canada','United Kingdom','Indonesia','Brazil','India','Japan','Italy','Argentina','France','Mexico','South Korea','Russia','Turkey','Saudi Arabia','Spain')
GROUP BY
	location
ORDER BY
	death_percentage DESC;

--Total vaccinated and boosted and percent boosted of G20 countries
WITH boosts AS
(
SELECT
	location,
	MAX(cast(people_fully_vaccinated AS int)) AS vaccinated,
	MAX(cast(total_boosters AS int)) AS boosted,
	MAX(cast(total_boosters AS float))/MAX(cast(people_fully_vaccinated AS float))*100 AS percent_boosted
FROM
	dbo.vaccinations
WHERE
	location IN ('United States','South Africa','China','Australia','Germany','Canada','United Kingdom','Indonesia','Brazil','India','Japan','Italy','Argentina','France','Mexico','South Korea','Russia','Turkey','Saudi Arabia','Spain')
GROUP BY
	location
	)
SELECT
	SUM(cast(vaccinated as bigint)) AS vaccinated,
	SUM(cast(boosted as bigint)) AS boosted,
	SUM(cast(boosted as float))/SUM(cast(vaccinated as float))*100 AS percent_boosted
FROM
	boosts;


--Vaccination rate of G20 countries over time

WITH VacRate AS
(
SELECT
	dea.location AS location,
	dea.population AS population,
	vac.date AS date,
	MAX(vac.people_fully_vaccinated) AS vaccinations,
	MAX((vac.people_fully_vaccinated/population))*100 AS population_vaccinated_percent
FROM
	dbo.deaths AS dea
	JOIN
	dbo.vaccinations AS vac
	ON
	dea.location=vac.location
GROUP BY
	dea.location,
	population,
	vac.date
	)
SELECT
	location,
	date,
	isnull(vaccinations,0) AS vaccinations,
	population_vaccinated_percent
FROM
	VacRate
WHERE
	location IN ('United States','South Africa','China','Australia','Germany','Canada','United Kingdom','Indonesia','Brazil','India','Japan','Italy','Argentina','France','Mexico','South Korea','Russia','Turkey','Saudi Arabia','Spain')
ORDER BY
	1,2;

--Death rate over time of G20 countries
SELECT
	location,
	date,
	MAX(total_cases) AS case_count,
	MAX(total_deaths) AS death_count,
	Max((cast(total_deaths as float)/cast(total_cases as float)))*100 AS death_percentage
FROM
	dbo.deaths
WHERE
	location IN ('United States','South Africa','China','Australia','Germany','Canada','United Kingdom','Indonesia','Brazil','India','Japan','Italy','Argentina','France','Mexico','South Korea','Russia','Turkey','Saudi Arabia','Spain')
GROUP BY
	location,
	population,
	date
ORDER BY
	1,2;

--Looking at the percent vaccinated in G20 countries compared to total population

WITH PopVac AS
(
SELECT
	dea.location AS location,
	dea.population AS population,
	isnull(Max(cast(vac.people_fully_vaccinated as float)),0) AS total_vaccinated
FROM
	dbo.deaths AS dea
	JOIN
	dbo.vaccinations AS vac
	ON
	dea.location=vac.location
GROUP BY
	dea.location,
	dea.population
)
SELECT
	location,
	population,
	total_vaccinated,
	(total_vaccinated/population)*100 AS percent_vaccinated
FROM
	PopVac
WHERE
	location IN ('United States','South Africa','China','Australia','Germany','Canada','United Kingdom','Indonesia','Brazil','India','Japan','Italy','Argentina','France','Mexico','South Korea','Russia','Turkey','Saudi Arabia','Spain')
ORDER BY
	percent_vaccinated DESC;