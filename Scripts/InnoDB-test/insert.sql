-- DROP TABLE ETL.script;
CREATE TABLE script (
	script_key int NOT NULL,
	script_type_key int null,
	name varchar(500) NOT NULL,
	schedule_key int not null,
	source_control_repo_key int null,
	PRIMARY KEY (script_key)
);
select * from script s order by script_key 

-- create DATABASE Archive;
select * from Archive.Script_2022_07_28
-- CREATE TABLE Archive.Script_2022_07_28
select * 
from script s order by script_key 
-- delete from ETL.script where script_key = 8;

-- truncate TABLE ETL.script;
insert into script 
values 
-- select * from ETL.Script where name like '%RecreatePer%'
-- (117,3,'AccountingPeriodBalanceRecreatePeriodRange',1,11),
-- (116,3,'AccountingPeriodBalanceDeletePeriodRange',1,10),
-- (12,3,'CsvToTrialBalanceMultiLevel',6,12),
(11,3,'TrialBalanceExcel',6,12),
(10,3,'DailyShiftReportGet',1,12)

(9,3,'AccountingStartPeriodUpdate',1,12)
(8,3,'AccountPeriodBalanceRecreateOpenPeriodRange',1,12)
(7,3,'AccountActivitySummaryGetOpenPeriodRange',1,12)
(6,3,'AccountingBalanceAppendPeriodRange',1,9),
(5,3,'AccountingPeriod',1,6),
(4,3,'AccountingPeriodRanges',1,5)
(3,3,'AccountingYearCategoryType.dtsx',1,4),
(1,3,'AccountingAccount.dtsx',1,1)