-- https://www.mysqltutorial.org/mysql-index/mysql-create-index/
select * from Plex.account_period_balance limit 1 

-- Another procedure should have already run to delete the Plex.account_period_balance
-- records that are in the Plex.accounting_balance_update_period_range table.
select * from Plex.accounting_balance_update_period_range;
select distinct pcn,period from Plex.account_period_balance order by pcn,period 
-- call Plex.account_period_balance_delete_period_range()
select * 
-- into Archive.Script_History_06_06
from ETL.script_history sh 
where script_key in (1,3,4,5,6,116,117)
and start_time > '2022-07-13' 
order by script_history_key desc

call Plex.account_period_balance_recreate_period_range()
-- drop procedure Plex.account_period_balance_recreate_period_range
create procedure Plex.account_period_balance_recreate_period_range()
begin
	declare v_pcn int;
	declare v_period_start int;
	declare v_period_end int;
	declare v_period int;
	declare v_max_fiscal_period int;
	
	declare v_id int;
	declare v_min_id int;
	declare v_max_id int;
	
	declare v_prev_period int;
	declare v_first_period int;
	declare v_anchor_period int;
	declare v_anchor_period_display varchar(7);
	
	declare v_cnt int;

	select min(id) into v_min_id from Plex.accounting_balance_update_period_range;  
	select max(id) into v_max_id from Plex.accounting_balance_update_period_range; 

	set v_id = v_min_id;

	call Plex.account_period_balance_recreate_period_range_init(v_id,v_pcn,v_period_start,v_period,v_period_end,v_max_fiscal_period,v_prev_period,v_anchor_period,v_anchor_period_display,v_first_period);
	-- select v_min_id,v_max_id,v_id,v_pcn,v_period_start,v_period,v_period_end,v_max_fiscal_period,v_prev_period,v_anchor_period,v_anchor_period_display,v_first_period;

	while v_id <= v_max_id do
		/*
		 * Add new account records to Plex.accounting_account_year_category_type 
		 * for the @anchor_period's year if not already added.
		 */
		INSERT INTO Plex.accounting_account_year_category_type ( pcn,`year`,category_type,revenue_or_expense)
		with account_year_category_type
		as
		(
			select a.*
			-- select count(*)
			from Plex.accounting_account a  
			inner join Plex.accounting_account_year_category_type y
			on a.pcn = y.pcn 
			and a.account_no =y.account_no
			where y.`year` = (v_prev_period/100) 
			and a.pcn = v_pcn
		)
		,add_account_year_category_type
		as 
		( 
			select a.*
			from Plex.accounting_account a  
			left outer join account_year_category_type y 
			on a.pcn = y.pcn 
			and a.account_no = y.account_no
			where y.pcn is null 
			and a.pcn = v_pcn
		)
		select y.pcn,y.`year`,y.category_type,y.revenue_or_expense
		from Plex.accounting_account_year_category_type y
		where y.year = (v_period_end div 100) -- there is no account_year_category_type records for the @prev_period year,ie. anchor_period, so we must add them.
		and y.pcn = v_pcn
		and y.account_no in 
		( 
			select account_no from add_account_year_category_type
		);
	    /*
	     * Update the anchor period. Add account_period_balance records for accounts with no no entries.
	     */
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
		    -- select count(*) from Plex.accounting_account where pcn = 123681  -- 4,363/4,595
		    -- select distinct pcn,period from Plex.account_period_balance b order by pcn,period 
		    -- select count(*) from Plex.account_period_balance b where pcn = 123681 and period = 202103  -- 4,595
			from Plex.accounting_account a   
			left outer join Plex.account_period_balance b 
			on a.pcn=b.pcn 
			and a.account_no=b.account_no 
			and b.period = v_anchor_period  -- this v_anchor_period is initialized the value of the first v_prev_period value.
			where a.pcn = v_pcn 
			and b.pcn is null;
		
	   	while v_period <= v_period_end do
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
				left outer join Plex.accounting_balance b 
				on a.pcn=b.pcn 
				and a.account_no=b.account_no 
				and b.period = v_period
				where a.pcn = v_pcn  
				order by a.pcn,a.account_no,b.period  
			)
			-- select count(*) into v_cnt from period_balance;
			,account_period_balance(pcn,account_no,period,period_display,debit,ytd_debit,credit,ytd_credit,balance,ytd_balance)
			as 
			(	
				select b.pcn,b.account_no,b.period,ap.period_display, 
				case 
				when b.debit is null then 0
				else b.debit
				end debit,
				cast(
					case 
					when (v_first_period=0) and (a.revenue_or_expense = 1) and (b.debit is null) then p.ytd_debit 
					when (v_first_period=0) and (a.revenue_or_expense = 1) and (b.debit is not null) then p.ytd_debit + b.debit 
					when (v_first_period=0) and (a.revenue_or_expense = 0) and (b.debit is null) then p.ytd_debit 
					when (v_first_period=0) and (a.revenue_or_expense = 0) and (b.debit is not null) then p.ytd_debit + b.debit
					when (v_first_period=1) and (a.revenue_or_expense = 1) and (b.debit is null) then 0 
					when (v_first_period=1) and (a.revenue_or_expense = 1) and (b.debit is not null) then b.debit 
					when (v_first_period=1) and (a.revenue_or_expense = 0) and (b.debit is null) then p.ytd_debit 
					when (v_first_period=1) and (a.revenue_or_expense = 0) and (b.debit is not null) then p.ytd_debit + b.debit 
					end as decimal(19,5) 
				) ytd_debit,
				case 
				when b.credit is null then 0
				else b.credit
				end credit,
				cast(
					case 
					when (v_first_period=0) and (a.revenue_or_expense = 1) and (b.credit is null) then p.ytd_credit 
					when (v_first_period=0) and (a.revenue_or_expense = 1) and (b.credit is not null) then p.ytd_credit + b.credit 
					when (v_first_period=0) and (a.revenue_or_expense = 0) and (b.credit is null) then p.ytd_credit 
					when (v_first_period=0) and (a.revenue_or_expense = 0) and (b.credit is not null) then p.ytd_credit + b.credit
					when (v_first_period=1) and (a.revenue_or_expense = 1) and (b.credit is null) then 0 
					when (v_first_period=1) and (a.revenue_or_expense = 1) and (b.credit is not null) then b.credit 
					when (v_first_period=1) and (a.revenue_or_expense = 0) and (b.credit is null) then p.ytd_credit 
					when (v_first_period=1) and (a.revenue_or_expense = 0) and (b.credit is not null) then p.ytd_credit + b.credit 
					end as decimal(19,5)
				) ytd_credit, 	
				case 
				when b.balance is null then 0
				else b.balance
				end balance,
				cast(
					case 
					when (v_first_period=0) and (a.revenue_or_expense = 1) and (b.balance is null) then p.ytd_balance 
					when (v_first_period=0) and (a.revenue_or_expense = 1) and (b.balance is not null) then p.ytd_balance + b.balance 
					when (v_first_period=0) and (a.revenue_or_expense = 0) and (b.balance is null) then p.ytd_balance 
					when (v_first_period=0) and (a.revenue_or_expense = 0) and (b.balance is not null) then p.ytd_balance + b.balance
					when (v_first_period=1) and (a.revenue_or_expense = 1) and (b.balance is null) then 0 
					when (v_first_period=1) and (a.revenue_or_expense = 1) and (b.balance is not null) then b.balance 
					when (v_first_period=1) and (a.revenue_or_expense = 0) and (b.balance is null) then p.ytd_balance 
					when (v_first_period=1) and (a.revenue_or_expense = 0) and (b.balance is not null) then p.ytd_balance + b.balance 
					end as decimal(19,5)
				) ytd_balance	
				from period_balance b  
				inner join Plex.account_period_balance p
				on b.pcn = p.pcn 
				and b.account_no = p.account_no 
				and p.period = v_prev_period
				inner join Plex.accounting_account_year_category_type a
				on b.pcn = a.pcn 
				and b.account_no =a.account_no
				and a.`year`=(v_prev_period div 100)
				inner join Plex.accounting_period ap 
				on b.pcn=ap.pcn 
				and b.period=ap.period 
			)
			select pcn,account_no,period,period_display,debit,ytd_debit,credit,ytd_credit,balance,ytd_balance 
			from account_period_balance;
		
-- 			select count(*) into v_cnt from account_period_balance;
			-- update the variables
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
	    	-- select v_period,v_period_end,v_max_fiscal_period,v_prev_period,v_first_period;
		
		end while;	
		
		set v_id = v_id + 1;
		if v_id <= v_max_id then
			call Plex.account_period_balance_recreate_period_range_init(v_id,v_pcn,v_period_start,v_period,v_period_end,v_max_fiscal_period,v_prev_period,v_anchor_period,v_anchor_period_display,v_first_period);
			-- select v_min_id,v_max_id,v_id,v_pcn,v_period_start,v_period,v_period_end,v_max_fiscal_period,v_prev_period,v_anchor_period,v_anchor_period_display,v_first_period;
		end if;
	end while; 

end;	
    /*
     * Update the anchor period. Add account_period_balance records for accounts with no no entries.
     * select * from Plex.account_period_balance
     */
    -- select count(*) from Plex.account_period_balance 
   -- select count(*) from Archive.account_period_balance_12_30 apb 
   -- where pcn=123681 and period=202101 and debit=0 and ytd_debit = 0 and credit = 0 and ytd_credit =0 and balance = 0 and ytd_balance =0  -- 3,815
	
		
   	set v_id=v_id+1;
	if v_id <= v_max_id then
	 	select r.pcn into v_pcn 
		from Plex.accounting_balance_update_period_range r
		inner join Plex.max_fiscal_period_view m 
		on r.pcn=m.pcn
		and (r.period_start div 100) = m.`year`
		where id = v_id;

	 	select r.period_start into v_period_start 
		from Plex.accounting_balance_update_period_range r
		inner join Plex.max_fiscal_period_view m 
		on r.pcn=m.pcn
		and (r.period_start div 100) = m.`year`
		where id = v_id;

		set v_period = v_period_start;	

	 	select r.period_end into v_period_end 
		from Plex.accounting_balance_update_period_range r
		inner join Plex.max_fiscal_period_view m 
		on r.pcn=m.pcn
		and (r.period_start div 100) = m.`year`
		where id = v_id;

	 	select m.max_fiscal_period into v_max_fiscal_period 
		from Plex.accounting_balance_update_period_range r
		inner join Plex.max_fiscal_period_view m 
		on r.pcn=m.pcn
		and (r.period_start div 100) = m.`year`
		where id = v_id;
	
		select max(b.period) into v_prev_period
		from Plex.account_period_balance b
		where b.pcn = v_pcn;	
	
		if v_prev_period is null then
			set v_prev_period=202101;
		end if;
	
		set v_anchor_period = v_prev_period;		

		select p.period_display into v_anchor_period_display 
		from Plex.accounting_period p 
		where p.pcn = v_pcn
		and p.period = v_anchor_period;

		if v_period%100 = 1 then 
			set v_first_period=1;
		else 
			set v_first_period=0;
		end	if;	
	end if;
	select v_min_id, v_max_id, v_pcn, v_period, v_period_start, v_period_end, v_max_fiscal_period,v_prev_period,v_anchor_period
	,v_anchor_period_display,v_first_period;

end while;
end;



-- pcn,account_no,period,period_display,debit,ytd_debit,credit,ytd_credit,balance,ytd_balance
--select * from account_period_balance;  -- 4,363
select count(*) from Plex.account_period_balance b -- 4,595*12=     45950+9190
where b.pcn=123681 
--and b.period = 202101 -- 4,595
--and b.period = 202112 -- 4,595
and b.period = 202112 -- 4,595
-- 813-704-1772
-- 
select * from Plex.account_period_balance apb where period = 202111
-- select distinct pcn,period from Plex.account_period_balance order by pcn,period 

/*
 * Format to be like CSV download
 */
--select * from Plex.accounting_account a where a.account_no = '10220-000-00000' 
declare @pcn int;
set @pcn = 123681;

call Report.trial_balance(202206,202206);

create schema Report;
CREATE PROCEDURE Report.trial_balance(
	in v_start_period int,
	in v_end_period int
)
begin
	select 
	b.period_display,
	a.category_type,
	-- don't use legacy category type even though it is on the real TB report. I think it will be less confusing 
	-- for the Southfield PCN which hass missing accounts.
	-- b.category_type_legacy category_type,  
	/*
	 * The Plex TB report uses the category type of the category linked to the account via the  category_account view. 
	 * I believe Plex now mostly uses the account category located directly on the accounting_v_account view so I used 
	 * this column instead of the one linked via the account_category view. 
	 */
	a.category_name_legacy category_name,
	a.sub_category_name_legacy sub_category_name,
	a.account_no,
	-- a.account_no [no],
	a.account_name,
	b.balance current_debit_credit,
	b.ytd_balance ytd_debit_credit
	from Plex.account_period_balance b -- 43,620
	inner join Plex.accounting_account a -- 43,620
	on b.pcn=a.pcn 
	and b.account_no=a.account_no 
	where b.pcn = 123681  -- 50,545,55,140
	AND b.period BETWEEN v_start_period AND v_end_period
	order by b.period_display,a.account_no;
end; 

select * from ssis.ScriptComplete sc 

select 
--b.period,
b.period_display,
a.category_type,
-- don't use legacy category type even though it is on the real TB report. I think it will be less confusing 
-- for the Southfield PCN which hass missing accounts.
-- b.category_type_legacy category_type,  
/*
 * The Plex TB report uses the category type of the category linked to the account via the  category_account view. 
 * I believe Plex now mostly uses the account category located directly on the accounting_v_account view so I used 
 * this column instead of the one linked via the account_category view. 
 */
a.category_name_legacy category_name,
a.sub_category_name_legacy sub_category_name,
a.account_no,
--a.account_no [no],
a.account_name,
b.balance current_debit_credit,
b.ytd_balance ytd_debit_credit
--select count(*)
--select distinct pcn,period from Plex.account_period_balance b order by pcn,period -- 123,681 (202101 to 202111)
from Plex.account_period_balance b -- 43,620
--where b.pcn = @pcn  -- 50,545
inner join Plex.accounting_account a -- 43,620
on b.pcn=a.pcn 
and b.account_no=a.account_no 
where b.pcn = 123681  -- 50,545,55,140,64,330
--AND b.period = 202201  -- 4,595
--AND b.period = 202202  -- 4,595
and a.account_no = '12400-000-0000'
--and a.account_no='11010-000-0000'
--and a.account_no = '10220-000-00000' 
order by a.account_no,b.period 
--where a.category_type != a.category_type_legacy 
--where b.period_display is not NULL -- 40,940
--where b.period_display is NULL -- 40,940
