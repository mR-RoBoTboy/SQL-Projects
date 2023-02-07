-- Function

--syntex

create or replace function function_name(argumetns|parameters)
returns return_datatype as $variable_name$
	declare
		declaration;
		[◘◘◘]
	begin
		< function_body>
		[◘◘◘]
		return (varibale_name|value)
end;
language plpgsql;
	
-----------------------------
-----------------------------

select * from delivery;

create or replace function total_del()
returns integer as $totalnoofdel$
	declare 
		totalnoofdel integer;
	begin
	select count(*) 
	into totalnoofdel
	from delivery ;
return toTalnoofdel;
end;
$totalnoofdel$
language plpgsql;


select total_del();

------------------------
select * from customers;

create or replace function  demofnc()
returns character varying as $custname$ 
	declare 
	custname character varying;
	begin
	select customername into custname 
	from customers
	where country ='Mexico';
return custname;
end;
$custname$
language plpgsql;

select demofnc();

----------------------------------------------------
SCALER func

--function without parameter

create function showmessage()
returns varchar(50)
language plpgsql
as $$
begin
	return 'Hello I am a function';
end
;
$$

-- function with single parameter

select showmessage();

create or replace function nums(num int)
returns int
language plpgsql
as $$
begin
	return (num * num * num);
end;
$$

select nums(9);


--- func with multiple parameter


create or replace function nums(num1 int, num2 int,num3 int)
returns int
language plpgsql
as $$
begin
	return (num1 * num2 * num3);
end;
$$

select nums(10,5,6);


--- funcs with if else condition.

create or replace function checkage(num int)
returns varchar(50)
language plpgsql
as $$
declare 
str varchar(50);
begin
	if num>=96	 then
	 str='wrong input';
	elseif num>=18 then
	 str = 'You are Eligible to vote';
	else 
	 str ='You are not Elligible to vote';
	end if;
return str ;
end;$$

select checkage(100);

--func can call another func

create function get_date()
returns timestamp without time zone
language plpgsql
as $$
begin
	return current_timestamp;
end;$$

select get_date();
