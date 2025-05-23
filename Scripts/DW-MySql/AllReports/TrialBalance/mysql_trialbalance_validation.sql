select s.Name,sh.*
from ETL.script_history sh 
join ETL.script s 
on sh.script_key=s.Script_Key 
where sh.script_key in (1,3,4,5,6,7,8,9,10,11,116,117)
and start_time between '2024-11-11 00:00:00' and '2024-11-12 00:00:00' 
order by script_history_key desc


select * from ETL.script s 
-- delete from ETL.script_history where script_history_key = 4746

select * 
-- select count(*)
-- 2024_04_05 count is 4638
select count(*) from Plex.accounting_account_year_category_type aayct  
where pcn = 123681 -- 27,752 diff from mssql which had 27,757 on 07/05/2024 #27,743 (05/07/2024) # diff from MSSQL which has 27,748
-- and year = 2025 -- 4,642
and year = 2024 -- 3 accounts were added on july 5, 2024 accounts=4642 on July 5th # 4638/4639 1 account was added when i ran on jun 7
and year = 2023 -- 4,639 on July 5, 2024 # 4638
and year = 2022 -- DIFF HERE between mysql and mssql (4,622 mssql and 4617 in mysql)
--and year = 2021 -- 4,617
--and year = 2020 -- 4,595

-- and year = 2020 -- 4,595
-- and year = 2021 -- 4,617

/*
 * Try to find any new accounts by comparing Plex.account_period_balance to Plex.accounting_account_year_category_type 
 * after the AccountingYearCategoryType.sh script and before the AccountPeriodBalanceRecreatePeriodRange.sh script 
 */

select b.pcn,b.account_no, c.pcn,c.[year],c.account_no 
from Plex.accounting_account_year_category_type c 
left outer join Plex.account_period_balance b
on c.pcn = b.pcn 
and c.account_no = b.account_no 
where c.pcn = 123681 -- 23,063
and c.[year] = 2024
limit 10
order by b.pcn 

--Accounts added on 5 July 2024:
--123681	2024	12450-000-0000
--123681	2024	77300-850-0055
--123681	2024	90300-850-0000

select s.Name,sh.*
from ETL.script_history sh 
join ETL.script s 
on sh.script_key=s.Script_Key 
where sh.script_key in (1,3,4,5,6,7,8,9,10,11,116,117)
and start_time between '2024-07-05 00:00:00' and '2024-07-06 00:00:00' 
order by script_history_key desc


-- Run the Accounting_account ETL script.  
-- Issue: This is used to generate records in account_period_balance. Since the previous 12 months account_period_balance gets  regenerated 
-- when a new period gets appended if the category type changes or an account somehow gets removed the previous 12 months worth of records 
-- get affected.  

select count(*) from Plex.accounting_account  -- 8,285
where pcn=123681 -- 4,639/4,638/4,622/4,621/4,617
select distinct(pcn) from Plex.accounting_account  
select * from Plex.accounting_account limit 10  

select s.Name,sh.*
from ETL.script_history sh 
join ETL.script s 
on sh.script_key=s.Script_Key 
where sh.script_key in (1,3,4,5,6,7,8,9,10,11,116,117)
and start_time between '2024-07-05 00:00:00' and '2024-07-06 00:00:00' 
order by script_history_key desc

/*
Accounting_period ETL script is used to refresh the DW accounting_period table containing 
start and end period dates, and add_date and update_date which well help us determine if  
there has been updates to the period since the last time these scripts were ran. 
*/
 
  select *
 -- select distinct 
 -- select count(*)
 from Plex.accounting_period p  
 where pcn = 123681 -- 1084/1060/1036 
 and period > 202101 -- 718/694/670

 and period = 202305 

select s.Name,sh.*
from ETL.script_history sh 
join ETL.script s 
on sh.script_key=s.Script_Key 
where sh.script_key in (1,3,4,5,6,7,8,9,10,11,116,117)
and start_time between '2024-07-05 00:00:00' and '2024-07-06 00:00:00' 
order by script_history_key desc


/* 
  accounting_period_ranges_dw_import,sproc123681_11728751_2112421
  The period range is min open period to year before it
  Pushed the min open period to one period back from the actual min open period
  in case the period was recently opened/closed, so the calculation is 
  based on the account activity summary web service which will have the 
  most up-to-date values.
 */
-- TB-202205_to_202305_on_06-09_DM
select * from Plex.accounting_period_ranges -- 
where pcn = 123681
-- update Plex.accounting_period_ranges 
-- set start_period = 202211,no_update = 0
-- set no_update=0
where pcn = 123681

select s.Name,sh.*
from ETL.script_history sh 
join ETL.script s 
on sh.script_key=s.Script_Key 
where sh.script_key in (1,3,4,5,6,7,8,9,10,11,116,117)
and start_time between '2024-07-05 00:00:00' and '2024-07-06 00:00:00' 
order by script_history_key desc

/*
The AccountingStartPeriodUpdate script calls the accounting_start_period_update python script 
to determine the date the Forever-to-date and YTD calculations need be started. This script
is not perfect.  It bases its decision on the updated_date of the previous accounting_period
record being different than the current one. If the pipeline fails before the FTD and YTD balances
are calculated and then it is restarted then both the updated_dates will be the same. Then 
you must manually change the accounting_period_ranges start_period  to what the AccountingPeriodRanges
script set it to be.
 */

select * from Plex.accounting_period_ranges -- 202105/202204
where pcn = 123681
-- update Plex.accounting_period_ranges 
-- set start_period = 202201,no_update = 0
-- set start_period = 202208,no_update = 0
--  set end_open_period = 202312
-- set end_open_period = 202401
-- set no_update=0
where pcn = 123681

select s.Name,sh.*
from ETL.script_history sh 
join ETL.script s 
on sh.script_key=s.Script_Key 
where sh.script_key in (1,3,4,5,6,7,8,9,10,11,116,117)
and start_time between '2024-07-05 00:00:00' and '2024-07-06 00:00:00' 
order by script_history_key desc


/*
 * You can verify the AccountingStartPeriodUpdate script by running this select command.
 * The ending period should be the Plex.accounting_period_ranges.end_period value.
 */

select p1.pcn,p1.period,p1.update_date prev_update_date,p2.update_date cur_update_date 
from Plex.accounting_period p1  
join Plex.accounting_period p2
on p1.pcn=p2.pcn 
and p1.period_key=p2.period_key
and p1.ordinal = 0
and p2.ordinal = 1
where p1.pcn = 123681 
and p1.period between 202201 and 202306
and p1.update_date <> p2.update_date 

-- update Plex.accounting_period p1
-- set update_date='2023-03-26 12:49:00.000', add_date='2023-04-10 16:30:12.007'
-- where p1.pcn = 123681 
-- and p1.period = 202304
-- 2023-04-11 09:02:58.400	2023-04-11 09:03:00.000
select * 
from Plex.accounting_period p1
where p1.pcn = 123681 
and p1.period = 202201

/*
 *  Or you can verify the AccountingStartPeriodUpdate script by running this select command.
 *  The ending period should be the Plex.accounting_period_ranges.end_period value.
 */
select o0.period_display,o0.add_date,o1.add_date,o0.update_date,o1.update_date
from 
(
 select * 
 from Plex.accounting_period o0 -- 1276/1418
 where pcn = 123681 -- 518
 and ordinal = 0
 and period between 202201 and 202302
) o0  
inner join 
(
 select * 
 from Plex.accounting_period o0 -- 1276/1418
 where pcn = 123681 -- 518
 and ordinal = 1
) o1  
on o0.pcn = o1.pcn 
and o0.period_key = o1.period_key
and o0.update_date!=o1.update_date

select s.Name,sh.*
from ETL.script_history sh 
join ETL.script s 
on sh.script_key=s.Script_Key 
where sh.script_key in (1,3,4,5,6,7,8,9,10,11,116,117)
and start_time between '2024-07-05 00:00:00' and '2024-07-06 00:00:00' 
order by script_history_key desc

SELECT @@global.time_zone, @@session.time_zone;
+--------------------+---------------------+
| @@global.time_zone | @@session.time_zone |
+--------------------+---------------------+
| SYSTEM             | SYSTEM              |
+--------------------+---------------------+
1 row in set (0.00 sec)
SELECT CURRENT_TIMESTAMP ;


/*
If no_update = 0 the AccountingBalanceAppendPeriodRange ETL script calls accounting_balance_append_period_range_dw_import
sproc300758_11728751_2000117 (pcn,start_period,end_period) to pull the most recent accounting_balance records from Plex.
It then runs Plex.accounting_balance_delete_period_range to delete the outdated accounting_balance records in the DW. 
*/
select * from Plex.accounting_period_ranges apr where pcn=123681
--TB-202205_to_202305_on_06-09_DM
SELECT distinct pcn,period 


-- select count(*)
-- select top 10 *
FROM Plex.accounting_balance 
where pcn = 123681 
-- and period = 202404  -- 230
-- and period between 202307 and 202404  -- 2327 on july 5th
and period between 202306 and 202404  -- 2560
and period between 202305 and 202403  -- 2578
and period between 202305 and 202402  -- 2354
and period between 202304 and 202402  -- 2597
and period between 202303 and 202401  -- 2607
and period between 202302 and 202312  -- 2625
and period between 202301 and 202311  -- 2642
and period between 202301 and 202310  -- 2410
and period between 202212 and 202310  -- 2659
and period between 202212 and 202309  -- 2423

and period between 202211 and 202309  -- 2676
and period between 202211 and 202308  -- 2417
and period between 202210 and 202308  -- 2651

-- and period = 202307  -- 234
and period between 202209 and 202307  -- 2654
-- and period between 202205 and 202304  -- 2878
-- and period = 202301  -- 244
-- and period = 202302  -- 241
-- and period = 202303  -- 240
--  and period between 202206 and 202304  -- 2641
-- and period = 202304  -- 243
-- and period between 202207 and 202305  -- 2646
-- and period = 202305  -- 248
 and period = 202306  -- 233
 and period = 202307  -- 0

 and period between 202206 and 202305  -- 2889
 and period = 202305 -- 248
order by pcn,period 

/*
 * Detected an error on 03/09/2023: 
 * no_update = 1 but there were no 2023-01 balance records at all.
 * The daily scripts were not running during this period.
 * Until the scripts are running again run the TrialBalance pipeline
 * with start_period_update = 0 so all the balance records will be
 * pulled from Plex.
 */
 select * 
 from Plex.accounting_period  -- 1276/1418
 where pcn = 123681 -- 518
 -- and ordinal = 0
 and period between 202212 and 202302
 order by pcn,period 

select s.Name,sh.*
from ETL.script_history sh 
join ETL.script s 
on sh.script_key=s.Script_Key 
where sh.script_key in (1,3,4,5,6,7,8,9,10,11,116,117)
and start_time between '2024-07-05 00:00:00' and '2024-07-06 00:00:00' 
order by script_history_key desc


/*
AccountActivitySummaryGetOpenPeriodRange
Takes the open period range from Plex.accounting_period_ranges and calls the Account_Activity_Summary_xPCN_Get web service
for each period. This gives the most up-to-date totals for each account. The Plex.account_activity_summary records for this
range are then deleted and added using the web service data.
*/

select * from Plex.accounting_period_ranges -- 202105/202204
where pcn = 123681
-- update Plex.accounting_period_ranges 
-- set start_period = 202208,no_update = 0
-- set no_update=0
where pcn = 123681

select distinct pcn,period 
-- select count(*)
from Plex.account_activity_summary  
where pcn=123681
-- order by pcn,period
--  and period = 202405  -- 4638
 and period = 202406  -- 4639
 and period = 202405  -- 4639
 and period = 202404  -- 4638
 and period = 202403  -- 4638
and period between 202403 and 202404 -- 9,276
and period between 202402 and 202403 -- 9,244
and period between 202401 and 202402 -- 9,244
and period between 202312 and 202401 -- 9,244
and period between 202311 and 202401 -- 13,866
and period between 202311 and 202312 -- 9,244/9,242
and period between 202310 and 202312 -- 13,863
and period between 202310 and 202311 -- 9,234
and period between 202309 and 202311 -- 13,851
-- and period = 202310  -- 4617
and period between 202309 and 202310 -- 9,234
-- and period = 202309  -- 4617
and period between 202308 and 202309 -- 9,234

-- and period = 202302 -- 4,617
-- and period between 202303 and 202304 -- 9,234
-- and period between 202304 and 202305 -- 9,234
-- and period between 202305 and 202306 -- 9,234
-- and period between 202306 and 202307 -- 9,234
-- and period between 202307 and 202308 -- 9,234
and period between 202308 and 202309 -- 9,234

order by pcn,period

select s.Name,sh.*
from ETL.script_history sh 
join ETL.script s 
on sh.script_key=s.Script_Key 
where sh.script_key in (1,3,4,5,6,7,8,9,10,11,116,117)
and start_time between '2024-07-05 00:00:00' and '2024-07-06 00:00:00' 
order by script_history_key desc


/*
AccountPeriodBalanceRecreatePeriodRange
The AccountPeriodBalanceRecreatePeriodRange ETL Script runs the Plex.account_period_balance_recreate_period_range procedure 
It calculates the Forever-to-date and YTD account totals by adding the accounting_balance totals for the period to the previous
periods values starting from the period previous to the start_period stored in the Plex.accounting_period_ranges table.
*/

/*
 * Backup
 */
-- CREATE TABLE Archive.account_period_balance_08_09_2023 -- 223691
-- as
-- SELECT * from Plex.account_period_balance;
-- select count(*) from Archive.account_period_balance_04_11_2023  -- 200,606

SHOW TABLES LIKE 'a%';
create table Archive.account_period_balance_2024_04_05 -- 237,542
-- CREATE TABLE Archive.account_period_balance_05_09_2023 -- 200,606
as
SELECT * from Plex.account_period_balance;
select distinct pcn,period 
-- select count(*) 
from Archive.account_period_balance_2024_02_08 -- 251,467
from Archive.account_period_balance_08_09_2023 -- 140,713
-- from Archive.account_period_balance_05_09_2023 -- 140,713
-- where period between 202201 and 202303 -- -- 69,255
where period between 202201 and 202305 -- 69,255
and pcn = 123681
order by pcn,period 

select * from Plex.accounting_period_ranges -- 202105/202204
where pcn = 123681
-- update Plex.accounting_period_ranges 
-- set start_period = 202210,no_update = 0
-- set no_update=0
where pcn = 123681


-- WATCH: THERE WAS AN ERROR IN THIS SCRIPT FOR MYSQL THERE WAS A 202213 PERIOD  
-- AccountPeriodBalanceRecreateOpenPeriodRange"

select distinct pcn,period 
-- select count(*)
from Plex.account_period_balance 
where pcn = 123681 
-- order by pcn,period desc
-- and period = 202401  -- 4,621
-- and period = 202312  -- 4,621
-- and period = 202311  -- 4,621
and period between 202304 and 202404  -- 60,294 (05/08/24)
and period between 202303 and 202404  -- 64,932 (04/05/24)
and period between 202302 and 202312  -- 50,842(02/08/24)
-- and period between 202301 and 202401  -- 60,074(01/09/24)#60,074(01/04/24)
-- and period between 202301 and 202312  -- 55,453(01/09/24)#55,453(01/03/24)
and period between 202301 and 202401  -- 60,074(01/04/24)

-- and period between 202301 and 202312  -- 55,454(01/09/24)#55,453(01/03/24)
-- and period between 202212 and 202312  -- 60,075(01/03/24)60,073(12/12)#60,073(12/08)
-- and period between 202211 and 202309  -- 50,787
-- and period between 202211 and 202308  -- 46,170
-- and period between 202309 and 202310  -- 9234
-- and period between 202210 and 202308  -- 50,787
-- and period between 202209 and 202307  -- 50,787
-- and period between 202207 and 202306  -- 55,404
-- and period between 202207 and 202307 -- 60,021
-- 
-- and period between 202206 and 202305 -- 55,404 
-- and period = 202305  -- 4,617
-- and period between 202205 and 202304 -- 55,404 
-- and period = 202304  -- 4,617
order by pcn,period desc 


select s.Name,sh.*
from ETL.script_history sh 
join ETL.script s 
on sh.script_key=s.Script_Key 
where sh.script_key in (1,3,4,5,6,7,8,9,10,11,116,117)
and start_time between '2024-07-05 00:00:00' and '2024-07-06 00:00:00' 
order by script_history_key desc



/*
AccountPeriodBalanceRecreateOpenPeriodRange
The AccountPeriodBalanceRecreateOpenPeriodRange ETL Script runs the Plex.account_period_balance_recreate_open_period_range procedure 
It calculates the Forever-to-date and YTD account totals by adding the accounting_balance totals for the period to the previous
periods values starting from the period previous to the start_period stored in the Plex.accounting_period_ranges table.
*/
select * from Plex.accounting_period_ranges -- 202303/202304
where pcn = 123681
-- update Plex.accounting_period_ranges 
set start_period = 202210,no_update = 0
-- set no_update=0
where pcn = 123681

-- WATCH: THERE WAS AN ERROR IN THIS SCRIPT FOR MYSQL THERE WAS A 202213 PERIOD  
-- AccountPeriodBalanceRecreateOpenPeriodRange"

select distinct pcn,period 
-- select *
-- delete from Plex.account_period_balance where period = 202213
-- select count(*)
from Plex.account_period_balance 
where pcn = 123681 
--  order by pcn,period DESC 
-- and period = 202312  -- 4,621
-- and period = 202311  -- 4,621
and period between 202401 and 202402  -- 9,244(2024_02_08)*9,242(01/03/24)#9,234
-- and period between 202311 and 202312  -- 9,242(01/03/24)#9,234
 
and period between 202310 and 202312  -- 13,863

-- and period = 202213 -- 0
and period between 202310 and 202311  -- 9,234
and period between 202309 and 202311  -- 13,851
and period between 202309 and 202310  -- 9234
-- and period between 202308 and 202309  -- 9234
-- and period between 202307 and 202308  -- 9234
-- and period between 202207 and 202307  -- 60,021
-- and period between 202206 and 202306  -- 60,021
-- and period between 202205 and 202305  -- 60,021
-- and period between 202304 and 202306 -- 13,851 
-- and period between 202303 and 202304 -- 9,234
-- and period between 202301 and 202303 -- 13,851
-- and period between 202201 and 202212 -- 55,404
-- and period between 202210 and 202212 -- 13,851
-- and period = 202213  -- 4,617
-- limit 100
-- and period >= 202204

select s.Name,sh.*
from ETL.script_history sh 
join ETL.script s 
on sh.script_key=s.Script_Key 
where sh.script_key in (1,3,4,5,6,7,8,9,10,11,116,117)
and start_time between '2024-07-05 00:00:00' and '2024-07-06 00:00:00' 
order by script_history_key desc

The CsvToTrialBalance python script is meant to replace the SSIS script
select distinct pcn,period from Plex.trial_balance_multi_level_py order by pcn,period desc 202305
select * from Plex.trial_balance_multi_level_py order by pcn,period desc

/*
 * Decide which TB periods to pull by  
 * each period has 2 records. ordinal 1 is the most recent
 * last update: 02-10-2023
 * If update_date is greater than last update then import that period.
 * goto Main Compare: section and locate the last period to have any differences
 * and import all periods after and including that one.
 * TB-202205_to_202305_on_06-09_DM found no diff between 202205 and 202304 so just need to import 202305
 * 05-09-2023: diff found in 202303 between trial_balance_multi-level and accounting_period_balance
 * 04-11-2023: diff found in 202303 between trial_balance_multi-level and accounting_period_balance * 03-02-2023: Pulled 202212 to 202301
 * 03-09-2023: Pulled 202302 to 202303 since there where no updates on 202301 since 2023-02-27
 */
select pcn,period,add_date,update_date 
from Plex.accounting_period p1  
where pcn = 123681
and ordinal =1
and period between 202201 and 202303
order by period DESC 
/*
 * Are there any accounts that have different values?
 */

declare @pcn int;
set @pcn= 123681;
declare @period_start int;
set @period_start = 202205;
declare @period_end int;
set @period_end = 202305; -- TB-202205_to_202305_on_06-09_DM

-- select b.period,b.account_no 
 --,b.balance b_balance, d.current_debit_credit d_balance
 --,b.ytd_balance, d.ytd_debit_credit 
select count(*)
-- select distinct b.period
from Plex.account_period_balance b 
-- where b.pcn = @pcn
-- and b.period between @period_start and @period_end -- 96,891/99,891/202101-202209/,234
join Plex.accounting_period ap
on b.pcn =ap.pcn 
and b.period = ap.period  
and ap.ordinal = 1
-- where b.pcn = @pcn
-- and b.period between @period_start and @period_end -- 96,891
join Plex.trial_balance_multi_level d -- TB download does not show the plex period for a multi period month, you must link to period_display
on b.pcn=d.pcn
and ap.period_display = d.period_display 
and b.account_no = d.account_no  -- 16,816
where b.pcn = @pcn
and b.period between @period_start and @period_end -- 54,652/202205-202305,117,712/202101-202304,109,304/202101-202302, 105,100/202101-202301,100,896/202101-202212,96,692/202101-202211,92,488/202101-202210/88,284/202101-202209/8,408/202208-202209,4,562/2021-01 to 2022-07,3,953/2021-01 to 2022-04
-- and b.balance  = d.current_debit_credit -- 54,617/202205-202305,117,117,645/202101-202304,109,242/202101-202302,/105,043/202101-202301,100,843/202101-202212,96,643/202101-202211,92,442/202101-202210,
-- and b.balance  != d.current_debit_credit -- 35,652/202205-202305,62/202101-202302,57/202101-202301,53/202101-202212,49/202101-202211,46//202101-202210
-- and abs(b.balance - d.current_debit_credit) >  0.01  -- 0 
-- and (b.ytd_balance = d.ytd_debit_credit)  -- 54,490/202205-202305,117,349/202101-202304,108,967/202101-202302,104,777/202101-202301,100,586/202101-202212,96,394/202101-202211,92,204/202101-202210
-- and (b.ytd_balance != d.ytd_debit_credit)  -- 162/202205-202305,363/202101-202304,337/202101-202302,323/202101-202301,310/202101-202212,298/202101-202211,284/202101-202210
and abs(b.ytd_balance - d.ytd_debit_credit) > .01 -- 13/202205-202305,16/202101-202304,15/202101-202303,14/202101-202302,17/202101-202302,13/202101-202301,12/202101-202212,11/202101-202211,-- 10/202101-202210 (73100-000-0000)
and d.account_no != '73100-000-0000' -- 0/202205-202305,0/202101-202304,0/202101-202303,16,816
order by b.period asc 
-- ISSUE: 1 ACCOUNT IS NOT THE SAME
-- See issue section at the bottom of this procedure and the Mobex Plex procedure: accounting_year_category_type_issue 
-- 73100-000-0000 has different category_types in accounting_v_account it is an Expense and in accounting_v_category_type it is a liability
-- Conclusion: The Plex TB report and Plex authored procedure is wrong to not reset YTD values.

select count(*) from Plex.trial_balance_multi_level d 

/*
 * 
 */
--From Plex download trial balance multi level report from the determined period range
--TrialBalance ssis ETL script that takes as input the Plex Trial Balance CSV file.   
--select distinct pcn,period from Plex.trial_balance_multi_level order by pcn,period desc

-- delete from ETL.script_history
where script_key in (1,3,4,5,6,7,8,9,10,11,116,117)
and start_time > '2023-01-27' 
-- delete from ETL.Script_History where Start_Time > '2022-07-11' and Script_Key in (1,3,4,5,6,116,117)
select * from ETL.Script s 
-- delete from ETL.script_history where script_history_key = 4746

/*
 * Compare/Diff Plex.account_period_balance to Azure.account_period_balance 
 */
select s.Name,sh.*
from ETL.script_history sh 
join ETL.script s 
on sh.script_key=s.Script_Key 
where sh.script_key in (1,3,4,5,6,7,8,9,10,11,116,117)
and start_time between '2024-07-05 00:00:00' and '2024-07-06 00:00:00' 
order by script_history_key desc

select count(*)
from Azure.account_period_balance  -- 64,708#60,086/96,891/87,657/157,283/202207,148,998

set @pcn= 123681;
set @period_start = 202212;
set @period_end = 202311; -- 55,464#55,454
-- set @period_end = 202401; -- 64,696

select count(*)
from Plex.account_period_balance p 
where pcn = 123681
and p.period between @period_start and @period_end 

set @pcn= 123681;
set @period_start = 202212;
set @period_end = 202311; -- 55,464#55,454
-- set @period_end = 202401; -- 64,696

select count(*)
from Azure.account_period_balance p 
where pcn = 123681
and p.period between @period_start and @period_end 

set @pcn= 123681;
set @open_period_start = 202312;
set @open_period_end = 202401; -- 9,244

select count(*)
from Plex.account_period_balance p 
where pcn = 123681
and p.period between @open_period_start and @open_period_end 

set @pcn= 123681;
set @open_period_start = 202312;
set @open_period_end = 202401; -- 9,244

select count(*)
from Azure.account_period_balance p 
where pcn = 123681
and p.period between @open_period_start and @open_period_end 

/*
 * Does MySQL match Azure DW?
 */
Total records: 64,708
Equal records: 64,696

set @pcn= 123681;
set @period_start = 202212;
-- set @period_end = 202311; -- 55,464#55,454
set @period_end = 202401; -- 64,696

select *
-- select count(*) cnt 
from Plex.account_period_balance p 
where p.pcn = @pcn 
-- and p.account_no = '11055-000-9806' 
and p.account_no = '11055-000-9806' 
and p.period between @period_start and @period_end 
order by p.period desc 

-- 123681	11055-000-9806	202311	
-- 123681	11055-000-9806	202212	

set @pcn= 123681;
set @period_start = 202212;
-- set @period_end = 202311; -- 55,464
set @period_end = 202401; -- 64,708

select *
-- select count(*) cnt 
from Azure.account_period_balance a 
where a.pcn = @pcn 
and a.account_no = '11055-000-9806' 
and a.period between @period_start and @period_end 
order by a.period desc 

set @pcn= 123681;
set @period_start = 202212;
-- set @period_end = 202311; -- 55,464#55,454
set @period_end = 202401; -- 64,708#64,696

-- select p.pcn,p.period,p.account_no,p.ytd_debit,a.ytd_debit 
 select count(*) -- 157,283
from Plex.account_period_balance p -- 
join Azure.account_period_balance a  -- 
on p.pcn = a.pcn 
and p.period = a.period 
and p.account_no = a.account_no -- 157,283 
where p.pcn = @pcn -- 87,657
-- and p.period = 202108 -- 4,617
and p.period between @period_start and @period_end -- 64,708#64,696#60,074
and p.period_display = a.period_display  
and p.debit = a.debit   
and p.credit  = a.credit   
and p.balance  = a.balance   
and p.ytd_debit = a.ytd_debit 
and p.ytd_credit  = a.ytd_credit  
and p.ytd_balance  = a.ytd_balance  -- 64,708#64,696#
and p.account_no = '11055-000-9806' 




