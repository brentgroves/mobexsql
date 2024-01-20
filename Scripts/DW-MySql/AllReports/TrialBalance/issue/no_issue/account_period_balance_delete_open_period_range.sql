/*
 * Backup
 */
 CREATE TABLE Archive.account_period_balance_2024_01_16 -- 251,455
 as
 SELECT * from Plex.account_period_balance;
-- select count(*) from Archive.account_period_balance_2024_01_16  -- 251,455

select * from Plex.accounting_period_ranges -- 202105/202204
where pcn = 123681

-- id	pcn		start_period	end_period	start_open_period	end_open_period	no_update
-- 707	123681	202301			202311		202312				202401			0

select *
-- select count(*) cnt
-- delete 
from Plex.account_period_balance 
WHERE pcn = 123681 
-- and account_no = '11055-000-9806' 
and period between 202312 and 202401 -- 9,242
-- and period between 202301 and 202311 -- 50,832
order by period 
limit 10

-- select * 
---- delete
from Plex.accounting_account_year_category_type 
where account_no = '11055-000-9806' and [year] in (2022,2023)

-- call `Plex`.`account_period_balance_delete_period_range`(123681); -- 50,832

select * from Plex.accounting_period_ranges -- 202105/202204
where pcn = 123681
select *
-- select count(*) cnt
-- delete 
from Plex.account_period_balance 
WHERE pcn = 123681 
and account_no = '11055-000-9806' 
and period between 202312 and 202401 -- 9,244/9,242
order by period desc
--select * 
---- delete
from Plex.accounting_account_year_category_type 
where account_no = '11055-000-9806' and [year] in (2022,2023)

-- call `Plex`.`account_period_balance_delete_open_period_range`(123681); -- 

CREATE DEFINER=`root`@`%` PROCEDURE `Plex`.`account_period_balance_delete_open_period_range`( 
	in v_pcn int
)
BEGIN   
	declare v_start_open_period int;
	declare v_end_open_period int;

	select start_open_period,end_open_period into v_start_open_period,v_end_open_period 
	from Plex.accounting_period_ranges where pcn = v_pcn;

	delete from Plex.account_period_balance 
	WHERE pcn = v_pcn 
	and period between v_start_open_period and v_end_open_period;
END;