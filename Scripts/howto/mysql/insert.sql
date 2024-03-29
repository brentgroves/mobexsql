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
(12,3,'CsvToTrialBalanceMultiLevel',6,12),
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

/*
If you don't want to list the fields, and the structure of the tables is the same, you can do:

INSERT INTO `table2` SELECT * FROM `table1`;
or if you want to create a new table with the same structure:

CREATE TABLE new_tbl [AS] SELECT * FROM orig_tbl;
*/

-- drop procedure InsToolAssemblyChangeHistory;
CREATE PROCEDURE InsToolAssemblyChangeHistory(
	IN pCNC_Part_Operation_Key INT,
	IN pSet_No INT,
	IN pBlock_No INT,
	IN pActual_Tool_Life INT,
  	IN pTrans_Date datetime,
  	OUT pTool_Assembly_Change_History_Key INT,
	OUT pReturnValue INT 
);
BEGIN
-- truncate table Tool_Assembly_Change_History	
/*
	set @CNC_Key = 1;
set @Part_Key = 1;
set @Operation_Key = 1;
set @Assembly_Key = 1;
set @Actual_Tool_Life = 2;
set @Trans_Date = '2020-08-18 00:00:01';	
	set @pCNC_Part_Operation_Key = 1;
	set @pSet_No = 1;
	set @pBlock_No = 1;
    set @pActual_Tool_Life = 12;
	set @pTrans_Date = '2020-08-18 00:00:01';	
  */ 

/*
	select a.CNC_Key,a.Part_Key,a.Operation_Key,a.Assembly_Key,@Actual_Tool_Life,@Trans_Date
	from 
   	CNC_Part_Operation p
	inner join CNC_Part_Operation_Set_Block b 
	on p.CNC_Key = b.CNC_Key
	and p.Part_Key = b.Part_Key
	and p.Operation_Key = b.Operation_Key  -- 1 to many
	inner join CNC_Part_Operation_Assembly a
	on b.CNC_Key = a.CNC_Key
	and b.Part_Key = a.Part_Key 
	and b.Operation_Key = a.Operation_Key 
	and b.Assembly_Key = a.Assembly_Key 
	where p.CNC_Part_Operation_Key=@pCNC_Part_Operation_Key 
    and b.Set_No = @pSet_No and b.Block_No = @pBlock_No;
*/
INSERT INTO Tool_Assembly_Change_History
(CNC_Key,Part_Key,Operation_Key,Assembly_Key,Actual_Tool_Life,Trans_Date)
	select a.CNC_Key,a.Part_Key,a.Operation_Key,a.Assembly_Key,@pActual_Tool_Life,@pTrans_Date
	from 
   	CNC_Part_Operation p
	inner join CNC_Part_Operation_Set_Block b 
	on p.CNC_Key = b.CNC_Key
	and p.Part_Key = b.Part_Key
	and p.Operation_Key = b.Operation_Key  -- 1 to many
	inner join CNC_Part_Operation_Assembly a
	on b.CNC_Key = a.CNC_Key
	and b.Part_Key = a.Part_Key 
	and b.Operation_Key = a.Operation_Key 
	and b.Assembly_Key = a.Assembly_Key 
	where p.CNC_Part_Operation_Key=pCNC_Part_Operation_Key 
    and b.Set_No = pSet_No and b.Block_No = pBlock_No;


-- VALUES(pCNC_Key,pPart_Key,pOperation_Key,pAssembly_Key,pActual_Tool_Life,pTrans_Date);
-- VALUES(@CNC_Key,@Part_Key,@Operation_Key,Assembly_Key,@Actual_Tool_Life,@Trans_Date);

-- Display the last inserted row.
set pTool_Assembly_Change_History_Key = (select Tool_Assembly_Change_History_Key from Tool_Assembly_Change_History where Tool_Assembly_Change_History_Key =(SELECT LAST_INSERT_ID()));
-- select pTool_Assembly_Change_History_Key;
-- SET @total_tax = (SELECT SUM(tax) FROM taxable_transactions);
set pReturnValue = 0;

END;