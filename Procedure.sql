-- creating a procedure and its syntex

create or replace procedure pr_name(p_name varchar , p_age int)
language plpgsql
as $$
declare
	variable 
begin
	procedure body - all logics will build here or put here
end;
$$

what is $$ in this syntex?
-it will handle our string errors for singlw quotes

eg.

select i'm nitesh -- getting error

-- now 2nd way to resolve this error is

select 'i'm nitesh'  -- this also will through an error

now,

select 'i''m nitesh' . -- now executed

--now another way to resolve this error is-

select E'i\'m nitesh' --- this is also a way 

--but if we have large string set with mutiple single quotes then 
-- we will use this $$ symbol

select $$ i'm nitesh $$  as my_name /*now this is the coolest way to handle this error and even there no need to put single quotes to specify string.*/


create table productD(
p_code int primary key not null,
p_name varchar(50) not null,
p_price int not null,
p_qty_remaining int not null default 0 check (p_qty_remaining>0),
p_sold int not null default 0);

insert into productD(
p_code,p_name,p_price,p_qty_remaining,p_sold)

values
(101,'apple max pro 11',80000,5,1),
(102,'samsung fold',75000,9,3);

select * from productD;


create  table sales(
oid serial primary key,
odate date not null,
p_code int not null,
qty_ordered int not null check(qty_ordered>0),
sale_price int not null
 );

insert into sales(
odate,p_code,qty_ordered,sale_price)
values
('2022-02-15',101,1,80000),
('2022-02-18',102,3,225000);

select * from sales;

select *from productD;



-- for every apple max pro 11 sale,modify the database tables accordingly.

create or replace procedure pr_buy_product(x_id integer)
language plpgsql
as $$
declare 
	v_pcode int not null default 0;
	v_price int not null default 0;
begin 
	select p_code,p_price
	into v_pcode,v_price
	from productD
	where p_name='apple max pro 11';
	
	insert into sales(
			odate,p_code,qty_ordered,sale_price)
			values 
			(current_date,v_pcode,1,(v_price * 1));
			
			update productD
			set p_qty_remaining = (p_qty_remaining - 1),
				p_sold= (p_sold + 1)
			
			where p_code = v_pcode ;
			
			
			
	raise notice 'Product Sold!';
end;
$$

alter table sales
drop constraint sales_pkey;

alter table sales
alter column oid drop not null;

drop table sales;

truncate table sales;


drop table productD;





---for every  given product and the quantity.
		1)check if product is avaialable base on the required quantity
		2)if available then modify the database tables acccordingly 
		
		
create or replace procedure pr_buy_product(p_product_name varchar(50),p_product_qty int)
language plpgsql
as $$
declare 
	v_pcode int not null default 0;
	v_price int not null default 0;
	v_count int ;
begin
		
	select count(*)
	into v_count
	from productD
	where p_name=p_product_name 
	and
	p_qty_remaining>=p_product_qty;
	
	if v_count>0 then
	
			select p_code,p_price
			into v_pcode,v_price
			from productD
			where p_name= p_product_name;

			insert into sales(
					odate,p_code,qty_ordered,sale_price)
					values 
					(current_date,v_pcode,p_product_qty,(v_price * p_product_qty));

					update productD
					set p_qty_remaining = (p_qty_remaining - p_product_qty),
						p_sold= (p_sold + p_product_qty)

					where p_code = v_pcode ;
			raise notice 'Product Sold!';
	else 
		raise notice 'insuffecient qty';
		
	end if;
end;
$$


-----------
materialized view

---- create table of 20m record

create table random(id int,val decimal);

insert into random
select 1,random()  from generate_series(1,100000); 

insert into random
select 2, random() from generate_series(50,100050);

select count(1) from random;

select id,avg(val),count(*)
from random
group by 1;

create materialized view mv_random_tbl
as
select id,avg(val),count(*)
from random
group by 1;

select * from mv_random_tbl


------------------------------------
views

select * from orders;

select * from product;

select * from delivery;


---fetch order summery

select t1.oid,t2.pid,t1.orderdate,t1.product,t2.pname,
t3.dp_id,t3.dperson_name,t3.d_date
from orders t1
join
product t2
on t1.pid=t2.pid
join
delivery t3
on t1.oid=t3.oid;
======
create view mv 
as
select t1.oid,t2.pid,t1.orderdate,t1.product,t2.pname,
t3.dp_id,t3.dperson_name,t3.d_date
from orders t1
join
product t2
on t1.pid=t2.pid
join
delivery t3
on t1.oid=t3.oid;

select * from mv;

create role manish
login
password 'abcd123'

grant select on mv to manish;



--with check option in view

create or replace view mv2
as
select * from orders
where product='MOBILE'
with check option ;

insert into mv2
values
(6,current_date,'furniture',15,56000); -- it will through errror bcsof check command

insert into mv2
values
(6,current_date,'MOBILE',15,56000); --this will work fine



select * from mv2;

select * from orders;