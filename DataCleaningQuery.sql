---Claning Data in SQL Queries------------------

select * 
From [Project Portfolio]..[Nashville Housing]

-----------------------standardize date format---------------------

select SaleDateConverted, convert(date, SaleDate) 
From [Project Portfolio]..[Nashville Housing]

update [Nashville Housing]
SET SaleDate= Convert(Date,SaleDate)

Alter Table [Nashville Housing]
add SaleDateConverted Date;

Update [Nashville Housing]
Set SaleDateConverted = CONVERT(Date, SaleDate)



--------------------------------Populate Property Address Data---------------------

select * 
From [Project Portfolio]..[Nashville Housing]
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
From [Project Portfolio]..[Nashville Housing] a
Join [Project Portfolio]..[Nashville Housing] b
on a.ParcelID =b.ParcelID
and a.[UniqueID]<> b.[UniqueID]
where a.PropertyAddress is null



Update a
set PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
From [Project Portfolio]..[Nashville Housing] a
Join [Project Portfolio]..[Nashville Housing] b
on a.ParcelID =b.ParcelID
and a.[UniqueID]<> b.[UniqueID]
where a.PropertyAddress is null




--------------------Breaking out Address into Indivisual Columns(Address, City, State)-------------------------

select PropertyAddress
From [Project Portfolio]..[Nashville Housing]
--where PropertyAddress is null
---order by ParcelID

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
FROM [Project Portfolio]..[Nashville Housing]



Alter Table [Nashville Housing]
Add PropertySplitAddress Nvarchar(255);

Update [Nashville Housing]
SET PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter Table [Nashville Housing]
Add PropertySplitCity Nvarchar(255);

Update [Nashville Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) ;


select*
From [Project Portfolio]..[Nashville Housing]





select OwnerAddress
From [Project Portfolio]..[Nashville Housing]


Select 
PARSENAME(Replace(OwnerAddress,',','.') ,3),
PARSENAME(Replace(OwnerAddress,',','.') ,2),
PARSENAME(Replace(OwnerAddress,',','.') ,1)
From [Project Portfolio]..[Nashville Housing]


Alter Table [Nashville Housing]
Add OwnerSplitAddress Nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitAddress=PARSENAME(Replace(OwnerAddress,',','.') ,3)

Alter Table [Nashville Housing]
Add OwnerSplitCity Nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.') ,2)

Alter Table [Nashville Housing]
Add OwnerSplitState Nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitState= PARSENAME(Replace(OwnerAddress,',','.') ,1)



select*
From [Project Portfolio]..[Nashville Housing]



---------CHange Y and N to Yes and No in "Sold as Vacant" field------------------



select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Project Portfolio]..[Nashville Housing]
Group by SoldAsVacant
Order by 2

select SoldAsVacant
,CASE When SoldAsVacant ='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
From [Project Portfolio]..[Nashville Housing]
Group by SoldAsVacant
Order by 2


select SoldAsVacant
,CASE When SoldAsVacant ='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
end 
From [Project Portfolio]..[Nashville Housing]


update [Project Portfolio]..[Nashville Housing]
set SoldAsVacant =CASE When SoldAsVacant ='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
end 

-----------Remove Duplicates-------------------

WITH RowNumCTE AS(
select*,
ROW_NUMBER() OVER (
PARTITION BY ParcelID, 
			PropertyAddress, 
			SalePrice, 
			SaleDate, 
			LegalReference
			Order by 
			UniqueID
			) row_num
from [Project Portfolio]..[Nashville Housing]
--Order by ParcelID;
)

DELETE
from RowNumCTE
where row_num>1
--order by PropertyAddress
--from [Project Portfolio]..[Nashville Housing]



--now let's make sure if there's more duplicates in there.---
WITH RowNumCTE AS(
select*,
ROW_NUMBER() OVER (
PARTITION BY ParcelID, 
			PropertyAddress, 
			SalePrice, 
			SaleDate, 
			LegalReference
			Order by 
			UniqueID
			) row_num
from [Project Portfolio]..[Nashville Housing]
--Order by ParcelID;
)
select* 
from RowNumCTE
where row_num>1
order by PropertyAddress


--Delete Unused Columns-----------


Select *
From [Project Portfolio]..[Nashville Housing]



Alter Table [Project Portfolio]..[Nashville Housing]
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

--forgot to drop SaleDate column, so now write the separate query for saleDate
Alter Table [Project Portfolio]..[Nashville Housing]
Drop Column SaleDate





