-- call Plex.sp_accounting_balance_update_start_period()
-- drop procedure Plex.sp_accounting_balance_update_start_period

create procedure Plex.sp_accounting_balance_update_start_period() 
begin 
	declare v_period_start int;
	declare v_pcn int;
	declare v_id int;
	declare v_min_id int;
	declare v_max_id int;
	select min(id),max(id) into v_min_id,v_max_id from Plex.accounting_balance_update_period_range; 
	set v_id := v_min_id;
-- 	select v_id id, v_min_id min_id, v_max_id max_id;
	while v_id <= v_max_id do
		select pcn into v_pcn 
		from Plex.accounting_balance_update_period_range r
		where id = v_id;
	
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
			where p1.pcn = v_pcn 
			and p1.update_date <> p2.update_date 
		)
		-- select * from account_period_diff;
		,new_start_period
		as 
		( 
			select min(period) period_start 
			from account_period_diff 
			group by pcn 
		)
		-- select * from new_start_period;
		select period_start into v_period_start from new_start_period;
		if v_period_start is not null then 
			update Plex.accounting_balance_update_period_range
			set no_update = 0,
			period_start = v_period_start
			where pcn = v_pcn;
		else 
			update Plex.accounting_balance_update_period_range
			set no_update = 1
			where pcn = v_pcn;
		end if;
	
-- 		select v_pcn pcn,v_period_start period_start,v_id id, v_min_id min_id, v_max_id max_id;
		set v_id = v_id + 1;
	end while; 
end;


select * from Plex.accounting_balance_update_period_range



select *
from Plex.accounting_period_2 ap 
