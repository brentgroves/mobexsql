/*
 * -- create schema Plex
-- drop table Plex.tool_BOM
-- mgdw.Plex.part_tool_BOM definition

-- Drop table

-- DROP TABLE mgdw.Plex.part_tool_BOM;
-- mgdw.Plex.part_tool_BOM definition

-- Drop table

-- DROP TABLE mgdw.Plex.part_tool_BOM;

CREATE TABLE Plex.part_tool_BOM (
	id int NOT NULL,
	pcn int NOT NULL,
	part_key int NULL,
	part_no varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	revision varchar(8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	part_type varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	storage_location varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	part_operation_key int NULL,
	operation_no int NULL,
	operation_key int NULL,
	operation_code varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	assembly_key int NULL,
	assembly_no varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	assy_descr varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	tool_key int NULL,
	tool_no varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	tool_type_key int NULL,
	tool_type_code varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	tool_descr varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	extra_description varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	standard_tool_life int NULL,
	rework_tool_life int NULL,
	Quantity_Required int NULL,
	PRIMARY KEY (id,pcn)
);
*/
--truncate table Plex.part_tool_BOM
-- delete from Plex.part_tool_BOM where pcn in (300758)
select count(*) from Plex.part_tool_BOM  -- 1639, 2930
where pcn = 300758 
--select count(distinct tool_no) from Plex.part_tool_BOM  -- 779
where pcn = 300758  -- Albion 1639
--where pcn = 310507  -- Avilla 1291
--where pcn = 306766 -- Edon 1818

select * from SSIS.ScriptComplete
--update SSIS.ScriptComplete set Done = 0
--select id,pcn from Plex.part_tool_BOM where pcn != 300758  -- 779


select 'TOOL SETTER' group_id,'TOOL SETTER' group_description,b.part_operation_key job_number,b.name + '-' + b.part_no as job_description ,CAST(CAST(b.tool_no AS INT) AS VARCHAR(50)) item_number,b.tool_no,b.part_no,b.operation_no,b.operation_code,
b.assembly_no,b.assy_descr,b.tool_no,b.tool_type_code, b.tool_descr,b.storage_location 
from Plex.part_tool_BOM b
where b.part_no = 'R568616'
and b.tool_no not like '%[A-Z-]%'  --17558
and b.tool_no in ('16845','17292','17137')

select * from MSC.ItemSummary is2 
