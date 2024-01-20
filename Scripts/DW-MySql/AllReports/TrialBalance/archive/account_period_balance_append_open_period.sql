select count(*) from Plex.account_period_balance apb -- 157,283,148,998/140,713/100,365 132,428,123,659,131,900, 123,615
select count(*) 
from Plex.account_period_balance apb 
where pcn=123681
and period = 202207  -- 4,617
and period = 202206  -- 4,617
-- select distinct pcn,period from Scratch.account_period_balance order by pcn,period  -- 41,293
select distinct pcn,period from Plex.account_period_balance order by pcn,period  -- 41,293

-- drop procedure Scratch.account_period_balance_append_open_period;

select * from Plex.account_period_balance apb where pcn = 123681 and period = 202207
-- call Plex.account_period_balance_delete_open_period
call Plex.account_period_balance_append_open_period();
delete from Plex.account_period_balance where period = 202207 
-- drop procedure Plex.account_period_balance_append_open_period
create procedure Plex.account_period_balance_append_open_period()
begin
declare v_pcn int;
declare v_id int;
declare v_min_id int;
declare v_max_id int;
declare v_open_period int;
declare v_period_end int;
declare v_first_period int;
declare v_cnt int;

select min(id) into v_min_id from Plex.accounting_balance_update_period_range; 
select max(id) into v_max_id from Plex.accounting_balance_update_period_range;
set v_id = v_min_id;

SELECT pcn into v_pcn
FROM Plex.accounting_balance_update_period_range 
where id=v_id;

SELECT open_period into v_open_period
FROM Plex.accounting_balance_update_period_range 
where id=v_id;

SELECT period_end into v_period_end
FROM Plex.accounting_balance_update_period_range 
where id=v_id;

if v_open_period%100 = 1 then
	set v_first_period=1;
else 
	set v_first_period=0;
end if;

-- select v_pcn pcn,v_open_period open_period,v_period_end period_end,v_first_period first_period;

while v_id <= v_max_id do 
  -- Add/Init missing accounting_account_summary_open_period records to 0 values.
-- select * from Plex.account_period_balance apb limit 1
  insert into Plex.account_period_balance(pcn,account_no,period,period_display,debit,ytd_debit,credit,ytd_credit,balance,ytd_balance)
  with open_period_balance(pcn,account_no,period,debit,credit,balance)
  as 
  (
    select 
    a.pcn,
    a.account_no,
    v_open_period period,
    case 
    when o.debit is null then 0 
    else o.debit 
    end debit,
    case 
    when o.credit is null then 0 
    else o.credit 
    end credit,
    case 
    when o.balance is null then 0 
    else o.balance 
    end balance
      -- select count(*) from Plex.accounting_account where pcn = 123681  -- 4,595/4,363
    from Plex.accounting_account a   
    left outer join Plex.accounting_account_summary_open_period o 
    on a.pcn=o.pcn 
    and a.account_no=o.account_no 
    and o.period = v_open_period
    where a.pcn = v_pcn  
  )
  select op.pcn,op.account_no,op.period,ap.period_display,
  op.debit,
  cast(
    case 
    when (v_first_period=0) then pb.ytd_debit + op.debit 
    when (v_first_period=1) and (a.revenue_or_expense = 1) then op.debit 
    when (v_first_period=1) and (a.revenue_or_expense = 0) then pb.ytd_debit + op.debit 
    end as decimal(19,5) 
  ) ytd_debit, 
  op.credit,
  cast(
    case 
    when (v_first_period=0) then pb.ytd_credit + op.credit 
    when (v_first_period=1) and (a.revenue_or_expense = 1) then op.credit 
    when (v_first_period=1) and (a.revenue_or_expense = 0) then pb.ytd_credit + op.credit 
    end as decimal(19,5) 
  ) ytd_credit, 
  op.balance,
  cast(
    case 
    when (v_first_period=0) then pb.ytd_balance + op.balance 
    when (v_first_period=1) and (a.revenue_or_expense = 1) then op.balance 
    when (v_first_period=1) and (a.revenue_or_expense = 0) then pb.ytd_balance + op.balance 
    end as decimal(19,5) 
  ) ytd_balance
  from Plex.account_period_balance pb 
  join open_period_balance op
  on pb.pcn=op.pcn 
  and pb.account_no=op.account_no
  and pb.period=v_period_end 
  and op.period=v_open_period
  inner join Plex.accounting_period ap 
  on op.pcn=ap.pcn 
  and op.period=ap.period 
  and ap.ordinal = 1
  inner join Plex.accounting_account_year_category_type a
  on pb.pcn = a.pcn 
  and pb.account_no =a.account_no
  and a.`year` = (v_period_end div 100);
  -- init next pcn
  set v_id=v_id+1;
  if v_id <= v_max_id then 
    SELECT pcn into v_pcn
    FROM Plex.accounting_balance_update_period_range 
    where id=v_id;

    SELECT open_period into v_open_period
    FROM Plex.accounting_balance_update_period_range 
    where id=v_id;

    SELECT period_end into v_period_end
    FROM Plex.accounting_balance_update_period_range 
    where id=v_id;

    if v_open_period%100 = 1 then
      set v_first_period=1;
    else 
      set v_first_period=0;
    end if;
-- select v_pcn pcn,v_open_period open_period,v_period_end period_end,v_first_period first_period;
  end if;
end while;
end; 
-- init accounts not in accounting_account_summary_open_period to zero

-- calc ytd totals using period_end
