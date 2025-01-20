-- repsys1.ETL.source_dependancy_type definition

-- Drop table

-- DROP TABLE repsys1.ETL.source_dependancy_type;

CREATE TABLE repsys1.ETL.source_dependancy_type (
	source_dependancy_type_key int NOT NULL,
	name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
);

select top 10 *
-- select count(*) 
from repsys1.ETL.source_dependancy_type

CREATE TABLE repsys1.ETL.source_dependancy (
	source_dependancy_key int NOT NULL,
	source_dependancy_type_key int NOT NULL,
	source_control_repo_key int NULL,
	system_name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	friendly_name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ws_datasource_name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ws_datasource_key int NULL,
	soap_request varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	plx_procedure varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK_source_dependancy PRIMARY KEY (source_dependancy_key)
);

select top 10 *
-- select count(*) 
from repsys1.ETL.source_dependancy

CREATE TABLE repsys1.ETL.source_control_repo (
	source_control_repo_key int NOT NULL,
	source_control_project_key int NOT NULL,
	name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT PK_source_control_repo PRIMARY KEY (source_control_repo_key,source_control_project_key)
);

select top 10 *
-- select count(*) 
from ETL.source_control_repo

-- repsys1.ETL.source_control_project definition

-- Drop table

-- DROP TABLE repsys1.ETL.source_control_project;

CREATE TABLE repsys1.ETL.source_control_project (
	source_control_project_key int NOT NULL,
	name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT PK_source_control_project PRIMARY KEY (source_control_project_key)
);

select top 10 *
-- select count(*) 
from ETL.source_control_project

-- repsys1.ETL.script_source_dependancy definition

-- Drop table

-- DROP TABLE repsys1.ETL.script_source_dependancy;

CREATE TABLE repsys1.ETL.script_source_dependancy (
	script_source_dependancy_key int NOT NULL,
	script_key int NOT NULL,
	source_dependancy_key int NOT NULL,
	CONSTRAINT PK_script_source_dependancy PRIMARY KEY (script_source_dependancy_key)
);

select top 10 *
-- select count(*) 
from repsys1.ETL.script_source_dependancy

INSERT INTO repsys1.ETL.script_source_dependancy
(script_source_dependancy_key, script_key, source_dependancy_key)
VALUES(1, 2, 4);

-- repsys1.ETL.schedule definition

-- Drop table

-- DROP TABLE repsys1.ETL.schedule;

CREATE TABLE repsys1.ETL.schedule (
	schedule_key int NOT NULL,
	name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT PK_schedule PRIMARY KEY (schedule_key)
);

select top 10 *
-- select count(*) 
from repsys1.ETL.schedule

-- repsys1.ETL.Script_Type definition

-- Drop table

-- DROP TABLE repsys1.ETL.Script_Type;

CREATE TABLE repsys1.ETL.Script_Type (
	Script_Type_Key int NOT NULL,
	name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Cost decimal(19,5) NULL,
	Cost_Unit nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK_script_type PRIMARY KEY (Script_Type_Key)
);

select top 10 *
-- select count(*) 
from repsys1.ETL.Script_Type

CREATE TABLE repsys1.ETL.Script_History (
	Script_History_Key int IDENTITY(1,1) NOT NULL,
	Script_Key int NOT NULL,
	Start_Time datetime NULL,
	End_Time datetime NULL,
	Done bit NOT NULL,
	Error bit NULL,
	[Time] int NULL,
	CONSTRAINT PK_Script_History PRIMARY KEY (Script_History_Key)
);

select count(*) cnt -- 92,093
from ETL.Script_History

select s.Name, sh.*
from ETL.script_history sh 
join ETL.script s 
on sh.script_key=s.Script_Key 
--where sh.script_key in (1,3,4,5,6,7,9,10,11,116)
 where sh.script_key in (1,3,4,5,6,7,8,9,10,11,116,117)
and start_time between '2025-01-08 00:00:00' and '2025-01-09 00:00:00' 
order by start_time desc

CREATE TABLE repsys1.ETL.Script (
	Script_Key int IDENTITY(115,1) NOT NULL,
	Script_Type_Key int NULL,
	Name varchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Schedule_Key int NOT NULL,
	Source_Control_Repo_Key int NULL,
	CONSTRAINT PK_Script PRIMARY KEY (Script_Key)
);

select count(*) cnt -- 41
from ETL.Script
