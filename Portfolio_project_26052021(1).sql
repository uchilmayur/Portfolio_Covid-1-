Select * 
From Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(DEATHS)]
Where continent is not null
ORDER BY 3,4

--Select * 
--From Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(Vaccinated)]
--ORDER BY 3,4

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(DEATHS)]
Where location like '%India%'
and continent is not null
ORDER BY 1,2

Select location,date,population,total_cases,(total_cases/population)*100 as DeathPercentage
From Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(DEATHS)]
Where location like '%India%'
ORDER BY 1,2

Select location,population,Max(total_cases) as HighlyInf,Max((total_cases/population))*100 as PercentagePopINF
From Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(DEATHS)]
--Where location like '%India%'
Group by location,population
ORDER BY PercentagePopINF desc

Select location,Max(cast(total_deaths as int)) as TotalDeathCount
From Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(DEATHS)]
--Where location like '%India%'
Where continent is not null
Group by location
ORDER BY TotalDeathCount desc

Select continent,Max(cast(total_deaths as int)) as TotalDeathCountContinent
From Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(DEATHS)]
--Where location like '%India%'
Where continent is not null
Group by continent
ORDER BY TotalDeathCountContinent desc


Select date,SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths ,SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as NewDeathPerc
From Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(DEATHS)]
--Where location like '%India%'
Where continent is not null
Group by date 
ORDER BY 1,2


Select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths ,SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as NewDeathPerc
From Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(DEATHS)]
--Where location like '%India%'
Where continent is not null
--Group by date 
ORDER BY 1,2

Select * 
From Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(Vaccinated)]

Select * 
From Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(DEATHS)] dea
Join Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(Vaccinated)] vac
     On dea.location = vac.location
	 and dea.date  = vac.date


Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
From Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(DEATHS)] dea
Join Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(Vaccinated)] vac
     On dea.location = vac.location
	 and dea.date  = vac.date
Where dea.continent is not null
ORDER BY 2,3

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) Over (Partition by dea.location order by dea.location,dea.date) as RollingPeopVac
From Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(DEATHS)] dea
Join Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(Vaccinated)] vac
     On dea.location = vac.location
	 and dea.date  = vac.date
Where dea.continent is not null
ORDER BY 2,3


With POPvsVac(continent,location,date,population,new_vaccinations,RollingPeopVac)
as
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) Over (Partition by dea.location order by dea.location,dea.date) as RollingPeopVac
From Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(DEATHS)] dea
Join Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(Vaccinated)] vac
     On dea.location = vac.location
	 and dea.date  = vac.date
Where dea.continent is not null
--ORDER BY 2,3
)

Select * ,(RollingPeopVac/population)*100 as TotPeopVacc
from POPvsVac


Drop Table if exists #PercPOPUVacc
Create Table #PercPOPUVacc
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopVac numeric
)

Insert into #PercPOPUVacc
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) Over (Partition by dea.location order by dea.location,dea.date) as RollingPeopVac
From Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(DEATHS)] dea
Join Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(Vaccinated)] vac
     On dea.location = vac.location
	 and dea.date  = vac.date
--Where dea.continent is not null
--ORDER BY 2,3

Select * ,(RollingPeopVac/population)*100 as TotPeopVacc
from #PercPOPUVacc

Create View PercPOPUVacc as 
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) Over (Partition by dea.location order by dea.location,dea.date) as RollingPeopVac
From Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(DEATHS)] dea
Join Portfolio_Project_26052021..['covid-data_ALEX_PROJECT(1)(Vaccinated)] vac
     On dea.location = vac.location
	 and dea.date  = vac.date
Where dea.continent is not null
--ORDER BY 2,3

