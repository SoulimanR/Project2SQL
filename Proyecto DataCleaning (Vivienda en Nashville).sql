
Select *
From PortfolioProject.dbo.NashvilleHousing

-- Estandarizar formato fecha de la variable SaleDate

Alter Table PortfolioProject.dbo.NashvilleHousing                               -- Cambiar formato de una columna
Alter Column SaleDate Date

-- Añadir valores a los valores nulos de PropertyAddress

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, Isnull(a.PropertyAddress, b.PropertyAddress)    -- Sustituir valores nulos des de otra columna
From PortfolioProject.dbo.NashvilleHousing as a
Inner join PortfolioProject.dbo.NashvilleHousing as b
	On a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set a.PropertyAddress = Isnull(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing as a
Inner join PortfolioProject.dbo.NashvilleHousing as b
	On a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Separar valores de la variable PropertyAddress en 2 valores diferentes(Adress, City) (Manera difícil)

Select PropertyAddress, Substring(PropertyAddress, 1, Charindex(',', PropertyAddress) -1) as Adress, 
Substring(PropertyAddress, Charindex(',', PropertyAddress) +1, Len(PropertyAddress)) as City
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAdress nvarchar(255)

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitAdress = Substring(PropertyAddress, 1, Charindex(',', PropertyAddress) -1)

Alter Table PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity nvarchar(255)

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitCity = Substring(PropertyAddress, Charindex(',', PropertyAddress) +1, Len(PropertyAddress))

Select *
From PortfolioProject.dbo.NashvilleHousing

-- Separar valores de la variable OwnerAddress en 3 valores diferentes(Adress, City, State) (Manera fácil)

Select OwnerAddress, Parsename(Replace(OwnerAddress, ',', '.'), 3) as OwnerSplitAdress
,Parsename(Replace(OwnerAddress, ',', '.'), 2) as OwnerSplitCity
,Parsename(Replace(OwnerAddress, ',', '.'), 1) as OwnerSplitState
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAdress nvarchar(255)

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitAdress = Parsename(Replace(OwnerAddress, ',', '.'), 3)

Alter Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity nvarchar(255)

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitCity = Parsename(Replace(OwnerAddress, ',', '.'), 2)

Alter Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState nvarchar(255)

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitState = Parsename(Replace(OwnerAddress, ',', '.'), 1)

Select *
From PortfolioProject.dbo.NashvilleHousing

-- Cambiar valores Y y N de la variable Sold a Yes o No

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
Case
	When SoldAsVacant = 'Y' then 'Yes'
	When SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
End
From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
Set SoldAsVacant = Case
						When SoldAsVacant = 'Y' then 'Yes'
						When SoldAsVacant = 'N' then 'No'
						Else SoldAsVacant
					End

Select Distinct(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant

-- Eliminar duplicados (Primero hacer comprovación con Select, luego Delete)

With RowNumCTE as (
Select *, Row_number() Over (Partition by ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference
								Order by UniqueID) as row_num

From PortfolioProject.dbo.NashvilleHousing
)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

With RowNumCTE as (
Select *, Row_number() Over (Partition by ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference
								Order by UniqueID) as row_num

From PortfolioProject.dbo.NashvilleHousing
)

Delete
From RowNumCTE
Where row_num > 1

-- Eliminar columnas no utilizadas

Select *
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, PropertyAddress, TaxDistrict



