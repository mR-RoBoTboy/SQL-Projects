--IN THIS FILE I HAVE TRIED SOME QUERIES.
===================================================================

select * from public.conversion_data;

-- Write a query to count the ad_campaign for each age group
select count(t.ad_id) as Cnt_of_adcmpgn,t.age
from public.conversion_data t
group by 2

-- Write a query to calculate the average spent on ads for each gender category
select t.gender,round(avg(t.spent),2) as avg_spent
from public.conversion_data t
group by 1

-- Write a query to find the total approved conversion per 
-- xyz campaign id. Arrange the total 
-- conversion in descending order
select count(t.approved_conversion) as total_aprvd_cnvrsn ,t.xyz_campaign_id
from public.conversion_data t
where t.approved_conversion=1
group by 2
order by 1 desc

-- Write a query to show the fb_campaign_id and
-- total interest per fb_campaign_id. Only show the 
-- campaign which has more than 300 interests.

select t.fb_campaign_id,sum(t.interest) as total_interest  from public.conversion_data t
group by 1
having sum(t.interest)>300

-- Write a query to find the age and gender segment with
-- maximum impression to interest ratio. Return 
-- three columns - age, gender, impression_to_interest.

select t.age,t.gender, (sum(t.impressions)/sum(t.interest)) as impression_to_interest
from public.conversion_data t
group by 1,2
order by 3 desc
limit 1


-- Write a query to find the top 2 xyz_campaign_id and gender segment with the maximum 
-- total_unapproved_conversion 

select t.xyz_campaign_id,t.gender,sum(t.total_conversion-t.approved_conversion)
		as total_unapproved_conversion
from public.conversion_data t
group by 1,2
order by 3 desc
limit 2


---------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
 #JOINS
 
SELECT * FROM PUBLIC.football_player;

select * from public.football_teams;


-- Write a query to return player_name, school_name, 
-- position, conference from the above dataset

select t1.player_name,t2.school_name,t1.position,t2.conference
from public.football_player t1
inner join 
public.football_teams t2
on t1.id=t2.id

-- Write a query to find the total number of 
-- players playing in each conference.Order the output in the 
-- descending order of number of players

select count(t1.player_name) as total_player,t2.conference
from public.football_player t1
inner join 
public.football_teams t2
on t1.id=t2.id
group by 2
order by 1 desc

-- Write a query to find the average height of players per division

select t2.division,round(avg(t1.height),2) as avg_height
from public.football_player t1
inner join 
public.football_teams t2
on t1.id=t2.id
group by 1
order by 2 desc

-- Write a query to return to the conference 
-- where average weight is more than 210. Order the output 
-- in the descending order of average weight.

select t2.conference,round(avg(t1.weight),2) as avg_weight
from public.football_player t1
inner join 
public.football_teams t2
on t1.id=t2.id
group by 1
having avg(t1.weight)>210
order by 2 desc


-- Write a query to return to the top 3 conference with the highest BMI (weight/height) ratio

select t2.conference,round((703*sum(t1.weight)/sum(power(t1.height,2))),2) as BMI
from public.football_player t1
inner join 
public.football_teams t2
on t1.id=t2.id
group by 1
order by 2 desc
limit 3



------------------------------------------
------------------------------------------


select * from public.sql_inventory_data;

select * from public.sql_transaction_data;


-- Find the product which does not sell a single unit.

select t1.product_name,t2.time
from public.sql_inventory_data t1
left join
public.sql_transaction_data t2
on t1.product_id=t2.product_id
where t2.time is null

-- Write a query to find how many units
-- are sold per product. Sort the data in terms of unit 
-- sold(descending order)

select t1.product_id, t1.product_name,count(t2.product_id)
from public.sql_inventory_data t1
left join
public.sql_transaction_data t2
on t1.product_id=t2.product_id
group by 1,2
order by 3 desc


-- Write a query to return product_type and units_sold
-- where product_type is sold more than 50 times.

select t1.product_type,count(t2.product_id) as unit_sold
from public.sql_inventory_data t1
left join
public.sql_transaction_data t2
on t1.product_id=t2.product_id
group by 1
having count(t2.time)>50








---------------------------------------------
---------------------------------------------

		#subquery
		
		

-- Create a query that selects all Warrant Arrests
-- from the sf_crime_incidents_2014_01 dataset, then wrap it in a 
-- query that only exposes unresolved incidents


  SELECT sq.*
  FROM  
  (select * from tutorial.sf_crime_incidents_2014_01
          WHERE descript='WARRANT ARREST') sq
  WHERE sq.resolution='NONE'





--  Write a query that counts the number of companies 
--  founded and acquired by quarter starting in Q1 2012. Create the 
-- aggregations in two separate queries, then join them. 
-- Use: tutorial.crunchbase_companies, tutorial.crunchbase_acquisitions tables.


select * FROM tutorial.crunchbase_companies;

select * FROM   tutorial.crunchbase_acquisitions;


SELECT COALESCE(companies.quarter, acquisitions.quarter) AS quarter,
 companies.companies_founded,
 acquisitions.companies_acquired
 FROM (
 SELECT founded_quarter AS quarter,
 COUNT(permalink) AS companies_founded
 FROM tutorial.crunchbase_companies
 WHERE founded_year >= 2012
 GROUP BY 1
 ) companies
LEFT JOIN (
 SELECT acquired_quarter AS quarter,
 COUNT(DISTINCT company_permalink) AS companies_acquired
 FROM tutorial.crunchbase_acquisitions
 WHERE acquired_year >= 2012
 GROUP BY 1
 ) acquisitions
 
 ON companies.quarter = acquisitions.quarter
 ORDER BY 1	

















