create database Plex;
-- drop database ETL;
-- test.mytable definition
use ETL;
-- drop table `mytable`
CREATE TABLE `mytable` (
  `c` char(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SELECT * FROM mcpdw.mytable
select * from mytable m 
insert into mytable 
values 
('a')
,('b')
,('c')
select * from mytable
Create Schema ETL

call ETL.mytest(1)
-- drop procedure ETL.mytest
create procedure ETL.mytest 
(
	cur_script_key int
)
begin 
	-- declare script_key int; 
	-- set @script_key = 4;
	select * from ETL.mytable;
	
end;


-- DROP TABLE ETL.script;
CREATE TABLE ETL.script (
	script_key int NOT NULL,
	script_type_key int null,
	name varchar(500) NOT NULL,
	schedule_key int not null,
	source_control_repo_key int null,
	PRIMARY KEY (script_key)
);
select * from ETL.script s order by script_key 

-- create DATABASE Archive;
select * from Archive.Script_2022_07_28
-- CREATE TABLE Archive.Script_2022_07_28
select * 
from ETL.script s order by script_key 
-- delete from ETL.script where script_key = 8;

-- truncate TABLE ETL.script;
insert into ETL.script 
values 
-- select * from ETL.Script where name like '%RecreatePer%'
-- (117,3,'AccountingPeriodBalanceRecreatePeriodRange',1,11),
-- (116,3,'AccountingPeriodBalanceDeletePeriodRange',1,10),
(12,3,'CsvToTrialBalanceMultiLevel',6,12)
(11,3,'TrialBalanceExcel',6,12)
(10,3,'DailyShiftReportGet',1,12)

(9,3,'AccountingStartPeriodUpdate',1,12)
(8,3,'AccountPeriodBalanceRecreateOpenPeriodRange',1,12)
(7,3,'AccountActivitySummaryGetOpenPeriodRange',1,12)
(6,3,'AccountingBalanceAppendPeriodRange',1,9),
(5,3,'AccountingPeriod',1,6),
(4,3,'AccountingPeriodRanges',1,5)
(3,3,'AccountingYearCategoryType.dtsx',1,4),
(1,3,'AccountingAccount.dtsx',1,1)
select * from ETL.Script_History 
where script_key = 117
order by start_time  
SELECT @@version;
select * from ETL.script s 

select s.Name,sh.*
from ETL.script_history sh 
join ETL.script s 
on sh.script_key=s.Script_Key 
where sh.script_key in (1,3,4,5,6,7,8,9,10,11,116,117)
and start_time between '2023-10-18 00:00:00' and '2023-10-19 00:00:00' 
order by script_history_key desc
--*/
-- drop table ETL.script_type  
create table ETL.script_type  
(
	script_type_key int,
	name varchar(50) null,
	CONSTRAINT PK_script_type PRIMARY KEY (script_type_key)
);
select * from ETL.script_type
insert into ETL.script_type 
values 
(1,'powershell'),
(2,'ssis'),
(3,'python')

select 
s.name script 
,st.name script_type 
-- ,sch.name schedule 
from ETL.script s
join ETL.script_type st 
on s.script_type_key = st.script_type_key 


-- drop table ETL.schedule 
create table ETL.schedule 
(
	schedule_key int not null,
	name varchar(100) not null,
	CONSTRAINT PK_schedule PRIMARY KEY (schedule_key)
);
insert into ETL.schedule 
values 
-- (1,'Daily'),
-- (2,'Weekly'),
-- (3,'Monthly'),
-- (4,'Yearly'),
(5,'Hourly'),
(6,'OnDemand')

-- select * from ETL.schedule s2 
select 
s.name script 
,st.name script_type 
,sch.name schedule 
from ETL.script s
join ETL.script_type st 
on s.script_type_key = st.script_type_key 
join ETL.schedule sch 
on s.schedule_key = sch.schedule_key 

create table ETL.script_source_dependancy 
(
	script_source_dependancy_key int not null,
	script_key int not null,
	source_dependancy_key int not null, 
	CONSTRAINT PK_script_source_dependancy PRIMARY KEY (script_source_dependancy_key)
);
insert into ETL.script_source_dependancy 
values 
(1,2,4) -- workcenter_get

-- drop table ETL.source_dependancy
-- truncate table ETL.source_dependancy
create table ETL.source_dependancy  
( 
	source_dependancy_key int not null,
	source_dependancy_type_key int not null,
	source_control_repo_key int null,
	
	-- Mobex authored procedure columnus
	system_name varchar(50) null,
	friendly_name varchar(100) null,
	-- Plex web service columnus 
	ws_datasource_name varchar(100) null,
	ws_datasource_key int null,
	soap_request text null,
	
	-- Plex authored procedure columnus
	plx_procedure text null,
	
	CONSTRAINT PK_source_dependancy PRIMARY KEY (source_dependancy_key)
);
select * from ETL.source_dependancy  
insert into ETL.source_dependancy  
values 
(3,2,2
,'sproc300758_11728751_1999565','accounting_balance_update_period_range_dw_import'
,null,null,null
,null
),
(2,2,2
,'sproc300758_11728751_1999909','accounting_year_category_type_dw_import'
,null,null,null
,null
),
(1,2,2
,'sproc300758_11728751_1978024','accounting_account_DW_Import'
,null,null,null
,null 
),
(4,1,8
,null,null
,'Workcenter_Get',4031,
'<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:dat="http://www.plexus-online.com/DataSource">
   <soap:Header />
   <soap:Body>
      <dat:ExecuteDataSource>
         <dat:ExecuteDataSourceRequest>
            <dat:DataSourceKey>4031</dat:DataSourceKey>
            <dat:InputParameters>
               <dat:InputParameter>
                  <dat:Value>$Active</dat:Value>
                  <dat:Name>Active</dat:Name>
               </dat:InputParameter >
            </dat:InputParameters>
         </dat:ExecuteDataSourceRequest>
      </dat:ExecuteDataSource>
   </soap:Body>
</soap:Envelope>
'
,null
)

select 
s.name script 
,script_proj.name script_proj  
,script_repo.name script_repo 
,st.name script_type 
,sch.name schedule 
,sd.system_name,sd.friendly_name 
,sd.ws_datasource_name
,dependancy_proj.name dependancy_proj  
,dependancy_repo.name dependancy_repo
-- select count(*)
from ETL.script s
join ETL.script_type st 
on s.script_type_key = st.script_type_key 
join ETL.schedule sch 
on s.schedule_key = sch.schedule_key 

left outer join ETL.source_control_repo script_repo  
on s.source_control_repo_key = script_repo.source_control_repo_key  
left outer join ETL.source_control_project script_proj 
on script_repo.source_control_project_key = script_proj.source_control_project_key 


left outer join ETL.script_source_dependancy ssd 
on s.script_key =ssd.script_key 
left outer join ETL.source_dependancy sd 
on ssd.source_dependancy_key = sd.source_dependancy_key 

left outer join ETL.source_control_repo dependancy_repo  
on sd.source_control_repo_key = dependancy_repo.source_control_repo_key  
left outer join ETL.source_control_project dependancy_proj 
on dependancy_repo.source_control_project_key = dependancy_proj.source_control_project_key 


select r.source_control_repo_key,r.name repo,p.name source_control_project  
from ETL.source_control_repo r 
join ETL.source_control_project p 
on r.source_control_project_key = p.source_control_project_key 
-- drop table ETL.source_dependancy_type 
create table ETL.source_dependancy_type  
( 
	source_dependancy_type_key int not null,
	name varchar(100) not null
);
SHOW CREATE TABLE ETL.source_dependancy_type;
select * from ETL.source_dependancy_type 
insert into ETL.source_dependancy_type 
values 
(1,'web service'),
(2,'Mobex authored procedure'),
(3,'Plex authored procedure')


-- DROP TABLE ETL.script_history;
CREATE TABLE ETL.script_history (
	script_history_key int NOT NULL AUTO_INCREMENT,
	script_key int NOT NULL,
	start_time datetime NULL,
	end_time datetime NULL,
	done bit NOT NULL,
	error bit NULL,
	`time` int null,
	CONSTRAINT PK__script_history PRIMARY KEY (script_history_key)
);

-- select * from ETL.Script_History 
-- truncate table ETL.script_history
declare @script_key int; 
set @script_key = 114;
--insert into ETL.script_history
	--(113,113,null,null,0)
--	insert into ETL.script_history
select @script_key,getdate(),null,0

select * from ETL.script_history
where script_key = 6



/*
Please call ETL.script_start and ETL.script_end.
The script_key can be found with: select * from ETL.script
Sam suggested to add a ELT.script_history

ETL Script Requirements 
ETL script schema with ETL.script, ETL.report, and ETL.report_script tables. 
Each script and report will have its own script_key and report_key and all 
the scripts needed for a report will be in the ETL.report_script table. 
There are 3 procedures: 
ETL.script_start(script_key): To be ran when the script starts.  
ETL.script_end(script_key): To be ran when the script ends.  
ETL.script_status(report_key):  procedures as I'm working on the TrialBalance automation process. 
select * from ETL.script
 */
call ETL.script_start(4)
-- drop procedure ETL.script_start 
create procedure ETL.script_start 
(
	cur_script_key int
)
begin 
	-- declare script_key int; 
	-- set @script_key = 4;
	insert into ETL.script_history (script_key,start_time,end_time,done,error,`time`)
	select cur_script_key,now(),null,0,null,null;
	
end;
-- truncate table ETL.script_history
select * from ETL.script_history
--delete from ETL.Script_History
--where script_history_key = 44 
where script_key =4
order by script_key, start_time desc
exec ETL.script_start 4
exec ETL.script_end 4,0 

select * from ETL.script_history  
-- delete from ETL.script_history 
where script_key in (1,3,4,5,6,116,117)
and start_time > '2022-07-11'

update ETL.script_history  
set done = 0
where script_key = 1
and Start_Time > '2022-07-11'

-- delete from ETL.script_history
where script_key = 1
and start_time > '2022-07-11'

where script_key =4

	select script_history_key,start_time  
	from ETL.script_history
	where script_key = 1
	and done = 0
	order by start_time desc 
	limit 1

select now()

-- Select timestampdiff(SECOND, '2023-09-20 12:30:15', '2023-09-01 10:15:00') as Difference;
call ETL.script_end(4,0)
-- drop procedure ETL.script_end 
create procedure ETL.script_end 
(
	cur_script_key int,
	error_bit bit
)
begin 
	declare cur_script_history_key int;
	declare cur_time datetime;
	declare cur_start_time datetime; 
	set cur_time = now();

	select script_history_key into cur_script_history_key  
	from ETL.script_history
	where script_key = cur_script_key 
	and done = 0
	order by start_time desc 
	limit 1;

	select start_time into cur_start_time 
	from ETL.script_history
	where script_key = cur_script_key 
	and done = 0
	order by start_time desc 
	limit 1;

  --  select @script_history_key,@start_time,DATEDIFF(ss, @start_time,@cur_time); 	
	update ETL.script_history  
	set end_time = cur_time,
	done = 1,
	error = error_bit,
	`time` = timestampdiff(SECOND, cur_start_time,cur_time)
	where script_history_key = cur_script_history_key; 
end;

select * from ETL.script_history order by script_key,start_time desc    
select * from ETL.script 



-- drop table ETL.source_control_repo  
-- truncate table ETL.source_control_repo 
create table ETL.source_control_repo  
(
	source_control_repo_key int,
	source_control_project_key int not null,
	name varchar(100) not null,
	CONSTRAINT PK_source_control_repo PRIMARY KEY (source_control_repo_key,source_control_project_key)
);
select r.name repo,p.name source_control_project  
from ETL.source_control_repo r 
join ETL.source_control_project p 
on r.source_control_project_key = p.source_control_project_key 
insert into ETL.source_control_repo  
values
(12,4,'ETL-Pod')
(11,1,'AccountingPeriodBalanceRecreatePeriodRange'),
(10,1,'AccountingPeriodBalanceDeletePeriodRange'),
(9,1,'AccountingBalanceAppendPeriodRange'),
(8,3,'PlexSoapUI'),
(7,3,'PlexSoap'),
(6,1,'AccountingPeriod'),
(5,1,'AccountingBalanceUpdatePeriodRange'),
(4,1,'AccountingYearCategoryType'),
(1,1,'AccountingAccount'),
(2,2,'MobexSQL'),
(3,1,'PlexETLScripts')


-- drop table ETL.source_control_project
-- truncate table ETL.source_control_project
create table ETL.source_control_project 
(
	source_control_project_key int,
	name varchar(100) not null,
	CONSTRAINT PK_source_control_project PRIMARY KEY (source_control_project_key)
);
select * from ETL.source_control_project
insert into ETL.source_control_project 
values 
(4,'MobexCloudPlatform')
(3,'Soap'),
(1,'PlexETLScripts'),
(2,'MobexSQL')


 