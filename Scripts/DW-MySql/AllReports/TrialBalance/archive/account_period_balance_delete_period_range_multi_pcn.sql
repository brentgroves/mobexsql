select * from Plex.accounting_balance_update_period_range

CREATE PROCEDURE Plex.account_period_balance_delete_period_range()
BEGIN   
	declare start_id int;
	declare end_id int;
	declare cur_id int;
	declare cur_pcn int;
	declare cur_period_start int;
	declare cur_period_end int;

	select min(id) into start_id from Plex.accounting_balance_update_period_range;
	select max(id) into end_id from Plex.accounting_balance_update_period_range;
 	set cur_id=start_id;
 	select start_id,end_id,cur_id;
	while cur_id <= end_id
	do
		select pcn into cur_pcn from Plex.accounting_balance_update_period_range where id = cur_id;
 		select period_start into cur_period_start from Plex.accounting_balance_update_period_range where id = cur_id;
 		select period_end into cur_period_end from Plex.accounting_balance_update_period_range where id = cur_id;
 		select cur_pcn,cur_period_start,cur_period_end,cur_id;
		delete from Plex.account_period_balance WHERE pcn = cur_pcn and period between cur_period_start and cur_period_end;
		set cur_id = cur_id + 1;
    END WHILE; 
END; 

call Plex.account_period_balance_delete_period_range()

select * from Plex.accounting_balance_update_period_range

select distinct pcn,period from Plex.accounting_balance  order by pcn,period  --, 200812 to 202204
select count(*) from Plex.account_period_balance apb -- 140,713/ 132,428,123,659,131,900, 123,615
