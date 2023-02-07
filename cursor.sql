--  ## CURSOR ## --
==================
==================

--  SYNTEX FOR CURSOR --

		CREATE OR REPLACE FUNCTION FUNCTION_NAME()
		RETURNS VOID/INT(IF YOU WANT)
		LANGUAGE PLPGSQL
		AS $$
		DECLARE
				ALIAS_NAME CURSOR FOR YOUR_QUERY;		 -- [YOUR_QUERY LIKE-(SELECT * FROM TABLE)]
				VARIABLE_NAME  VARIABLE_CONSTRAINT;		 --	[WHERE YOU CAN STORE YOUR RECORDS]
		BEGIN_
				OPEN ALIAS_NAME;									--YOU ALSO CAN USE "MOVE" CLAUSE TO MOVE CURSOR FROM CURRENT POSITION/ROW
				FETCH FISRST/LAST/ABSOLUTE/PRIOR/RELATIVE/NEXT;
				RAISE NOTICE 'FOR FETCHING RESULT';
				CLOSE ALAIS_NAME;
		END; $$

--AND TO CALL AND RUN CURSOR 
SELECT FUNCTION_NAME();

==============================================================
================================================================================================
		
--In this function we will try to fetch delivery tbl data one by one from cursor.

select * from delivery;

Create or replace function printcursr()
returns void
language plpgsql
as $$
declare 
	crsr cursor for select * from delivery;
	rec record;
begin
	open crsr;
	fetch first from crsr into rec;
	raise notice 'dp_id is: %',rec.dp_id;
	raise notice 'delivery person name is : %',rec.dperson_name;
	raise notice 'delivery date is : %',rec.d_date;
	close crsr;
end; $$

select printcursr();

=======================================================
-- in this func we will try return first record from tbl from cursor


Create or replace function printcrsr()
returns record
language plpgsql
as $$
declare 
	crsr cursor for select * from delivery;
	rec record;
begin
	open crsr;
	fetch first from crsr into rec;
	raise notice 'dp_id is: %',rec.dp_id;
	raise notice 'delivery person name is : %',rec.dperson_name;
	raise notice 'delivery date is : %',rec.d_date;
	close crsr;
return rec;
end; $$

select printcrsr();

=========================================================
--In this function we will try to fetch last record from the tbl from cursor

Create or replace function printcursr2()
returns record
language plpgsql
as $$
declare 
	crsr cursor for select * from delivery;
	rec record;
begin
	open crsr;
	fetch first from crsr into rec;
	raise notice 'dp_id is: %',rec.dp_id;
	raise notice 'delivery person name is : %',rec.dperson_name;
	raise notice 'delivery date is : %',rec.d_date;
	
	fetch last from crsr into rec;
	raise notice '% % %',rec.dp_id,rec.dperson_name,rec.d_date;
	close crsr;
return rec;
end; $$

select printcursr2();

========================================================================
-- In this function we will try to fetch prior record from tbl from last cursor position.

Create or replace function printcursr2()
returns record
language plpgsql
as $$
declare 
	crsr cursor for select * from delivery;
	rec record;
begin
	open crsr;
	fetch first from crsr into rec;
	raise notice 'dp_id is: %',rec.dp_id;
	raise notice 'delivery person name is : %',rec.dperson_name;
	raise notice 'delivery date is : %',rec.d_date;
	
	fetch last from crsr into rec;
	raise notice 'last row : % % %',rec.dp_id,rec.dperson_name,rec.d_date;
	
	
	fetch prior from crsr into rec;
	raise notice 'second last row : % % %',rec.dp_id,rec.dperson_name,rec.d_date;
	close crsr;
return rec;
end; $$

select printcursr2();

==============================================================================================
-- In this function we willl try to fetch absolute records from the table from pointout cursor on particular row.

Create or replace function printcursr2()
returns record
language plpgsql
as $$
declare 
	crsr cursor for select * from delivery;
	rec record;
begin
	open crsr;
	fetch first from crsr into rec;
	raise notice 'dp_id is: %',rec.dp_id;
	raise notice 'delivery person name is : %',rec.dperson_name;
	raise notice 'delivery date is : %',rec.d_date;
	
	fetch last from crsr into rec;
	raise notice 'last row : % % %',rec.dp_id,rec.dperson_name,rec.d_date;
	
	
	fetch prior from crsr into rec;
	raise notice 'second last row : % % %',rec.dp_id,rec.dperson_name,rec.d_date;
	
	fetch absolute 3 from crsr into rec;
	raise notice 'third row : % % %',rec.dp_id,rec.dperson_name,rec.d_date;
	
	close crsr;
return rec;
end; $$

select printcursr2();

======================================================================================

select * from customers;

--In this function we will try tpo fetch next row record from where cursor pointing rifht now.

Create or replace function printcursr2()
returns record
language plpgsql
as $$
declare 
	crsr cursor for select * from customers;
	rec record;
begin
	open crsr;
	fetch first from crsr into rec;
	raise notice 'customer id is: %',rec.customerid;
	raise notice 'customer name is : %',rec.customername;
	raise notice 'country is : %',rec.country;
	
	fetch last from crsr into rec;
	raise notice 'last row : % % %',rec.customerid,rec.customername,rec.country;
	
	
	fetch prior from crsr into rec;
	raise notice 'second last row : % % %',rec.customerid,rec.customername,rec.country;
	
	fetch absolute 3 from crsr into rec;
	raise notice 'third row : % % %',rec.customerid,rec.customername,rec.country;
	
	fetch next from crsr into rec;
	raise notice 'next row after third row : % % %',rec.customerid,rec.customername,rec.country;
	close crsr;
	
return rec;
end; $$

select printcursr2();

==============================================================================================
--In this function we will try to fetch relative  records from cursor last position

Create or replace function printcursr2()
returns record
language plpgsql
as $$
declare 
	crsr cursor for select * from customers;
	rec record;
begin
	open crsr;
	fetch first from crsr into rec;
	raise notice 'dp_id is: %',rec.customerid;
	raise notice 'delivery person name is : %',rec.customername;
	raise notice 'delivery date is : %',rec.country;
	
	fetch last from crsr into rec;
	raise notice 'last row : % % %',rec.customerid,rec.customername,rec.country;
	
	
	fetch prior from crsr into rec;
	raise notice 'second last row : % % %',rec.customerid,rec.customername,rec.country;
	
	fetch absolute 12 from crsr into rec;
	raise notice 'twelth row : % % %',rec.customerid,rec.customername,rec.country;
	
	fetch next from crsr into rec;
	raise notice 'next row after twelth row : % % %',rec.customerid,rec.customername,rec.country;
	
	fetch relative -2 from crsr into rec;
	raise notice '-2 row from relative 13th row : % % %',rec.customerid,rec.customername,rec.country;
	
	fetch relative 5 from crsr into rec;
	raise notice '+5 row from relative 11th row : % % %',rec.customerid,rec.customername,rec.country;
	
	close crsr;
	
return rec;
end; $$ 

select printcursr2();

=============================================================================
--In this function we will try to move the cursor from current row to another row and fetch 2 relative row from moved rows

Create or replace function printcursr2()
returns record
language plpgsql
as $$
declare 
	crsr cursor for select * from customers;
	rec record;
begin
	open crsr;
	fetch first from crsr into rec;
	raise notice 'dp_id is: %',rec.customerid;
	raise notice 'delivery person name is : %',rec.customername;
	raise notice 'delivery date is : %',rec.country;
	
	fetch last from crsr into rec;
	raise notice 'last row : % % %',rec.customerid,rec.customername,rec.country;
	
	
	fetch prior from crsr into rec;
	raise notice 'second last row : % % %',rec.customerid,rec.customername,rec.country;
	
	fetch absolute 12 from crsr into rec;
	raise notice 'twelth row : % % %',rec.customerid,rec.customername,rec.country;
	
	fetch next from crsr into rec;
	raise notice 'next row after twelth row : % % %',rec.customerid,rec.customername,rec.country;
	
	fetch relative -2 from crsr into rec;
	raise notice '-2 row from relative 13th row : % % %',rec.customerid,rec.customername,rec.country;
	
	fetch relative 5 from crsr into rec;
	raise notice '+5 row from relative 11th row : % % %',rec.customerid,rec.customername,rec.country;
	
	move first from crsr;
	fetch relative 2 from crsr into rec;
	raise notice '+2 row after moving first row : % % %',rec.customerid,rec.customername,rec.country;
	
	close crsr;
	
return rec;
end; $$ 

select printcursr2();


===========================================================================================================
--In this function we will try to move cursor from current row to 3rd row from forward clause.


Create or replace function printcursr2()
returns record
language plpgsql
as $$
declare 
	crsr cursor for select * from customers;
	rec record;
begin
	open crsr;
	fetch first from crsr into rec;
	raise notice 'dp_id is: %',rec.customerid;
	raise notice 'delivery person name is : %',rec.customername;
	raise notice 'delivery date is : %',rec.country;
	
	fetch last from crsr into rec;
	raise notice 'last row : % % %',rec.customerid,rec.customername,rec.country;
	
	
	fetch prior from crsr into rec;
	raise notice 'second last row : % % %',rec.customerid,rec.customername,rec.country;
	
	fetch absolute 12 from crsr into rec;
	raise notice 'twelth row : % % %',rec.customerid,rec.customername,rec.country;
	
	fetch next from crsr into rec;
	raise notice 'next row after twelth row : % % %',rec.customerid,rec.customername,rec.country;
	
	fetch relative -2 from crsr into rec;
	raise notice '-2 row from relative 13th row : % % %',rec.customerid,rec.customername,rec.country;
	
	fetch relative 5 from crsr into rec;
	raise notice '+5 row from relative 11th row : % % %',rec.customerid,rec.customername,rec.country;
	
	move first from crsr;
	fetch relative 2 from crsr into rec;
	raise notice '+2 row after moving first row : % % %',rec.customerid,rec.customername,rec.country;
	
	move forward 3 from crsr;
	fetch prior from crsr into rec;
	raise notice 'prior row, after moving 3rd row to 6th row : % % %',rec.customerid,rec.customername,rec.country;
	
	close crsr;
	
return rec;
end; $$ 

select printcursr2();


================================================================================================================================
--In this function we will try to fetch data one by one from loop.

select * from empdetails;


create or replace function printempdtl()
returns int 
language plpgsql
as $$
declare
		crsr cursor for select * from empdetails;
		rec empdetails%rowtype;
		cnt int=0;
begin
		open crsr;
		loop 
			fetch crsr into rec;
			exit when not found;
			raise notice '% % %',rec.eid,rec.ename,rec.edesignation;
			cnt=cnt+1;
		end loop;
		close crsr;
	return cnt;
end; $$

select printempdtl();

==============================================================================================================
--In this function we will try to fetch data one by one by maintainig condition.

create or replace function printempdtl()
returns int 
language plpgsql
as $$
declare
		crsr cursor for select * from empdetails;
		rec empdetails%rowtype;
		cnt int=0;
begin
		open crsr;
		loop 
			fetch crsr into rec;
			exit when not found;
			if rec.wages>36000 then
				raise notice '% % % %',rec.eid,rec.ename,rec.edesignation,rec.wages;
				cnt=cnt+1;
			end if;
		end loop;
		close crsr;
	return cnt;
end; $$

select printempdtl();

===================================================================================
--In this function we will try to update our original table one by one by using cursor

select * from stu_demo order by 1;

alter table stu_demo
add column grade varchar(20);

create or replace function updtstu()
returns int
language plpgsql
as $$
declare
		crsr cursor for select * from stu_demo;
		rec stu_demo%rowtype;
		g char;
		cnt int=0;
begin
		open crsr;
		loop
			fetch crsr into rec;
			exit when not found;
			if rec.mks>=80 then
				g='A';
			elsif rec.mks>=70 and rec.mks<80 then
				g='B';
			elsif rec.mks>=50 and rec.mks<70 then
				g='C';
			elsif rec.mks>=40 and rec.mks<50 then
				g='D';
			else 
				g='F';
				raise notice 'You have been failed in your exam,practice hard';
			end if;
			
			update stu_demo
			set grade=g
			where current of crsr;
			
			cnt =cnt+1;
			
		end loop;
		close crsr;
	return cnt;	
end; $$


select  updtstu();


select * from stu_demo;


======================================================================================================================
--In this we will try to update multiple columns in our original table from cursor.

select * from empdetails;

alter table empdetails
add column cmsnperc decimal(5,2),
add cmsnprice numeric,
add ttl_sal numeric;




create or replace function updempdtlclm()
returns int
language plpgsql
as $$
declare 
		crsr cursor for select * from empdetails;
		a decimal(5,2);
		rec empdetails%rowtype;
		b int;
		c int;
		cnt int=0;
begin
		open crsr;
		loop
			fetch crsr into rec;
			exit when not found;
			
			if rec.edesignation='SALES' then
				a=40.00;
				b=(rec.wages*(a/100));
				c= (rec.wages+b);
				   
				update empdetails
				set cmsnperc=a,cmsnprice=b,ttl_sal=c
				where current of crsr;
				   
			elsif rec.edesignation='TECH' then
				a=25.00;
				b=(rec.wages*(a/100));
				c= (rec.wages+b);
				   
				update empdetails
				set cmsnperc=a,cmsnprice=b,ttl_sal=c
				where current of crsr;
				   
			else
				a=12.00;
				b=(rec.wages*(a/100));
				c= (rec.wages+b);
				   
				update empdetails
				set cmsnperc=a,cmsnprice=b,ttl_sal=c
				where current of crsr;
				   
			end if;
				   
			cnt=cnt+1;
				   
		end loop;
	return cnt;
end; $$


select updempdtlclm();

select * from empdetails;

===========================================================================================================
--Lets first create two tables to performing our next task.


create table area(
aname varchar(20),
atype varchar(20));

insert into area values	('Pune','Urban'),('Sinnar','Rural'),('Mumbai','Urban'),('Chakan','Rural'),('Bhor','Rural'),('Nagpur','Urban'),('Ambegaon','Rural'),('Nashik','Urban');

create table prsn_tbl_for_area(
pnum serial primary key not null,
pname varchar(50),
bdate date,
income numeric(10,2),
aname varchar(20)
);

insert into prsn_tbl_for_area (pname,bdate,income,aname)
values
('azhar','2000-12-12',30000,'Pune'),
('bhushan','2000-12-12',25000,'Chakan'),
('kailash','2000-05-20',60000,'Nashik'),
('harsh','1996-02-19',45000,'Nagpur'),
('sachin','1999-07-11',40000,'Pune'),
('sarang','2001-06-30',50000,'Nashik'),
('sohail','2002-05-20',60000,'Ambegaon'),
('sadhna','1997-03-15',33000,'Mumbai'),
('mangesh','1996-02-19',41000,'Sinnar'),
('sonali','1997-01-30',55000,'Nagpur'),
('kunal','2001-07-31',65000,'Ambegaon'),
('sudhir','1998-04-25',70000,'Mumbai'),
('komal','1998-04-25',80000,'Bhar'),
('neha','1999-07-11',15000,'Chakan'),
('karan','1997-01-30',51000,'Sinnar'),
('ajay','1997-03-15',33000,'Bhar')
;


select * from area;

select * from prsn_tbl_for_area;




-- 	NOW LETS TRY TO FETCH AREA WISE PERSON NAME WITH USING BOTH TABLES FROM CURSOR



create or replace function printareawise()
returns int
language plpgsql
as $$
declare
		crsr1 cursor for select * from area;
		crsr2 cursor for select * from prsn_tbl_for_area;
		rec1 area%rowtype;
		rec2 prsn_tbl_for_area%rowtype;
		cnt int =0;
begin
		open crsr1;
		loop
		fetch crsr1 into rec1;
		exit when not found;
			if rec1.atype='Urban' then
				open crsr2;
				loop
				fetch crsr2 into rec2;
				exit when not found;
					if rec1.aname=rec2.aname then
						raise notice '% % %',rec2.pname,rec1.aname,rec1.atype;
						cnt = cnt+1;
					end if;
				end loop;
				close crsr2;
			end if;
		end loop;
		close crsr1;
	return cnt;
end; $$


select printareawise();

=====================================================================

--NOW LETS TRY TO FETCH DATA FROM PARAMETERISED CURSOR.


create or replace function printareawise()
returns int
language plpgsql
as $$
declare
		crsr1 cursor for select * from area where atype='Urban';
		crsr2 cursor(x varchar(20)) for select * from prsn_tbl_for_area where aname=x;
		rec1 area%rowtype;
		rec2 prsn_tbl_for_area%rowtype;
		cnt int =0;
begin
		open crsr1;
		loop
		fetch crsr1 into rec1;
		exit when not found;
			
				open crsr2(rec1.aname);
				loop
				fetch crsr2 into rec2;
				exit when not found;
					
				raise notice '% % %',rec2.pname,rec1.aname,rec1.atype;
				cnt = cnt+1;
					
				end loop;
				close crsr2;
			
		end loop;
		close crsr1;
	return cnt;
end; $$


select printareawise();

===============================================================================

--NOW LETS UPDATE OUR ORIGINAL TABLE WITH HELP OF CURSOR.



create or replace function printareawise()
returns int
language plpgsql
as $$
declare
		crsr1 cursor for select * from area;
		crsr2 cursor for select * from prsn_tbl_for_area;
		rec1 area%rowtype;
		rec2 prsn_tbl_for_area%rowtype;
		cnt int =0;
		inc numeric(10,2);
begin
		open crsr1;
		loop
		fetch crsr1 into rec1;
		exit when not found;
			if rec1.atype='Urban' then
				open crsr2;
				loop
				fetch crsr2 into rec2;
				exit when not found;
					if rec1.aname=rec2.aname then
						inc=(rec2.income*10)/100;
						update prsn_tbl_for_area
						set income=income+inc
						where current of crsr2;
						
						raise notice '% % % %',rec2.pname,rec1.aname,rec1.atype,rec2.income;
						cnt = cnt+1;
					end if;
				end loop;
				close crsr2;
			end if;
		end loop;
		close crsr1;
	return cnt;
end; $$


select printareawise();

select * from prsn_tbl_for_area;			--UPDATED SUCCESSFULLY

========================================================================================================

-- LETS CREATE SOME TABLES AND THEN PERFORM OUR NEXT TASK FOR MANY TO MANY RELATION FROM CURSOR.

create table studentm2m(
roll int primary key not null,
name varchar(20),
course varchar(20)
);

insert into studentm2m
values
(111,'aaa','bsc'),
(222,'bbb','bba'),
(333,'ccc','bcom'),
(444,'ddd','mba'),
(555,'eee','btech'),
(666,'fff','btech');

create table studsubm2m(
roll int,
subcode int
);


insert into studsubm2m
values
(111,1),(111,2),(111,3),(222,2),(222,4),
(222,3),(333,5),(333,1),(444,3),(444,4),(555,1),(555,4),(555,2),(666,1),(666,5),(666,3);

create table subjectm2m(
subcode int ,
subname varchar(20));

insert into subjectm2m values (1,'cprog'),(2,'sql'),(3,'plpsql'),(4,'python'),(5,'java');


select * from studentm2m;

select * from studsubm2m;

select * from subjectm2m;

========================

-- NOW LETS PRINT STUDENT WISE SUBJECT NAME WITH THE HELP OF CURSOR.


create or replace function fetch_stuwisesub(a varchar(20))
returns int
language plpgsql
as $$
declare
		crsr1 cursor for select * from studentm2m where course=a;
		crsr2 cursor(x int) for select * from studsubm2m where roll=x;
		crsr3 cursor(y int) for select * from subjectm2m where subcode=y;
		rec1 studentm2m%rowtype;
		rec2 studsubm2m%rowtype;
		rec3 subjectm2m%rowtype;
		cnt int=0;
begin
		open crsr1;
		loop
		fetch crsr1 into rec1;
		exit when not found;
			open crsr2(rec1.roll);
			loop
			fetch crsr2 into rec2;
			exit when not found;
				open crsr3(rec2.subcode);
				loop
				fetch crsr3 into rec3;
				exit when not found;
				raise notice '% % % % ',rec1.roll,rec1.name,rec1.course,rec3.subname;
				cnt=cnt +1;
				end loop;
				close crsr3;
			end loop;
			close crsr2;
		end loop;
		close crsr1;
	return cnt;
end; $$



select fetch_stuwisesub('bcom');