--view 1 :
create view singer_sale as
select [Lana] ,[Adele], [Eminem] ,[SIA], [Billie] 
from(
select A.ID as a,C.FirstName as name
from Ticket as A join Concert as B 
on (A.Concert_ID = B.ID)
join Artist as C 
on (B.Artist_ID = C.ID)
)as mytable

pivot
(
count(a)
for name in([Lana] ,[Adele], [Eminem] ,[SIA], [Billie] )
)as PVT ;

-- test: 
select * from singer_sale

--view 2:
create view concert_analysis as

with one (concert,genere,location) as (
select  A.Name , C.Name , B.Name


from Concert as A inner join Location as B on (A.Location_ID=B.ID)
inner join Genre as C on (A.Genre_ID=c.ID))


select  ISNULL(genere,'All genere')  as genere,
ISNULL(location,'All location') as location
,count(*) as count
from one 

GROUP BY rollup(genere,location) ;


-- test: 
select * from concert_analysis

-- view 3:
create view customer_analysis as

with one (CustomerName,CustomerFamily,Price,Class) as (
select  D.FirstName,D.LastName , B.Price , B.Class

from Order_ticket as A inner join Ticket as B on (A.Ticket_ID=B.ID)
inner join Customer_Order as C on (A.Customer_Order_ID=C.ID) inner join Customer as D on (C.Customer_ID=D.ID) )

select DENSE_RANK()over(order by CustomerName,CustomerFamily) as [customer row],
 count(*) OVER (PARTITION by CustomerName,
 CustomerFamily ORDER BY Class ROWS UNBOUNDED PRECEDING) as [customer tickt row], 
 CustomerName,
 CustomerFamily,
 Class
,sum(price) OVER (PARTITION by CustomerName,CustomerFamily ORDER BY Class
 ROWS UNBOUNDED PRECEDING) as price

from one 


-- test: 
select * from customer_analysis




--functions :

-- function 1:
create FUNCTION dbo.order_price(@in int) 
RETURNS money
AS 

BEGIN     
DECLARE @ret money;   
DECLARE @all money;
DECLARE @dis numeric;

select @all = sum(price)
from Order_ticket as A 
inner join Ticket as B on (A.Ticket_ID=B.ID)
inner join Customer_Order as C on (A.Customer_Order_ID=C.ID)
where C.ID=@in


select @dis = Discount
from Customer_Order 
where Customer_Order.ID=@in

set @ret =@all*((100-@dis)/100)

RETURN @ret; 
END; 

-- test:
select dbo.order_price(5)


-- function 2:
create FUNCTION dbo.mail_domain(@in int) 
RETURNS varchar(50)
AS 

BEGIN     
DECLARE @ret varchar(50);   
DECLARE @mail varchar(50);   

select @ret= SUBSTRING (EmailAddress,PATINDEX ('%@%',EmailAddress)+1,LEN (EmailAddress)-PATINDEX ('%@%',EmailAddress)+1)
from Customer
where ID=@in

RETURN @ret; 
END; 


-- test:

select dbo.mail_domain(5)


-- function 3:
create FUNCTION dbo.TicketCount(@in int, @in2 int) 
RETURNS table
AS 
return 
(

select cast(ID as varchar(50)) as ID,'-' as count
 from Ticket
 where ID in (select B.ID from Concert as A 
inner join Ticket as B on (A.ID=B.Concert_ID)
inner join location as C on (A.Location_ID=C.ID)
where C.ID = @in

except

select B.ID from Concert as A 
inner join Ticket as B on (A.ID=B.Concert_ID)
inner join location as C on (A.Location_ID=C.ID)
where C.ID = @in2)


union 

select 'Count Of All',cast(count(*) as varchar(50))
 from Ticket
 where ID in (select B.ID from Concert as A 
inner join Ticket as B on (A.ID=B.Concert_ID)
inner join location as C on (A.Location_ID=C.ID)
where C.ID = @in

except

select B.ID from Concert as A 
inner join Ticket as B on (A.ID=B.Concert_ID)
inner join location as C on (A.Location_ID=C.ID)
where C.ID = @in2)


);




-- test:

select * from dbo.TicketCount(1,2)
