--Name: Rivka Grinbaume
--Date: 16/04/2024


--Q1
select pp.ProductID, pp.Name, pp.Color, pp.ListPrice, pp.Size
from Production.Product as pp
 left join sales.SalesOrderDetail as sod
on pp.ProductID = sod.ProductID
where sod.ProductID is null
order by pp.ProductID


--Q2
select c.CustomerID, 
isnull(p.LastName, 'unknown') as LastName,
isnull(p.FirstName, 'unknown') as FirstName
from SALES.Customer as C
 left join SALES.SalesOrderHeader as SOH
on c.CustomerID = soh.CustomerID
 left join Person.Person as p
on c.CustomerID = p.BusinessEntityID
where soh.CustomerID is null
order by c.CustomerID


--Q3
select top 10 
soh.CustomerID, p.FirstName, p.LastName,
count(soh.SalesOrderID) as countoforders
from SALES.SalesOrderHeader as soh
 join sales.Customer as c
on soh.CustomerID = c.CustomerID
 join Person.Person as p
on c.PersonID = p.BusinessEntityID
group by soh.CustomerID, p.FirstName, p.LastName
order by countoforders desc


--Q4
select P.FirstName, P.LastName, e.JobTitle, e.HireDate,
count(*) over (partition by e.JobTitle) as countoftitle
from HumanResources.Employee as E
 join Person.Person as P
on E.BusinessEntityID = P.BusinessEntityID


--Q5
with lastorder
as
(select soh.SalesOrderID, soh.CustomerID, c.PersonID, soh.OrderDate, p.lastname, p.firstname,
lead(soh.OrderDate)over(partition by soh.CustomerID order by soh.orderdate desc) as previousorder,
dense_rank()over(partition by soh.customerid order by soh.OrderDate DESC) as RANK_lastdate
from sales.Customer as c
 join SALES.SalesOrderHeader as soh 
on soh.CustomerID = c.CustomerID
 join person.Person as p
on c.PersonID = p.BusinessEntityID)
------------------------------------------
select l.SalesOrderID, l.CustomerID, l.LastName, l.FirstName, l.OrderDate as lastorder, l.previousorder
from lastorder as l
where l.RANK_lastdate =1
order by l.PersonID


--Q6
select A.YEAR, A.SalesOrderID, A.LastName, A.FirstName, A.TOTAL
from
(select sod.SalesOrderID, pp.LastName, pp.FirstName, YEAR(SOH.OrderDate) as YEAR,
sum(sod.UnitPrice*(1-sod.UnitPriceDiscount)*sod.OrderQty) as SUM_,
max(sum(sod.UnitPrice*(1-sod.UnitPriceDiscount)*sod.OrderQty)) over(partition by YEAR(SOH.OrderDate)) as TOTAL,
dense_rank()over(partition by YEAR(SOH.OrderDate) order by sum(sod.UnitPrice*(1-sod.UnitPriceDiscount)*sod.OrderQty)desc) as RK
from sales.SalesOrderDetail as sod
 left join sales.SalesOrderHeader as soh
on sod.SalesOrderID = soh.SalesOrderID
 left join sales.Customer as c
on soh.CustomerID = c.CustomerID
 left join Person.Person as pp
on c.PersonID = pp.BusinessEntityID
group by sod.SalesOrderID, pp.LastName, pp.FirstName, soh.OrderDate) AS A
WHERE RK=1


--Q7
select *
from
(
select year(s.OrderDate) as yy, month(s.OrderDate)as month, s.SalesOrderID
from sales.SalesOrderHeader as s
) as soh
pivot(count(soh.SalesOrderID) for yy in ([2011], [2012], [2013], [2014])) pvt
order by 1, 2


--Q8
with SumPrice 
as
(select YEAR(soh.OrderDate) as 'Year',MONTH(soh.OrderDate) as 'Month_',SUM(sod.UnitPrice) as 'SumPrice'
from Sales.SalesOrderDetail as sod 
 join Sales.SalesOrderHeader as soh 
on sod.SalesOrderID = soh.SalesOrderID
group by YEAR(soh.OrderDate), MONTH(soh.OrderDate)),

YearTotal
as
(select Year(soh.OrderDate) as 'Year', 'grand_total' as 'GrandTotal', SUM(sod.UnitPrice) as 'SumPrice', 1 as 'SortOrder'
from Sales.SalesOrderDetail as sod
join Sales.SalesOrderHeader as soh 
on sod.SalesOrderID = soh.SalesOrderID
group by Year(soh.OrderDate))      
---------------------------------------------------------
select Final.Year,Final.Month,Final.SumPrice,final.CumSum
from
(select sp.Year ,CAST(sp.Month_ as varchar) as 'Month',sp.SumPrice,
SUM(sp.SumPrice) over (partition by sp.Year order by sp.Month_ ASC 
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as 'CumSum',
1 as 'SortOrder'
from SumPrice as sp

union

select yt.Year,yt.GrandTotal,NULL,yt.SumPrice,2
from YearTotal as yt) as Final
order by Year,SortOrder,
CASE WHEN month = 'grand_total' THEN 13 ELSE CAST(month AS INT) END


--Q9
select d.Name as departmentname, e.BusinessEntityID as employeesid, p.FirstName + ' ' + p.LastName as employeesfullname, e.HireDate,
datediff(MM, e.HireDate, getdate())as seniority ,
lead(p.FirstName + ' ' + p.LastName, 1)over(PARTITION BY d.name ORDER BY e.HireDate desc) as previuseEmpname,
lead(e.HireDate, 1)over(PARTITION BY d.name ORDER BY e.HireDate desc) as previuseEmpdate,
DATEDIFF(DAY, lead(e.HireDate, 1)over(PARTITION BY d.name ORDER BY e.HireDate desc), e.HireDate) as diffdate
from HumanResources.Employee as e
 join Person.Person as p
on e.BusinessEntityID = p.BusinessEntityID 
 join HumanResources.EmployeeDepartmentHistory as h
on e.BusinessEntityID = h.BusinessEntityID
 join HumanResources.Department as d
on h.DepartmentID = d.DepartmentID


--Q10
select e.HireDate, d.DepartmentID,
STRING_AGG(CONVERT(NVARCHAR(max), CONCAT(p.BusinessEntityID, ' ' ,p.LastName , ' ',p.FirstName, ' ,' )), CHAR(13)) as teamemployees
from HumanResources.Employee as e
 join Person.Person as p
on e.BusinessEntityID = p.BusinessEntityID 
 join HumanResources.EmployeeDepartmentHistory as h
on e.BusinessEntityID = h.BusinessEntityID
 join HumanResources.Department as d
on h.DepartmentID = d.DepartmentID
where h.enddate is null
group by e.HireDate, d.DepartmentID
order by e.HireDate desc











--Q8





