-- IN THIS FILE I HAVE TRIED CTE SUBQUERY AND WINDOW FUNCTION.

select * from public.football_player;



CTE

-- Add a column in database which depicts whether a player is in senior year or not?

select * ,
case
when t.year='SR' then 'yes'
when t.year in ('JR','SO','FR') then 'no'
else 'no'
end as Player_is_senior_or_not
from public.football_player t



-- Group the players according to their weights by adding new column in database

select t.weight,
case
when t.weight <=150 then 'very low'
when t.weight>150 and t.weight<=170 then 'low'
when t.weight>170 and t.weight<=185 then 'high'
when t.weight>185 and t.weight<=200 then 'very high'
when t.weight>200 then 'huge'
else 'not matchable'
end as weight_group
from public.football_player t

--fetch the records where emp having salary more than avg salary?

with avg_salary(avg_s)  as 
(select cast(avg(wages)as int )  from public.empdetails)
select *from public.empdetails t,avg_salary av
where t.wages > av.avg_s;

select * from public.sql_inventory_data;







-- find product_name who's current_inventory is better than the avg inventory across all product?

select product_name,sum(current_inventory) as sum_inv
from public.sql_inventory_data
group by 1
order by 1

select cast(avg(sum_inv) as int) as avg_inv from (select product_name,sum(current_inventory) as sum_inv
from public.sql_inventory_data
group by 1) t1

--------------------------------------
-------------------------------
`from sub_query



-- select *	
-- 			from 
-- 			(select product_name,sum(current_inventory) as sum_inv
-- 												from public.sql_inventory_data
-- group by 1 ) total_inv
-- join 
-- 		(select cast(avg(sum_inv) as int) as avg_inv from 
--  							(select product_name,sum(current_inventory) as sum_inv
-- 														from public.sql_inventory_data
-- group by 1) t2) avg_inv
-- on total_inv.sum_inv > avg_inv
-- order by 2 desc


------------------------------------------------------
------------------------------------------

`FROM CTE


with total_inv (product_name,sum_inv) as
			(select product_name,sum(current_inventory) as sum_inv
												from public.sql_inventory_data
												group by 1),
	  
	  avg_inventory (avg_inv) as
			(select (cast(avg(sum_inv) as int)) as avg_inv from total_inv)
			 
select * from total_inv t1
join
avg_inventory t2
on t1.sum_inv>t2.avg_inv
order by 2 desc


-------------------------------------------------
-------------------------------------------------
   `WINDOW FUNC

select * from public.empdetails

select t.*,
max(wages) over(partition by t.edesignation order by t.wages desc) as max_wages_for_particular_dept,
max(last_payout) over(partition by t.edesignation order by t.wages desc) as max_wages_for_particular_dept
from public.empdetails t

select t.*,
sum(wages) over (partition by t.edesignation) as total_wages_by_dept,
sum(last_payout) over (partition by t.edesignation) as total_payout_by_dept
from public.empdetails t

select t.*,
avg(wages) over (partition by t.edesignation)::int as total_wages_by_dept,
avg(last_payout) over (partition by t.edesignation)::int as total_payout_by_dept
from public.empdetails t


select edesignation,avg(wages) avg_wages from public.empdetails
group by 1    -- but can not fetch all data 


select t.*,
sum(wages) over (order by t.wages  rows between unbounded preceding and current row) as running_total
--sum(wages) over (order by t.wages desc  rows between unbounded following and current row) as running_total
from public.empdetails t

----------------------------------------
--row_number,dense,rank, lead and lag


select * from public.conversion_data

select t.*,
row_number () over(order by t.ad_id) as id_no 
from public.conversion_data t

select *
from public.nominee_details

select t.*,
rank() over(order by t.year) as id_for_year
from public.nominee_details t


select t.*,
row_number() over(partition by t.category order by year) as ranks
from public.nominee_details t

SELECT t.*,
dense_rank() over(order by category )
from public.nominee_details  t


select distinct movie
from public.nominee_details
where winner=true and year>2010


SELECT t.*,
dense_rank() over(partition by category order by year ) rnk
from public.nominee_details  t
order by rnk

select t.*,
lag(year,1,0)  over(partition by category order by year) prev_year_in_category
from public.nominee_details t


select t.*,
lead(year)  over(partition by category order by year) next_year_in_category
from public.nominee_details t


select *,
ntile(10) over(order by id)
from public.nominee_details


select * from public.empdetails

select *,
percent_rank() over(order by wages)*100 prcntg
from public.empdetails

select * from orders;

select *,
first_value(product) over(partition by product order by product_price)
from orders;





