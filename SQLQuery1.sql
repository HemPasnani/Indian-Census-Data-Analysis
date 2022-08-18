select * from [Project 1].dbo.Data1;
select * from [Project 1].dbo.Data2;
select count(*) from [Project 1]..Data1
select count(*) from [Project 1]..Data2

-- dataset for jharkand and bihar
select * from [Project 1]..Data1 where state in('Jharkhand','Bihar');

-- total population of india
select sum(Population) from [Project 1]..Data2;

-- average growth 
select State,AVG(Growth)*100 as "Growth percantage" from [Project 1]..Data1 group by State;

-- average sex ratio
select State ,round( avg(Sex_ratio),0) as "sex ratio" from [Project 1]..Data1 group by State order by [sex ratio] desc

-- average literacy rate
select State ,round( avg(Literacy),0) as "literacy" from [Project 1]..Data1 
group by State having round( avg(Literacy),0)>89 order by [Literacy] desc


-- top 3 states showing highest growth ratio
select  top 3 State,round(AVG(Growth)*100,2) as "Growth percantage" from [Project 1]..Data1 group by State order by [Growth percantage] desc


-- bottom 3 states lowest sex ratio
select top 3 State ,round( avg(Sex_ratio),0) as "sex ratio" from [Project 1]..Data1 group by State order by [sex ratio] asc


-- top and bottom 3 states in literacy rate
--top 3
drop table if exists topstates
create table topstates( state varchar(255),
                            topstate float)
insert into topstates
select  State,round(AVG(Literacy),0) as "Literacy rate" from [Project 1]..Data1
group by State order by [Literacy rate] desc
select top 3 * from topstates order by topstates.topstate desc

--bottom 3
drop table if exists bottom
create table bottomstatesss( state varchar(255),
                            bottomstate float)
insert into bottomstates
select  State,round(AVG(Literacy),0) as "Literacy rate" from [Project 1]..Data1
group by State order by [Literacy rate] desc
select top 3 * from bottomstates order by bottomstates.bottomstate asc

-- both together in a single table
select * from(select top 3 * from topstates order by topstates.topstate desc)a
union
select * from(
select top 3 * from bottomstates order by bottomstates.bottomstate asc)b

-- states starting with a

select  state from [Project 1]..Data1  where state like 'A%' group by State	

-- joining 2 tables 

select District, State , Population/(sex_ratio-1)  males,(population*sex_ratio)/(sex_ratio +1) from 

(select data1.District, data1.State, sex_ratio/1000 as sex_ratio, data2.Population from [Project 1]..Data1 
inner join  [Project 1]..Data2 on Data1.District = Data2.District)a


-- total literacy rate 
-- formula used total literacy ratio  = total literate people/ population therefore literate0ppl = literacyratio*population

select d.district , d.state ,round(d.literacy_ratio *d.population,0) as literate_people ,
round((1-d.literacy_ratio) *d.population,0)  as illeterate_people  from

(select  data1.District, data1.State, data1.Literacy/100 as literacy_ratio, 
data2.Population from [Project 1]..Data1 
inner join  [Project 1]..Data2 on Data1.District = Data2.District)d

--total males and females
-- formula used here is males = population/(sex ratio +1)
-- females =population* sex ratio /sex ratio +1

select d.state,sum(d.males) total_males,sum(d.females) total_females from
(select c.district,c.state state,round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from [Project 1]..Data1 a inner join [Project 1]..Data2 b on a.district=b.district ) c) d
group by d.state;




--output top 3 districts with highest literacy rate
select * from
(select Literacy , State	, District , rank() over(partition by state order by Literacy) as "rank" from [Project 1]..Data1)a
where "rank" in (1,2,3) order by state



