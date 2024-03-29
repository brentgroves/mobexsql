/*
 * Find part info to use to update TL_Plex_PN_Op_Map_Plant8
 */
select * from [ToolList PartNumbers] m where PartNumbers like '%CBO1410373%'
--where PartNumbers like '%5221%'  --52215T6N 
where processid = 40129 --41202 
select * from [ToolList Plant] m where processid = 62372 41202 41207 54071 -- 50868  
from bvToolListsInPlants tl
where partnumber like '%0924%'
where plant = 8
--and tl.Originalprocessid = 40750
and partnumber like '%0924%'
-- 51210T6N
select * from [ToolList Master] m where PartFamily like '%52210%' and released = 1
select * from [ToolList Master] m where PartFamily like '%51211%' and released = 1
select * from [ToolList Master] m where PartFamily like '%52211%' and released = 1
select * from [ToolList Master] m where PartFamily like '%52216%' and released = 1
select * from [ToolList Master] m where PartFamily like '%51216%' and released = 1


select * from [ToolList Master] m where PartFamily like '%Knuckle%' and released = 1
-- select OriginalProcessID origpid,* from [ToolList Master] m where m.ProcessID = 63813--50868--(chrysler 60 mill complete)  -- -- not released
select OriginalProcessID origpid,* 
from [ToolList Master] m where m.ProcessID = 62610 40129 62372 40129 41202 41207 40173-- 41207  --, 40137 --(chrysler 60 mill complete)  -- -- released

-- run in Plex SDE
select * from part_v_part where part_no like '%0924%'
/*
 * Create Tool List Plex Mapping
 */
select * from TL_Plex_PN_Op_Map_Plant8 
-- drop table TL_Plex_PN_Op_Map_Plant8 
-- truncate table TL_Plex_PN_Op_Map_Plant8 
CREATE TABLE [Busche ToolList].dbo.TL_Plex_PN_Op_Map_Plant8 (
	OriginalProcessID int NULL,
	ProcessID int NULL,
	TL_Part_No nvarchar(50) NULL,
	Plex_Part_key int null,
	Plex_Part_Operation_key int not null,
	Plex_Part_No varchar(100) NOT NULL,
	Revision varchar(8) NOT NULL,
	Operation_Code varchar(30) NOT NULL
);
select * from TL_Plex_PN_Op_Map_Plant8 
insert into TL_Plex_PN_Op_Map_Plant8 
values
(83,62610,'CBO1410373',2795323,7872696,'CBO1410373','D1','Final')
(49503,54522,'HXE66422 PAINT',2795364,7873079,'HXE66422','G','Final' )  -- 2795364	7873079	Drive Support - HXE66422	HXE66422 G	110

--(61875,62372,'R568616',2812907,7950317,'R568616','J','Machine A - WIP')  -- 2812907	Support Front Control - OP 10 Vertical R568616	R568616	Support Front Control

--(61876,63710,'R568616',2812907,7950328,'R568616','J','Final') -- 2812907	Support Front Control - OP 20 Horizontal R568616	R568616	Support Front Control

-- (39685,41202,'51211-T6N-A010-M1',2802824,7886723,'51210T6N A000','00-','Machine A - WIP') 	-- 51210T6N A000	RH NSX Front Knuckle, OP 10 Vertical Mill HAAS
(39686,40129,'51211-T6N-A010-M1',2802824,7884545,'51210T6N A000','00-','Final') 	-- 51210T6N A000	RH NSX Front Knuckle, OP 20 Horizontal Mill - Mazak variaxis
--(40127,41207,'52216-T6N-A030-M1',2802825,7888473,'52215T6N A020','20-','Machine A - WIP') -- 40127|    41207|52216-T6N-A030-M1 LH REAR KNUCKLE|             10|VERTICAL - HAAS 
--(40173,40173,'52216-T6N-A030-M1',2802825,7884560,'52215T6N A020','20-','Final') -- 40173|52216-T6N-A030-M1 LH REAR KNUCKLE| 20|MAZAK VARIAXIS // Plex 2802825	7884560	LH NSX Rear Knuckle - 52215T6N A020	52215T6N A020	20-	130      
-- 40174|51216-T6N-A010-M1 LH FRONT KNUCKLE 20|MAZAK VARIAXIS operation 20
--(40127,41207)  -- 2802825	7888473	52215T6N A020	52215T6N A020	20-	LH NSX Rear Knuckle	7888473	100  -- for operation 10 vertical haas tool list
(41207,52216,'52216-T6N-A030-M1',2802825,) -- 2802825	7884560	LH NSX Rear Knuckle - 52215T6N A020	52215T6N A020	20-	for operation 20 tool list,
(23246,54071,'R344400',2795342,7872989,'R344400','C','Final') -- 2795342	7872989	Axle Housing - R344400	R344400	C	120
(48625,48625,'R556656',2795339,7872976,'R556656','B','Final') -- 2795339	7872976	Support 6R - R556656	R556656	B	120
(49503,54522,'HXE66422 PAINT',2795364,7873079,'HXE66422','G','Final' )  -- 2795364	7873079	Drive Support - HXE66422	HXE66422 G	110
(50868,50868,'68400221AA',2811382,7927601,'68400221AA','08','Final') -- 2811382	7927601	Winch Bracket - 68400221AA	68400221AA	120
(54351,54351,'10037207',2796140,7873103,'10037207','C','Final')  -- 2796140	7873103	Navistar Vista Knuckle LH - 10037207	10037207	130
(50265,54339,'10037203',2796137,7873096,'10037203','C','Final')  -- 2796137	7873096	Navistar Vista Knuckle RH - 10037203	10037203	130
-- (14218,'26088054','26088054','07B','Final') -- 14218|    14218 NEXTEER |26088054 ALUMINUM ASSEMBLY  -- No tool boss items
-- 'Operation 100 is not a Production Process operation so this tool list won't be visible from the workcenter's tooling button' 
--(61875,62372,'R568616',2812907,7950317,'R568616','J','Machine A - WIP')  -- 2812907	Support Front Control - OP 10 Vertical R568616	R568616	Support Front Control
(40800,61623,'H2GC-5K652-AB',2684943,7466413,'H2GC 5K652 AB','','Machine A - WIP')  -- done 07-06
(40750,61622,'H2GC-5K651-AB',2684942,7466404,'H2GC 5K651 AB','','Machine A - WIP') -- done 07-06
(49265,63811,'51394-TJB-A040-M1',2960020,8568187,'51394TJB A040M1','40-M1-','Final')  --2960020	51394TJB A040M1	RDX Left Hand
(49396,63810,'51393-TJB-A040-M1',2960018,8568181,'51393TJB A040M1-','40-M1-','Final') -- 63810|51393-TJB-A040-M1|RDX Right Hand


(741,63747,'001-0518-74',3024948,'001-0924-03','01','Machine A - WIP') -- 3024948	3D Honed - 001-0924-03 Horz	001-0924-03	3D Honed
/* These tool lists should contain the same tooling */
63740|001-0518-12
63741|001-0518-13
63742|001-0518-14
63743|001-0518-15
63744|001-0518-71
63745|001-0518-72
63746|001-0518-73
63747|001-0518-74  -- picked this one to represent all of the 3D Tool lists

-- (61875,62372,'R568616',2812907,'R568616','J','Machine A - WIP') -- 2812907	Support Front Control - R568616	R568616	Support Front Control

-- (63810,'51393-TJB-A040-M1','51393TJB A040M1-','40-M1-','Final') -- 63810|51393-TJB-A040-M1|RDX Right Hand
-- (14218,'26088054','26088054','07B','Final') -- 14218|    14218 NEXTEER |26088054 ALUMINUM ASSEMBLY  -- No tool boss items
-- 61623,'H2GC-5K652-AB','H2GC 5K652 AB','','Machine A - WIP')  -- done 07-06

-- The following tool list has already been added to plex.
-- (61748,'10103355','10103355','A','Machine A - WIP')  -- 10103355H DANA P558 6K LH Horizontal  Done
-- (54479,'10103355','10103355','A','Final')  -- 10103355H DANA P558 6K LH - Vertical - Done, 02/10/21
-- (54536,'10103344','10103344','A','Final')  -- DANA - 10103344 P558 7K RH KNUCKLE - 2ND OP VERTICAL MILL
-- (62576,'10103344','10103344','A','Machine A - WIP')  -- 62576|DANA    |10103344H P558 7K RH KNUCKLE|10103344H |1ST OP HORIZONTAL MILL|
-- (61747,'10103353','10103353','A','Machine A - WIP')  -- 61747|DANA    |10103353H P558 6K RH    |10103353  |MILL COMPLETE  
-- (54480,'10103353','10103353','A','Final')  -- 54480|DANA    |10103353 DANA 6K RH VERT|10103353  |MILL COMPLETE   
-- (54480,'10103351','10103351','A','Final')  -- 28080|    5453U3|DANA    |10103351 P558 7K LH KNUCKLE |10103351  |2ND OP VERTICAL MILL  
-- which tool list, i asked Jason, and he wants the latest imported, which would be 61763
-- (54529,'10103351H','10103344','A','Machine A - WIP')  -- 62576|DANA    |10103344H P558 7K RH KNUCKLE|10103344H |1ST OP HORIZONTAL MILL|
-- (61763,'10103351H','10103344','A','Machine A - WIP')  -- 62576|DANA    |10103344H P558 7K RH KNUCKLE|10103344H |1ST OP HORIZONTAL MILL|
-- (50531,'2007669','2007669','C','Machine A - WIP')  -- 734|    50531|USM     |2007669 7K KING PIN YOKE|2007669   |1ST OP MILL
--(50532,'2007669','2007669','C','Machine Complete')  -- 188|    50532|USM     |2007669 7K KING PIN YOKE|2007669   |2ND OP MILL         
select 

select * from TL_Plex_PN_Op_Map_Plant8

/* Section to find processid and part number
select 
tl.originalProcessid,
tl.processid,
tl.customer,tl.partfamily,
tl.partNumber,tl.OperationDescription,
'PlexPartNumber' PlexPartNumber,
'PlexRevision' PlexRevision,
'PlexOperationCode' PlexOperationCode,
tl.plant 
-- select *
from bvToolListsInPlants tl
where plant = 8
--and tl.Originalprocessid = 40750
and partnumber like '%26088054%'
order by tl.customer,tl.partfamily,tl.partNumber 
-- R559432,R218919
select Originalprocessid,* from [ToolList Master] tm where processid in (54529,
61763)
select originalprocessid,* from [ToolList Master] 
-- where partFamily like '%R559432%'
where partFamily like '%R218919%'

select top 10 * from btDistinctToolLists

select * from bvToolListsAssignedPN

select * from PlexToolListAssemblyTemplatePlant8
*/
-- drop table PlexToolListAssemblyTemplatePlant8
-- truncate table PlexToolListAssemblyTemplatePlant8
create table PlexToolListAssemblyTemplatePlant8
(
	ProcessID int NOT NULL,
	ToolID int NOT NULL,
	ToolNumber int NOT NULL,
	Assembly_No	varchar (50), --Assembly No,
	Tool_Assembly_Type	varchar (50), --Tool Assembly Type,
	Description	varchar (100), --Description,
	Part_No	varchar (100), --Part No,
	Part_Revision varchar (8), --Part Revision,
	Operation	varchar (30), --Operation_Code in Plex,
	Tool_Assembly_Status	varchar (50),  --Tool Assembly Status
	Include_In_Analysis smallint,  --Include in Analysis
	Analysis_Note	varchar (500), --Analysis Note,
	Note	varchar (500), -- Note,
	Location varchar (5) --	I don't know what this is 
)

insert into PlexToolListAssemblyTemplatePlant8 (ProcessID,ToolID,ToolNumber,Assembly_No,Tool_Assembly_Type,Description,Part_No,Part_Revision,Operation,Tool_Assembly_Status,Include_In_Analysis,Analysis_Note,Note,Location)
	select 
	tl.ProcessID,
	tl.ToolID,
	tl.ToolNumber,
	case 
	when ((tl.CellIndex <> 0) and (tl.ToolCount>1)) then substring(tl.Assembly_No + '-' + tl.Cell + '-' + tl.OperationDescription,1,50)
--	else substring(tl.Assembly_No + '-' + tl.OperationDescription,1,50) 
	else substring(tl.Assembly_No + '-' + tl.Operation_Code,1,50)
	end Assembly_No,
	tl.Tool_Assembly_Type,
	tl.Description,tl.Part_No,tl.Part_Revision,tl.Operation,tl.Tool_Assembly_Status,tl.Include_In_Analysis,tl.Analysis_Note,tl.Note,tl.Location 
	from 
	(
		select
		tl.processid, 
		tt.ToolID,
		tt.ToolNumber,
		tc.ToolCount,
		case 
			when (tt.ToolNumber < 10) then 'T0' + cast(tt.ToolNumber as varchar(3)) 
			when (tt.ToolNumber >= 10) then 'T' + cast(tt.ToolNumber as varchar(3))
		end Assembly_No,
		m.Operation_Code,
		tl.OperationDescription,
		'Machining' Tool_Assembly_Type,
		tt.OpDescription Description,
		-- tl.PartNumber,
		CHARINDEX('CELL', tt.OpDescription) CellIndex,
		substring(tt.OpDescription,CHARINDEX('CELL', tt.OpDescription),6) Cell,

		m.Plex_Part_No Part_No,
		m.Revision Part_Revision,
		m.Operation_Code Operation,
		'Active' Tool_Assembly_Status,
		1 Include_In_Analysis,
		'' Analysis_Note,
		'' Note,
		'' Location
		-- select tl.*
		from bvToolListsInPlants tl
		inner join [ToolList Tool] tt  
		on tl.processid = tt.ProcessID
		inner join TL_Plex_PN_Op_Map_Plant8 m 
		on tl.processid = m.processid  
		-- order by tt.toolnumber
		left outer join 
		(
			select tl.processid,tt.ToolNumber, count(*) toolCount
			from bvToolListsInPlants tl
			inner join [ToolList Tool] tt  
			on tl.processid = tt.ProcessID
			inner join TL_Plex_PN_Op_Map_Plant8 m 
			on tl.processid = m.processid  
			group by tl.processid,tt.ToolNumber 
			having count(*) > 1	-- 0	
		) tc 
		on tl.processid = tc.processid 
		and tt.toolNumber = tc.ToolNumber
		-- ONLY FOR TOOLLISTS THAT ARE IN MULTIPLE PLANTS
		--where tl.Plant =8
	)tl  
	order by Assembly_No
	-- 15 rows 1 through 21 / 90 items
	-- where tl.Part_No = '28245973' 

	select count(*) from PlexToolListAssemblyTemplatePlant8 -- 1
	select * from PlexToolListAssemblyTemplatePlant8 -- 1
	/*
 * For each ToolList create a TF Assembly.
 */
insert into PlexToolListAssemblyTemplatePlant8 
(ProcessID,ToolID,ToolNumber,Assembly_No,Tool_Assembly_Type,Description,Part_No,Part_Revision,Operation,Tool_Assembly_Status,Include_In_Analysis,Analysis_Note,Note,Location)
select 
/*
m.Plex_Part_No,
m.revision,
m.Operation_Code,
'TF-' + tl.OperationDescription Assembly_No1,
m.Plex_Part_No,
*/
tl.processid,
111111 ToolID,
111111 ToolNumber,
'TF-' + m.Operation_Code Assembly_No,
--'TF-' + tl.OperationDescription Assembly_No,
'Machining' Tool_Assembly_Type,
'Fixture' Description,
m.Plex_Part_No Part_No,
m.Revision Part_Revision,
m.Operation_Code Operation,
'Active' Tool_Assembly_Status,
1 Include_In_Analysis,
'' Analysis_Note,
'' Note,
'' Location
-- m.Plex_Part_No Part_No,m.Revision Part_Revision,m.Operation_Code Operation,tl.OperationDescription 
from bvToolListsInPlants tl
inner join TL_Plex_PN_Op_Map_Plant8 m  
on tl.processid = m.processid  -- 27
-- ONLY FOR TOOLLISTS THAT ARE IN MULTIPLE PLANTS
where tl.Plant = 8

select count(*) from PlexToolListAssemblyTemplatePlant8 -- 2
select * from PlexToolListAssemblyTemplatePlant8 -- 2


/*
 * For each ToolList create a TM Miscellaneous Assembly.
 */
insert into PlexToolListAssemblyTemplatePlant8 (ProcessID,ToolID,ToolNumber,Assembly_No,Tool_Assembly_Type,Description,Part_No,Part_Revision,Operation,Tool_Assembly_Status,Include_In_Analysis,Analysis_Note,Note,Location)
-- delete from PlexToolListAssemblyTemplateAvilla where ToolNumber = 222222	
select 
tl.processid,
222222 ToolID,
222222 ToolNumber,
--'TM-' + tl.OperationDescription Assembly_No,
'TM-' + m.Operation_Code Assembly_No,
'Machining' Tool_Assembly_Type,
'Miscellaneous' Description,
m.Plex_Part_No Part_No,
m.Revision Part_Revision,
m.Operation_Code Operation,
'Active' Tool_Assembly_Status,
1 Include_In_Analysis,
'' Analysis_Note,
'' Note,
'' Location
-- m.Plex_Part_No Part_No,m.Revision Part_Revision,m.Operation_Code Operation,tl.OperationDescription 
from bvToolListsInPlants tl
inner join TL_Plex_PN_Op_Map_Plant8 m 
on tl.processid = m.processid  -- 27
-- ONLY FOR TOOLLISTS THAT ARE IN MULTIPLE PLANTS
where tl.Plant = 8

select count(*) from PlexToolListAssemblyTemplatePlant8-- 3
select * from PlexToolListAssemblyTemplatePlant8-- 3
where Part_No = '28245973'

select * from TL_Plex_PN_Op_Map_Plant8

/*
 * Plex ToolAssembly Template
 */
select * from PlexToolListAssemblyTemplatePlant8
-- where Part_No != '28245973' 
order by Part_No,Operation,Assembly_No 

select Assembly_No,Tool_Assembly_Type,substring(replace(Description,'Ø',''),1,50) Description,Part_No,Part_Revision,Operation,
Tool_Assembly_Status,Include_In_Analysis,Analysis_Note,Note,Location
from PlexToolListAssemblyTemplatePlant8
-- where Part_No != '28245973' 
order by Part_No,Operation,Assembly_No 



/*
 *  Test
 * 
 */
select Assembly_No,Tool_Assembly_Type,Description,Part_No,Part_Revision,Operation,
Tool_Assembly_Status,Include_In_Analysis,Analysis_Note,Note,Location
from PlexToolListAssemblyTemplatePlant6
-- where Part_No = '28245973' 
-- and Assembly_No like '%1ST%'
-- and Assembly_No like '%2ND%'
-- and Assembly_No like '%3RD%'
order by Operation,Assembly_No 


select Assembly_No,Tool_Assembly_Type,Description,Part_No,Part_Revision,Operation,
Tool_Assembly_Status,Include_In_Analysis,Analysis_Note,Note,Location
from PlexToolListAssemblyTemplatePlant6
-- where Part_No = '28245973' 
-- and Assembly_No like '%1ST%'
-- and Assembly_No like '%2ND%'
-- and Assembly_No like '%3RD%'
order by Operation,Assembly_No 
/* 3rd
 * descript                                    |ToolNumber|OpDescription                
--------------------------------------------|----------|-----------------------------
DELPHI - 26090196 PITMAN SHAFT - 3RD OP MILL|         1|MILL OUTSIDE TEETH AND KEYWAY
DELPHI - 26090196 PITMAN SHAFT - 3RD OP MILL|         3|CUT INSIDE TEETH       

1st
DELPHI - 26090196L PITMAN SHAFT - 1ST OP LATHE|         1|FACE AND FINISH OD
DELPHI - 26090196L PITMAN SHAFT - 1ST OP LATHE|         3|ROUGH DRILL HOLE  
DELPHI - 26090196L PITMAN SHAFT - 1ST OP LATHE|        11|DRILL 1/2" HOLE   
DELPHI - 26090196L PITMAN SHAFT - 1ST OP LATHE|         7|BORE ID PROFILE   
DELPHI - 26090196L PITMAN SHAFT - 1ST OP LATHE|         9|THREAD ID         

2nd
DELPHI - 26090196L PITMAN SHAFT - 2ND OP LATHE|         3|THREAD OD              
DELPHI - 26090196L PITMAN SHAFT - 2ND OP LATHE|         4|CENTER DRILL           
DELPHI - 26090196L PITMAN SHAFT - 2ND OP LATHE|         1|TURN GEAR OD ROUGH FACE
DELPHI - 26090196L PITMAN SHAFT - 2ND OP LATHE|         2|FACE AND FINISH OD     
                  
 */

select * from TL_Plex_PN_Op_Map_Plant6
where Plex_Part_No = '26090196' 
--	where ProcessID = 56673  -- Final
--	where ProcessID = 62568 -- Machine B - WIP
-- where ProcessID = 56675 -- Machine B - WIP
-- where Plex_Part_No = '28245973'
--	where ProcessID = 56679  -- Machine Complete
--	where ProcessID = 61581 -- Machine B - WIP
-- where ProcessID = 62019 -- Machine B - WIP
-- select * from toolitems
select 
tl.descript,
tt.ToolNumber,
tt.OpDescription
-- tl.descript, tt.*
from bvToolListsInPlants tl
inner join [ToolList Tool] tt  -- 307
on tl.processid = tt.ProcessID
-- where Plex_Part_No = '26090196' 
-- where tl.ProcessID = 56673  -- Final  -- 3RD OP MILL
--	where tl.ProcessID = 62568 -- Machine B - WIP  -- 1st
 where tl.ProcessID = 56675 -- Machine B - WIP
-- where Plex_Part_No = '28245973'
-- where tl.ProcessID = 56679  -- Machine Complete
-- where tl.ProcessID = 62019 -- Machine B - WIP
-- where tl.ProcessID = 61581 -- Machine B - WIP
and tt.ToolNumber = 9
/*
 * where tl.ProcessID = 61581 -- Machine B - WIP
 * DELPHI - 28245973L PITMAN SHAFT - 1ST OP LATHE	11	THREAD I.D.-CELL 3
DELPHI - 28245973L PITMAN SHAFT - 1ST OP LATHE	9	ROUGH DRILL HOLE-CELL 3
DELPHI - 28245973L PITMAN SHAFT - 1ST OP LATHE	1	FACE AND FINISH OD
DELPHI - 28245973L PITMAN SHAFT - 1ST OP LATHE	7	BORE ID PROFILE-CELL 3
DELPHI - 28245973L PITMAN SHAFT - 1ST OP LATHE	5	DRILL 1/2" HOLE
DELPHI - 28245973L PITMAN SHAFT - 1ST OP LATHE	9	THREAD I.D.-CELL 2
DELPHI - 28245973L PITMAN SHAFT - 1ST OP LATHE	11	ROUGH DRILL HOLE-CELL 2
DELPHI - 28245973L PITMAN SHAFT - 1ST OP LATHE	3	BORE ID PROFILE-CELL 2
 */
/*
 * where tl.ProcessID = 62019 -- Machine B - WIP
 * DELPHI - 28245973L PITMAN SHAFT - 2ND OP LATHE	3	THREAD OD
 * DELPHI - 28245973L PITMAN SHAFT - 2ND OP LATHE	2	FACE AND FINISH OD
 * DELPHI - 28245973L PITMAN SHAFT - 2ND OP LATHE	4	CENTER DRILL
 * DELPHI - 28245973L PITMAN SHAFT - 2ND OP LATHE	6	FACE IDENTIFICATION GROOVE
 * DELPHI - 28245973L PITMAN SHAFT - 2ND OP LATHE	1	TURN GEAR OD ROUGH FACE/OD
 */
/*
 * where tl.ProcessID = 56679  -- Machine Complete
 * DELPHI - 28245973 PITMAN SHAFT - 3RD OP MILL	3	CUT INSIDE TEETH
 * DELPHI - 28245973 PITMAN SHAFT - 3RD OP MILL	1	MILL OUTSIDE TEETH AND KEYWAY
*/
