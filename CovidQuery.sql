SELECT *
FROM PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

SELECT *
FROM PortfolioProject..CovidVaccinations$
order by 3,4

-- Data we will be using

SELECT location , date , total_cases , new_cases , total_deaths , population
FROM PortfolioProject..CovidDeaths
order by 1,2

--Total Worldwide cases and Death Percentage
SELECT  sum(new_cases) as Cases, sum(cast(new_deaths as int)) as Deaths, sum(cast(new_deaths as int))/ sum(new_cases) * 100 as DeathPerventage
FROM PortfolioProject..CovidDeaths
where continent is not null
order by 1,2



-- Total Cases vs Total Deaths Nigeria
SELECT location, sum(new_cases) as Cases, sum(cast(new_deaths as int)) as Deaths, sum(cast(new_deaths as int))/ sum(new_cases) * 100 as DeathPerventage
FROM PortfolioProject..CovidDeaths
where continent is not null
and location like '%nigeria%'
group by location
order by 1,2


-- Total Cases vs Total Deaths Canada
SELECT location, sum(new_cases) as Cases, sum(cast(new_deaths as int)) as Deaths, sum(cast(new_deaths as int))/ sum(new_cases) * 100 as DeathPerventage
FROM PortfolioProject..CovidDeaths
where continent is not null
and location like '%canada%'
group by location
order by 1,2

-- Countries 
SELECT LOCATION , population, max(total_cases) as HighestInfectionCount , round(max((total_deaths/population)*100),2) as PercentPopInfected
FROM PortfolioProject..CovidDeaths
where continent is not null
group by location, population
order by PercentPopInfected desc


-- Covid Deaths per HDI
SELECT location, population ,sum(new_cases) as HighestInfectionCount , human_development_index , sum(cast(new_deaths as int)) as Deaths
FROM PortfolioProject..CovidDeaths
where continent is not null
group by location, population ,human_development_index
order by 3,4


--Total Death for each Location and HDI
SELECT LOCATION , max(cast(new_deaths as int)) as TotalDeaths , human_development_index
FROM PortfolioProject..CovidDeaths
where continent is not null
group by location , human_development_index
order by TotalDeaths desc

--Total Death for each Continent and 
SELECT continent , max(cast(total_deaths as int)) as TotalDeaths
FROM PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeaths desc

--Total Death for each African Country and HDI
SELECT location , max(cast(total_deaths as int)) as TotalDeaths , human_development_index
FROM PortfolioProject..CovidDeaths
where continent like '%africa%'
group by location , human_development_index
order by TotalDeaths desc

SELECT date, sum(new_cases) as Cases, sum(cast(new_deaths as int)) as Deaths, sum(cast(new_deaths as int))/ sum(new_cases) * 100 as DeathPerventage
FROM PortfolioProject..CovidDeaths
where continent and new_cases is not null
group by date
order by 1,2

SELECT location, sum(new_cases) as Cases, sum(cast(new_deaths as int)) as Deaths, sum(cast(new_deaths as int))/ sum(new_cases) * 100 as DeathPerventage
FROM PortfolioProject..CovidDeaths
where continent is not null
and location like '%canada%'
group by location
order by 1,2


-- Population vs Vaccination
select dea.continent , dea.location , dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.Date, dea.Location) as Rolling
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


--Create View For Viz
Create View AfricaCovid1 as
SELECT location , max(cast(total_deaths as int)) as TotalDeaths , human_development_index
FROM PortfolioProject..CovidDeaths
where continent like '%africa%'
group by location , human_development_index



select *
from AfricaCovid

--Create View for Percentage Vaccinated
create view PercentVaccinated as
-- Population vs Vaccination
select dea.continent , dea.location , dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.Date, dea.Location) as Rolling
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


select Rolling
from PercentVaccinated


With PopvsVac (continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac