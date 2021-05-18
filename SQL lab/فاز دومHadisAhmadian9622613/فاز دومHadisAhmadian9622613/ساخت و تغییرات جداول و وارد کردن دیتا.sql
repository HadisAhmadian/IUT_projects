CREATE TABLE Artist (   
Score decimal,
FirstName varchar(50) NOT NULL,   
LastName varchar(50) NOT NULL ,   
ID int PRIMARY KEY,   
Gender char(1) 
Check (Gender in ('F','M')) ); 

ALTER TABLE Artist   ADD BirthYear int 
ALTER TABLE Artist   ADD Nationality varchar(50) 
ALTER TABLE Artist   ADD Website varchar(50) 

CREATE TABLE Location (   
Capacity int,
Name varchar(50) NOT NULL,    
ID int PRIMARY KEY,   
 ); 


CREATE TABLE Genre  (   
Name varchar(50) NOT NULL,    
ID int PRIMARY KEY,   
 ); 

 CREATE TABLE Concert (   
Date datetime,
Name varchar(50) NOT NULL,  
ID int PRIMARY KEY,
Artist_ID int ,
Genre_ID int ,
Location_ID int ,
FOREIGN KEY (Artist_ID) REFERENCES Artist(ID),
FOREIGN KEY (Genre_ID) REFERENCES Genre(ID),
FOREIGN KEY (Location_ID) REFERENCES Location(ID)
 ); 


CREATE TABLE Ticket (   
Price money,
seat int ,  
ID int PRIMARY KEY,
Concert_ID int ,
FOREIGN KEY (Concert_ID) REFERENCES Concert(ID),
Class int 
Check (Class in (1,2,3)) );  


CREATE TABLE Customer (   
FirstName varchar(50) NOT NULL,   
LastName varchar(50) NOT NULL ,   
EmailAddress varchar(50) NOT NULL , 
ID int PRIMARY KEY,   
Gender char(1) 
Check (Gender in ('F','M'))
);  

CREATE TABLE Customer_Order (   
ID int PRIMARY KEY,   
OrderTime datetime,
Discount decimal,
final_price money,
Customer_ID int ,
FOREIGN KEY (Customer_ID) REFERENCES Customer(ID),
);  

alter table Customer_Order
drop column final_price

CREATE TABLE Order_ticket (   
ID int PRIMARY KEY,   
Ticket_ID int ,
Customer_Order_ID int ,
FOREIGN KEY (Customer_Order_ID) REFERENCES Customer_Order(ID),
FOREIGN KEY (Ticket_ID) REFERENCES Ticket(ID)
); 


INSERT INTO Artist (Score, FirstName, LastName,ID,Gender,BirthYear,Nationality,Website ) 
VALUES (10,'Lana', 'Del Rey', 1,'F',1985,'American','https://lanadelrey.com/');
INSERT INTO Artist (Score, FirstName, LastName,ID,Gender,BirthYear,Nationality,Website ) 
VALUES (10,'Adele', 'Adkins', 2,'F',1988,'British','http://adele.com/'),
	   (10,'Eminem', 'Mathers', 3,'M',1972,'American','https://www.eminem.com/'),
	   (9,'SIA', 'Furler', 4,'F',1975,'Australian','https://www.siamusic.net/'),
	   (8,'Billie', 'Eilish', 5,'F',2001,'American','https://www.billieeilish.com/');

select *from Artist

INSERT INTO Location(ID,Name,Capacity ) 
VALUES (1,'Walt Disney Concert Hall', 2265),(2,'National Centre for the Performing Arts', 5452),
(3,'The Oslo Opera House', 400),(4,'Royal Albert Hall', 8000),(5,'The Copenhagen Concert Hall', 1800);

select *from Location

INSERT INTO Genre(ID,Name ) 
VALUES (1,'Alternative'),(2,'Pop'),
(3,'rock'),(4,'Jazz'),(5,'Rapper'),(6,'Hip Hop');

select *from Genre

INSERT INTO Concert(ID,Name,Artist_ID,Genre_ID,Location_ID,Date ) 
VALUES (1,'Born To die World tour',1,1,1,'2012-05-06 20:00:00'),(2,'2015 world tour',2,2,4,'2015-05-08 20:00:00'),
(3,'LSD',4,2,5,'2018-01-06 10:00:00'),(4,'where do we go tour',5,2,3,'2019-12-27 15:00:00')
,(5,'2020 state tour',3,5,2,'2020-02-03 12:30:00');

select *from Concert


INSERT INTO Customer(ID,FirstName,LastName,Gender,EmailAddress ) 
VALUES
(1,'Faride','Ahmadian','F','fari000ah@gmail.com'),
(2,'Parmida','Salimi','F','marshmalo@yahoo.com'),
(3,'Parisa','qaderi','F','parisa@gmail.com'),
(4,'nima','sabahi','M','nima@yahoo.com'),
(5,'amirhosein','sadeqi','F','amir_h@gmail.com');

update Customer
set Gender = 'M'
WHERE FirstName ='amirhosein' ; 

select *from Customer


INSERT INTO Ticket(ID,Concert_ID,seat,Class,Price) 
VALUES 
(1,1,100,1,1500),
(2,1,101,1,1500),
(3,1,102,1,1500),
(4,1,103,3,400),
(5,1,104,1,1500),
(6,2,200,2,600),
(7,2,101,1,1000),
(8,3,300,2,700),
(9,2,201,1,1500),
(10,3,301,3,530),
(11,4,400,1,2000),
(12,5,100,3,400),
(13,1,105,1,1500),
(14,2,202,2,500),
(15,2,203,2,500),
(16,4,401,3,410),
(17,1,106,1,2000),
(18,4,402,2,710),
(19,5,100,1,1500),
(20,2,204,1,1600);

select *from Ticket

INSERT INTO Customer_Order(ID,Customer_ID,Discount,OrderTime) 
VALUES (1,1,0,'2011-02-03 16:30:00'),
(2,1,0,'2011-02-03 16:30:00'),
(3,2,20,'2014-02-03 16:30:00'),
(4,3,0,'2014-02-03 16:30:00'),
(5,4,10,'2013-02-03 16:30:00'),
(6,5,0,'2015-02-03 16:30:00'),
(7,1,5,'2017-02-03 16:30:00'),
(8,2,0,'2019-02-03 16:30:00');

INSERT INTO Customer_Order(ID,Customer_ID,Discount,OrderTime) 
VALUES (9,2,0,'2014-02-03 16:30:00'),
(10,3,0,'2017-02-03 16:30:00');

select *from Customer_Order

INSERT INTO Order_ticket(ID,Customer_Order_ID,Ticket_ID) 
VALUES
(1,1,1),(2,1,2),(3,1,3),
(4,2,4),(5,2,5),(6,2,6),
(7,3,7),(8,3,8),
(9,4,9),(10,4,10),
(11,5,11),(12,5,12),
(13,6,13),(14,6,14),
(15,7,15),(16,7,16),
(17,8,17),(18,8,18),
(19,9,19),
(20,10,20);

select *from Order_ticket