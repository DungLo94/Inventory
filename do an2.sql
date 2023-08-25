-- Chỉnh sửa bảng Address_DIM
select *
from [dbo].[Address_DIM]
ALTER TABLE Address_DIM
ALTER COLUMN Brand varchar(100);
ALTER TABLE Address_DIM
ALTER COLUMN Store varchar(100);
go
ALTER TABLE Address_DIM
ADD CONSTRAINT PK_Address_DIM PRIMARY KEY (Ad_key);
go
ALTER TABLE Address_DIM
ADD Store VARCHAR(50),
	City VARCHAR(50),
	Brand VARCHAR(50);
UPDATE Address_DIM
SET InventoryID = REPLACE(InventoryID, '"', '');
	----- Cập nhật dữ liệu cho các cột mới dựa vào cột InventoryID
UPDATE Address_DIM
SET Store = SUBSTRING(InventoryID, 1, CHARINDEX('_', InventoryID) - 1),
    City = SUBSTRING(InventoryID, CHARINDEX('_', InventoryID) + 1, CHARINDEX('_', InventoryID, CHARINDEX('_', InventoryID) + 1) - CHARINDEX('_', InventoryID) - 1),
    Brand = SUBSTRING(InventoryID, CHARINDEX('_', InventoryID, CHARINDEX('_', InventoryID) + 1) + 1, LEN(InventoryID));
-- Chỉnh sửa bảng Vendor_DIM
select *
from [dbo].[Vendor_DIM] ;

-- Chỉnh sửa bảng Brand_DIM
select *
from [dbo].[Brand_DIM] ;
ALTER TABLE Brand_DIM
ALTER COLUMN Price float;
ALTER TABLE Brand_DIM
ALTER COLUMN PurchasePrice float ;
ALTER TABLE Brand_DIM
ADD CONSTRAINT PK_Brand_DIM PRIMARY KEY (Brand);
-- Chỉnh sửa bảng InvoicePurchase_DIM
select *
from [dbo].[InvoicePurchases_DIM] ;
ALTER TABLE InvoicePurchases_DIM
ALTER COLUMN InvoiceDate date not null;
ALTER TABLE InvoicePurchases_DIM
ALTER COLUMN PODate date not null;
ALTER TABLE InvoicePurchases_DIM
ALTER COLUMN PayDate date not null;
ALTER TABLE InvoicePurchases_DIM
ALTER COLUMN Dollars float not null;
ALTER TABLE InvoicePurchases_DIM
ALTER COLUMN Freight float not null;
ALTER TABLE InvoicePurchases_DIM
ALTER COLUMN Quantity int not null;
ALTER TABLE InvoicePurchases_DIM
ADD CONSTRAINT PK_Invoice_DIM PRIMARY KEY (PONumber);
-- Chỉnh sửa bảng PurchasesFinal_Fact
select *
from PurchasesFinal_Fact
ALTER TABLE PurchasesFinal_Fact
ALTER COLUMN PONumber varchar(100) not null;
ALTER TABLE PurchasesFinal_Fact
ALTER COLUMN Quantity int not null;
ALTER TABLE PurchasesFinal_Fact
ALTER COLUMN ReceivingDate date not null;
-- Chỉnh sửa bảng [dbo].[BeginInventory_Fact]
select *
from BeginInventory_Fact
UPDATE BeginInventory_Fact
SET InventoryID = REPLACE(InventoryID, '"', '');
ALTER TABLE BeginInventory_Fact
ALTER COLUMN OnHand int not null;
-- Chỉnh sửa bảng [dbo].[EndInventory_Fact]
select *
from EndInventory_Fact
UPDATE EndInventory_Fact
SET InventoryID = REPLACE(InventoryID, '"', '');
ALTER TABLE EndInventory_Fact
ALTER COLUMN OnHand int not null;
-- Tạo bảng Date_DIM
CREATE TABLE Date_DIM (
    date_key INT IDENTITY(1,1) PRIMARY KEY,
    date DATE,
    week INT,
    month INT,
    year INT
);
-- Thêm dữ liệu vào bảng Date_DIM từ ngày 20-12-2015 đến ngày 19-2-2017
DECLARE @startDate DATE = '2015-12-20';
DECLARE @endDate DATE = '2017-02-19';

WHILE @startDate <= @endDate
BEGIN
    INSERT INTO Date_DIM (date, week, month, year)
    VALUES (
        @startDate,
        DATEPART(ISO_WEEK, @startDate),
        MONTH(@startDate),
        YEAR(@startDate)
    );
    SET @startDate = DATEADD(DAY, 1, @startDate);
END;

go
Select *from Date_DIM
drop table Date_DIM
go
--- Tạo bảng tạm Purchases_Synthetic
CREATE TABLE Purchases_Synthetic (
    InventoryID varchar(100),
    PurchasesQuantity INT
);
INSERT INTO Purchases_Synthetic (InventoryID, PurchasesQuantity)
Select
A.InventoryID,
sum(A.Quantity)
from PurchasesFinal_Fact A
group by A.InventoryID ;
go
--Tạo bảng Sales
Alter table Sales
Add SaleQuantity int
Create table Sales(
InventoryID varchar(100) Primary key not null,
PurchasesQuantity int,
BegInventoryQuantity int,
EndInventoryQuantity int,
SaleQuantity int) ;
go
INSERT INTO Sales(InventoryID)
select A.InventoryID
from Address_DIM A
UPDATE A
Set PurchasesQuantity = D.PurchasesQuantity	
from Sales  A
Left join Purchases_Synthetic  D
on A.InventoryID = D.InventoryID
UPDATE A
Set BegInventoryQuantity = D.OnHand	
from Sales  A
Left join BeginInventory_Fact D
on A.InventoryID = D.InventoryID
UPDATE A
Set EndInventoryQuantity = D.OnHand	
from Sales  A
Left join EndInventory_Fact D
on A.InventoryID = D.InventoryID
UPDATE Sales
SET PurchasesQuantity = 0
WHERE PurchasesQuantity IS NULL;
UPDATE Sales
SET BegInventoryQuantity = 0
WHERE BegInventoryQuantity IS NULL;
UPDATE Sales
SET EndInventoryQuantity = 0
WHERE EndInventoryQuantity IS NULL;
UPDATE Sales
set SaleQuantity = PurchasesQuantity + BegInventoryQuantity - EndInventoryQuantity
go
Select * from Sales
-- Tạo bảng Sales on Brand
drop table SalesDemo
drop table SaleOnBrand
Create table SalesDemo(
Brand varchar(100) Primary key not null,
SalePrice float,
SaleQuantity int,
Revenue float );
go
insert into SalesDemo(Brand,SaleQuantity)
select
C.Brand,
sum(A.SaleQuantity) as SaleQuantity
from [dbo].[Sales] A
join Address_DIM B
on  A.InventoryID =B.InventoryID
join Brand_DIM C
on B.Brand =C.Brand
group by C.Brand
UPDATE A
Set SalePrice = D.Price	
from SalesDemo  A
Left join Brand_DIM D
on A.Brand = D.Brand
UPDATE SalesDemo
Set Revenue = SalePrice*SaleQuantity
go
declare @Sumtotal decimal(18,2) = (Select sum(Revenue) from SalesDemo);
WITH cte AS (
    SELECT *,
		   SUM(Revenue) Over (ORDER BY Revenue DESC) as RunningTotal,
		   @Sumtotal as RevenueTotal
    FROM SalesDemo
),
seo as (SELECT *,(100*RunningTotal)/RevenueTotal as PercentRunningTotal,
	Case When (100*RunningTotal)/RevenueTotal < 70 then 'A'
		When (100*RunningTotal)/RevenueTotal < 90 then 'B'
		Else 'C' 
	End	as Class
 FROM cte)
SELECT * 
into SaleOnBrand
from seo
--
drop table SaleOnBrand
Select * from SaleOnBrand
-- Tạo bảng Sales on Store
drop table SalesDemo2
Create table SalesDemo2(
Store varchar(100),
SalePrice float,
SaleQuantity int,
Revenue decimal(18,2) );
go
insert into SalesDemo2
select
B.Store,
D.Price as SalePrice,
A.SaleQuantity as SaleQuantity,
D.Price * A.SaleQuantity as Revenue
from [dbo].[Sales] A
join Address_DIM B
on  A.InventoryID =B.InventoryID
join Brand_DIM D
on B.Brand = D.Brand
go
 select 
Store, 
sum(Revenue)  as Revenue
into new
from SalesDemo2
group by Store
order by 2 desc;
declare @Sumtotal2 decimal(18,2) = (Select sum(Revenue) from new);
With tam AS (
    SELECT *,
		   SUM(Revenue) Over (ORDER BY Revenue DESC) as RunningTotal,
		   @Sumtotal2 as RevenueTotal
    FROM new
),
anh as (SELECT *,(100*RunningTotal)/RevenueTotal as PercentRunningTotal,
	Case When (100*RunningTotal)/RevenueTotal < 60 then 'A'
		When (100*RunningTotal)/RevenueTotal < 90 then 'B'
		Else 'C' 
	End	as ClassStore
 FROM tam)
SELECT * 
into SaleOnStore
from anh
go
drop table SaleOnStore
drop table new
select * from SaleOnStore