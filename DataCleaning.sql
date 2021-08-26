-----------------------------
--Data Cleaning Learnign Project
-- In this proejct with dsiplay my skill altering tables , removing duplicated data , string parsing and using CTE's in SQL---



SELECT *
FROM PortfolioProject..NashHousing

------------------------------------------------------------------
--Date Format

Select SaleDateConverted
From PortfolioProject..NashHousing

Update NashHousing
SET SaleDate =  CONVERT(Date,SaleDate)

ALTER TABLE NashHousing
Add SaleDateConverted Date;

Update NashHousing
set SaleDateConverted = CONVERT(DATE,SaleDate)

---------------------------------------------------------------------------
---Populate Propery Address Data

Select *
From PortfolioProject..NashHousing
where PropertyAddress is null


Select a.ParcelID , a.PropertyAddress , b.ParcelID , b.PropertyAddress , ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashHousing a
JOIN PortfolioProject..NashHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashHousing a
JOIN PortfolioProject..NashHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Seperating the Adress and breaking into individual columms
select PropertyAddress
FROM Portfolioproject..NashHousing


SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1 , len(PropertyAddress)) as Address
FROM Portfolioproject..NashHousing

--Update
ALTER TABLE Portfolioproject..NashHousing
Add SplitAddress Nvarchar(255);

Update Portfolioproject..NashHousing
SET SplitAddress =  SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

ALTER TABLE Portfolioproject..NashHousing
Add SplitCity Nvarchar(255);

Update Portfolioproject..NashHousing
set SplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1 , len(PropertyAddress)) 

--Updated Table with SPlit Address Data
SELECT *
FROM PortfolioProject..NashHousing


--- Using ParseName To Split the Column

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM PortfolioProject..NashHousing


ALTER TABLE Portfolioproject..NashHousing
Add OwnerSplitAddress Nvarchar(255);

Update Portfolioproject..NashHousing
SET OwnerSplitAddress =  PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

ALTER TABLE Portfolioproject..NashHousing
Add OwnerSplitCity Nvarchar(255);

Update Portfolioproject..NashHousing
SET OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress, ',','.'),2)


ALTER TABLE Portfolioproject..NashHousing
Add OwnerSplitState Nvarchar(255);

Update Portfolioproject..NashHousing
SET OwnerSplitState =  PARSENAME(REPLACE(OwnerAddress, ',','.'),1)


-------------------------------------------------------------------------------------------------------------------------
Select Distinct(SoldasVacant), count(SoldAsVacant)
From PortfolioProject..NashHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant,
	CASE When SoldasVacant = 'Y' THEN 'Yes'
	When SoldasVacant = 'N' THEN 'No'
	Else SoldAsVacant
	END
From PortfolioProject..NashHousing


Update PortfolioProject..NashHousing
SET SoldAsVacant = CASE When SoldasVacant = 'Y' THEN 'Yes'
	When SoldasVacant = 'N' THEN 'No'
	Else SoldAsVacant
	END


-- Removing Duplicates From The Housing DataSet---------------------------------------------------------

--Finding Duplicates
WITH RowNumCTE AS(
SELECT *,
 ROW_NUMBER() OVER (
 partition by ParcelID ,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order by UniqueID) row_num

From PortfolioProject..NashHousing
)

SELECT * 
From RowNumCTE
WHERE row_num >1


select *
From PortfolioProject..NashHousing


--------------------------------------------------------------------------
-- Drop Unused Columns	


alter table PortfolioProject..NashHousing
DROP COLUMN OwnerAddress , TaxDistrict , PropertyAddress

alter table PortfolioProject..NashHousing
DROP COLUMN SplitCity , SplitAddress