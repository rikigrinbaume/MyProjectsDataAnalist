--Name: Rivka Grinbaume
--Date: 14/03/2024

Use master
Go 
Create Database sales
Go
Use sales
Go
Create table SalesTerritory
(
TerritoryID int,
Name varchar(50) constraint st_nm_nnnot null,
CountryRegionCode varchar(3) constraint st_crc_nn not null,
[group] varchar(50) constraint st_gro_nn not null,
SalesYTD money constraint st_sytd_nn not null,
SalesLastYear money constraint st_sly_nn not null,
CostYTD money constraint st_cytd_nn not null,
CostLastYear money constraint st_cly_nn not null,
ModifiedDate datetime constraint st_mdate_nn not null,
constraint st_tid_pk Primary key (TerritoryID)
)
Go
Create table Customer
(
CustomerID int,
PersonID int,
StoreID int,
TerritoryID int ,
AccountNumber nvarchar(15) constraint ctr_anum_nn not null,
ModifiedDate datetime constraint ctr_mdate_nn not null,
constraint ctr_cid_pk Primary key (CustomerID),
constraint ctr_tid_fk FOREIGN KEY(TerritoryID) references salesTerritory (TerritoryID)
)
Go
Create table SalesPerson
(
BusinessEntityID int,
TerritoryID int,
SalesQuota money,
Bonus money constraint sp_bs_nn not null,
CommissionPct smallmoney constraint sp_cp_nn not null,
SalesYTD money constraint sp_sytd_nn not null,
SalesLastYear money constraint sp_sly_nn not null,
ModifiedDate datetime constraint sp_mdate_nn not null,
constraint sp_beid_pk Primary key (BusinessEntityID),
constraint sp_tid_fk FOREIGN KEY (TerritoryID) references salesTerritory (TerritoryID)
)
Go
Create table CreditCard
(
creditCardID int,
CardType varchar(50) constraint ccd_ct_nn not null,
CardNumber varchar(25) constraint ccd_cnr_nn not null,
ExpMonth tinyint constraint ccd_exm_nn not null,
ExpYear smallint constraint ccd_exy_nn not null,
ModifiedDate datetime constraint ccd_mdate_nn not null,
constraint ccd_ccid_pk Primary key (creditCardID)
)
Go
create table SpecialOfferProduct
(
SpecialofferID int,
ProductID int,
ModifiedDate datetime constraint soffer_mdate_nn not null,
constraint soffer_soid_pid_pk Primary key (SpecialofferID, ProductID)
)
Go
Create table CurrencyRate
(
currencyRateID int,
currencyRateDate datetime constraint cr_crdate_nn not null,
FromCurrencyCode char(3) constraint cr_fcc_nn not null,
ToCurrencyCode char(3) constraint cr_tcc_nn not null,
AverageRate money constraint cr_arate_nn not null,
EndOfDayRate money constraint cr_eodr_nn not null,
ModifiedDate datetime constraint cr_mdate_nn not null,
constraint cr_crid_pk Primary key (currencyRateID)
)
Go
Create table SalesOrderHeader
(
SalesOrderID int,
RevisionNumber tinyint constraint soh_rn_nn not null,
OrderDate datetime constraint soh_odate_nn not null,
DueDate datetime constraint soh_ddate_nn not null,
ShipDate datetime,
status tinyint constraint soh_stt_nn not null,
OnlineOrderFlag bit constraint soh_oof_nn not null,
SalesOrderNumber nvarchar(25) constraint soh_son_nn not null,
PurchaseOrderNumber varchar(25),
AccountNumber varchar(15),
CustomerID int constraint soh_cid_nn not null,
SalesPersonID int,
TerritoryID int,
BillToAddressID int constraint soh_btaid_nn not null,
ShipToAddressID int constraint soh_staid_nn not null,
ShipMethodID int constraint soh_smid_nn not null,
CreditCardID int, 
CreditCardApprovalCode varchar(15),
CurrencyRateID int, 
SubTotal money constraint soh_st_nn not null,
TaxAmt money constraint soh_txa_nn not null,
freight money constraint soh_ft_nn not null,
TotalDue money constraint soh_td_nn not null,
Comment varchar(128),
ModifiedDate datetime constraint soh_mdate_nn not null,
constraint soh_soid_pk Primary key (SalesOrderID),
constraint soh_crid_fk FOREIGN KEY (CurrencyRateID) references CurrencyRate (CurrencyRateID),
constraint soh_ccid_fk FOREIGN KEY (CreditCardID) references creditCard (CreditCardID),
constraint soh_tid_fk FOREIGN KEY (TerritoryID) references SalesTerritory (TerritoryID),
constraint soh_spid_fk FOREIGN KEY (SalesPersonID) references SalesPerson (BusinessEntityID),
constraint soh_cid_fk FOREIGN KEY(CustomerID) references Customer (CustomerID)
)
Go
create table SalesOrderDetail
(
SalesOrderID int,
SalesOrderDetailID int,
CarrierTrackingNumber varchar(25),
OrderQty smallint constraint sod_oqty_nn not null,
ProductID int constraint sod_pid_nn not null,
SpecialofferID int constraint sod_sfid_nn not null,
UnitPrice money constraint sod_unp_nn not null,
UnitPriceDiscount money constraint sod_upd_nn not null,
ModifiedDate datetime constraint sod_mdate_nn not null,
constraint sod_soid_sodid_pk Primary key (SalesOrderID, SalesOrderDetailID),
constraint sod_sfid_pid_fk FOREIGN KEY (SpecialofferID, ProductID) references SpecialOfferProduct (SpecialofferID, ProductID),
constraint sod_soid_fk FOREIGN KEY (SalesOrderID) references SalesOrderHeader (SalesOrderID)
)
Go
Insert into SalesTerritory
Select TerritoryID, Name, CountryRegionCode, [group], SalesYTD, SalesLastYear, CostYTD, CostLastYear, ModifiedDate
From [AdventureWorks2017].Sales.SalesTerritory
Go
Insert into Customer
Select CustomerID, PersonID, StoreID, TerritoryID, AccountNumber, ModifiedDate
From [AdventureWorks2017].Sales.Customer
Go
Insert into SalesPerson
Select BusinessEntityID, TerritoryID, SalesQuota, Bonus, CommissionPct, SalesYTD, SalesLastYear, ModifiedDate
From [AdventureWorks2017].Sales.SalesPerson
Go
Insert into CreditCard
Select creditCardID, CardType, CardNumber, ExpMonth, ExpYear, ModifiedDate
From [AdventureWorks2017].Sales.CreditCard
Go
Insert into SpecialOfferProduct
Select SpecialofferID, ProductID, ModifiedDate
From  [AdventureWorks2017].Sales.SpecialOfferProduct
Go
Insert into CurrencyRate
Select currencyRateID, currencyRateDate, FromCurrencyCode, ToCurrencyCode, AverageRate, EndOfDayRate, ModifiedDate
From [AdventureWorks2017].Sales.CurrencyRate
Go
Insert into SalesOrderHeader
Select SalesOrderID, RevisionNumber, OrderDate, DueDate, ShipDate, status, OnlineOrderFlag, SalesOrderNumber, PurchaseOrderNumber, AccountNumber,
CustomerID, SalesPersonID, TerritoryID, BillToAddressID, ShipToAddressID, ShipMethodID, CreditCardID, CreditCardApprovalCode, CurrencyRateID,
SubTotal, TaxAmt, freight, TotalDue, Comment, ModifiedDate
From [AdventureWorks2017].Sales.SalesOrderHeader
Go
Insert into SalesOrderDetail
Select SalesOrderID, SalesOrderDetailID, CarrierTrackingNumber, OrderQty, ProductID, SpecialofferID, UnitPrice, UnitPriceDiscount, modifiedDate
From [AdventureWorks2017].Sales.SalesOrderDetail