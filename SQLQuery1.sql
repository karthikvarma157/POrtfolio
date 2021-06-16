



select * from 
portfolioproject..covidVcaccinations
where continent is not null
order by 3,4


select location,date,total_cases,new_cases,total_deaths,population from 
portfolioproject..covidDeaths
order by 1,2

--Total cases vs Total Deaths

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPerecentage from 
portfolioproject..covidDeaths
--where location like 'india'
order by 1,2

--glance at total cases vs population( % of population affected)


select location,date,total_cases,population,(total_cases/population)*100 as DeathPerecentage from 
portfolioproject..covidDeaths
--where location like 'india'
order by 1,2

--looking at most affected coutries according to population

select location,max(total_cases) as Highestinfected ,population,max((total_cases/population))*100 as PerecentageofpopulationInfected from 
portfolioproject..covidDeaths
--where location like 'india'
group by location, population
order by PerecentageofpopulationInfected desc


--countries with highest death rate vs population

select continent,max(cast(total_deaths as int)) as totaldeathcount, max((total_deaths/population))*100 as Dpecentage from 
portfolioproject..covidDeaths
--where location like 'india'
where continent is not null
group by continent
order by  totaldeathcount desc

----Showing highest Deaths BY CONTINENT

select continent,max(cast(total_deaths as int)) as totaldeathcount from 
portfolioproject..covidDeaths
--where location like 'india'
where continent is not null
group by continent
order by  totaldeathcount desc

--Global

select sum(new_cases) as total_cases ,sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage from portfolioproject..covidDeaths
--where location like 'india'
where continent is not null
--group by date
order by 1,2

--Looking at total population vs vaccination

select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations, sum(cast(new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date ) as Rollingpeoplevaccinated from portfolioproject..covidDeaths as dea
join portfolioproject..covidVcaccinations as vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null 
order by 2,3

--USE CTE


with popvsvac(continent,location,date,population,new_vaccinations,Rollingpeoplevaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations, sum(cast(new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date ) as Rollingpeoplevaccinated from portfolioproject..covidDeaths as dea
join portfolioproject..covidVcaccinations as vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null 

)
select *, (Rollingpeoplevaccinated/population)*100
from popvsvac

--Creating a view to save data for visualization
create view popvsvac as
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations, sum(cast(new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date ) as Rollingpeoplevaccinated from portfolioproject..covidDeaths as dea
join portfolioproject..covidVcaccinations as vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null 





