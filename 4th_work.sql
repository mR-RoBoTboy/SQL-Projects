--HERE I HAVE DONE A VERY SMALL PROJECT.
=========================================================

-- CREATE AND INSERT VLAUES INTO TABLE

create table student(
 roll_no int primary key not null,
class character varying not null,
name varchar(50) not null,
father_name varchar(50),
stream varchar(50),
fees int not null,
pending_fees int not null,
fees_paid_status boolean not null
);

insert into student
(roll_no,class,name,father_name,stream,fees,pending_fees,fees_paid_status)
values
(1,'9th','rahul pawar','shyam pawar','default',5000,0,true),
(2,'9th','meghna sharma','rakesh sharma','default',5000,1200,true),
(3,'11th','satendra singh','rajan singh','pcm',10000,1000,true),
(4,'10th','aman kumar','rohtash kumar','default',8500,0,true),
(5,'12th','shivani verma','prakash verma','pcm',12500,13000,false),
(6,'7th','kumkum kashyap','rohtash kashyap','default',4000,0,true),
(7,'11th','ankit kashyap','rohtash kashyap','accounts',10500,0,true),
(8,'11th','ankur kashyap','rohtash kashyap','arts',10100,0,true),
(9,'12th','nikhil tongar','ranjendra tongar','accounts',12000,15000,false),
(10,'12th','chavi sharama','radha sharma','pcm',12100,1200,true)
returning name,stream;

select * from student;
=====================================================

--INSERT DATA INDIVIDUALLY.

insert into student
(roll_no,class,name,father_name,stream,fees,pending_fees,fees_paid_status)
values
(11,'5th','vikas yadav','ramu yadav','default',3000,3000,false);

select * from student;

select * from student
where stream='pcm' and fees_paid_status is false;

================================================


update student
set pending_fees=0,fees_paid_status=true
where roll_no=5;

select * from student
order by roll_no;

select * from student
where father_name like '%kashyap';


select *,
sum(fees) over(order by roll_no rows between unbounded preceding and current row) total_runing_fees
from student;

alter table student
add column expensis int;

update student
set expensis =15000;

select * from student;

select *,
dense_rank() over(partition by stream order by class) stu_per_class
from student;


create table customers(
CustomerID int primary key not null,
CustomerName character varying not null,
ContactName character varying not null,
Address character varying not null,
City character varying not null,
PostalCode character varying ,
Country character varying not null
);	

copy customers from 'F:\Projects\psql Work\datasets\customers.csv' delimiter ',' csv header;

select * from customers;

SELECT * FROM Customers
WHERE lower(City) LIKE 'b%';

DELETE FROM Customers WHERE CustomerName='Alfreds Futterkiste';





SELECT A.CustomerName AS CustomerName1, B.CustomerName AS CustomerName2, A.City
FROM Customers A, Customers B
WHERE A.CustomerID <> B.CustomerID
AND A.City = B.City
ORDER BY A.City;


select * from orders t1
full join
product t2
on t1.pid=t2.pid
full join
delivery t3
on t1.oid=t3.oid;


select pid
from orders 
union 
select pid 
from product
order by pid;


select pid
from orders 
union all
select pid 
from product
order by pid;

select * from student;


select name
from student
where exists(select * from student where fees>11000 and pending_fees=0);


select name
from student
where name = any (select name from student where fees>11000 and pending_fees=0);


select name
from student
where name = all (select name from student where fees>11000 and pending_fees=0);

select * from product;

insert into product(pid,pname)
select oid,dperson from delivery;

delete from product
where pid in (1,2,3,4,5);


select * from customers;



/*create procedure customertable1(customername character varying )
language plpgsql
as $$
begin
select * from customers
commit;
end;$$

call customertable1(customername);*/


select * from delivery
alter table delivery 
rename column dperson to dperson_name









