select * from portfolioproject..NashvilleHousing

--Standardize Data format
select SaleDateconverted, CONVERT(date,saledate)  from portfolioproject..NashvilleHousing

update NashvilleHousing
set saledate=  CONVERT(date,saledate)

alter table nashvillehousing
add saledateconverted date

update NashvilleHousing
set saledateconverted= convert(date,saledate)

--populate property Adress data
 
 select a.ParcelID, b.ParcelID, a.PropertyAddress,b.PropertyAddress, isnull(a.propertyaddress,b.PropertyAddress)from portfolioproject..NashvilleHousing a

join  portfolioproject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress = isnull(a.propertyaddress,b.PropertyAddress)
from portfolioproject..NashvilleHousing a 
join  portfolioproject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out address into Individual columns( Adress, city, state)

select propertyaddress from portfolioproject..NashvilleHousing

select parsename(replace(propertyaddress, ',', '.'),2)
,parsename(replace(propertyaddress, ',', '.'),1)

from portfolioproject..NashvilleHousing

alter table nashvillehousing
add propertysplitaddress nvarchar(255)

update NashvilleHousing
set propertysplitaddress= parsename(replace(propertyaddress, ',', '.'),2)


alter table nashvillehousing
add propertysplitcity nvarchar(255)

update NashvilleHousing
set propertysplitcity= parsename(replace(propertyaddress, ',', '.'),1)

select *   from portfolioproject..NashvilleHousing





select * from portfolioproject..NashvilleHousing

select parsename(replace(owneraddress, ',', '.'),3),
parsename(replace(owneraddress, ',', '.'),2),
parsename(replace(owneraddress, ',', '.'),1)

from portfolioproject..NashvilleHousing


alter table nashvillehousing
add ownersplitaddress nvarchar(255)

update NashvilleHousing
set ownersplitaddress= parsename(replace(OwnerAddress, ',', '.'),3)


alter table nashvillehousing
add ownersplitcity nvarchar(255)

update NashvilleHousing
set ownersplitcity= parsename(replace(owneraddress, ',', '.'),2)


alter table nashvillehousing
add ownersplitstate nvarchar(255)

update NashvilleHousing
set ownersplitstate= parsename(replace(owneraddress, ',', '.'),1)

--Change Y and N to yes and No in 'Sold as Vacant' field

select distinct(soldasvacant),count(soldasvacant)
from portfolioproject..NashvilleHousing

group by soldasvacant
order by 2


select soldasvacant,
case when soldasvacant='Y' then 'YES'
     when soldasvacant= 'N' then 'NO'
	 else soldasvacant
	 end
	 from portfolioproject..NashvilleHousing

	 update NashvilleHousing
	 set SoldAsVacant=case when soldasvacant='Y' then 'YES'
     when soldasvacant= 'N' then 'NO'
	 else soldasvacant
	 end

	 --Remove Duplicates
	 with RowNumCTE as (
	 select *, 
	 row_number() over(
	 partition by parcelid,
	              propertyaddress,
				  saleprice,
				  saledate,
				  legalreference
				  order by 
				  uniqueid
				  ) row_num
	 
	 from  portfolioproject..NashvilleHousing
	 --order by ParcelID
	 )
	select *  
	 from RowNumCTE
	 where row_num>1

	 --Delete Unused Columns
	 
	 select * from portfolioproject..NashvilleHousing

	 alter table portfolioproject..NashvilleHousing

	 drop column saledate





