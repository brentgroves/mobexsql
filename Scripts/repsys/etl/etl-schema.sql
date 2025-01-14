create schema ETL;
create procedure ETL.script_start 
(
	@script_key int
)
as 
begin 
	--declare @script_key int; 
	--set @script_key = 4;
	insert into ETL.script_history
	select @script_key,getdate(),null,0,null,null
	
end;

create procedure ETL.script_end 
(
	@script_key int,
	@error_bit bit
)
as 
begin 
	--declare @script_key int;
	--set @script_key = 4;
	--declare @error_bit bit; 
	--set @error_bit = 0;
	declare @script_history_key int;
	declare @cur_time datetime;
	declare @start_time datetime; 
	set @cur_time = getdate();
	select top 1 @script_history_key=script_history_key,@start_time=start_time  
	from ETL.script_history
	where script_key = @script_key 
	and done = 0
	order by start_time desc 
  --  select @script_history_key,@start_time,DATEDIFF(ss, @start_time,@cur_time); 	
	update ETL.script_history  
	set end_time = @cur_time,
	done = 1,
	error = @error_bit,
	time = DATEDIFF(ss, @start_time,@cur_time)
	where script_history_key = @script_history_key 
end;

create procedure ETL.report_script_status 
(
	@report_key int
)
as 
begin 
	--declare @report_key int; 
	-- set @reportkey = 100; 
	declare @not_done_or_error int;
	declare @script_history_count int;
	declare @report_script_count int;
	declare @prev_day_midnight datetime;
	-- see howto/date_calc.sql 
	set @prev_day_midnight = DATEADD(dd, DATEDIFF(dd, 0, GETDATE()) - 1, 0);
	--select @prev_day_midnight; 
	--declare @report_key int;
	--set @report_key = 101;
	declare @script_history table 
	( 
		row_number int,
		schedule_key int,
		schedule_no int,
		script_history_key int,
		script_key int,
		start_time datetime,
		end_time datetime,
		done bit,
		error bit
		
	);
	with script_history_with_row 
	as 
	(
		select 
	    ROW_NUMBER() OVER(PARTITION BY h.script_key ORDER BY h.start_time desc) AS row_number,
		sc.schedule_key,sc.schedule_no, h.*
		from ETL.report_script rs 
		join ETL.script s 
		on rs.script_key=s.script_key 
		join ETL.script_history h 
		on s.script_key = h.script_key 
		join ETL.schedule sc  
		on s.schedule_key = sc.schedule_key  
		where rs.report_key = @report_key 
		--and f.frequency_no = 1
	),
--	select * from script_history_with_row
	script_history 
	as 
	(
		select * from script_history_with_row where row_number = 1
	)
	insert into @script_history 
	select * from script_history;
	--select * from @script_history 
	with script_daily 
	as 
	(
		--declare @report_key int;
		-- set @report_key = 100;
		select * 
		from @script_history  
		where schedule_no = 1
	)
	--select * from script_daily 
	select @not_done_or_error=count(*) 
	from script_daily
	where 
	((start_time is null) or 
	(end_time is null) or 
	(end_time < start_time) or 
	(end_time <= @prev_day_midnight) or  
	(done =0) or 
	(error = 1)); 

	select @script_history_count=count(*) from @script_history; 
	--select @script_history_count 
	select @report_script_count=count(*)  
	from ETL.report_script rs 
	join ETL.script s 
	on rs.script_key=s.script_key 
	where rs.report_key = @report_key; 
	--select @report_script_count report_script_count 
	if ( @not_done_or_error  > 0 or 
		 @script_history_count < @report_script_count
		) 
	begin
		select 1 status
	end
	else 
	begin
		select 0 status
	end 
end;

create procedure ETL.clear_script_done 
(
  @report_key int 
)  
as 
begin
update ETL.script 
	set done = 0
where script_key in 
(
	select script_key from ETL.report_script where report_key = @report_key 
)
end;

-- mgdw.ETL.source_dependancy_type definition

-- Drop table

-- DROP TABLE mgdw.ETL.source_dependancy_type;

CREATE TABLE mgdw.ETL.source_dependancy_type (
	source_dependancy_type_key int NOT NULL,
	name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
);

-- mgdw.ETL.source_dependancy definition

-- Drop table

-- DROP TABLE mgdw.ETL.source_dependancy;

CREATE TABLE mgdw.ETL.source_dependancy (
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

-- mgdw.ETL.source_control_repo definition

-- Drop table

-- DROP TABLE mgdw.ETL.source_control_repo;

CREATE TABLE mgdw.ETL.source_control_repo (
	source_control_repo_key int NOT NULL,
	source_control_project_key int NOT NULL,
	name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT PK_source_control_repo PRIMARY KEY (source_control_repo_key,source_control_project_key)
);

-- mgdw.ETL.source_control_project definition

-- Drop table

-- DROP TABLE mgdw.ETL.source_control_project;

CREATE TABLE mgdw.ETL.source_control_project (
	source_control_project_key int NOT NULL,
	name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT PK_source_control_project PRIMARY KEY (source_control_project_key)
);

-- mgdw.ETL.script_source_dependancy definition

-- Drop table

-- DROP TABLE mgdw.ETL.script_source_dependancy;

CREATE TABLE mgdw.ETL.script_source_dependancy (
	script_source_dependancy_key int NOT NULL,
	script_key int NOT NULL,
	source_dependancy_key int NOT NULL,
	CONSTRAINT PK_script_source_dependancy PRIMARY KEY (script_source_dependancy_key)
);

-- mgdw.ETL.schedule definition

-- Drop table

-- DROP TABLE mgdw.ETL.schedule;

CREATE TABLE mgdw.ETL.schedule (
	schedule_key int NOT NULL,
	name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT PK_schedule PRIMARY KEY (schedule_key)
);

CREATE TABLE mgdw.ETL.Script_History (
	Script_History_Key int IDENTITY(1,1) NOT NULL,
	Script_Key int NOT NULL,
	Start_Time datetime NULL,
	End_Time datetime NULL,
	Done bit NOT NULL,
	Error bit NULL,
	[Time] int NULL,
	CONSTRAINT PK_Script_History PRIMARY KEY (Script_History_Key)
);


CREATE TABLE mgdw.ETL.Script (
	Script_Key int IDENTITY(115,1) NOT NULL,
	Script_Type_Key int NULL,
	Name varchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Schedule_Key int NOT NULL,
	Source_Control_Repo_Key int NULL,
	CONSTRAINT PK_Script PRIMARY KEY (Script_Key)
);

-- mgdw.ETL.Script_Type definition

-- Drop table

-- DROP TABLE mgdw.ETL.Script_Type;

CREATE TABLE mgdw.ETL.Script_Type (
	Script_Type_Key int NOT NULL,
	name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Cost decimal(19,5) NULL,
	Cost_Unit nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK_script_type PRIMARY KEY (Script_Type_Key)
);