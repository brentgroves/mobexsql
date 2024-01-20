-- drop procedure Plex.account_period_balance_recreate_period_range_init()
select 1 into @v1;
select @v1;
CREATE PROCEDURE stored_proc_tutorial.spGetAverageMarks(OUT average DECIMAL(5,2))
BEGIN
    SELECT AVG(total_marks) INTO average FROM studentMarks;
END
CALL stored_proc_tutorial.spGetAverageMarks(@average_marks);
-- Once it is executed, you can run SELECT for the OUT variable, to fetch the result.

SELECT @average_marks;

call Plex.account_period_balance_recreate_period_range_init(@v_min_id);
select @v_min_id;
-- drop procedure Plex.account_period_balance_recreate_period_range_init;
create procedure Plex.account_period_balance_recreate_period_range_init(
	in v_id int,
	out v_pcn int,
	out v_period_start int,
	out v_period int,
	out v_period_end int,
	out v_max_fiscal_period int,
	out v_prev_period int,
	out v_anchor_period int,
	out v_anchor_period_display varchar(7),
	out v_first_period int
)
begin
	select r.pcn into v_pcn
	-- select * from Plex.accounting_balance_update_period_range r
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

	if ((v_period_start%100)!=1) then
		set v_prev_period = v_period_start - 1;
	else
		set v_prev_period = (((v_period_start/100)-1)*100)+12;
	end if;


	set v_anchor_period=v_prev_period;

	select p.period_display into v_anchor_period_display
	from Plex.accounting_period p 
	where p.pcn = v_pcn
	and p.period = v_anchor_period;
	
	if v_period%100 = 1 then
		set v_first_period=1;
	else 
		set v_first_period=0;
	end if;


end;
/*
 * Make a backup
 */
-- select *
-- into Archive.account_period_balance_01_07_2022 -- 160,655 
-- from Plex.account_period_balance b order by pcn,period
-- select count(*) from Archive.account_period_balance_01_26_2022 
-- SET NOCOUNT ON;
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

-- select * from Plex.accounting_balance_update_period_range r

select min(id) into v_min_id from Plex.accounting_balance_update_period_range;  
select max(id) into v_max_id from Plex.accounting_balance_update_period_range; 

-- select v_min_id, v_max_id;

set v_id = v_min_id;

select r.pcn into v_pcn
-- select * from Plex.accounting_balance_update_period_range r
from Plex.accounting_balance_update_period_range r
inner join Plex.max_fiscal_period_view m 
on r.pcn=m.pcn
and (r.period_start div 100) = m.`year`
where id = v_min_id;

select r.period_start into v_period_start
from Plex.accounting_balance_update_period_range r
inner join Plex.max_fiscal_period_view m 
on r.pcn=m.pcn
and (r.period_start div 100) = m.`year`
where id = v_min_id;

set v_period = v_period_start;

select r.period_end into v_period_end
from Plex.accounting_balance_update_period_range r
inner join Plex.max_fiscal_period_view m 
on r.pcn=m.pcn
and (r.period_start div 100) = m.`year`
where id = v_min_id;

select m.max_fiscal_period into v_max_fiscal_period
from Plex.accounting_balance_update_period_range r
inner join Plex.max_fiscal_period_view m 
on r.pcn=m.pcn
and (r.period_start div 100) = m.`year`
where id = v_min_id;


-- select count(*) from Plex.account_period_balance b -- 
-- select distinct pcn,period from Plex.account_period_balance b order by pcn,period
-- delete Plex.account_period_balance where  period between 202102 and 202111
-- delete Plex.account_period_balance where  pcn = 300758
-- Another procedure should have already run to delete the Plex.account_period_balance
-- records that are in the Plex.accounting_balance_update_period_range table.
 
select max(b.period) into v_prev_period
from Plex.account_period_balance b
where b.pcn = v_pcn;

set v_anchor_period=v_prev_period;

select p.period_display into v_anchor_period_display
from Plex.accounting_period p 
where p.pcn = v_pcn
and p.period = v_anchor_period;

if v_period%100 = 1 then
	set v_first_period=1;
else 
	set v_first_period=0;
end if;

select v_min_id, v_max_id, v_pcn, v_period, v_period_start, v_period_end, v_max_fiscal_period,v_prev_period,v_anchor_period
,v_anchor_period_display,v_first_period;

-- select concat('v_min_id ' , cast(v_min_id as char));

end;
