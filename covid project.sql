
select location, total_cases, total_deaths, date, new_cases, population
from portfolioproject..CovidDeaths$
order by 1,2

select location, total_cases, total_deaths, date, (total_deaths/total_cases)*100 as deathpercentage
from portfolioproject..CovidDeaths$
where location like '%india%'
order by 1,2






select location,MAX( total_cases) as highestinfectioncount, population,max((total_cases/population))*100 as percentpopulationinfected
from portfolioproject..CovidDeaths$
--where location like '%india%'
group by location, population
order by percentpopulationinfected desc



select location,MAX(cast( total_deaths as int)) as totaldeathcount
from portfolioproject..CovidDeaths$
--where location like '%india%'
where continent is  not null
group by location
order by totaldeathcount desc




select continent,MAX(cast( total_deaths as int)) as totaldeathcount
from portfolioproject..CovidDeaths$
--where location like '%india%'
where continent is  null
group by continent
order by totaldeathcount desc
(



select  date,sum(new_cases) as total_cases ,sum(cast(new_deaths as int)) as total_deaths, sum (cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from portfolioproject..CovidDeaths$
--where location like '%india%'
where continent is not null
group by date
order by 1,2




select*
from portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
     on dea.location=vac.location
	 and dea.date=vac.date





 select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
from portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
     on dea.location=vac.location
	 and dea.date=vac.date
where  dea.continent is not null
order by 2,3








 select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
 Sum(convert( int,vac.new_vaccinations ) ) over (partition by dea.location order by dea.location,dea.date) as roolingpeoplevaccinated,
from portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
     on dea.location=vac.location
	 and dea.date=vac.date
where  dea.continent is not null
order by 2,3




with popvsvac(continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
 Sum(convert( int,vac.new_vaccinations ) ) over (partition by dea.location order by dea.location,dea.date) as roolingpeoplevaccinated
from portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
     on dea.location=vac.location
	 and dea.date=vac.date
where  dea.continent is not null

)
select* ,(rollingpeoplevaccinated/population)*100
from popvsvac

create view percentpopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
 Sum(convert( int,vac.new_vaccinations ) ) over (partition by dea.location order by dea.location,dea.date) as roolingpeoplevaccinated
from portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
     on dea.location=vac.location
	 and dea.date=vac.date
where  dea.continent is not null


select*
from percentpopulationvaccinated

 