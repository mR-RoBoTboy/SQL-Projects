create or replace function power_cal(int,int)
returns int
language plpgsql
as $$
declare
	a alias for $1;
	b alias for $2;
	c int;
	
begin
	c=power(a,b);
return c;
end;$$

select power_cal(2,5);



create or replace function nthroot(float,float)
returns float
language plpgsql
as $$
declare
	a alias for $1;
	b alias for $2;
	c float;
begin
	c=power(a,1/b);
return c;
end;$$


select nthroot(23625,4);


select * from football_player;

create or replace procedure clearance_check(int,int)
language plpgsql
as $$
declare
	a alias for $1;
	b alias for $2;
	v_name text;
begin
	select player_name into v_name from football_player
	where height>=a and weight>=b; 
end;$$

call clearance_check(160,200);

create table workers(
wid serial primary key not null,
wname varchar(50) not null,
w_age int not null,
sal int not null);

select * from workers;


create or replace procedure insert_workers(int,varchar(50),int,int)
language plpgsql
as $$
declare 
	a alias for $1;
	b alias for $2;
	c alias for $3;
	d alias for $4;
begin
	insert into workers
	values
	(a,b,c,d);
	commit;
end;$$

call insert_workers(1,'Rahul',21,15000);

select * from workers;

call insert_workers(2,'mehta',30,14000);

call insert_workers(3,'Prakash',21,16500);

call insert_workers(4,'Rakesh',29,13500);

call insert_workers(5,'Ramesh',21,13800);

select * from workers;


---------------------------------------------------------------------
---------------------------------------------------------------------

select * from delivery;

select* from orders;

select * from product;

alter table product
 add column qty int ;

create or replace procedure update_clm_product(int,varchar(50))
language plpgsql
as $$
declare 
	a alias for $1;
	b alias for $2;
begin
	update product
	set qty=a 
	where pname=upper(b);
commit;
end;$$

call update_clm_product(21,'samsung')

call update_clm_product(28,'Asus_tuf')

call update_clm_product(16,'apple')

call update_clm_product(50,'table')

call update_clm_product(20,'asus')

select*from product;

create table sales_new_dop(
pid int not null,
pname varchar(50),
order_qty int ,
remaining_qty int ,
sale int not null
);

create or replace procedure insert_salesdop(int,varchar(50),int,int,int)
language plpgsql
as $$
declare
	a alias for $1;
	b alias for $2;
	c alias for $3;
	d alias for $4;
	e alias for $5;
begin
	insert into sales_new_dop
	values
	(a,b,c,d,e);
commit;
end;$$

call insert_salesdop(15,'ASUS',0,20,0);
UPDATE sales_new_dop
set pid=14 where pname='ASUS'
select * from sales_new_dop;

select*from product;

truncate table sales_new_dop;


create or replace procedure order_update(varchar(50),int)
language plpgsql
as $$
declare
	products alias for $1;
	quant alias for $2;
	v_pid int not null default 0;
	v_price int not null default 0;
	v_count int;
	v_qty int;
begin
	select count(1) 
	into v_count
	from product
	where pname=products and
	qty>=quant;
	raise notice 'check 1';
	raise notice 'count is%',v_count;
	if v_count>0 then
		raise notice 'check 2';
		
		select qty,pid 
		into v_qty,v_pid
		from product
		where pname=products;
		raise notice 'check 3';
		raise notice 'qty is%',v_qty;
		raise notice 'pid is%',v_pid;
		
		select product_price 
		into v_price
		from orders
		where pid=v_pid;
		raise notice 'check 4';
		raise notice 'price is %',v_price;
					
		insert into sales_new_dop
		(pid,pname,order_qty,remaining_qty,sale)
		values
		(v_pid,products,quant,(v_qty-quant),(v_price*quant));
		raise notice 'check 5';
		
		update product
		set qty=(qty-quant)
		where pid=v_pid;
		raise notice 'check 6';
		
		raise notice
			'Product Sold!';
	else 
		raise notice
			'Insufficient Qty!';
 end if;
end;$$ 
 
call order_update('APPLE',1);

call order_update('ASUS',2);

call order_update('ASUS_TUF',1);

call order_update('TABLE',5);

select * from orders;

select * from sales_new_dop;

select * from product;

update sales_new_dop
set remaining_qty=14
where sale =160000;


alter table sales_new_dop
add column sid serial primary key not null;

===========================================
exception handling in procedures

create table demot(democlm float );

create or replace procedure test(int,int)
language plpgsql
as $$
declare
	a alias for $1;
	b alias for $2;
	result float;
begin
	begin
	result:=round((a/b),2);
	
	exception when others then
	 raise notice 'You can not devide by zero';
	
	end;
	if b<>0 then
	insert into demot(democlm) values (result);
	end if;
	
end;$$

call test(50,2);

select * from demot;

call test(20,0);

call test(5325,56);

drop table demot;

truncate table demot;