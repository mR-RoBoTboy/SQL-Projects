select * from empdetails;


-- print 3rd highest salary emp
with third_high as(
	select ename,wages,
	dense_rank() over(order by wages desc) as rank_no
	from empdetails)
	
select * from third_high
where rank_no=3;


--print 3rd lowest salary emp
with third_low as(
	select ename,wages,
	dense_rank() over(order by wages) as rank_no
	from empdetails)
	
select * from third_low
where rank_no=3;

--print1 to 1000 without using loop.

select generate_series(1,1000,1);


-- Find Duplicate records and also delete them.

create table dup_rec_tbl(
id serial not null,
fname varchar(20) not null,
lname varchar(20) not null,
age int not null,
profession varchar(20));


insert into dup_rec_tbl (fname,lname,age,profession)
values
('Ramesh','Kumar',26,'Eng'),
('Suresh','Sharma',29,'Marketing'),
('Mukesh','Kushwah',30,'Business'),
('Sarvesh','Khanna',27,'Business'),
('Ramesh','Kumar',26,'Eng'),
('Vasya','Thakur',25,'Acount'),
('Vasya','Thakur',25,'Acount'),
('Raja','Ahlawat',32,'Hr'),
('Mukesh','Kushwah',30,'Business'),
('Raja','Ahlawat',32,'Hr');

select * from dup_rec_tbl;

select fname,age,profession,count(fname) dup_count
from dup_rec_tbl
group by 1,2,3
having count(fname)>1;


-- with del_dup as (
-- 		select id ,
-- 	row_number() over(partition by id order by id) part_row
-- 	from dup_rec_tbl )
	
delete from dup_rec_tbl
where id in (select id from(select *,
row_number() over(partition by fname order by id) part_row
from dup_rec_tbl) t1 where t1.part_row=2);

/* TRIED
delete from dup_rec_tbl t1
using dup_rec_tbl t2
where t1.id>t2.id
and t1.fname=t2.fname;*/

select * from dup_rec_tbl;

drop table dup_rec_tbl;


-- make first name(nitesh) last name(parashar) as nitesh parashar

select id,(fname ||' '|| lname) as full_name,age,profession
from dup_rec_tbl;


-- make full name (nitesh parashar) as fist name=nitesh last name= parashar

select * from football_player;

select trim(split_part(full_school_name,' ',1)) as fschoolname,
trim(split_part(player_name,' ',1)) as pfirstname,
trim(split_part(player_name,' ',2)) as plastname
from football_player;

-- write a query to print fruits name as(apple,guaave,strowberry,grapes,banana,coconut) in single row

create or replace function fruits_name(varchar(10),varchar(10),varchar(10),varchar(10),varchar(10))
returns text
language plpgsql
as $$
declare
	a alias for $1;
	b alias for $2;
	c alias for $3;
	d alias for $4;
	e alias for $5;
	f text;
begin
	f=a||','||b||','||c||','||d||','||e;
return f;
end; $$

select fruits_name('apple','guaava','strowberry','grapes','banana');

==========================================================================================
/*

-- write a query for printing fruits name as a list (new row for each fruit)

-- select split_part((select fruits_name('apple','guaave','strowberry','grapes','banana'),',',1)

-- select unnest((select fruits_name('apple','guaave','strowberry','grapes','banana')),',');

-- split_part((select concat_ws(',','apple','guaave','strowberry','grapes','banana')) as concate,',') ;*/   tried,but Not worked.
===========================================================================================

 write a query for printing fruits name as a list (new row for each fruit)

select regexp_split_to_table('apple guava strowberry grapes banana','\s+') as friuts_name;


=============================================

create table if not exists fruits_name(name character varying);
insert into fruits_name(name) values ('Apple')
select * from fruits_name;
drop table fruits_name;

insert into fruits_name values ('banana');

create or replace procedure apend_fruit(character varying(50))
language plpgsql
as $$
declare 
	a alias for $1;  
begin
	update fruits_name
	set name = name||','||a
	;
end; $$


truncate table fruits_name

call apend_fruit('mango');

select * from fruits_name;




select string_to_table(name,',') tbl_frmt from fruits_name;


/*
CREATE UNLOGGED TABLE sample_data AS
SELECT string_agg(CASE WHEN mod(i,64) = 0 THEN E'\n' ELSE CHR(64 + mod(i,64)) END,'') AS data
FROM generate_series(1, 500000) i;

select * from 
DROP TABLE IF EXISTS sample_data_rows; 
CREATE UNLOGGED TABLE sample_data_rows AS
SELECT regexp_split_to_table(data, E'\n')
FROM sample_data;


select * from sample_data_rows;
*/


