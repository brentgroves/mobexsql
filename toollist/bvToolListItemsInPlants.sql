SELECT * 
from bvToolListsInPlants tl
where processid in (49995,49716)
where plant = 112;

select * from bvToolBossItemsInPlants

select * from bvToolListItemsInPlants
where processid in (49995,49716)

select distinct tl.originalprocessid,tl.processid,tl.descript,tl.partNumber,tl.plant,
lv1.itemNumber,lv1.itemClass,lv1.UDFGLOBALTOOL,lv1.toolbossStock  
from bvToolListsInPlants tl
inner join
bvToolListItemsLv1 lv1
ON tl.processid = lv1.ProcessID
where lv1.UDFGLOBALTOOL <> 'YES'

			select * 
			from
			btDistinctToolLists tb
			inner join
			[ToolList Master] tm
			on tb.ProcessId=tm.ProcessID
where tb.processid in (49995,49716)

			--///////////////////////////////////////////////////////////////////////////////
-- This view does not take into consideration the [ToolList Toolboss Stock Items]
-- table which lists the item classes to be stocked in the toolbosses. See
-- bvToolBossItemsInPlants to determine items to be stocked in the ToolBosses.
-- This list would be appropriate to list restrictions for the Cribmaster if you
-- grouped the recordset on all fields except plant.
select * from dbo.bvToolListItemsInPlants where processid = 63647
--///////////////////////////////////////////////////////////////////////////////
create view [dbo].[bvToolListItemsInPlants]
as
select distinct tl.originalprocessid,tl.processid,tl.descript,tl.partNumber,tl.plant,
lv1.itemNumber,lv1.itemClass,lv1.UDFGLOBALTOOL,lv1.toolbossStock  
from bvToolListsInPlants tl
inner join
bvToolListItemsLv1 lv1
ON tl.processid = lv1.ProcessID
where lv1.UDFGLOBALTOOL <> 'YES'
--27838
union
	-- 796 select count(*) from bvToolListsInPlants
	select tl.originalprocessid,tl.processid,tl.descript,tl.partNumber,tl.plant
	,ti.itemNumber, ti.itemclass, ti.UDFGLOBALTOOL, 0 as toolbossStock 
	FROM  toolitems ti
	CROSS JOIN
	bvToolListsInPlants tl
	WHERE (ti.UDFGLOBALTOOL = 'YES');

SELECT * 
from bvToolListsInPlants tl
where processid in (49995,49716)

SELECT * 
from bvToolListsInPlants tl
inner join
bvToolListItemsLv1 lv1
ON tl.processid = lv1.ProcessID
where tl.processid = 63647

-- dbo.bvToolListItemsLv1 source

select * from bvToolListItemsLv1
--////////////////////////////////////////////////
-- Each toolid/item could have a different items
-- per part ratio, but the toolbosses dont currently
-- have an opsdescription in the restrictions2 table
-- so we have to choose the toolids items per part ratio
-- for costing purposes.
-- /////////////////////////////////////////////////
create View [dbo].[bvToolListItemsLv1] 
AS
select lv2.*,ti.itemClass,ti.UDFGLOBALTOOL,ti.cost
from
(
	select tl.partNumber,tl.Description as tlDescription, lv1.*
	from
	(
		SELECT tm.OriginalProcessID, tm.processid,CribToolID as itemNumber,
		tt.ToolID, tt.processid as ttpid, tt.toolNumber,tt.OpDescription, 
		ti.itemid,ti.tooltype,ti.tooldescription,
		Quantity,
		AnnualVolume,
		AdjustedVolume,
		QuantityPerCuttingEdge,
		NumberOfCuttingEdges,
		'item' as itemType,partspecific,
		Consumable, 
		case 
			when toolbossStock is null then 0
			when toolbossStock = 0 then 0
			when toolbossStock = 1 then 1
			else 0
		end as toolbossStock,
		case
			when (Quantity=0) or (NumberofCuttingEdges =0) or (QuantityPerCuttingEdge=0) or
			(Quantity is null) or (NumberofCuttingEdges is null) or (QuantityPerCuttingEdge is null)
				then 0
			when (Consumable = 1)
				then 1/((QuantityPerCuttingEdge/cast( ti.quantity as numeric(19,8)))*NumberofCuttingEdges)
			when Consumable = 0 then 0.0
		end itemsPerPart, 
		case 
			when tt.PartSpecific = 0 and ti.Consumable = 1 then (Quantity * (AnnualVolume/12.0)) / cast((QuantityPerCuttingEdge * NumberOfCuttingEdges) as numeric(19,8)) 
			when tt.PartSpecific = 1 and ti.Consumable = 1  then (ti.Quantity * (tt.AdjustedVolume/12)) / cast((QuantityPerCuttingEdge * NumberOfCuttingEdges) as numeric(19,8)) 
			when ti.Consumable = 0 then ti.Quantity
		end MonthlyUsage,  
		case 
			when tt.PartSpecific = 0 and ti.Consumable = 1 then (ti.Quantity * (tm.AnnualVolume/365.0)) / cast((QuantityPerCuttingEdge * NumberOfCuttingEdges) as numeric(19,8)) 
			when tt.PartSpecific = 1 and ti.Consumable = 1  then (ti.Quantity * (tt.AdjustedVolume/365)) / cast((QuantityPerCuttingEdge * NumberOfCuttingEdges) as numeric(19,8))
			when ti.Consumable = 0 then ti.Quantity/30
		end DailyUsage  
		-- select ti.*
		FROM [TOOLLIST ITEM] as ti 
		-- when a tool gets deleted the toollist item remains?
		inner join [TOOLLIST TOOL] as tt on ti.toolid=tt.toolid
		INNER JOIN 
		(
			-- these are the toollist which are added to the toolbosses
			select tm.* 
			from
			btDistinctToolLists tb
			inner join
			[ToolList Master] tm
			on tb.ProcessId=tm.ProcessID
			--731
		) as tm 
		ON tt.PROCESSID = tm.PROCESSID 
		--30432
	union
		SELECT tm.originalprocessid, tm.processid,CribToolID as itemNumber, 
		0 as ToolID, 0 as ttpid, 0 as toolNumber,'Fixture' as OpDescription, 
		tf.itemid,tf.tooltype,tf.tooldescription,  
		Quantity,AnnualVolume,0 as AdjustedVolume,0 as QuantityPerCuttingEdge,0 as NumberOfCuttingEdges,
		'fixture' as itemType,0 as partspecific, 0 as Consumable, 
		case 
			when toolbossStock is null then 0
			when toolbossStock = 0 then 0
			when toolbossStock = 1 then 1
			else 0
		end as toolbossStock,
		cast(0.0 as numeric(19,8)) itemsPerPart, 
		0 as MonthlyUsage, 0 as DailyUsage
		FROM [TOOLLIST Fixture] as tf 
		INNER JOIN 
		(
			-- these are the toollist which are added to the toolbosses
			select tm.* 
			from
			btDistinctToolLists tb
			inner join
			[ToolList Master] tm
			on tb.ProcessId=tm.ProcessID
			--731
		) as tm 
		ON tf.PROCESSID = tm.PROCESSID 
		--1648
	union
		SELECT tm.OriginalProcessID, tm.processid,CribToolID as itemNumber, 
		0 as ToolID, 0 as ttpid, 0 as toolNumber,'Misc' as OpDescription, 
		m.itemid,m.tooltype,m.tooldescription,  
		Quantity,AnnualVolume,0 as AdjustedVolume,QuantityPerCuttingEdge,NumberOfCuttingEdges,
		'misc' as itemType, 0 as partspecific,m.Consumable, 
		case 
			when toolbossStock is null then 0
			when toolbossStock = 0 then 0
			when toolbossStock = 1 then 1
			else 0
		end as toolbossStock,
		case
			when (Quantity=0) or (NumberofCuttingEdges =0) or (QuantityPerCuttingEdge=0) or
			(Quantity is null) or (NumberofCuttingEdges is null) or (QuantityPerCuttingEdge is null)
				then 0
			when (Consumable = 1)
				then 1/((QuantityPerCuttingEdge/cast( quantity as numeric(19,8)))*NumberofCuttingEdges)
			when Consumable = 0 then 0.0
		end itemsPerPart, 
		case 
			when m.Consumable = 1 then (m.Quantity * (tm.AnnualVolume/12.0)) / cast((QuantityPerCuttingEdge * NumberOfCuttingEdges) as numeric(19,8))
			else m.Quantity
		end MonthlyUsage,  
		case 
			when m.Consumable = 1 then (m.Quantity * (tm.AnnualVolume/365.0)) / cast((QuantityPerCuttingEdge * NumberOfCuttingEdges) as numeric(19,8)) 
			else m.Quantity/30
		end DailyUsage  
		FROM [ToolList Misc] as m 
		INNER JOIN 
		(
			-- these are the toollist which are added to the toolbosses
			select tm.* 
			from
			btDistinctToolLists tb
			inner join
			[ToolList Master] tm
			on tb.ProcessId=tm.ProcessID
			--731
		)  
		as tm 
		ON m.PROCESSID = tm.PROCESSID 
		--371
	--32571
	)lv1
	inner join 
	btDistinctToolLists tl
	on lv1.ProcessID=tl.processid
	--32571
)lv2
-- drop items that are not in the crib
inner join
toolitems ti
on lv2.itemNumber=ti.itemnumber
--32438;
select * from toolitems010921 
-- truncate table toolitems
SELECT itemnumber, description1, itemclass, UDFGLOBALTOOL, cost
FROM [Busche ToolList].dbo.toolitems;

-- [Busche ToolList].dbo.toolitems definition

-- Drop table

-- DROP TABLE [Busche ToolList].dbo.toolitems GO

CREATE TABLE [Busche ToolList].dbo.toolitems (
	itemnumber varchar(12) NOT NULL,
	description1 varchar(50) NULL,
	itemclass varchar(15) NOT NULL,
	UDFGLOBALTOOL varchar(20) NOT NULL,
	cost numeric(19,4) NOT NULL
) GO;

