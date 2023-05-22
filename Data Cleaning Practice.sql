--Data cleaning practice

Select *
From
	PortfolioProject.dbo.nashhouse;

-----------------------------------

--Standardize Date Formant

Select
	SaleDateConverted,
	Convert(Date,SaleDate)
From
	PortfolioProject.dbo.nashhouse
--Step 1
ALTER TABLE nashhouse
Add SaleDateConverted Date;
--Step 2
Update nashhouse
SET 
	SaleDateConverted = Convert(Date,SaleDate)


--------------------------------------

--Populate Property Address data

--Step 1 check where null values can be matched
Select *
From
	PortfolioProject.dbo.nashhouse
--WHERE PropertyAddress is null
order by ParcelID

--Step 2 verify and find the address associated with null values
Select 
	a.ParcelID,
	a.PropertyAddress,
	b.ParcelID,
	b.PropertyAddress,
	ISNULL(a.PropertyAddress,b.PropertyAddress)
From
	PortfolioProject.dbo.nashhouse a
	JOIN
	PortfolioProject.dbo.nashhouse b
	ON
	a.ParcelID = b.ParcelID
	AND
	a.[UniqueID ] <> b.[UniqueID ]
WHERE
	a.PropertyAddress is null

--Step 3 replace null values
Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM
	PortfolioProject.dbo.nashhouse a
	JOIN
	PortfolioProject.dbo.nashhouse b
	ON
	a.ParcelID = b.ParcelID
	AND
	a.[UniqueID ] <> b.[UniqueID ]

-----------------------------------

--Breaking out Address into Individual columns (Address, City, State)

Select
	PropertyAddress
From
	PortfolioProject.dbo.nashhouse
--Step 1: separate out address and city using substrings
Select
	Substring(PropertyAddress, 1, Charindex(',',PropertyAddress)-1) as Address,
	Substring(PropertyAddress, Charindex(',', PropertyAddress)+1, Len(PropertyAddress)) as City
FROM
	PortfolioProject.dbo.nashhouse

--Step 2: add to the table
ALTER TABLE nashhouse
Add PropertySplitAddress Nvarchar(255);
--Step 3: fill values
Update nashhouse
SET 
	PropertySplitAddress = Substring(PropertyAddress, 1, Charindex(',',PropertyAddress)-1)
--Step 4 add to the table
ALTER TABLE nashhouse
Add PropertySplitCity Nvarchar(255);
--Step 5: fill values
Update nashhouse
SET 
	PropertySplitCity = Substring(PropertyAddress, Charindex(',', PropertyAddress)+1, Len(PropertyAddress))
--Double check it is properly added
Select*
From
	PortfolioProject.dbo.nashhouse

--Same using parsename function

Select
	Parsename(Replace(OwnerAddress, ',','.'),3),
	Parsename(Replace(OwnerAddress, ',','.'),2),
	Parsename(Replace(OwnerAddress, ',','.'),1)
From PortfolioProject.dbo.nashhouse


ALTER TABLE nashhouse
Add OwnerSplitAddress Nvarchar(255)

Update nashhouse
SET
	OwnerSplitAddress = Parsename(Replace(OwnerAddress, ',','.'),3)


ALTER TABLE nashhouse
Add OwnerSplitCity Nvarchar(255)

Update nashhouse
SET
	OwnerSplitCity = Parsename(Replace(OwnerAddress, ',','.'),2)


ALTER TABLE nashhouse
Add OwnerSplitState Nvarchar(255)

Update nashhouse
SET
	OwnerSplitState = Parsename(Replace(OwnerAddress, ',','.'),1)



------------------------------------------------

--Change Y and N to Yes and No in 'Sold as Vacant field using CASE

--check for values that may have more than 1 form
Select
	Distinct(SoldAsVacant),
	Count(SoldAsVacant)
From
	PortfolioProject.dbo.nashhouse
Group by
	SoldAsVacant
order by
	2


--CASE statement to standarize
Select
	SoldAsVacant,
	CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldASVacant
	END
From
	PortfolioProject.dbo.nashhouse

--Update to complete
Update nashhouse
SET
	SoldAsVacant = 
	CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldASVacant
	END


---------------------------------------------

--Remove Duplicates

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	Partition by 
		ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		ORDER by
			UniqueID
			) row_num
From
	PortfolioProject.dbo.nashhouse
--Order by ParcelID
)
DELETE
From
	RowNumCTE
WHERE
	row_num > 1
--Order by PropertyAddress

