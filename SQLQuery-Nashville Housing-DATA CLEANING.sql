-- */ DATA CLEANING */

Select *
FROM [ProjectPortfolio].[dbo].[NashvilleHousing]

--------------------------------------------------------------------------------------------------------

-- Change SaleDate Format

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)


Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

Select SaleDateConverted, CONVERT(Date, SaleDate)
FROM [ProjectPortfolio].[dbo].[NashvilleHousing]

--------------------------------------------------------------------------------------

-- Populate Property Address data that was NULL

Select *
FROM [ProjectPortfolio].[dbo].[NashvilleHousing]
--Where  PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)																																																																																																					
FROM [ProjectPortfolio].[dbo].[NashvilleHousing] a
JOIN [ProjectPortfolio].[dbo].[NashvilleHousing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where  a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [ProjectPortfolio].[dbo].[NashvilleHousing] a
JOIN [ProjectPortfolio].[dbo].[NashvilleHousing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where  a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------

-- Breaking out Addresses into Individual Columns (Address, City, State)

---	PROPERTYADDRESS
Select PropertyAddress
FROM [ProjectPortfolio].[dbo].[NashvilleHousing]

SELECT 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address

FROM [ProjectPortfolio].[dbo].[NashvilleHousing]

ALTER TABLE NashvilleHousing
Add PropertySplitAddress nVarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity nVarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))


Select *
FROM [ProjectPortfolio].[dbo].[NashvilleHousing]

---	OWNERADDRESS

Select OwnerAddress
FROM [ProjectPortfolio].[dbo].[NashvilleHousing]

SELECT
PARSENAME(Replace(OwnerAddress,',','.'),3) as OwnerSplitAddress
,PARSENAME(Replace(OwnerAddress,',','.'),2) as OwnerSplitCity
,PARSENAME(Replace(OwnerAddress,',','.'),1) as OwnerSplitState
FROM [ProjectPortfolio].[dbo].[NashvilleHousing]


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress nVarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity nVarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState nVarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)


Select *
FROM [ProjectPortfolio].[dbo].[NashvilleHousing]


----------------------------------------------------------------------------------------------------------------

-- Change Y and N in the 'Sold as Vacant'

Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [ProjectPortfolio].[dbo].[NashvilleHousing]
GROUP BY (SoldAsVacant)
ORDER BY 2



Select SoldAsVacant
,CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	  WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
END 
FROM [ProjectPortfolio].[dbo].[NashvilleHousing]


UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	  WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
END 


----------------------------------------------------------------------------------------------------------------

-- Removing Duplicates (using CTE)

Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
				    UniqueID
				    ) row_num

FROM [ProjectPortfolio].[dbo].[NashvilleHousing]
ORDER BY ParcelID


WITH RowNumCTE As (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
				    UniqueID
				    ) row_num

FROM [ProjectPortfolio].[dbo].[NashvilleHousing]
--ORDER BY ParcelID
)
Select *
FROM RowNumCTE
Where row_num > 1
order by PropertyAddress



WITH RowNumCTE As (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
				    UniqueID
				    ) row_num

FROM [ProjectPortfolio].[dbo].[NashvilleHousing]
--ORDER BY ParcelID
)
DELETE
FROM RowNumCTE
Where row_num > 1


-----------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
FROM [ProjectPortfolio].[dbo].[NashvilleHousing]


ALTER TABLE [ProjectPortfolio].[dbo].[NashvilleHousing]
DROP COLUMN OwnerAddress,TaxDistrict, PropertyAddress

ALTER TABLE [ProjectPortfolio].[dbo].[NashvilleHousing]
DROP COLUMN SaleDate