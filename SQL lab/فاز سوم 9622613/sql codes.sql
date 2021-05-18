--**************************************************************************************************
--*                                              VIEWS                                             *
--**************************************************************************************************


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


--------------------------------------------------------


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

--------------------------------------------------------

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

--------------------------------------------------------

-- view 4:
create view all_concerts_data as
select C.Name,A.FirstName as artist,L.Name as location,g.Name as genere, Date
from concert as C inner join
Artist as A on C.Artist_ID=A.ID inner join
Location as L on L.ID=C.Location_ID inner join
Genre as G on C.Genre_ID=G.ID

-- test: 
select * from all_concerts_data



--**************************************************************************************************
--*                                           FUNCTIONS                                            *
--**************************************************************************************************

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

--------------------------------------------------------

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

--------------------------------------------------------

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

--------------------------------------------------------

-- function 4:
create FUNCTION avalable_ticket(@in int) 
RETURNS table
AS 
return 
(
select ID from ticket where Concert_ID=@in
except
select ID from Order_ticket 
);

-- test:
select * from avalable_ticket(1)



--**************************************************************************************************
--*                                            PROCEDURES                                          *
--**************************************************************************************************

--procedure 1:
create PROCEDURE SignUp
@FirstName nvarchar(50),@LastName nvarchar(50),@Email nvarchar(50),@Gender char,@ID int,@PassWord  nvarchar(50)
As
insert into Customer(FirstName,LastName,EmailAddress,Gender,ID,PassWord) values (@FirstName,@LastName,@Email,@Gender,@ID,@PassWord)

--test :
EXECUTE SignUp 'mohammad','amini','hihi@yahoo.com','M',7,'hello';
select * from Customer

--------------------------------------------------------

--procedure 2 :
create PROCEDURE [Login]
@ID int,@password nvarchar(50),@result int output
As
begin
DECLARE @temp nvarchar(50)
select @temp=[password] from Customer where ID=@id
if @password =@temp
select @result=1
else select @result =0
end

-- test :
declare @result int 
EXECUTE Login 7,'hi',@result output;
print @result

declare @result int 
EXECUTE Login 7,'hello',@result output;
print @result

--------------------------------------------------------

--procedure 3:
create PROCEDURE [change_pass]
@ID int,@password nvarchar(50),@new_password nvarchar(50),@result nvarchar(50) output
As
begin
DECLARE @temp nvarchar(50)
select @temp=[password] from Customer where ID=@id
if @password =@temp
BEGIN
update customer set password=@new_password where Id=@ID; select @result='CHANGED SUCCESSFULLY';
END
else select @result='WRONG PASSWORD';
end

-- test :
declare @result nvarchar(50)
EXECUTE change_pass 7,'hi','new',@result output;
print @result

declare @result nvarchar(50)
EXECUTE change_pass 7,'hello','new',@result output;
print @result

--------------------------------------------------------

--procedure 4 :

create PROCEDURE [create_order]
@ID_customer int
As
begin
declare @temp int
select @temp=ID from Customer where Id=@ID_customer
declare @next_id int
select @next_id=max(ID)+1 from Customer_Order
if @temp is not null 
insert into Customer_Order(ID,Customer_ID,OrderTime,Discount) values (@next_id,@ID_customer,CURRENT_TIMESTAMP,0)
else
print 'wrong customer'
end

--test :

EXECUTE create_order 10
select * from Customer_Order

EXECUTE create_order 5
select * from Customer_Order

--------------------------------------------------------

--procedure 5:

create PROCEDURE [add_to_order]
@ID_order int,@ID_ticket int
As
begin

declare @temp int
select @temp=ID from Ticket where Id=@ID_ticket

declare @temp2 int
select @temp2=ID from Order_ticket where Ticket_ID=@ID_ticket

declare @temp3 int
select @temp3=ID from Customer_Order where Id=@ID_order

declare @next_id int
select @next_id=max(ID)+1 from Order_ticket

if @temp is not null and @temp2 is null and @temp3 is not null
insert into Order_ticket(ID,Ticket_ID,Customer_Order_ID) values (@next_id,@ID_ticket,@ID_order)
else
print 'wrong order or ticket'

end

--test :
EXECUTE add_to_order 3,10
select * from Order_ticket



--**************************************************************************************************
--*                                             TRIGGERS                                           *
--**************************************************************************************************
--trigger 1:
CREATE TRIGGER anti_DOS 
ON customer_order 
INSTEAD OF delete 
AS 
PRINT 'NO ACCESS TO RETURN ORDER'

--test :
delete from Customer_Order
select * from Customer_Order

--------------------------------------------------------
--trigger 2:
CREATE TRIGGER pass_change
ON customer 
for update 
AS 
declare @pass nvarchar(50)
select @pass=password from inserted
declare @old nvarchar(50)
select @old=password from deleted
declare @user int
select @user=ID from inserted 
insert into my_logs(description_of_log) values('password changed for user  ' +convert( varchar(50),@user )+'  from : '+@old+'     to : '+@pass )

--test :
declare @result nvarchar(50)
EXECUTE change_pass 7,'new','very new',@result output;
print @result

select * from my_logs

--------------------------------------------------------
--trigger 3:
create TRIGGER concert_addition 
ON concert 
after  insert 
AS 
declare @ID int
select @ID=ID from inserted 
declare @NAME varchar(50)
select @NAME=Name from inserted
insert into my_logs(description_of_log) values('concert  :  '+@NAME+'  with id : '+ convert( varchar(50),@ID )+' has been modified in '+convert( varchar(50),CURRENT_TIMESTAMP ))

-- test
INSERT INTO Concert(ID,Name,Artist_ID,Genre_ID,Location_ID,Date ) 
VALUES (6,'dreams',1,1,5,'2021-05-06 20:00:00')

select * from my_logs





