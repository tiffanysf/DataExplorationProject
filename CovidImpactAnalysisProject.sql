-- Select Data that I'm going to be using 

Select * 
From CovidPortfolioProject1..[CovidDeaths$']
Where continent is not null 
Order by 3,4

Select * 
From CovidPortfolioProject1..CovidVax
Order by 3,4


-- Looking at total cases vs Total Deaths 
-- Query shows the likliood of dying if you contract covid in your country 
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidPortfolioProject1..[CovidDeaths$']
Where location like '%states%' and continent is not null 
Order by 1,2

-- Looking at the total cases vs population in the United States 
-- Shows what percentage of population got Covid 
Select location, date, Population, total_cases, total_deaths, (total_cases/population)*100 as DeathPercentage
From CovidPortfolioProject1..[CovidDeaths$']
Where location like '%states%' and continent is not null
Order by 1,2

-- Looking at Countries with highest infection rate compared to population 
-- Notes: Must add group by when using an aggregate function 
Select location, Population, Max(total_cases) as Highest_Infection_Count, Max((total_deaths/total_cases))*100 as Percent_Population_Infected
From CovidPortfolioProject1..[CovidDeaths$']
-- Where location like '%states%'
Group by Location, population
Order by Percent_Population_Infected desc 

-- Looking at Countries with highest death count per population
Select location, Max(cast(total_deaths as int)) as Total_Death_Count 
From CovidPortfolioProject1..[CovidDeaths$']
Where continent is not null 
Group by Location
Order by Total_Death_Count desc 

-- Filtering by location to see the highest death count by location
Select location, Max(cast(total_deaths as int)) as Total_Death_Count 
From CovidPortfolioProject1..[CovidDeaths$']
Where continent is not null 
Group by location
Order by Total_Death_Count desc 

-- Global numbers 
Select date, Sum(new_cases), Sum(Cast(new_deaths as int)), Sum(new_deaths)/sum(new_cases)*100 as DeathPercentage 
From CovidPortfolioProject1..[CovidDeaths$']
Where continent is not null 
Group by date 
Order by 1,2 

-- Looking for Total Population vs Vaccinations 

Select [CovidDeaths$'].continent, [CovidDeaths$'].location, [CovidDeaths$'].date
From CovidPortfolioProject1..[CovidDeaths$'] join CovidPortfolioProject1..CovidVax 
on [CovidDeaths$'].location = CovidVax.location and [CovidDeaths$'].date = CovidVax.date
Where [CovidDeaths$'].continent is not null	
Order by 2,3

-- Looking at the Total Population vs Vaccinations locations  
Select [CovidDeaths$'].continent, [CovidDeaths$'].location, [CovidDeaths$'].date, CovidVax.location, Sum(Cast(CovidVax.location as int)) over (Partition by [CovidDeaths$'].location, [CovidDeaths$'].date)
From CovidPortfolioProject1..[CovidDeaths$'] join CovidPortfolioProject1..CovidVax 
on [CovidDeaths$'].location = CovidVax.location and [CovidDeaths$'].date = CovidVax.date
Where [CovidDeaths$'].continent is not null	
Order by 2,3

-- Creating view to store data visualizations 
Create view TotalCasesVSPopulationInUSA as 
Select location, date, Population, total_cases, total_deaths, (total_cases/population)*100 as DeathPercentage
From CovidPortfolioProject1..[CovidDeaths$']
Where location like '%states%' and continent is not null
-- Order by 1,2

Create view HighestDeathCountByLocation as 
Select location, Max(cast(total_deaths as int)) as Total_Death_Count 
From CovidPortfolioProject1..[CovidDeaths$']
Where continent is not null 
Group by location
-- Order by Total_Death_Count desc 

Create view TotalInfectionsVsTotalDeaths as 
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidPortfolioProject1..[CovidDeaths$']
Where location like '%states%' and continent is not null 
-- Order by 1,2