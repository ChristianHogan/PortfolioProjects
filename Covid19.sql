USE Covid19;
SET SQL_SAFE_UPDATES = 0;
delete from Covid19.owid where location like '%income%';

Create View TotalDeathsPerCountry as
SELECT location, MAX(cast(total_deaths as float)) as TotalDeathCount
From Covid19.owid
Where continent != ""
group by location
order by TotalDeathCount desc;

Create View TotalInfectionsPerCountry as
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From Covid19.owid
Group by location, population
order by PercentPopulationInfected desc;

Create View TotalDeathsPerContinent as
SELECT location, MAX(cast(total_deaths as float)) as TotalDeathCount
From Covid19.owid
Where continent = "" 
group by location
order by TotalDeathCount desc;

Create View DeathPercentagePerDay as
SELECT date, SUM(new_cases), SUM(cast(new_deaths as float)), SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
From Covid19.owid
where continent !=""
Group by date;

Create View VaccinationRate as
With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select continent, location, date, population, new_vaccinations, 
SUM(cast(new_vaccinations as float)) OVER (Partition by location Order by location, date) as RollingPeopleVaccinated
From Covid19.owid
Where continent != ""
)
Select *, (RollingPeopleVaccinated/population)*100 as PopulationVaccinated
From PopvsVac;





