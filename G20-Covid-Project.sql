
--G20 Covid Project
--Goal is to see how G20 countries compare to each other on COVID deaths and vaccinations
--Total cases, deaths, and death rate by country
SELECT
	location,
	SUM(new_cases) AS total_cases,
	SUM(new_deaths) AS total_deaths,
	SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM
	PortfolioProject.dbo.deaths
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
	PortfolioProject.dbo.deaths
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
	PortfolioProject.dbo.deaths AS dea
	JOIN
	PortfolioProject.dbo.vaccinations AS vac
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
	PortfolioProject.dbo.deaths
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
	PortfolioProject.dbo.deaths AS dea
	JOIN
	PortfolioProject.dbo.vaccinations AS vac
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
	
	
-----------------------------------------------------------------------------------------

--Original queries that ultimately are not being used for visualization

--Death rate of Covid-19 by region and country with total cases and deaths--
SELECT
	location,
	SUM(new_cases) AS total_cases,
	SUM(new_deaths) AS total_deaths,
	SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM
	PortfolioProject.dbo.deaths
WHERE 
	continent is not null
	AND
	new_cases <> 0
Group by
	location
Order by
	1,2;

--Total cases and deaths by continent--
SELECT
	location,
	SUM(new_cases) AS total_cases,
	SUM(new_deaths) AS total_deaths
FROM
	PortfolioProject.dbo.deaths
WHERE
	continent is null
	AND
	location not in ('World','European Union','International','Low income','Lower middle income','Upper middle income','High income')
Group by
	location
Order by
	total_deaths DESC;

--Population infected and percent of population infected--
SELECT
	location,
	population,
	MAX(cast(total_cases as float)) AS population_infected,
	MAX((cast(total_cases as float)/population))*100 AS population_infected_percent
FROM
	PortfolioProject.dbo.deaths
Group by
	location,
	population
Order by
	population_infected_percent DESC;

--Population infected over time by country--
SELECT
	location,
	population,
	date,
	Max(cast(total_cases as float)) AS highest_infection_count,
	Max((cast(total_cases as float)/population))*100 AS population_infected_percent
FROM
	PortfolioProject.dbo.deaths
Group by
	location,
	population,
	date
Order by
	location,
	date;

--Population vaccinated by country over time--
SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	Max(vac.total_vaccinations) AS number_vaccinated
FROM
	PortfolioProject.dbo.deaths AS dea
	JOIN
	PortfolioProject.dbo.vaccinations AS vac
	ON
	dea.location = vac.location
	AND
	dea.date = vac.date
WHERE
	dea.continent is not null
Group by
	dea.continent,
	dea.location,
	dea.date,
	dea.population
Order by
	1,2,3;
