create schema Plex;

-- mgdw.Plex.trial_balance_multi_level_py definition

-- Drop table

-- DROP TABLE mgdw.Plex.trial_balance_multi_level_py;

CREATE TABLE mgdw.Plex.trial_balance_multi_level_py (
	pcn int NULL,
	period int NULL,
	period_display varchar(7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	category_type varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	category_name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	sub_category_name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_no varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	account_name varchar(110) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	current_debit_credit decimal(18,2) NULL,
	ytd_debit_credit decimal(18,2) NULL,
	CONSTRAINT PK__trial_ba__42B3FBF342BDBF9D PRIMARY KEY (period_display,account_no)
);

create procedure Plex.account_period_balance_recreate_period_range
( 
	@pcn int
)
as 
begin

SET NOCOUNT ON;
--debug variable
--declare @pcn int;
--set @pcn = 123681;

declare @no_update int;
declare @start_period int;
declare @end_period int;
-- Bug fix need end_open_period in case account gets added in January and Dec of previous year is closed but January is open.
declare @end_open_period int;
declare @period int;
declare @max_fiscal_period int;

declare @prev_period int;
declare @first_period int;
declare @anchor_period int;
declare @anchor_period_display varchar(7);

declare @cnt int

select @start_period=r.start_period, @period=r.start_period,@end_period=r.end_period,@end_open_period=r.end_open_period,
@no_update=r.no_update,@max_fiscal_period=m.max_fiscal_period
--select * from Plex.accounting_balance_update_period_range r
from Plex.accounting_period_ranges r
inner join Plex.max_fiscal_period_view m 
on r.pcn=m.pcn
and (r.start_period/100) = m.[year]
where r.pcn = @pcn;

--Debug
if (@no_update=1)
begin
--	select 'returning early', @no_update no_update;
	return 0;
end

if ((@start_period%100)!=1)
begin
	set @prev_period = @start_period - 1;
end
else
begin
	set @prev_period = (((@start_period/100)-1)*100)+12;
end;

set @anchor_period = @prev_period;

select @anchor_period_display=p.period_display 
from Plex.accounting_period p 
where p.pcn = @pcn
and p.period = @anchor_period
and p.ordinal = 1;

if @period%100 = 1 
begin
	set @first_period=1;
end 
else 
begin 
	set @first_period=0;
end;

--select @no_update no_update,@pcn pcn,@anchor_period anchor_period,@anchor_period_display anchor_period_display,
--@period period,
--@prev_period prev_period,@start_period start_period,
--@first_period first_period,@end_period end_period,@end_open_period end_open_period,@period period,@max_fiscal_period max_fiscal_period;

--no_update	pcn		anchor_period	anchor_period_display	period	prev_period	start_period	first_period	end_period	period	max_fiscal_period
--0			123681	202212			12-2022					202301	202212		202301			1				202311		202301	202312

--select * 
---- delete
--from Plex.accounting_account_year_category_type 
--where account_no = '11055-000-9806' and [year] in (2022,2023)
/*
 * Add new account records to Plex.accounting_account_year_category_type 
 * for the @anchor_period's year if not already added.
-- Bug fix 
-- 11055-000-9806 was not in Plex.accounting_account_year_category_type for 2023 but is for 2022, 2024 and 2025
-- To make sure an Plex.accounting_account_year_category_type records gets added for both 2022 and 2023
-- I added add_account_year_category_type_prev_period and add_account_year_category_type_end_period
-- to insert both records. Previously only the @prev_period record, 2022, was, added, but
-- now an @end_period year record is added.
-- Also we get Plex.accounting_account_year_category_type account data from @end_open_period instead of @end_period.
 */
with account_year_category_type_prev_period
as
(
	select a.*
	-- select count(*)
	from Plex.accounting_account a  
	--where a.pcn=123681 -- 4,617
	inner join Plex.accounting_account_year_category_type y
	on a.pcn = y.pcn 
	and a.account_no =y.account_no
	where y.[year] = (@prev_period/100) 
	and a.pcn = @pcn
)
--select count(*) from account_year_category_type  -- 4,595
,add_account_year_category_type_prev_period
as 
( 	select a.*
	from Plex.accounting_account a  
	left outer join account_year_category_type_prev_period y 
	on a.pcn = y.pcn 
	and a.account_no =y.account_no
	where y.pcn is null -- there is no account_year_category_type records for the @prev_period year so we must add them.
	and a.pcn = @pcn
)
INSERT INTO Plex.accounting_account_year_category_type (pcn,account_no,YEAR,category_type,revenue_or_expense)
	select y.pcn,y.account_no, (@prev_period/100) year,y.category_type,y.revenue_or_expense	
	from Plex.accounting_account_year_category_type y
	where y.[year] = (@end_open_period/100) -- there is no account_year_category_type records for the @prev_period year so we must add them.
	and y.pcn = @pcn
	and y.account_no in 
	( 
		select account_no from add_account_year_category_type_prev_period
	)

;with account_year_category_type_end_period
as
(
	select a.*
	-- select count(*)
	from Plex.accounting_account a  
	--where a.pcn=123681 -- 4,617
	inner join Plex.accounting_account_year_category_type y
	on a.pcn = y.pcn 
	and a.account_no =y.account_no
	where y.[year] = (@end_period/100) 
	and a.pcn = @pcn
)
,add_account_year_category_type_end_period
as 
( 	select a.*
	from Plex.accounting_account a  
	left outer join account_year_category_type_end_period y 
	on a.pcn = y.pcn 
	and a.account_no =y.account_no
	where y.pcn is null -- there is no account_year_category_type records for the @prev_period year so we must add them.
	and a.pcn = @pcn
)
-- select * 
-- from Plex.accounting_account_year_category_type y
-- where pcn=123681 and account_no = '11055-000-9806'
-- 11055-000-9806
INSERT INTO Plex.accounting_account_year_category_type (pcn,account_no,YEAR,category_type,revenue_or_expense)
	select y.pcn,y.account_no, (@end_period/100) year,y.category_type,y.revenue_or_expense	
	from Plex.accounting_account_year_category_type y
	where y.[year] = (@end_open_period/100) -- there is no account_year_category_type records for the @end_period year so we must add them.
	and y.pcn = @pcn
	and y.account_no in 
	( 
		select account_no from add_account_year_category_type_end_period
	)
/*
 * Update the anchor period. Add records for new accounts.
 */
insert into Plex.account_period_balance 
    select 
    @pcn pcn,
    a.account_no,
    @anchor_period period,
    @anchor_period_display period_display,
    0 debit,
    0 ytd_debit,
    0 credit,
    0 ytd_credit,
    0 balance,
    0 ytd_balance
    -- select count(*) from Plex.accounting_account where pcn = 123681  -- 4,617,4,363/4,595
    -- select distinct pcn,period from Plex.account_period_balance b order by pcn,period 
    -- select count(*) from Plex.account_period_balance b where pcn = 123681 and period = 202103  -- 4,595
	from Plex.accounting_account a   
	left outer join Plex.account_period_balance b 
	on a.pcn=b.pcn 
	and a.account_no=b.account_no 
	and b.period = @anchor_period
	where a.pcn = @pcn 
	and b.pcn is null;
--select count(*) account_period_balance_cnt from Plex.account_period_balance  where period = @anchor_period and pcn = @pcn -- 4,617
--no_update	pcn		anchor_period	anchor_period_display	period	prev_period	start_period	first_period	end_period	period	max_fiscal_period
--0			123681	202212			12-2022					202301	202212		202301			1				202311		202301	202312
while @period <= @end_period
begin
	with period_balance(pcn,account_no,period,debit,credit,balance)
	as 
	(
	    select 
	    a.pcn,
	    a.account_no,
		@period period,
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
	    -- select count(*) from Plex.accounting_account where pcn = 123681  -- 4,595/4,363
		from Plex.accounting_account a   
		left outer join Plex.accounting_balance b 
		on a.pcn=b.pcn 
		and a.account_no=b.account_no 
		and b.period = @period
		where a.pcn = @pcn  
	),
	--select @cnt=count(*) from period_balance;
	--print '@cnt=' + cast(@cnt as varchar(4));
	account_period_balance(pcn,account_no,period,period_display,debit,ytd_debit,credit,ytd_credit,balance,ytd_balance)
	--,ending_period,ending_ytd_debit,ending_ytd_credit,ending_ytd_balance,next_period)
	as 
	(	
	--select * from Plex.accounting_period ap where pcn = 300758
		select b.pcn,b.account_no,b.period,ap.period_display,
		b.debit,
		cast(
		    case 
		    when (@first_period=0) then p.ytd_debit + b.debit 
		    when (@first_period=1) and (a.revenue_or_expense = 1) then b.debit 
		    when (@first_period=1) and (a.revenue_or_expense = 0) then p.ytd_debit + b.debit 
		    end as decimal(19,5) 
		) ytd_debit, 
		b.credit,
	  	cast(
		    case 
		    when (@first_period=0) then p.ytd_credit + b.credit 
		    when (@first_period=1) and (a.revenue_or_expense = 1) then b.credit 
		    when (@first_period=1) and (a.revenue_or_expense = 0) then p.ytd_credit + b.credit 
		    end as decimal(19,5) 
	  	) ytd_credit, 
		b.balance,
	  	cast(
		    case 
		    when (@first_period=0) then p.ytd_balance + b.balance 
		    when (@first_period=1) and (a.revenue_or_expense = 1) then b.balance 
		    when (@first_period=1) and (a.revenue_or_expense = 0) then p.ytd_balance + b.balance 
		    end as decimal(19,5) 
	  	) ytd_balance
		from period_balance b  -- will contain all the accounts labled with just one period
		inner join Plex.account_period_balance p
		on b.pcn = p.pcn 
		and b.account_no = p.account_no 
		AND b.period=@period
		and p.period=@prev_period
		inner join Plex.accounting_period ap 
		on b.pcn=ap.pcn 
		and b.period=ap.period 
		and ap.ordinal = 1
--no_update	pcn		anchor_period	anchor_period_display	period	prev_period	start_period	first_period	end_period	period	max_fiscal_period
--0			123681	202212			12-2022					202301	202212		202301			1				202311		202301	202312
		inner join Plex.accounting_account_year_category_type a
		on p.pcn = a.pcn 
		and p.account_no =a.account_no
		and (p.period/100)=a.[year]
	
	)
	
--	select @period, count(*)  from account_period_balance;  -- 4,363
	
	insert into Plex.account_period_balance
	select pcn,account_no,period,period_display,debit,ytd_debit,credit,ytd_credit,balance,ytd_balance from account_period_balance;  -- 4,363

--no_update	pcn		anchor_period	anchor_period_display	period	prev_period	start_period	first_period	end_period	period	max_fiscal_period
--0			123681	202212			12-2022					202301	202212		202301			1				202311		202301	202312
	
	set @prev_period = @period
	
    if @period < @max_fiscal_period 
    begin 
	    set @period=@period+1
	end 
	else 
	begin 
		set @period=((@period/100 + 1)*100) + 1 
	end 
		
	select @max_fiscal_period=m.max_fiscal_period
	from Plex.max_fiscal_period_view m 
	where m.pcn = @pcn 
	and m.year = @period/100

	if @period%100 = 1 
	begin
		set @first_period=1;
	end 
	else 
	begin 
		set @first_period=0;
	end
--	select @period period,@period_end period_end,@prev_period previous_period,@max_fiscal_period max_fiscal_period,@first_period first_period;
		
end 
	
end;

create procedure Plex.account_period_balance_delete_period_range
(
	@pcn int
)
as
begin
	declare @start_period int;
	declare @end_period int;
	select @start_period=start_period,@end_period=end_period 
	from Plex.accounting_period_ranges where pcn = @pcn
--	SELECT @pcn pcn, @start_period start_period, @end_period end_period
	delete from Plex.account_period_balance WHERE pcn = @pcn and period between @start_period and @end_period
end;

create procedure Plex.account_period_balance_recreate_open_period_range
( 
	@pcn int
)
as 
begin

SET NOCOUNT ON;
--Debug
--DECLARE @pcn int;
--SET @pcn=123681;
declare @period int;
declare @start_open_period int;
declare @end_open_period int;
declare @max_fiscal_period int;

declare @prev_period int;
declare @first_period int;
declare @anchor_period int;
declare @anchor_period_display varchar(7);

declare @cnt int

select @start_open_period=r.start_open_period, @period=r.start_open_period,@end_open_period=r.end_open_period,
@max_fiscal_period=m.max_fiscal_period
from Plex.accounting_period_ranges r
inner join Plex.max_fiscal_period_view m 
on r.pcn=m.pcn
and (r.start_open_period/100) = m.[year]
where r.pcn = @pcn;

if ((@start_open_period%100)!=1)
begin
	set @prev_period = @start_open_period - 1;
end
else
begin
	set @prev_period = (((@start_open_period/100)-1)*100)+12;
end;

set @anchor_period = @prev_period;

select @anchor_period_display=p.period_display 
from Plex.accounting_period p 
where p.pcn = @pcn
and p.period = @anchor_period
and p.ordinal = 1;

if @period%100 = 1 
begin
	set @first_period=1;
end 
else 
begin 
	set @first_period=0;
end;

--select @pcn pcn,@anchor_period anchor_period,@anchor_period_display anchor_period_display,
--@period period,@prev_period prev_period,@start_open_period start_open_period,
--@first_period first_period,@end_open_period end_open_period,@max_fiscal_period max_fiscal_period;

--pcn		anchor_period	anchor_period_display	period	prev_period	start_open_period	first_period	end_open_period	max_fiscal_period
--123681	202311			11-2023					202312	202311		202312				0				202401			202312
/*
 * Add new account records to Plex.accounting_account_year_category_type 
 * for the @anchor_period's year if not already added.
 */
with account_year_category_type
as
(
	select a.*
	-- select count(*)
	from Plex.accounting_account a  
	--where a.pcn=123681 -- 4,617
	inner join Plex.accounting_account_year_category_type y
	on a.pcn = y.pcn 
	and a.account_no =y.account_no
	where y.[year] = (@prev_period/100) 
	and a.pcn = @pcn
)
-- select count(*) from account_year_category_type  -- 4,595
,add_account_year_category_type
as 
( 	select a.*
	from Plex.accounting_account a  
	left outer join account_year_category_type y 
	on a.pcn = y.pcn 
	and a.account_no =y.account_no
	where y.pcn is null -- if there is no account_year_category_type records for the @prev_period year so we must add them.
	and a.pcn = @pcn
)
-- select top 10 *
---- select *
-- from Plex.accounting_account_year_category_type y
---- where y.account_no = ''
-- where y.account_no is null
-- delete from Plex.accounting_account_year_category_type
-- where account_no is null
--select * 
-- from Plex.accounting_account_year_category_type y
--where y.account_no = '11055-000-9806'
--17372671	123681	11055-000-9806	2024	Asset	0
--17377293	123681	11055-000-9806	2025	Asset	0

-- Issue: There was 1 2024 record with a null account_no
-- Bug fix must insert the account_no column
-- change from: select y.pcn,y.[year],y.category_type,y.revenue_or_expense	
-- change to: select y.pcn,y.account_no,(@prev_period/100) [year] ,y.category_type,y.revenue_or_expense	 
-- INSERT INTO Plex.accounting_account_year_category_type (pcn,YEAR,category_type,revenue_or_expense)
INSERT INTO Plex.accounting_account_year_category_type (pcn,account_no,YEAR,category_type,revenue_or_expense)
	select y.pcn,y.account_no,(@prev_period/100) [year] ,y.category_type,y.revenue_or_expense	
	from Plex.accounting_account_year_category_type y
	where y.[year] = (@end_open_period/100) -- if there is no account_year_category_type records for the @prev_period year so we must add them.
	and y.pcn = @pcn
	and y.account_no in 
	( 
		select account_no from add_account_year_category_type
	)

--pcn		anchor_period	anchor_period_display	period	prev_period	start_open_period	first_period	end_open_period	period
--123681	202311			11-2023					202312	202311		202312				0				202401			202312

--Why is 202212 present but not 202301-202310?	Work on account_period_balance_recreate_period_range to find answer.
--select *	
--from Plex.account_period_balance b 	
--where account_no = '11055-000-9806'
--order by period 
--pcn		account_no		period	period_display	debit	ytd_debit	credit	ytd_credit	balance	ytd_balance
--123681	11055-000-9806	202212	12-2022			0.00000	0.00000	0.00000	0.00000	0.00000	0.00000
--123681	11055-000-9806	202311	11-2023			0.00000	0.00000	0.00000	0.00000	0.00000	0.00000
/*
 * Update the anchor period. Add records for new accounts.
 */
insert into Plex.account_period_balance 
    select 
    @pcn pcn,
    a.account_no,
    @anchor_period period,
    @anchor_period_display period_display,
    0 debit,
    0 ytd_debit,
    0 credit,
    0 ytd_credit,
    0 balance,
    0 ytd_balance
    -- select count(*) from Plex.accounting_account where pcn = 123681  -- 4,617,4,363/4,595
    -- select distinct pcn,period from Plex.account_period_balance b order by pcn,period 
    -- select count(*) from Plex.account_period_balance b where pcn = 123681 and period = 202103  -- 4,595
	from Plex.accounting_account a   
	left outer join Plex.account_period_balance b 
	on a.pcn=b.pcn 
	and a.account_no=b.account_no 
	and b.period = @anchor_period
	where a.pcn = @pcn 
	and b.pcn is null;
--select count(*) account_period_balance_cnt from Plex.account_period_balance  where period = @anchor_period and pcn = @pcn -- 4,617
--select * 
--from Plex.account_activity_summary
--where pcn = 123681 
--and account_no = '11055-000-9806'

--pcn		period	account_no		beginning_balance	debit		credit			balance			ending_balance
--123681	202311	11055-000-9806	0.00000				0.00000		0.00000			0.00000			0.00000
--123681	202312	11055-000-9806	0.00000				95934.43000	872657.96000	-776723.53000	-776723.53000
--123681	202401	11055-000-9806	-776723.53000		0.00000		95934.43000		-95934.43000	-872657.96000

--pcn		anchor_period	anchor_period_display	period	prev_period	start_open_period	first_period	end_open_period	period
--123681	202311			11-2023					202312	202311		202312				0				202401			202312

while @period <= @end_open_period
begin
--	Make sure there is a summary record for every account and replace null values with 0
	with period_balance(pcn,account_no,period,debit,credit,balance)
	as 
	(
	    select 
	    a.pcn,
	   a.account_no,
		@period period,
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
	    -- select count(*) from Plex.accounting_account where pcn = 123681  -- 4,595/4,363
		from Plex.accounting_account a   
		left outer join Plex.account_activity_summary b 
		on a.pcn=b.pcn 
		and a.account_no=b.account_no 
		and b.period = @period
		where a.pcn = @pcn  
	),
	--select @cnt=count(*) from period_balance;
	account_period_balance(pcn,account_no,period,period_display,debit,ytd_debit,credit,ytd_credit,balance,ytd_balance)
	--,ending_period,ending_ytd_debit,ending_ytd_credit,ending_ytd_balance,next_period)
	as 
	(	
	--select * from Plex.accounting_period ap where pcn = 300758
		select b.pcn,b.account_no,b.period,ap.period_display,
		b.debit,
		cast(
		    case 
		    when (@first_period=0) then p.ytd_debit + b.debit 
		    when (@first_period=1) and (a.revenue_or_expense = 1) then b.debit 
		    when (@first_period=1) and (a.revenue_or_expense = 0) then p.ytd_debit + b.debit 
		    end as decimal(19,5) 
		) ytd_debit, 
		b.credit,
		cast(
		    case 
		    when (@first_period=0) then p.ytd_credit + b.credit 
		    when (@first_period=1) and (a.revenue_or_expense = 1) then b.credit 
		    when (@first_period=1) and (a.revenue_or_expense = 0) then p.ytd_credit + b.credit 
		    end as decimal(19,5) 
		) ytd_credit, 
		b.balance,
		cast(
		    case 
		    when (@first_period=0) then p.ytd_balance + b.balance 
		    when (@first_period=1) and (a.revenue_or_expense = 1) then b.balance 
		    when (@first_period=1) and (a.revenue_or_expense = 0) then p.ytd_balance + b.balance 
		    end as decimal(19,5) 
		) ytd_balance
		from period_balance b  -- will contain all the accounts labled with just one period
		inner join Plex.account_period_balance p
		on b.pcn = p.pcn 
		and b.account_no = p.account_no 
		and b.period = @period
		and p.period=@prev_period
		inner join Plex.accounting_period ap 
		on b.pcn=ap.pcn 
		and b.period=ap.period 
		and ap.ordinal = 1
		inner join Plex.accounting_account_year_category_type a
		on p.pcn = a.pcn 
		and p.account_no =a.account_no
		and (p.period/100)=a.[year]
	)
--	select @period, count(*)  from account_period_balance;  -- 4,363
	insert into Plex.account_period_balance
	select pcn,account_no,period,period_display,debit,ytd_debit,credit,ytd_credit,balance,ytd_balance from account_period_balance;  -- 4,363

--pcn		anchor_period	anchor_period_display	period	prev_period	start_open_period	first_period	end_open_period	max_fiscal_period
--123681	202311			11-2023					202312	202311		202312				0				202401			202312
	
	set @prev_period = @period
	
    if @period < @max_fiscal_period 
    begin 
	    set @period=@period+1
	end 
	else 
	begin 
		set @period=((@period/100 + 1)*100) + 1 
	end 
		
	select @max_fiscal_period=m.max_fiscal_period
	from Plex.max_fiscal_period_view m 
	where m.pcn = @pcn 
	and m.year = @period/100
	
--	select m.max_fiscal_period
--	from Plex.max_fiscal_period_view m 
--	where m.pcn = 123681 
--	and m.year = 2024 -- 202412

	if @period%100 = 1 
	begin
		set @first_period=1;
	end 
	else 
	begin 
		set @first_period=0;
	end
--	select @period period,@end_open_period end_open_period,@prev_period previous_period,@max_fiscal_period max_fiscal_period,@first_period first_period;
		
end 
	
end;

create procedure Plex.account_period_balance_delete_open_period_range
(
	@pcn int
)
as 
begin
	-- debug variable;
--	declare @pcn int;
--	set @pcn = 123681;

	declare @start_open_period int;
	declare @end_open_period int;
	select @start_open_period=start_open_period,@end_open_period=end_open_period 
	from Plex.accounting_period_ranges where pcn = @pcn
--	SELECT @pcn pcn, @start_open_period start_open_period, @end_open_period end_open_period
	delete from Plex.account_period_balance 
	WHERE pcn = @pcn 
	and period between @start_open_period and @end_open_period

end; -- Plex.account_period_balance_delete_open_period_range;

create procedure Plex.accounting_start_period_update
as
begin 
	declare @start_period int;
	declare @end_period int;
	declare @pcn int;
	declare @diff_count int;
	declare @new_start_period int;
	declare @id int;
	declare @min_id int;
	declare @max_id int;
	select @min_id = min(id),@max_id=max(id) from Plex.accounting_period_ranges r 
	set @id = @min_id;

--	 select @id id, @min_id min_id, @max_id max_id;
	while @id <= @max_id
	BEGIN
		select @pcn = pcn,@start_period=start_period,@end_period=end_period  
		from Plex.accounting_period_ranges r
		where id = @id;
	
		with account_period_diff 
		as 
		(
			select p1.pcn,p1.period,p1.update_date prev_update_date,p2.update_date cur_update_date 
			from Plex.accounting_period p1  
			join Plex.accounting_period p2
			on p1.pcn=p2.pcn 
			and p1.period_key=p2.period_key
			and p1.ordinal = 0
			and p2.ordinal = 1
			where p1.pcn = @pcn 
			and p1.period between @start_period and @end_period
			and p1.update_date <> p2.update_date 
		)
--		 select * from account_period_diff;
		select @diff_count=count(*) from account_period_diff;

		if @diff_count > 0 
		begin 
			select @new_start_period=min(p1.period) 
			from Plex.accounting_period p1  
			join Plex.accounting_period p2
			on p1.pcn=p2.pcn 
			and p1.period_key=p2.period_key
			and p1.ordinal = 0
			and p2.ordinal = 1
			where p1.pcn = @pcn 
			and p1.period between @start_period and @end_period
			and p1.update_date <> p2.update_date 
		end
		else 
		begin
			set @new_start_period = 0
		end
		-- select @diff_count diff_count,@new_start_period new_start_period
		if @diff_count > 0 
		begin 
			update Plex.accounting_period_ranges
			set no_update = 0,
			-- change 
			start_period = @new_start_period
			where pcn = @pcn
		end
		else 
		begin
			update Plex.accounting_period_ranges
			set no_update = 1
			where pcn = @pcn
		end;
--		select @pcn pcn,@new_start_period new_start_period,@id id, @min_id min_id, @max_id max_id;
		set @id = @id + 1;
	end; 
end;

create procedure Plex.account_period_balance_delete_period_range
(
	@pcn int
)
as
begin
	declare @start_period int;
	declare @end_period int;
	select @start_period=start_period,@end_period=end_period 
	from Plex.accounting_period_ranges where pcn = @pcn
--	SELECT @pcn pcn, @start_period start_period, @end_period end_period
	delete from Plex.account_period_balance WHERE pcn = @pcn and period between @start_period and @end_period
end;

-- mgdw.Plex.trial_balance_multi_level definition

-- Drop table

-- DROP TABLE mgdw.Plex.trial_balance_multi_level;

CREATE TABLE mgdw.Plex.trial_balance_multi_level (
	pcn int NULL,
	period int NULL,
	period_display varchar(7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	category_type varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	category_name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	sub_category_name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_no varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	account_name varchar(110) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	current_debit_credit decimal(18,2) NULL,
	ytd_debit_credit decimal(18,2) NULL,
	CONSTRAINT PK__trial_ba__42B3FBF34116C87C PRIMARY KEY (period_display,account_no)
);

-- mgdw.Plex.account_period_balance definition

-- Drop table

-- DROP TABLE mgdw.Plex.account_period_balance;

CREATE TABLE mgdw.Plex.account_period_balance (
	pcn int NULL,
	account_no varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	period int NULL,
	period_display varchar(7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	debit decimal(19,5) NULL,
	ytd_debit decimal(19,5) NULL,
	credit decimal(19,5) NULL,
	ytd_credit decimal(19,5) NULL,
	balance decimal(19,5) NULL,
	ytd_balance decimal(19,5) NULL
);

-- mgdw.Plex.account_activity_summary definition

-- Drop table

-- DROP TABLE mgdw.Plex.account_activity_summary;

CREATE TABLE mgdw.Plex.account_activity_summary (
	pcn int NOT NULL,
	period int NOT NULL,
	account_no varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	beginning_balance decimal(19,5) NULL,
	debit decimal(19,5) NULL,
	credit decimal(19,5) NULL,
	balance decimal(19,5) NULL,
	ending_balance decimal(19,5) NULL,
	CONSTRAINT PK_account_activity_summary PRIMARY KEY (pcn,period,account_no)
);

-- mgdw.Plex.accounting_balance definition

-- Drop table

-- DROP TABLE mgdw.Plex.accounting_balance;

CREATE TABLE mgdw.Plex.accounting_balance (
	pcn int NOT NULL,
	account_key int NOT NULL,
	account_no varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	period int NOT NULL,
	debit decimal(19,5) NULL,
	credit decimal(19,5) NULL,
	balance decimal(19,5) NULL,
	CONSTRAINT PK__accounti__34E7554F34C584AF PRIMARY KEY (pcn,account_key,period)
);

-- mgdw.Plex.accounting_period_ranges definition

-- Drop table

-- DROP TABLE mgdw.Plex.accounting_period_ranges;

CREATE TABLE mgdw.Plex.accounting_period_ranges (
	id int IDENTITY(1,1) NOT NULL,
	pcn int NULL,
	start_period int NULL,
	end_period int NULL,
	start_open_period int NULL,
	end_open_period int NULL,
	no_update bit NULL,
	CONSTRAINT PK__accounti__3213E83FA52AEBCA PRIMARY KEY (id)
);

-- mgdw.Plex.accounting_period definition

-- Drop table

-- DROP TABLE mgdw.Plex.accounting_period;

CREATE TABLE mgdw.Plex.accounting_period (
	pcn int NOT NULL,
	period_key int NOT NULL,
	period int NULL,
	fiscal_order int NULL,
	begin_date datetime NULL,
	end_date datetime NULL,
	period_display varchar(7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	quarter_group tinyint NULL,
	period_status int NULL,
	add_date datetime NULL,
	update_date datetime NULL,
	ordinal int NOT NULL,
	CONSTRAINT IX_accounting_period_pcn_period_no_newest UNIQUE (pcn,period,ordinal),
	CONSTRAINT PK__accounting_period PRIMARY KEY (pcn,period_key,ordinal)
);

-- mgdw.Plex.accounting_account definition

-- Drop table

-- DROP TABLE mgdw.Plex.accounting_account;

CREATE TABLE mgdw.Plex.accounting_account (
	pcn int NOT NULL,
	account_key int NOT NULL,
	account_no varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_name varchar(110) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	active bit NULL,
	category_type varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	category_no_legacy int NULL,
	category_name_legacy varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	category_type_legacy varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	sub_category_no_legacy int NULL,
	sub_category_name_legacy varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	sub_category_type_legacy varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	revenue_or_expense bit NULL,
	start_period int NULL,
	CONSTRAINT PK__accounti__F6D2783F78916262 PRIMARY KEY (pcn,account_key)
);

-- mgdw.Plex.accounting_account_year_category_type definition

-- Drop table

-- DROP TABLE mgdw.Plex.accounting_account_year_category_type;

CREATE TABLE mgdw.Plex.accounting_account_year_category_type (
	id int IDENTITY(1,1) NOT NULL,
	pcn int NULL,
	account_no varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[year] int NULL,
	category_type varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	revenue_or_expense bit NULL,
	CONSTRAINT PK__accounti__3213E83FF126C7A5 PRIMARY KEY (id),
	CONSTRAINT UQ__accounti__22DAE7B5B1F76486 UNIQUE (pcn,account_no,[year])
);

-- mgdw.Plex.Account_Balances_by_Periods definition

-- Drop table

-- DROP TABLE mgdw.Plex.Account_Balances_by_Periods;

CREATE TABLE mgdw.Plex.Account_Balances_by_Periods (
	pcn int NULL,
	revenue decimal(19,5) NULL,
	expense decimal(19,5) NULL,
	amount decimal(19,5) NULL,
	period int NULL,
	Period_Display varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Category_Type varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Category_No int NULL,
	Category_Name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[No] varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Name varchar(110) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Ytd_Debit decimal(18,2) NULL,
	Ytd_Credit decimal(18,2) NULL,
	Current_Debit decimal(18,2) NULL,
	Current_Credit decimal(18,2) NULL,
	Sub_Category_No int NULL,
	Sub_Category_Name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Subtotal_After int NULL,
	Subtotal_Name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
);