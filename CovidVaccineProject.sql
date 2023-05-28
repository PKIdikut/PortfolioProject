
select * from CovidVaccineProject..covidDeath
order by 3,4

--select * from CovidVaccineProject..covidVacsinations
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from CovidVaccineProject..covidDeath
order by 1,2

-- Total Cases VS Total Deaths
-- 
select * from CovidVaccineProject..covidDeath
order by 3,4

--select * from CovidVaccineProject..covidVacsinations
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from CovidVaccineProject..covidDeath
order by 1,2

-- Total Cases VS Total Deaths

-- (cast(total_deaths as int)/cast (total_deaths as int)) *100 as DeathPercentage

select location,date,total_cases,total_deaths/total_cases *100 as DeathPercentage
from CovidVaccineProject..covidDeath
where location like ('Finland')
order by 1,2


-- Total Cases VS Population

select location,date,Population, total_cases, total_cases/population *100 as PercentPopulationInfected
from CovidVaccineProject..covidDeath
--where location like ('Finland')
order by 1,2

-- Countries with Highest Infection Rates compare to Population

select location,Population, max(total_cases) as HighestInfectionCount, 
max(total_cases/population) *100 as PercentPopulationInfected
from CovidVaccineProject..covidDeath
--where location like ('Finland')
group by location,population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population 

select location,max(cast(Total_deaths as int)) as TotalDeathCount
from CovidVaccineProject..covidDeath
--where location like ('Finland')
where continent is not null
group by location
order by TotalDeathCount desc

-- Break Things by Continent

select continent,max(cast(Total_deaths as int)) as TotalDeathCount
from CovidVaccineProject..covidDeath
--where location like ('Finland')
where continent is not null
group by continent
order by TotalDeathCount desc


-- Countinents with Highest Death Count per Population 

-- Global Numbers

select sum(new_cases) as total_cases,
sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int)) / sum(new_cases)*100 as DeathPercentage
from CovidVaccineProject..covidDeath
-- where location like ('Finland')
where continent is not null
order by 1,2


-- Total Population VS Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert (bigint, vac.new_vaccinations)) over (Partition by dea.location
	order by dea.location, dea.Date) as RollingPeopleVaccinated
	,(RollingPeopleVaccinated)*100
	
from CovidVaccineProject..covidDeath dea
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
	
from CovidVaccineProject..covidDeath dea
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
	
from CovidVaccineProject..covidDeath dea
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
	
from CovidVaccineProject..covidDeath dea
join CovidVaccineProject..covidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
-- order by 2,3

select * from PercentPopulationVaccinated