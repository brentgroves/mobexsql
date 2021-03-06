-- Determine what item locations are not in the Crib 
select top 10 item,CribBin
FROM
STATION st
for xml path
for xml raw
for xml auto


-- Used for Plex Location List Upload screen
select 
Location,Building_Code,Location_Type,Note,Location_Group
--count(*)
from
(
	select Row#,Location,Building_Code,Location_Type,Note,Location_Group
	from
	(
		select 
		ROW_NUMBER() over(order by CribBin asc) as row#,
		CribBin  as location,
		'BPG Central Stores' as building_code,
		'Supply Crib' as location_type,
		'' as note,
		'MRO Crib' as location_group
		from station
		where 
		item in (
	'16705R','16707R'
		)
		--and CribBin in ('12-AA3B03','12-AA3A03','12-AA1C02')
	)lv1
--	where row# > 500 -- and row# <= 1000
--	order by location
)lv2

-- Used for Plex Supply Item Locations upload screen
select DISTINCT SUBSTRING(CribBin,1,3) site from STATION
select 
item as item_no,
CribBin as location,
BinQuantity as quantity,
'N' as Building_Default,
'' Transaction_Type
from station
where item in
(
	'16705R','16707R'
)
--and CribBin not in ('01-N202A02','01-R03B03','01-C212A04')


-- Remove previous days backup of station and PlxSupplyItemLocation tables
-- drop table PlxSupplyItemLocation0524
-- drop table  station0524
-- Make backup of station quantities table before changing it in Cribmaster. 
select * 
into station0729
from STATION
--12653
--12624
--verify backup of station
select count(*) from station0729
--12653
-- Upload the item_location table into PlxSupplyItemLocation table.
CREATE TABLE Cribmaster.dbo.PlxSupplyItemLocation0729 (
	item_no varchar(50),
	location varchar(50),
	quantity integer
)
--update purchasing.dbo.item set Description=Brief_Description + ', ' + Description where Brief_Description <> Description
-- Verify table was created and has zero records
select count(*) from PlxSupplyItemLocation0729  --
-- truncate table PlxSupplyItemLocation0726
-- Insert Plex item_location data into CM
Bulk insert PlxSupplyItemLocation0729
from 'c:\il0729GE12500.csv'
with
(
	fieldterminator = ',',
	rowterminator = '\n'
)

select
	count(*)
--top 100 * 
from PlxSupplyItemLocation0729 --0
select itemNumber from INVENTRY where itemnumber like 'BE%'
/*
 * Set Cribmaster station with item numbers in this set to 0
 * Station0628 contains a backup of this table prior to
 * performing this change.
 */	


select 
--il.item_no,il.location,il.quantity
--into nic0726
count(*) --236	
--il.item_no,inv.ItemClass,inv.Description1,il.location,il.quantity as PlexQuantity,st.BinQuantity as CribMasterQty,st.Quantity as CMQuantity
from (
	select --distinct incase I inserted items more than once
		distinct item_no,location,quantity
	from PlxSupplyItemLocation0726 
	--from PlxSupplyItemLocation0628 
	--from PlxSupplyItemLocation0418 
) il
left outer join STATION st 
on il.location=st.CribBin
and il.item_no=st.Item
--0726 13193 --0628 13206
left outer join INVENTRY inv
on il.item_no=inv.ItemNumber
where st.CribBin is null  
--0726/2563  --0628/1921
and il.quantity = 0 

/*
 * All these 644 locations have a quantity of 0 and a 01-002A01 default location
 * 
 */
select
n7.location
--count(*) cnt
--n7.* 
from nic0726 n7
left outer JOIN
nic0628 n6
on n7.item_no =n6.item_no
and n7.location=n6.location
where n6.item_no is null --644
and n7.quantity <> 0 --0

select 
count(*)
from PlxSupplyItemLocation0628 il
--from PlxSupplyItemLocation0726 il
where location = '01-002A01'
--0726/2542 --0628/1900
--642 more in july 

/*
 * If these item are in station in CM these station should be made to have 0 quantity.
 * If make the station quantity 0 in this step and there happens to be another location
 * for the same item number in plex the next step should increase the quantity if it has 
 * the same quantity in CM but that probably wont happen.
 */
--select top 10 * from STATION0726
--update STATION 
set BinQuantity = 0,
Quantity = 0
where item in
(
	select
	item
	--count(*)cnt
	--st.*
	--inv.ItemNumber,st.CribBin,inv.Description1
	--inv.InactiveItem,inv.AltVendorNo
	from station st
	inner join INVENTRY inv --12653
	on st.Item=inv.ItemNumber --12650
	where st.Item in
	(
		select 
		--count(*) cnt
		item_no
		--item_no,quantity
		--from PlxSupplyItemLocation0628 il
		from PlxSupplyItemLocation0726 il
		where location = '01-002A01' --2542
		and quantity = 0  --2534
	)
	and st.Quantity <> 0  --0628/336 --0726/957
)

and inv.InactiveItem =0 --all but 6 are inactive

/*
 * If I make all these quantities in CM 0 how much cost difference will there be?
 */

select count(*) from station0726 --12653

--Join these 2 tables on item number and location.
--Set the station table???s quantity equal to PlxItemLocation.quantity value. 
--update station
--update STATION 
set BinQuantity = il.quantity,
Quantity = il.quantity
select 
--il.item_no,il.location,il.quantity
count(*) --0726/903 --1013  06/28  --
--il.item_no,inv.ItemClass,inv.Description1,il.location,il.quantity as PlexQuantity,st.BinQuantity as CribMasterQty,st.Quantity as CMQuantity
from (
	select --distinct incase I inserted items more than once
		distinct item_no,location,quantity
	--from PlxSupplyItemLocation0628 
	from PlxSupplyItemLocation0726 
--	from PlxSupplyItemLocation0418 
) il
inner join STATION st 
on il.location=st.CribBin   
and il.item_no=st.Item --0726/10630 --0628/11285  --number of default locations have increased in plex by 644 from jun to jul
inner join INVENTRY inv
on il.item_no=inv.ItemNumber
where
--il.quantity < st.BinQuantity
il.quantity <> st.BinQuantity	--0726/903 --1013 06/28
and inv.InactiveItem = 0  


select 
--count(*) --236	
il.item_no,inv.ItemClass,inv.Description1,il.location,il.quantity as PlexQuantity,st.BinQuantity as CribMasterQty,st.Quantity as CMQuantity
from (
	select --distinct incase I inserted items more than once
		distinct item_no,location,quantity
	from PlxSupplyItemLocation0628 
) il
inner join STATION st --12614
on il.location=st.CribBin
and il.item_no=st.Item
inner join INVENTRY inv
on il.item_no=inv.ItemNumber
--12608
--where il.quantity < st.BinQuantity	
--and inv.InactiveItem = 0  
--530
where il.quantity <> st.BinQuantity	
and inv.InactiveItem = 0  


select itemnumber
from INVENTRY inv
inner join
(
select 
il.item_no,il.location,il.quantity

--count(*) --236	
--il.item_no,inv.ItemClass,inv.Description1,il.location,il.quantity as PlexQuantity,st.BinQuantity as CribMasterQty,st.Quantity as CMQuantity
from (
	select --distinct incase I inserted items more than once
		distinct item_no,location,quantity
--	from PlxSupplyItemLocation0418 
	from PlxSupplyItemLocation0628 
) il
left outer join STATION st --12614 / 11284
on il.location=st.CribBin
and il.item_no=st.Item
left outer join INVENTRY inv
on il.item_no=inv.ItemNumber
where st.CribBin is null  --1922
and il.quantity <> 0 --17
)il
on inv.ItemNumber=il.item_no


--Update the items Nancy told me to
--16520,006944,14396,009259
select *
--from station st
from PlxSupplyItemLocation0422 il 
where item_no in
('16520','006944','14396','009259')
--update station
set BinQuantity = 9,
Quantity = 9 
from station st
where item = '009259'
--How many of these 


--Why is there 86 more item locations in Plex than Cribmaster
--Are there any item locations in cribmaster that are not in plex?
select 
--count(*)
st.item,st.cribbin,st.BinQuantity,
inv.InactiveItem
from STATION st --12614
left outer join INVENTRY inv
on st.item=inv.ItemNumber
left outer join PlxSupplyItemLocation0416 il
on st.CribBin=il.location
and il.item_no=st.Item
where il.location is null
order by st.item
--17


-- Are there any item locations in Plex that are not in Cribmaster? YES 96
select 
count(*)
--il.*
from PlxSupplyItemLocation0416 il 
left outer join STATION st --12614
on il.location=st.CribBin
and il.item_no=st.Item
where st.CribBin is null

-- What quantities have changed in plex since the import from CM 
select 
--count(*) --236	
inv.InactiveItem,il.item_no,inv.ItemClass,inv.Description1,il.location,il.quantity as PlexQuantity,st.BinQuantity as CribMasterQty,st.Quantity as CMQuantity
from PlxSupplyItemLocation0411 il 
inner join STATION st --12614
on il.location=st.CribBin
and il.item_no=st.Item
inner join INVENTRY inv
on il.item_no=inv.ItemNumber
--12597
where il.quantity <> st.BinQuantity	
and inv.InactiveItem = 1
--233
select *
from 
STATION where item = '005825R'


--Plex screen location list
--Location,Building Code,Location Type,Note,Location Group


--Are there any Plex locations which are not in the Cribmaster
-- No There are no locations 'Supply Crib','MRO Crib','BPG Central Stores'
-- that are not supposed to be there
select count(*)
from btPlexLocation pl
left outer join station st
on pl.location=st.CribBin
where st.CribBin is NULL
--11734

--Are all the Crib locations in Plex
select
count(*)
--st.item,st.CribBin,pl.location 
from station st
left outer join btPlexLocation pl
on st.CribBin=pl.location
where crib=11 and pl.location is not NULL



-- Uploaded 12000 Locations with Quantities on 04-11 and
-- this table is a snapshot of this upload
CREATE TABLE Cribmaster.dbo.PlxSupplyItemLocation0411 (
	item_no varchar(50),
	location varchar(50),
	qty integer,
	Building_Default varchar(5),
	Transaction_Type varchar(50)
)
-- truncate table PlxSupplyItemLocation0411
Bulk insert PlxSupplyItemLocation0411
from 'c:\il0411LE13000.csv'
with
(
	fieldterminator = ',',
	rowterminator = '\n'
)
select 
--*
--count(*)
count(distinct location)
from PlxSupplyItemLocation0411
--3967
--4964
--5960
-- Determine items in Cribmaster that have changed since this upload
SELECT
--count(*)
--st.cribbin,sil.location
sil.item_no,sil.location,sil.qty as plexQty,st.BinQuantity as cribmasterQty
from PlxSupplyItemLocation0411 sil
left outer join STATION st
on st.cribbin = sil.location
--where st.CribBin = sil.location
where st.BinQuantity<>sil.qty

-- Used to Supply Item Location upload
--truncate TABLE Cribmaster.dbo.PlxSupplyItemLocation
CREATE TABLE Cribmaster.dbo.PlxSupplyItemLocation (
	item_no varchar(50),
	location varchar(50),
	qty integer,
	Building_Default varchar(5),
	Transaction_Type varchar(50)
)


select * from PlxSupplyItemLocation
-- Store purchasing.item_location. 
-- Failed item location upload because item not in plex.
-- Linux note don't use double quote and change file format
-- to dos in vim https://vim.fandom.com/wiki/File_format
Bulk insert PlxSupplyItemLocation
from 'c:\noitem.csv'
with
(
	fieldterminator = ',',
	rowterminator = '\n'
)


-- Import all locations in plex
select * from btPlexLocation --11734
where location like 'n++%'
update btPlexLocation
set location = '01-I03D01'
where location = 'n++01-I03D01'

Bulk insert btPlexLocation
from 'c:\PlexLocationGE7000.csv'
with
(
fieldterminator = ',',
rowterminator = '\n'
)

select distinct cribbin from STATION order by cribbin where cribbin like '09%'


--This table contain

-- DROP TABLE [Busche ToolList].dbo.ToolBoss GO

CREATE TABLE [Busche ToolList].dbo.PlxNotInPlex (
	Part_No varchar (100)
) 

select * from PlxPartNumber
Bulk insert PlxPartNumber
from 'c:\PlexPartNumbers.csv'
with
(
fieldterminator = ',',
rowterminator = '\n'
)


--Plex screen location list
--Location,Building Code,Location Type,Note,Location Group
select 
Location,Building_Code,Location_Type,Note,Location_Group
--count(*)
from
(
	select Row#,Location,Building_Code,Location_Type,Note,Location_Group
	from
	(
		select 
		ROW_NUMBER() over(order by CribBin asc) as row#,
		CribBin  as location,
		'BPG Central Stores' as building_code,
		'Supply Crib' as location_type,
		'' as note,
		'MRO Crib' as location_group
		from station
		where 
		item in (
		'16947'
		)
		--or crib = 11
		--or crib = 12
	)lv1
	where row# > 500 -- and row# <= 1000
--	order by location
)lv2


