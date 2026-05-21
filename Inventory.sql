create database Inventory 

use Inventory

create table [Supplier] 
([SID] varchar(10) primary key,
[SName] varchar(20) not null,
[SAddress] varchar(50) not null,
[SCity] varchar(20) check(SCity in ('Delhi','Mumbai','Pune')),
[SPhone] varchar(15) unique,
[Email] varchar(50) unique)

insert into supplier values
('S0001','rahul traders','karol bagh','Delhi','9876543210','rahul@gmail.com'),
('S0002','mumbai electronics','andheri west','Mumbai','9123456780','melec@gmail.com'),
('S0003','pune distributors','shivaji nagar','Pune','9988776655','pune.dist@gmail.com'),
('S0004','delhi supplies','lajpat nagar','Delhi','9012345678','delhi.sup@gmail.com'),
('S0005','tech hub','noida sector 18','Delhi','9090909090','techhub@gmail.com'),
('S0006','health plus','bandra','Mumbai','9887766554','healthplus@gmail.com'),
('S0007','appliance zone','wakad','Pune','9765432109','appliance@gmail.com'),
('S0008','it world','connaught place','Delhi','9654321098','itworld@gmail.com'),
('S0009','urban supply','thane','Mumbai','9543210987','urban@gmail.com'),
('S0010','prime traders','kothrud','Pune','9432109876','prime@gmail.com');

select * from Supplier

create table [Product] 
([PID] varchar(10) primary key,
[PName] varchar(20) not null,
[Price] int check ([Price] > 0),
[Category] varchar(10) check([Category] in ('IT','Home Appliances','Health Care')),
[SID] varchar(10) not null,
foreign key (SID) references Supplier(SID))

insert into product values
('P0001','laptop',55000,'IT','S0001'),
('P0002','mouse',500,'IT','S0001'),
('P0003','keyboard',1500,'IT','S0002'),
('P0004','fridge',30000,'Home Appliances','S0007'),
('P0005','washing machine',25000,'Home Appliances','S0007'),
('P0006','ac',40000,'Home Appliances','S0006'),
('P0007','vitamins',800,'Health Care','S0006'),
('P0008','protein powder',2500,'Health Care','S0006'),
('P0009','monitor',12000,'IT','S0008'),
('P0010','printer',7000,'IT','S0008'),
('P0011','heater',2000,'Home Appliances','S0004'),
('P0012','fan',1500,'Home Appliances','S0004'),
('P0013','thermometer',300,'Health Care','S0003'),
('P0014','router',2000,'IT','S0005'),
('P0015','tablet',18000,'IT','S0005');

select * from Product

alter table Product
alter column Category varchar(30)

create table [Stock] 
([PID] varchar(10) primary key,
foreign key (PID) references Product(PID),
[SQuantity] int check(SQuantity >= 0),
[ReOrder Limit] int check([ReOrder Limit] > 0),
[MOQ] int check([MOQ] >= 5)) -- MOQ = Minimum Order Quantity

insert into stock values
('P0001',50,10,5),
('P0002',100,20,10),
('P0003',80,15,5),
('P0004',30,5,5),
('P0005',25,5,5),
('P0006',20,5,5),
('P0007',60,10,5),
('P0008',40,8,5),
('P0009',35,7,5),
('P0010',45,10,5);

select * from Stock

create table [Customer]
([CID] varchar(10) primary key,
[CName] varchar(20) not null,
[Address] varchar(50) not null,
[City] varchar(20) not null,
[Phone] varchar(15) unique not null,
[Email] varchar(50) unique not null,
[DOB] date check([DOB] > '2000-01-01'))

insert into customer values
('C0001','Aman Sharma','Delhi','Delhi','9876543211','aman@gmail.com','2001-05-12'),
('C0002','Riya Verma','Mumbai','Mumbai','9876543212','riya@gmail.com','2002-08-20'),
('C0003','Karan Mehta','Pune','Pune','9876543213','karan@gmail.com','2000-11-15'),
('C0004','Sneha Gupta','Delhi','Delhi','9876543214','sneha@gmail.com','2003-02-10'),
('C0005','Arjun Singh','Mumbai','Mumbai','9876543215','arjun@gmail.com','2001-07-25'),
('C0006','Neha Kapoor','Pune','Pune','9876543216','neha@gmail.com','2002-09-05'),
('C0007','Rohit Jain','Delhi','Delhi','9876543217','rohit@gmail.com','2000-12-30'),
('C0008','Pooja Nair','Mumbai','Mumbai','9876543218','pooja@gmail.com','2001-03-18'),
('C0009','Vikas Yadav','Pune','Pune','9876543219','vikas@gmail.com','2002-06-22'),
('C0010','Anjali Desai','Delhi','Delhi','9876543220','anjali@gmail.com','2001-10-08');

select * from [Customer]

create table [Orders]
([OID] varchar(10) primary key,
[ODate] date not null,
[PID] varchar(10) not null ,
[CID] varchar(10) not null ,
[OQuantity] int check([OQuantity] >= 1),
foreign key (PID) references Product(PID),
foreign key (CID) references Customer(CID))

insert into orders values
('O0001','2024-01-10','P0001','C0001',2),
('O0002','2024-01-12','P0003','C0002',1),
('O0003','2024-01-15','P0005','C0003',3),
('O0004','2024-01-18','P0002','C0004',2),
('O0005','2024-01-20','P0007','C0005',1);

select * from Orders

-- 1. Display PName,PID,Category,SName,SCity
select PID,PName,Category,SName,SCity 
from Product
Left Join Supplier
on Product.SID = Supplier.SID


-- 2. Display OID,ODate,CName,Address,Phone,PName,Price,OQuantity,Revenue(Price*Quantity)
select OID,ODate,Cname,Address,Phone,PName,Price,OQuantity,Price*OQuantity as Revenue
from Orders
Inner Join Customer
on Customer.CID = Orders.CID
Inner join Product
on Product.PID = Orders.PID

-- 3. revenue per customer
select Customer.CID,CName, coalesce (sum(Price*OQuantity),0) as Revenue 
from Customer
left join Orders
on Orders.CID = Customer.CID
left join Product
on Product.PID = Orders.PID
group by Customer.CID, CName
order by Revenue desc 

-- 4. top 3 products by quantity sold
select top 3 Product.PID,PName,OQuantity as [Highest Quantity]
from Product
Inner Join Orders
on Orders.PID = Product.PID
order by [Highest Quantity] desc

-- 5. Low Stock
select Product.PID ,PName,SQuantity,[ReOrder Limit]
from Product
Inner Join Stock
on Stock.PID = Product.PID
where SQuantity < [ReOrder Limit]
order by SQuantity asc

-- 6. Products Never Sold
select Product.PID,PName,OQuantity
from Product
Left Join Orders
on Product.PID = Orders.PID
where OQuantity is null

-- 7. Revenue by Category 
select Category, coalesce(sum(Price*OQuantity),0) as Revenue
from Product 
Left Join Orders
on Orders.PID = Product.PID
group by Category
order by Revenue desc