-- IN THIS FILE I HAVE DONE SOME DDL AND DML COMMANDS

select * from public.empdetails

 alter table public.empdetails 
add last_payout varchar(50)


alter table public.empdetails
alter column last_payout type integer using last_payout::integer

alter table public.empdetails
drop column last_payout

alter table public.empdetails 
add last_payout integer
 

update public.empdetails
set last_payout= 36000  where ename='RAVI' ;
update public.empdetails
set last_payout= 39000  where ename='VISHNU'
update public.empdetails
set last_payout= 35000  where ename='SUHAIL'
update public.empdetails
set last_payout= 38500  where ename='SHANKAR'
update public.empdetails
set last_payout= 45100  where ename='RAM'
update public.empdetails
set last_payout= 37900  where ename='VIKAS'

 select *from public.empdetails;

/*insert into public.empdetails
(last_payout)
values
(34800),
(39500),
(33000),
(37000),
(41000),
(36500);*/
===================================================================================

--aggrigation with subquery

SELECT  max(a.wages) as max_salary,
(select min(b.wages) from public.empdetails b) min_salary 
from public.empdetails a
;

select *
from public.empdetails a
where a.wages>=40000 and a.last_payout<50000

--Self join
select t1.eid, t1.ename,t2.edesignation from public.empdetails t1,public.empdetails t2
where t1.eid<>t2.eid and t1.edesignation=t2.edesignation;

================================================================================================

--inner join

select *,
case when t3.d_date=t1.orderdate then 'Very Fast Delivery'
 when t3.d_date-t1.orderdate=1 then 'Fast Delivery'
 when t3.d_date-t1.orderdate=2 then 'Delivered'
 when t3.d_date-t1.orderdate>2 then 'Slow Delivery'
Else 'Not delivered yet'
end as D_Status
from public.orders t1 
inner join public.product t2
on t1.pid=t2.pid 
inner join public.delivery t3
on t1.oid=t3.oid
-- where t3.d_date-t1.orderdate<=2 
;

=========================================================================
=========================================================================


--LETS WORK ON NOMINEE TABLE

--Write a query to display all the records in the table 
select * from public.nominee_details;

--Write a query to find the distinct values in the ‘year’ column
-- select distinct t1.year from public.nominee_details t1;

--Write a query to filter the records from year 1999 to year 2006?
alter table public.nominee_details 
alter column year type numeric using "year"::numeric ;

select * from public.nominee_details t1
where t1.year between 1999 and 2006;

--Write a query to filter the records for either year 1991 or 1998.

select * from public.nominee_details t
where t.year=1991 or t.year=1998 ;

--Write a query to return the winner movie name for the year of 1937.

select t.year,t.movie,t.winner from public.nominee_details t
where t.winner = true and t.year=1937
order by 1;

--Write a query to return the winner in the ‘actor in a leading role’
-- and ‘actress in a leading role’ 
-- category for the year of 1994,1980, and 2008. 

select *
from public.nominee_details t
where t.category in ('actor in a leading role','actress in a leading role')
and t.year in (1994,1980,2008) ;


-- Write a query to return the name of the movie starting from letter ‘a’

select t.movie
from public.nominee_details t
where t.movie like 'A%'

-- Write a query to return the name of movies containing the word ‘the’.

select t.movie from public.nominee_details t
where upper(t.movie) like '%THE%'


-- Write a query to return all the records 
-- where the nominee name starts with “c” and ends with “r

select * from public.nominee_details t
where t.nominee like 'C%r'
;


-- Write a query to return all the records where the movie
-- was released in 2005 and movie name does 
-- not start with ‘a’ and ‘c’ and nominee was a winner

select * from public.nominee_details t
where t.year=2005 and t.movie not like '%A' and t.movie not like 'C%';


select * from public.conversion_data;

-- Write a query to count the total number of records
-- in the tutorial.kag_conversion_data dataset
select count(*) from public.conversion_data;

-- Write a query to count the distinct number of fb_campaign_id.
select count(distinct t.fb_campaign_id) as cnt_fbid from public.conversion_data t;


-- Write a query to find the maximum spent, 
-- average interest, minimum impressions for ad_id.

select max(t.spent),avg(t.interest),min(t.impressions) 
from public.conversion_data t

-- Write a query to create an additional column spent per impressions(spent/impressions
select *, round(t.spent/t.impressions,5) as "spent/imp" from public.conversion_data t



