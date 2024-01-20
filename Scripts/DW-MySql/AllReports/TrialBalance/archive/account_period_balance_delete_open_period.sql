drop table 

select count(*) from Plex.account_period_balance apb -- 157,283,148,998/140,713/100,365 132,428,123,659,131,900, 123,615
where period = 202207
select count(*) 
from Plex.account_period_balance apb 
where pcn=123681
and period = 202207  -- 4,617
and period = 202206  -- 4,617

select count(*) 
from Plex.account_period_balance apb 
where pcn=300758
and period = 202207  -- 3,668
and period = 202206  -- 3,668

-- select distinct pcn,period from Scratch.account_period_balance order by pcn,period  -- 41,293
select distinct pcn,period from Plex.account_period_balance order by pcn,period  -- 41,293

31008

call Plex.account_period_balance_delete_open_period(123681)
-- delete from Plex.account_period_balance where period = 202207 
-- drop procedure Plex.account_period_balance_delete_open_period
create procedure Plex.account_period_balance_delete_open_period
( 
	in v_pcn int
)
begin
declare v_open_period int;

SELECT open_period into v_open_period
FROM Plex.accounting_balance_update_period_range 
where pcn=v_pcn;

-- select v_pcn pcn, v_open_period open_period;

delete from Plex.account_period_balance 
where pcn=v_pcn
and period=v_open_period;

end; -- Plex.account_period_balance_delete_open_period
-- init accounts not in accounting_account_summary_open_period to zero

-- calc ytd totals using period_end

CREATE DEFINER=`root`@`%` PROCEDURE `Plex`.`account_period_balance_delete_open_period`()
begin
declare v_pcn int;
declare v_id int;
declare v_min_id int;
declare v_max_id int;
declare v_open_period int;
declare v_cnt int;

select min(id) into @v_min_id from Plex.accounting_balance_update_period_range;
select max(id) into @v_max_id from Plex.accounting_balance_update_period_range; 
select @v_min_id into @v_id;

SELECT pcn into @v_pcn
FROM Plex.accounting_balance_update_period_range 
where id=@v_id;

SELECT open_period into @v_open_period
FROM Plex.accounting_balance_update_period_range 
where id=@v_id;

select @v_id,@v_min_id,@v_max_id,@v_pcn,@v_open_period; 


while v_id <= v_max_id do
	delete from Plex.account_period_balance 
	where pcn=v_pcn
	and period=v_open_period;
	set v_id=v_id+1;
end while;
end;

