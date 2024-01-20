select * 
-- select count(*)
from Plex.accounting_account_summary_open_period  -- 313

-- call Plex.accounting_account_summary_delete_open_period()
-- drop procedure Plex.accounting_account_summary_delete_open_period
create procedure Plex.accounting_account_summary_delete_open_period()
BEGIN   
	declare start_id int;
	declare end_id int;
	declare cur_id int;
	declare cur_pcn int;
	declare cur_period_start int;
	declare cur_period_end int;
	declare cur_open_period int;

	select min(id) into start_id from Plex.accounting_balance_update_period_range;
	select max(id) into end_id from Plex.accounting_balance_update_period_range;
 	set cur_id=start_id;
 	-- select start_id,end_id,cur_id;
	while cur_id <= end_id
	do
		-- could change this to a procedure with output parameters.
		select pcn into cur_pcn from Plex.accounting_balance_update_period_range where id = cur_id;
 		select period_start into cur_period_start from Plex.accounting_balance_update_period_range where id = cur_id;
 		select period_end into cur_period_end from Plex.accounting_balance_update_period_range where id = cur_id;
 		select open_period into cur_open_period from Plex.accounting_balance_update_period_range where id = cur_id;
 	-- select * from Plex.accounting_balance_update_period_range;
	
--  		select cur_pcn,open_period;
		delete from Plex.accounting_account_summary_open_period WHERE pcn = cur_pcn and period = cur_open_period;
		set cur_id = cur_id + 1;
    END WHILE; 
END; 

select * from Plex.accounting_balance_update_period_range
