-- Tạo database 
Create database DA
use DA
go
--- Tạo bảng Vendor_DIM
CREATE TABLE [dbo].[Vendor_DIM](
	[Vendor_key] [int] IDENTITY(1,1) primary key NOT NULL,
	[VendorNumber] [varchar](100) NOT NULL,
	[VendorName] [varchar] (100) not null,
) ON [PRIMARY]
go
--- Tạo bảng Brand_DIM
CREATE TABLE [dbo].[Brand_DIM](
	[Brand] [varchar](100) NOT NULL,
	[Description] [varchar] (100) not null,
	[Price] [varchar] (100) not null,
	[Size] [varchar] (100) not null,
	[Volume] [varchar] (100) not null,
	[Classification] [varchar] (100) not null,
	[PurchasePrice] [varchar] (100) not null,
	[Vendor_key] [int] NOT NULL,
) ON [PRIMARY]
go
--- Tạo bảng InvoicePurchases_DIM
CREATE TABLE [dbo].[InvoicePurchases_DIM](
	[PONumber] [varchar](100)  NOT NULL,
	[InvoiceDate] [varchar](100) NOT NULL,
	[PODate] [varchar](100) NOT NULL,
	[PayDate] [varchar](100) NOT NULL,
	[Dollars] [varchar] (100) not null,
	[Quantity] [varchar](100),
	[Freight] [varchar] (100),
	[Approval] [varchar] (100),
) ON [PRIMARY]
go
--- Tạo bảng Address_DIM
CREATE TABLE [dbo].[Address_DIM](
	[Ad_key] [int] IDENTITY(1,1) NOT NULL,
	[InventoryID] [varchar](100) NOT NULL,
) ON [PRIMARY]
go
--- Tạo bảng BeginInventory_Fact
CREATE TABLE [dbo].[BeginInventory_Fact](
	[BegInv_key] [int] IDENTITY(1,1) primary key NOT NULL,
	[InventoryID] [varchar](100) NOT NULL,
	[OnHand] [varchar] (100) not null,
) ON [PRIMARY]
go
--- Tạp bảng EndInventory_Fact
CREATE TABLE [dbo].[EndInventory_Fact](
	[EndInv_key] [int] IDENTITY(1,1) primary key NOT NULL,
	[InventoryID] [varchar](100) NOT NULL,
	[OnHand] [varchar] (100) not null,
) ON [PRIMARY]
go
--- Tạo bảng PurchasesFinal_Fact
CREATE TABLE [dbo].[PurchasesFinal_Fact](
	[Purchases_key] [int] IDENTITY(1,1) primary key NOT NULL,
	[InventoryID] [varchar](100) NOT NULL,
	[PONumber] [varchar] (100) not null,
	[Quantity] [varchar](100),
	[ReceivingDate] [varchar] (100),
) ON [PRIMARY]




