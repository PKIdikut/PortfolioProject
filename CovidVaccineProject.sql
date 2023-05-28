/* courtesy to  Alex The Analyst

*/

/*

Queries used for Tableau Project

*/



-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidVaccineProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From CovidVaccineProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidVaccineProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidVaccineProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidVaccineProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc






-- Queries I originally had, but excluded some because it created too long of video
-- Here only in case you want to check them out


-- 1.

Select dea.continent, dea.location, dea.date, dea.population
, MAX(vac.total_vaccinations) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidVaccineProject..CovidDeaths dea
Join CovidVaccineProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3




-- 2.
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidVaccineProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From CovidVaccineProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 3.

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidVaccineProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc



-- 4.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidVaccineProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc



-- 5.

--Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From CovidVaccineProject..CovidDeaths
----Where location like '%states%'
--where continent is not null 
--order by 1,2

-- took the above query and added population
Select Location, date, population, total_cases, total_deaths
From CovidVaccineProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
order by 1,2


-- 6. 


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidVaccineProject..CovidDeaths dea
Join CovidVaccineProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac


-- 7. 

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidVaccineProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc




--#######################################################################################################----

---  Mening !!!!!

select * from CovidVaccineProject..covidDeaths
order by 3,4

--select * from CovidVaccineProject..covidVacsinations
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from CovidVaccineProject..covidDeaths 
order by 1,2

-- Total Cases VS Total Deaths
-- 
select * from CovidVaccineProject..covidDeaths 
order by 3,4

--select * from CovidVaccineProject..covidVacsinations
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from CovidVaccineProject..covidDeaths
order by 1,2

-- Total Cases VS Total Deaths

-- (cast(total_deaths as int)/cast (total_deaths as int)) *100 as DeathPercentage

select location,date,total_cases,total_deaths/total_cases *100 as DeathPercentage
from CovidVaccineProject..covidDeaths 
where location like ('Finland')
order by 1,2


-- Total Cases VS Population

select location,date,Population, total_cases, total_cases/population *100 as PercentPopulationInfected
from CovidVaccineProject..covidDeaths 
--where location like ('Finland')
order by 1,2

-- Countries with Highest Infection Rates compare to Population

select location,Population, max(total_cases) as HighestInfectionCount, 
max(total_cases/population) *100 as PercentPopulationInfected
from CovidVaccineProject..covidDeaths 
--where location like ('Finland')
group by location,population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population 

select location,max(cast(Total_deaths as int)) as TotalDeathCount
from CovidVaccineProject..covidDeaths 
--where location like ('Finland')
where continent is not null
group by location
order by TotalDeathCount desc

-- Break Things by Continent

select continent,max(cast(Total_deaths as int)) as TotalDeathCount
from CovidVaccineProject..covidDeaths 
--where location like ('Finland')
where continent is not null
group by continent
order by TotalDeathCount desc


-- Countinents with Highest Death Count per Population 

-- Global Numbers

select sum(new_cases) as total_cases,
sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int)) / sum(new_cases)*100 as DeathPercentage
from CovidVaccineProject..covidDeaths 
-- where location like ('Finland')
where continent is not null
order by 1,2


-- Total Population VS Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert (bigint, vac.new_vaccinations)) over (Partition by dea.location
	order by dea.location, dea.Date) as RollingPeopleVaccinated
	,(RollingPeopleVaccinated)*100
	
from CovidVaccineProject..covidDeaths dea
join CovidVaccineProject..covidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- Use CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert (bigint, vac.new_vaccinations)) over (Partition by dea.location
	order by dea.location, dea.Date) as RollingPeopleVaccinated
	--,(RollingPeopleVaccinated)*100
	
from CovidVaccineProject..covidDeaths dea
join CovidVaccineProject..covidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
-- order by 2,3
)

select *,(RollingPeopleVaccinated/Population)*100
from PopvsVac


-- Temp Table

Drop table if exists #PercentPopulationVaccinated

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert (bigint, vac.new_vaccinations)) over (Partition by dea.location
	order by dea.location, dea.Date) as RollingPeopleVaccinated
	--,(RollingPeopleVaccinated)*100
	
from CovidVaccineProject..covidDeaths dea
join CovidVaccineProject..covidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date
-- where dea.continent is not null
-- order by 2,3

select *,(RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated



-- Create View to store data for later visualizations

Create View PercentPopulationVaccinated as

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert (bigint, vac.new_vaccinations)) over (Partition by dea.location
	order by dea.location, dea.Date) as RollingPeopleVaccinated
	--,(RollingPeopleVaccinated)*100
	
from CovidVaccineProject..covidDeaths dea
join CovidVaccineProject..covidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
-- order by 2,3

select * from PercentPopulationVaccinated

