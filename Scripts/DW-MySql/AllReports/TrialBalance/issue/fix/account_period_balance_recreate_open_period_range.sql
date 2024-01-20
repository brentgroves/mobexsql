-- Backup Plex.account_period_balance 
-- CREATE TABLE Archive.account_period_balance_2024_01_12 -- 251455
-- as
-- SELECT * from Plex.account_period_balance;
-- 
-- select * from Archive.account_period_balance_2024_01_12 limit 10
-- select count(*) cnt from Archive.account_period_balance_2024_01_12 -- 251,455

-- https://stackoverflow.com/questions/273437/how-do-you-debug-mysql-stored-procedures
-- call debug_msg(@enabled, (select concat_ws('','arg1:', v_first_period)));
-- CREATE PROCEDURE Archive.debug_msg(enabled INTEGER, msg VARCHAR(255))
-- CREATE PROCEDURE Plex.debug_msg(enabled INTEGER, msg VARCHAR(255))
-- BEGIN
--   IF enabled THEN
--     select concat('** ', msg) AS '** DEBUG:';
--   END IF;
-- END; 


/*
-- Bug fix 01-18-2024
-- 11055-000-9806 was in Plex.accounting_account_year_category_type for 2022, 2024 and 2025
-- To make sure an Plex.accounting_account_year_category_type records gets added for both 2022 and 2023
-- I added add_account_year_category_type_prev_period and add_account_year_category_type_end_period
-- to insert both records. Previously only the @prev_period record, 2022, was, added, but
-- now an @end_period, 2023, year record is added.
-- Also we added the account_no column to the following insert statement.
-- 	INSERT INTO Plex.accounting_account_year_category_type ( pcn,`year`,category_type,revenue_or_expense)
-- 	INSERT INTO Plex.accounting_account_year_category_type ( pcn,account_no,`year`,category_type,revenue_or_expense)

 */
-- drop PROCEDURE `Plex`.`account_period_balance_recreate_open_period_range`
ALWAYS DELETE PERIOD RANGE BEFORE RECREATING PERIOD RANGE 
-- drop PROCEDURE `Archive`.`account_period_balance_recreate_open_period_range_2024_01_18`
-- drop PROCEDURE `Plex`.`account_period_balance_recreate_open_period_range`

-- call `Plex`.`account_period_balance_delete_open_period_range`(123681); -- 
select *
-- select count(*) cnt
-- delete 
from Plex.account_period_balance 
WHERE pcn = 123681 
and period between 202312 and 202401 -- 9,244/9,242
order by period desc


-- call `Archive`.`account_period_balance_recreate_open_period_range_2024_01_18`(123681);
-- CREATE DEFINER=`root`@`%` PROCEDURE `Archive`.`account_period_balance_recreate_open_period_range_2024_01_18`(
-- call `Plex`.`account_period_balance_recreate_open_period_range`(123681);
CREATE DEFINER=`root`@`%` PROCEDURE `Plex`.`account_period_balance_recreate_open_period_range`(
	in v_pcn int
)
proc_Exit:begin
	declare v_start_open_period int;
	declare v_end_open_period int;
	declare v_period int;
	declare v_max_fiscal_period int;
	
	declare v_prev_period int;
	declare v_first_period int;
	declare v_anchor_period int;
	declare v_anchor_period_display varchar(7);
	
	declare v_cnt int;

	select r.start_open_period,r.start_open_period,r.end_open_period,m.max_fiscal_period 
	into v_start_open_period,v_period,v_end_open_period,v_max_fiscal_period
	from Plex.accounting_period_ranges r
	inner join Plex.max_fiscal_period_view m 
	on r.pcn=m.pcn
	and (r.start_open_period div 100) = m.`year`
	where r.pcn = v_pcn;

	if ((v_start_open_period%100)!=1) then
		set v_prev_period = v_start_open_period - 1;
	else
		set v_prev_period = (((v_start_open_period div 100)-1)*100)+12;
	end if;


	set v_anchor_period=v_prev_period;

	select p.period_display into v_anchor_period_display
	from Plex.accounting_period p 
	where p.pcn = v_pcn
	and p.period = v_anchor_period
	and p.ordinal = 1;
	
	if v_period%100 = 1 then
		set v_first_period=1;
	else 
		set v_first_period=0;
	end if;

  	SET @enabled = FALSE;
--   	SET @enabled = TRUE;
	set @str = concat_ws('','v_prev_period:', v_prev_period);
  	set @str = concat_ws('',@str,'#','v_start_open_period:', v_start_open_period);
  	set @str = concat_ws('',@str,'#','v_period:', v_period);
	set @str = concat_ws('',@str,'#','v_end_open_period:', v_end_open_period);
	set @str = concat_ws('',@str,'#','v_max_fiscal_period:', v_max_fiscal_period);
	set @str = concat_ws('',@str,'#','v_first_period:', v_first_period);
	set @str = concat_ws('',@str,'#','v_anchor_period:', v_anchor_period);
	set @str = concat_ws('',@str,'#','v_anchor_period_display:', v_anchor_period_display);
	call debug_msg(@enabled, @str);
-- pcn		anchor_period	anchor_period_display	period	prev_period	start_open_period	first_period	end_open_period	max_fiscal_period
-- 123681	202311			11-2023					202312	202311		202312				0				202401			202312

-- 	Bug fix: added the account_no column to the following insert.
-- 	INSERT INTO Plex.accounting_account_year_category_type ( pcn,`year`,category_type,revenue_or_expense)
	INSERT INTO Plex.accounting_account_year_category_type ( pcn,account_no,`year`,category_type,revenue_or_expense)
	with account_year_category_type_prev_period
	as
	(
		select a.*
		from Plex.accounting_account a  
		inner join Plex.accounting_account_year_category_type y
		on a.pcn = y.pcn 
		and a.account_no =y.account_no
		where y.`year` = (v_prev_period div 100) 
		and a.pcn = v_pcn
	)
	,add_account_year_category_type_prev_period
	as 
	( 
		select a.*
		from Plex.accounting_account a  
		left outer join account_year_category_type_prev_period y 
		on a.pcn = y.pcn 
		and a.account_no = y.account_no
		where y.pcn is null 
		and a.pcn = v_pcn
	)
	-- bug fix added account_no column to select statement and changed year to be from v_prev_perid
-- 	select y.pcn,y.`year`,y.category_type,y.revenue_or_expense
	select y.pcn,y.account_no,(v_prev_period div 100) year,y.category_type,y.revenue_or_expense
	from Plex.accounting_account_year_category_type y
	where y.year = (v_end_open_period div 100) 
	and y.pcn = v_pcn
	and y.account_no in 
	( 
		select account_no from add_account_year_category_type_prev_period
	);
-- select *  
-- from Plex.accounting_account_year_category_type y
-- where y.account_no = "11055-000-9806"

-- pcn		anchor_period	anchor_period_display	period	prev_period	start_open_period	first_period	end_open_period	max_fiscal_period
-- 123681	202311			11-2023					202312	202311		202312				0				202401			202312

    insert into Plex.account_period_balance 
	    select 
	    v_pcn pcn,
	    a.account_no,
	    v_anchor_period period,
	    v_anchor_period_display period_display,
	    0 debit,
	    0 ytd_debit,
	    0 credit,
	    0 ytd_credit,
	    0 balance,
	    0 ytd_balance
		from Plex.accounting_account a   
		left outer join Plex.account_period_balance b 
		on a.pcn=b.pcn 
		and a.account_no=b.account_no 
		and b.period = v_anchor_period  
		where a.pcn = v_pcn 
		and b.pcn is null;

   	while v_period <= v_end_open_period do
		-- pcn		anchor_period	anchor_period_display	period	prev_period	start_open_period	first_period	end_open_period	max_fiscal_period
		-- 123681	202311			11-2023					202312	202311		202312				0				202401			202312
		insert into Plex.account_period_balance (pcn,account_no,period,period_display,debit,ytd_debit,credit,ytd_credit,balance,ytd_balance)
   		with period_balance(pcn,account_no,period,debit,credit,balance)
   		as 
		(
		    select 
		    a.pcn,
		    a.account_no,
			v_period period,
			case 
			when b.debit is null then 0 
			else b.debit 
			end debit,
			case 
			when b.credit is null then 0 
			else b.credit 
			end credit,
			case 
			when b.balance is null then 0 
			else b.balance 
			end balance
			from Plex.accounting_account a   
			left outer join Plex.account_activity_summary b 
			on a.pcn=b.pcn 
			and a.account_no=b.account_no 
			and b.period = v_period
			where a.pcn = v_pcn  
			order by a.pcn,a.account_no,b.period  
		)
		
		,account_period_balance(pcn,account_no,period,period_display,debit,ytd_debit,credit,ytd_credit,balance,ytd_balance)
		as 
		(	
			select b.pcn,b.account_no,b.period,ap.period_display, 
			b.debit,
			cast(
			    case 
			    when (v_first_period=0) then p.ytd_debit + b.debit 
			    when (v_first_period=1) and (a.revenue_or_expense = 1) then b.debit 
			    when (v_first_period=1) and (a.revenue_or_expense = 0) then p.ytd_debit + b.debit 
			    end as decimal(19,5) 
			) ytd_debit, 
			b.credit,
		  	cast(
			    case 
			    when (v_first_period=0) then p.ytd_credit + b.credit 
			    when (v_first_period=1) and (a.revenue_or_expense = 1) then b.credit 
			    when (v_first_period=1) and (a.revenue_or_expense = 0) then p.ytd_credit + b.credit 
			    end as decimal(19,5) 
		  	) ytd_credit, 
			b.balance,
			cast(
			    case 
			    when (v_first_period=0) then p.ytd_balance + b.balance 
			    when (v_first_period=1) and (a.revenue_or_expense = 1) then b.balance 
			    when (v_first_period=1) and (a.revenue_or_expense = 0) then p.ytd_balance + b.balance 
			    end as decimal(19,5) 
			) ytd_balance
			from period_balance b  
			inner join Plex.account_period_balance p
			on b.pcn = p.pcn 
			and b.account_no = p.account_no 
			and b.period = v_period
			and p.period = v_prev_period
			inner join Plex.accounting_account_year_category_type a
			on b.pcn = a.pcn 
			and b.account_no =a.account_no
			and a.`year`=(v_prev_period div 100)
			inner join Plex.accounting_period ap 
			on b.pcn=ap.pcn 
			and b.period=ap.period 
			and ap.ordinal = 1
		)

		select pcn,account_no,period,period_display,debit,ytd_debit,credit,ytd_credit,balance,ytd_balance 
		from account_period_balance;

		-- pcn		anchor_period	anchor_period_display	period	prev_period	start_open_period	first_period	end_open_period	max_fiscal_period
		-- 123681	202311			11-2023					202312	202311		202312				0				202401			202312
	
		set v_prev_period = v_period;
		
	    if v_period < v_max_fiscal_period then
		    set v_period=v_period+1;
		else 
			set v_period=((v_period div 100 + 1)*100) + 1; 
		end if; 

		select m.max_fiscal_period into v_max_fiscal_period
		from Plex.max_fiscal_period_view m 
		where m.pcn = v_pcn 
		and m.`year` = v_period div 100;

		if v_period%100 = 1 then  
			set v_first_period=1;
		else 
			set v_first_period=0;
		end if;

	
	end while;	
	
end;