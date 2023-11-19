/*

Cleaning Data in SQL Queries

*/
select *
  from project.dbo.NashvilleHousing



--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

select SaleDateConverted, CONVERT(Date, SaleDate)
  from project.dbo.NashvilleHousing

UPDATE NashvilleHousing
set SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
set SaleDateConverted = CONVERT(Date, SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

select *
  from project.dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from project.dbo.NashvilleHousing a
join project.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
    and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from project.dbo.NashvilleHousing a
join project.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
    and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from project.dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID

SELECT
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS ADRESS,
         SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS ADRESS

from project.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAdress NVARCHAR(255);

UPDATE NashvilleHousing
set PropertySplitAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



Select *
from project.dbo.NashvilleHousing



Select OwnerAddress
from project.dbo.NashvilleHousing


Select
    parsename(replace(OwnerAddress,',','.'),3),
    parsename(replace(OwnerAddress,',','.'),2),
    parsename(replace(OwnerAddress,',','.'),1)
from project.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
set OwnerSplitAddress = parsename(replace(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE NashvilleHousing
set OwnerSplitCity = parsename(replace(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
set OwnerSplitState = parsename(replace(OwnerAddress,',','.'),1)

Select *
from project.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM Project.dbo.NashvilleHousing
Group By SoldAsVacant
ORDER BY 2


select SoldAsVacant
, Case when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
       else SoldAsVacant
END
FROM Project.dbo.NashvilleHousing



UPDATE NashvilleHousing
SET
    SoldAsVacant = Case when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
       else SoldAsVacant
END

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
with Row_numCTE AS (Select *,
                           ROW_NUMBER() over (
                               PARTITION BY ParcelID,
                               PropertyAddress,
                               SalePrice,
                               SaleDate,
                               LegalReference
                               ORDER BY [UniqueID ]
                               ) row_num


                    FROM Project.dbo.NashvilleHousing
                    )
SELECT *
FROM Row_numCTE
WHERE row_num > 1
--order by PropertyAddress
--order by ParcelID

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT  * FROM Project.dbo.NashvilleHousing

ALTER TABLE Project.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Project.dbo.NashvilleHousing
DROP COLUMN SaleDate
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
















