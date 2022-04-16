select * from [sql data exploration project]..coviddeath
order by 3,4
-- normal select comment to check difference between two tables
select * from [sql data exploration project]..vaccination
order by 3,4  

SELECT location, date, total_caseS, new_cases, total_deaths, population
FROM [sql data exploration project]..coviddeath
ORDER BY 1,2



-- total case vs total death
SELECT location, date, total_caseS, total_deaths, (total_deaths/total_cases)*100 as 'death per case(PERCENTAGE)'
FROM [sql data exploration project]..coviddeath
WHERE (total_deaths/total_cases)  IS NOT NULL
ORDER BY 1,2


--  total case vs total death For turkey and prob. of dying of covid
SELECT location, date, total_caseS, total_deaths, (total_deaths/total_cases)*100 as 'death per case(PERCENTAGE)'
FROM [sql data exploration project]..coviddeath
WHERE (total_deaths/total_cases)  IS NOT NULL AND location = 'turkey'
ORDER BY 1,2


-- total case vs population  percantage show
SELECT location, date, total_caseS, population, (total_cases/population)*100 as 'case per population(PERCENTAGE)'
FROM [sql data exploration project]..coviddeath
WHERE (total_deaths/total_cases)  IS NOT NULL AND location = 'turkey'
ORDER BY 1,2


-- looking at countries highest infection rate by population 
SELECT location, [population],
MAX(total_cases) as highest,
max((total_cases/[population])*100) as 'case per population(PERCENTAGE)'
FROM [sql data exploration project]..coviddeath
GROUP BY location, [population]
ORDER BY 4 DESC;

--looking at death count descending
SELECT location,  max(cast(total_deaths as int)) as death  FROM [sql data exploration project]..coviddeath
group by location
having max(total_deaths) is not null
order by 2 desc


--looking at death count descending by continent and location

SELECT continent,  max(cast(total_deaths as int)) as death  FROM [sql data exploration project]..coviddeath
where continent is not null
group by continent
having max(total_deaths) is not null
order by 2 desc

--looking at death count descending by location

SELECT location,  max(cast(total_deaths as int)) as death  FROM [sql data exploration project]..coviddeath
where continent is null 
group by location
having max(total_deaths) is not null
order by 2 desc

--looking at death count descending by location where continent is not null
SELECT location,  max(cast(total_deaths as int)) as death  FROM [sql data exploration project]..coviddeath
where continent is not null 
group by location
having max(total_deaths) is not null
order by 2 desc

-- looking total world cases and deaths group by dates

SELECT date, SUM(new_cases) as total_case_byday, SUM(CAST(new_deaths as INT)) as 'total deaths by day',
SUM(CAST(new_deaths as INT))*100/SUM(new_cases) as death_percent
FROM [sql data exploration project]..coviddeath
WHERE continent is not null
GROUP BY DATE
HAVING SUM(new_cases) IS NOT NULL AND SUM(new_cases)  <> 0
ORDER BY 1,2


-- looking total world cases and deaths partition by dates
SELECT distinct date, SUM(new_cases) over (partition by date) , SUM(CAST(new_deaths as INT)) over (partition by date)
FROM [sql data exploration project]..coviddeath
where continent is not null
order by 1,2

--looking at total vaccination and poulation

SELECT C.continent, C.location, C.date, C.population, V.new_vaccinations, V.[total_vaccinations]
FROM [sql data exploration project]..coviddeath C
JOIN [sql data exploration project]..vaccination V ON C.location = V.location and
	C.date = V.date
	where C.continent is not null AND  V.[total_vaccinations_per_hundred] IS NOT NULL AND V.location='tURKEY'
	order  by 1 , 2 



--looking at total vaccination and poulation PARTITION BY to see incremental cumulative 

SELECT DISTINCT C.continent, C.location, C.date, C.population, V.new_vaccinations,
		SUM(CAST(V.new_vaccinations as BIGINT)) OVER (PARTITION BY C.location ORDER BY C.location ,C.date )  as cumulativevacs
FROM [sql data exploration project]..coviddeath C	
INNER JOIN [sql data exploration project]..vaccination V ON C.location = V.location and
	C.date = V.date
	where C.continent is not null  
	order  by 2,3 


	--USING CTE BECAUSE (cumulativevaccinations*100/population) IS NOT POSSIBLE SINCE cumulativevaccinations TEMP COLUMN
	WITH CTE( continent, location, date, population, new_vaccinations, cumulativevaccinations)
	AS(
	SELECT DISTINCT C.continent, C.location, C.date, C.population, V.new_vaccinations,
		SUM(CAST(V.new_vaccinations as BIGINT)) OVER (PARTITION BY C.location ORDER BY C.location ,C.date )  as cumulativevaccinations
FROM [sql data exploration project]..coviddeath C	
INNER JOIN [sql data exploration project]..vaccination V ON C.location = V.location and
	C.date = V.date
	where C.continent is not null  
	
	)

		SELECT DISTINCT continent, location, date, population, new_vaccinations, 
		(cumulativevaccinations*100/population) as 'vacc.overpop'
	FROM CTE
	order  by 2,3 
	

-- TEMP TABLE USE BECAUSE (cumulativevaccinations*100/population) IS NOT POSSIBLE SINCE cumulativevaccinations TEMP. COLUMN
DROP TABLE IF EXISTS #TABLE1
CREATE TABLE #TABLE1

(Continent varchar(255),
Location nvarchar(255),
date datetime,
population bigint,
new_vaccination bigint,
cumulativevacs bigint)

INSERT INTO #TABLE1
SELECT DISTINCT C.continent, C.location, C.date, C.population, V.new_vaccinations,
		SUM(CAST(V.new_vaccinations as BIGINT)) OVER (PARTITION BY C.location ORDER BY C.location ,C.date )  as cumulativevacs
FROM [sql data exploration project]..coviddeath C	
INNER JOIN [sql data exploration project]..vaccination V ON C.location = V.location and
	C.date = V.date
	where C.continent is not null  
	order  by 2,3
	

		SELECT DISTINCT *, (cumulativevacs*100/population) as 'vacc.overpop'
FROM #TABLE1
order  by 2,3 



--temp table use 2 
SELECT *,((cumulativevacs*100)/population) AS 'vacc.overpop'
    

FROM
   ( SELECT DISTINCT C.continent, C.location, C.date, C.population, V.new_vaccinations,
		SUM(CAST(V.new_vaccinations as BIGINT)) OVER (PARTITION BY C.location ORDER BY C.location ,C.date )  as cumulativevacs
FROM [sql data exploration project]..coviddeath C	
INNER JOIN [sql data exploration project]..vaccination V ON C.location = V.location and
	C.date = V.date
	where C.continent is not null  
	) T2
	 ORDER BY 2,3




	-- SELECT INTO #TABLE2 --- temporary table
	
	

	--CREATİNG VİEW  TO STORE DATE FOR LATER VISUALISATION

	CREATE VIEW vacc_overpop AS		
	SELECT DISTINCT C.continent, C.location, C.date, C.population, V.new_vaccinations,
		SUM(CAST(V.new_vaccinations as BIGINT)) OVER (PARTITION BY C.location ORDER BY C.location ,C.date )  as cumulativevaccinations
FROM [sql data exploration project]..coviddeath C	
INNER JOIN [sql data exploration project]..vaccination V ON C.location = V.location and
	C.date = V.date
	where C.continent is not null  
	
	
	-- still we have tables though 
	SELECT * FROM vacc_overpop
	order by 2  , 3 desc