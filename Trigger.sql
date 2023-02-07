create or replace function usptimecalc(float,float)
returns text
language plpgsql
as $$
declare
	distance alias for $1;
	velocity alias for $2;
	a float;
	ans text;

begin
	if velocity<>0.0 then
		a=(distance/velocity);
		ans='total time taken is'||' '||a;
	else
		ans=0.0;	
	end if;
return ans;
end; $$

select usptimecalc(55,22);


SELECT *,
SUM(sale) over(order by sid rows between unbounded preceding and current row) running_total
from sales_new_dop;

select sum(sale) from sales_new_dop;


--create a procedure who returns multiple rows from data

create or replace function multi_rows()
returns setof conversion_data
language sql
as $$
	select * from conversion_data;
$$

select * from multi_rows();

--create a func who returns total count of  male and female?

create or replace function total_gender_conversion_data()
returns table(
	age varchar,
	gender int) 
language sql
as $BODY$
	select age,count(gender) total_male_female from conversion_data
	group by 1;
	$BODY$
	
select * from total_gender_conversion_data();

==============================================================================
==============================================================================

TRIGGER
--------

SYNTEX=>
=> Before insert

CREATE TRIGGER <`TRIGGER_NAME> 
BEFORE INSERT ON <`TABLE_NAME>
FOR EACH ROW EXECUTE PROCEDURE <FUNCTION_NAME()>;

## -- RETURNS DATA TYPE OF RETURNS IN FUNCTION SHOULD BE TRIGGER
 --EG.
 
==
--first create table student_info

create table student_info(
roll_no int primary key not null,
s_name varchar(50) not null,
age int );

insert into student_info
values
(101,'ram',-5),
(202,'vasant',200);

select * from student_info;

-- As we can see age can't be in -ve niether 100+ , so we should make precaution for this so that this type of cant be inserted in table
-- so for this we need TRIGGER
-- this can help us before insertion of this type of data and insertion too.


create or replace function check_fun()
returns trigger 
language plpgsql
as $$
declare 

begin
	if new.age<0 then
		raise exception 'age can not be -ve';
	end if;
return new;
end;$$


create trigger checkage
before insert on student_info
for each row execute procedure check_fun();

select * from student_info;

insert into student_info
values
(303,'vignesh',-5)

select * from student_info; -- we can see data does not inserted.

drop trigger checkage on student_info;
-- let see trigger for after insertion.

create trigger checkageafter
after insert on student_info
for each row execute procedure check_fun();


insert into student_info
values
(404,'ramu',-6)

select * from student_info;

drop table student_info;

create table students (roll_no int primary key not null,contact varchar(20));

insert into students
values 
(101,1234567890);

select * from students;

--let try to insert contact no less than 10 digit

insert into students values (202,12345);

select * from students; -- as we can see wrong contact details inserted into data let  try to trigger it.

create or replace function check_func()
returns trigger
language plpgsql
as $$
begin
	if length(new.contact)<10 or length(new.contact)>10 then
		raise exception 'Contact no. should be of 10 digits ';
	end if;
return new;
end;$$

create trigger check_num
before insert on students
for each row execute procedure check_func();

--now lets try to insert wrong contact detials in table

insert into students values(303,5153215);

select * from students;

/*select length(contact) from students where roll_no=303;

delete from students
where roll_no=303;*/

--## now wrong data will not be insert into table
drop table students;
=======================

-- now let see how can restrict insertion of vlaues more than 5 in a table.
create table emp(eid serial primary key not null,ename varchar(50),edept varchar(20),esal int);

--lets insert some data.

insert into emp (ename,edept,esal)  values('ramesh','it','35000'),('raju','sales',31000),('vayu','design',34000);

select * from emp;

create or replace function stop_rows()
returns trigger
language plpgsql
as $$
declare
	num int;
begin
	select count(*) from emp into num;
	if num>5 then
	raise notice 'can not insert more than 5 rows';
	return null;
	end if;
return  new;
end;$$

create trigger limitinsert
before insert on emp
for each row execute procedure stop_rows();

insert into emp(ename,edept,esal) values ('mukesh','sales',30000),('rajesh','acounts',25000),('brijesh','sales',30000)

select * from emp; -- now we alrdy 5 rows exist ,now let's see row will be insert or not.

insert into emp(ename,edept,esal) values ('daya','tech',30000) -- data not inserted.

delete from emp
where eid=6;

truncate table emp;
=========================================
=========================================
select * from emp;

alter table emp
add column dob date;

insert into emp(ename,edept,esal,dob) values ('ramesh','it','35000','2001-02-12'),('raju','sales',31000,'2001-08-11'),('vayu','design',34000,'2035-12-25');

select * from emp;-- we can see wrong dob updated on data and we dont want dob more than current date


create or replace function dob_chk_fun()
returns trigger
language plpgsql
as $$
declare

begin
 	if new.dob>current_Date then
		raise notice 'Wrong DOB Inserted,Please insert right dob';
		return null;
	end if;
return new;
end; $$

create trigger check_dob
before insert on emp
for each row execute procedure dob_chk_fun();


insert into emp(ename,edept,esal,dob) values ('shanu','it','35000','2045-02-12');
--greate no data has been inserted into table.

===========================================
-- now insert data insertion time

alter table emp
add column data_update_time time;

select * from emp; --there is no time mentioned in recent data
--let write a code to auto update time in table 


create or replace function update_time()
returns trigger
language plpgsql
as $$
begin
	update emp set data_update_time=current_time 
	where eid=new.eid;
	raise notice 'time updated';
return new;
end;$$
	
create trigger time_update
after insert on emp              --- we need updated time after insertion so we use after here
for each row execute procedure update_time();

insert into emp (ename,esal) values ('basak',50000);

select * from emp;   --- time updated in table for new data.

====================================
-- now try to make restrictions for delinting rows 

create or replace function dontdel()
returns trigger 
language plpgsql
as $$
begin
	if old.ename='raju' then
	raise exception 'you can not delete this tupple/rows';
	end if;
return old;
end; $$

create trigger del
before delete on emp
for each row execute procedure dontdel();

select * from emp;
delete from emp where ename='raju'  --- data does not deleted!

delete from emp where eid=10; --even if we use another column for same value row cant be delete.

==================================================================================
================================================================================
--TRIGGER CONTINUE(PART-B)
===============================================================================================

select* from emp;

-- now lets try to protect our data in the table so that no can delete any row column from table

create or replace function prot_data()
returns trigger 
language plpgsql
as $$
begin
	raise exception 'This sheet is Protected';
end; $$
	
	
create trigger save_data
before delete on emp
for each row execute procedure prot_data();


--Now lets try to delete any data from emp table

delete from emp
where eid=9;    

delete from emp;		--greate now this table is protected.

===========================================================================

-- Now lets try to set time limit for delete any tupple from emp table.

drop trigger save_data on emp;

create or replace function time_limit_for_delete()
returns trigger
language plpgsql
as $$
begin
	if current_date>'2023-01-24' and current_time>'12:29:00' then
		raise exception 'Time over,you can not delete data now';
	end if;
return old;
end; $$

create trigger set_limit_for_delete
before delete on emp
for each row execute procedure time_limit_for_delete();

--Now lets try to delete data from emp table ,my time & date both exceeds alrdy

delete from emp;  --Hurrey data is protectd for certain time.

===============================================================================================================
--Now its time to store deleted record data into another table with deleting time,so that we can later which data has been deleted and which time/.

create table stu_demo
(roll_no int primary key,
name varchar(20),
add varchar(20),
mks decimal(5,2));

insert into stu_demo values (11,'Raju','Delhi',46),(12,'Vidyut','Dwarka',81),(13,'Vimlesh','Pune',39),(14,'Jawahar','UP',33),
(15,'Suresh','Haryana',96);

select * from stu_demo;

create table del_record_from_studemo_tbl(roll_no int primary key,
name varchar(20),
add varchar(20),
mks decimal(5,2),
dlt_time time );

select * from del_record_from_studemo_tbl;

create or replace function save_del_rec()
returns trigger
language plpgsql
as $$

	begin
		insert into del_record_from_studemo_tbl
		values
		(old.roll_no,old.name,old.add,old.mks,current_time);
	return old;
end; $$

create trigger save_rec
after delete on stu_demo
for each row execute procedure save_del_rec();

-- lets see ,Is record inserted in "del_record_from_studemo_tbl" after delete any record or not.

delete from stu_demo
where roll_no = 12;

select * from stu_demo; -- data is deleted from table

select *  from del_record_from_studemo_tbl;  --Awesome! code works and deleted data stored in new tbl with dlt time.

===============================================================
--Now update the data and save old data who's present in table before updation in table.

create trigger old_new
after update on stu_demo
for each row execute procedure save_del_rec();

-- let's update and see

update stu_demo
set name='Brijesh'
where roll_no=13;

select * from stu_demo;

select * from del_record_from_studemo_tbl;  -- Greate data store in del_record_from_studemo_tbl tbl.

================================================================================
--Now we dont want to store that data we just want print old value and new value and also check both will not to be same.

drop trigger old_new on stu_demo;

drop trigger save_rec on stu_demo;

drop function save_del_rec();

create or replace function old_new_print()
returns trigger
language plpgsql
as $$
begin
	if old.name=new.name and old.add=new.add and old.mks=new.mks then
		raise exception 'Old and new Both entries are same,cannot update';
	else 
		raise notice 'old entries are: % % %',old.name,old.add,old.mks;
		raise notice 'new entries are: % % %',new.name,new.add,new.mks;
	end if;
return new;
end; $$


create trigger chk_print_old_new
after update on stu_demo
for each row execute procedure old_new_print();

--let's try to update and see

update stu_demo						-- first try same entry
set name='Raju' where roll_no=11;
-- not updated code works throws error

update stu_demo							-- try update diff entry
set name='Jalala' where roll_no=14;

select * from stu_demo;----updated and also prints our print statement.






================================================================================================================
================================================================================================================

