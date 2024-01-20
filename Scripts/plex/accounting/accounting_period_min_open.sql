accounting_period_min_open

/*
Don't know if 2 periods can be open at the same time even for a short time.
select distinct period_status from accounting_v_period_e ap (0,1)
*/


;with open_period
as 
(
  --select plexus_customer_no pcn,period  
  select  *
  from accounting_v_period_e ap
  where ap.plexus_customer_no = 123681
  and ap.period_status = 1  
)
,min_open_period
as 
(
  select plexus_customer_no,min(period) period
  from open_period
  group by plexus_customer_no
)
-- select * from min_open_period
,last_closed_before_min_open_period
as 
(
select plexus_customer_no,period,
case
when (period%100)=1 then (((period/100)-1)*100)+12
else period-1
end prev_period
from min_open_period mop
)
select * from last_closed_before_min_open_period



/*

,fiscal_period(pcn,year,period)
as
(
	select ap.plexus_customer_no pcn,year(begin_date) year,period 
	from accounting_v_period ap --where pcn = 123681
  where ap.plexus_customer_no = 123681

)
-- select * from fiscal_period
,max_fiscal_period(pcn,year,max_fiscal_period)
as
(
  SELECT pcn,year,max(period) max_fiscal_period
  FROM fiscal_period
  group by pcn,year
)
-- select count(*) cnt from max_fiscal_period
-- select * from max_fiscal_period;

select * from Plex.accounting_period order by pcn,period
select distinct pcn from Plex.accounting_period

select  *
from accounting_v_period_e ap
group by plexus_customer_no
  and begin_date between '01/01/2022' and '07/30/2022' 
order by ap.plexus_customer_no,period desc

*/