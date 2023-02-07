create or replace function addition(x int , y int)
returns int
language plpgsql
as $$
declare 
z int;
begin
  z= (x + y);
return z;
end;$$

select addition(50,60);

create or replace function multiplication(x int ,y int )
returns int
language plpgsql
as $$
declare
z int not null default 0;
begin
z= x * y;
return z;
end;$$

select multiplication(25,25);

create or replace function get_cube_for_each(x int , y int , z int )
returns character varying(100)
language plpgsql
as $$
declare
a int;
b int;
c int ;
d character varying (100) not null default 0;
begin
a= x * x * x;
b= y * y * y;
c= z * z * z;
d =concat(a,',',b,',',c);
return d;
end;$$

select get_cube_for_each(11,12,13);

create or replace function total_rows()
returns int
language plpgsql
as $$
declare
total_person int not null default 0;
begin 
select count(*) into total_person
from conversion_data;
return total_person;
end; $$

select total_rows();

select * from conversion_data;


create or replace function total_person_for_each_gender(x varchar(1))
returns character varying(50) 
language plpgsql
as $$
declare 
z int not null default 0;
y character varying(50) not null default 0;
begin
select count(*) into z
from conversion_data
where gender =x
group by gender;
y= concat('your input is',' ',x,' ','and count is',' ',z);
return y;
end;$$

select total_person_for_each_gender('F');


create or replace function sum_product(int,int,out int,out int)
language plpgsql
as $$
declare 
a alias for $1;
b alias for $2;
c alias for $3;
d alias for $4;
begin
c=a+b;
d=a*b;
end;$$

select sum_product(10,60);

create or replace  function check_num(int)
returns text
language plpgsql
as $$
declare
	 a alias for $1;
	 b text;
begin
	if a>0 then
	 b= 'Positive';
	elseif a<0 then
	 b= 'Negative';
	else 
	 b= 'Zero';
	end if;
return b;
end ; $$

select check_num(-45);

create or replace function even_odd(int)
returns text
language plpgsql
as $$
declare
	a alias for $1;
	b text;
begin
	if a%2=0 then
	 b=a ||' '|| 'Number is Even';
	else
	 b=a ||' '||  'Number is odd';
	end if;
return b;
end;$$

select even_odd(544);


create or replace function factorial(int)
returns int
language plpgsql
as $$
declare
	a alias for $1;
	b int :=1;
begin
	while a>0 loop
		b=b*a;
		a=a-1;
	end loop;
return b;
end;$$

select factorial(5);

select factorial(0);


create or replace function factorial_forloop(int)
returns int
language plpgsql
as $$
declare
	a alias for $1;
	b int :=1;
begin
	for i in  1..a loop
		b=b*i;
	end loop;
return b;
end;$$

select factorial_forloop(5);


create or replace function check_prime(int)
returns text
language plpgsql
as $$
declare 
	a alias for $1;
	c text;
	b int;
begin 
	b=a-1;
	if a<=1 then
		raise notice 'aa';
		c=a||' '||'is not prime';
	

	elseif a>1 then
		raise notice 'bb';
		for i in 2..b loop
		raise notice 'var of a :%',a;
		raise notice 'value of i :%', i;
			if a%i=0 then
			raise notice 'cc';
				c=a||' '||'is not prime';
				exit;
			else 
				raise notice 'not prime';
				c=a||' '||'is prime';
			end if;
		end loop;
	else
		raise notice 'ee';
		c=a||' '||'is prime';
	end if;
return c;
end;$$


select check_prime(81);





create or replace function check_prime2(int)
returns text
language plpgsql
as $$
declare
	n alias for $1;
	start1 int;
	div int;
	ans text not null default 0;
begin
	start1=1;
		while(start1<n) loop
	div=2;
		while (div<=start1) loop
			if (mod(start1,div)=0 and div<start1) then
		 	 	exit;
			else
				if mod(start1,div)=0 and div=start1 then
					
			 	ans=ans||' ' ||start1::text;
				end if;
			end if;
			div=div+1;
		end loop;
	 	start1=start1+1;
 	end loop;
return ans;
end;$$
			
select check_prime2(45)	;		
			