/*

Cleaning Data with SQL Queries

*/

SELECT *
FROM NashvilleHousing..NashvilleHousing

-- Standardize Data Format

SELECT SaleDate
FROM NashvilleHousing..NashvilleHousing


-- Populate property address data

SELECT *
FROM NashvilleHousing..NashvilleHousing
WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
	ISNULL(a.propertyaddress, b.PropertyAddress)
FROM NashvilleHousing..NashvilleHousing a
JOIN NashvilleHousing..NashvilleHousing b
	ON a.UniqueID <> b.UniqueID
	AND a.ParcelID = b.ParcelID
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.propertyaddress, b.PropertyAddress)
FROM NashvilleHousing..NashvilleHousing a
JOIN NashvilleHousing..NashvilleHousing b
	ON a.UniqueID <> b.UniqueID
	AND a.ParcelID = b.ParcelID
WHERE a.PropertyAddress IS NULL

-- Breaking out address into individual columns (Address, City, State)

SELECT PropertyAddress
FROM NashvilleHousing..NashvilleHousing

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS Address
FROM NashvilleHousing..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashvilleHousing..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing..NashvilleHousing
GROUP BY SoldAsVacant


ALTER TABLE NashvilleHousing
ALTER COLUMN SoldAsVacant varchar(255)

UPDATE NashvilleHousing
SET SoldAsVacant = CONVERT(varchar(255), SoldAsVacant)
FROM NashvilleHousing..NashvilleHousing
--GROUP BY SoldAsVacant

--WITH soldasv AS
--(SELECT CASE 
--	WHEN [SoldAsVacant] = 0 THEN 'No'
--	WHEN [SoldAsVacant] = 1 THEN 'Yes'
--	ELSE [SoldAsVacant]
--	END AS convertedSoldAsVacant
--FROM NashvilleHousing..NashvilleHousing
--)

--SELECT DISTINCT(convertedSoldAsVacant), COUNT(convertedSoldAsVacant)
--FROM NashvilleHousing..NashvilleHousing
--GROUP BY convertedSoldAsVacant

ALTER TABLE NashvilleHousing
ADD ConvertedSoldAsVacant varchar(255)

UPDATE NashvilleHousing
SET SoldAsVacant = CASE 
	WHEN SoldAsVacant = 0 THEN 'No'
	WHEN SoldAsVacant = 1 THEN 'Yes'
	ELSE SoldAsVacant
	END
FROM NashvilleHousing..NashvilleHousing


-- Remove Duplicates

WITH ROWNUMCTE AS
(SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, 
				PropertyAddress, 
				SalePrice, 
				SaleDate, 
				LegalReference
				ORDER BY UniqueID
				) row_num
FROM NashvilleHousing..NashvilleHousing
)

SELECT *
FROM ROWNUMCTE
WHERE row_num > 1
ORDER BY UniqueID

-- Delete unused columns

SELECT *
FROM NashvilleHousing..NashvilleHousing

ALTER TABLE NashvilleHousing..NashvilleHousing
DROP COLUMN OwnerAddress, SaleDate, PropertyAddress, TaxDistrict, ConvertedSoldAsVacant

