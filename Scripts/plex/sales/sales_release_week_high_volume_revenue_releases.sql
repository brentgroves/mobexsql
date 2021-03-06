-- Reports: SalesReleaseVolumeRevenue
-- release_status: Any 
-- release_type: Any. 
-- Quantity shipped: from sales_release.quantity_shipped field.
-- Revenue and Volume: shipper_status='Shipped'
-- Primary Key: year_week,year_week_fmt,start_week,end_week,customer_no,part_key 
-- Order: customer_code,part_no,year_week
--//////////////////////////////////////////////////////////
--Check Parameters
--/////////////////////////////////////////////////////////
--SELECT DATEADD(YEAR,-2,GETDATE()) 
IF @Start_Date < DATEADD(YEAR,-5,GETDATE())
BEGIN
  --PRINT 'ERROR'
  RETURN
END


IF @End_Date > DATEADD(YEAR,5,GETDATE())
BEGIN
  --PRINT 'ERROR'
  RETURN
END


IF DATEDIFF(year, @End_Date,@Start_Date) > 1 
BEGIN
  --PRINT 'ERROR'
  RETURN
END



Declare @start_year char(4)
Declare @start_week int
Declare @end_year char(4)
Declare @end_week int
Declare @start_of_week_for_start_date datetime
Declare @end_of_week_for_end_date datetime

set @start_year = DATEPART(YEAR,@Start_Date)
set @start_week = DATEPART(WEEK,@Start_Date)
set @end_year = DATEPART(YEAR,@End_Date)
set @end_week = DATEPART(WEEK,@End_Date)


if DATEPART(WEEK,@Start_Date) = 1
set @start_of_week_for_start_date = datefromparts(DATEPART(YEAR,@Start_Date), 1, 1)
else
set @start_of_week_for_start_date = DATEADD(wk, DATEDIFF(wk, 6, '1/1/' + @start_year) + (@start_week-1), 6)  --start of week
--select DATEPART(WEEK,@End_Date)
--select DATEPART(MONTH,DATEADD(wk, DATEDIFF(wk, 5, '1/1/' + CONVERT(varchar, DATEPART(YEAR,@End_Date))) + (DATEPART(WEEK,@End_Date)-1), 5))
if DATEPART(WEEK,@End_Date) > 51 and  (  DATEPART(MONTH,DATEADD(wk, DATEDIFF(wk, 5, '1/1/' + CONVERT(varchar, DATEPART(YEAR,@End_Date))) + (DATEPART(WEEK,@End_Date)-1), 5))   =1)
set @end_of_week_for_end_date = DATEADD(second,-1,convert(datetime,DATEADD(day, 1,datefromparts(DATEPART(YEAR,@End_Date), 12, 31))))
else
set @end_of_week_for_end_date = DATEADD(second,-1,DATEADD(day,1,DATEADD(wk, DATEDIFF(wk, 5, '1/1/' + @end_year) + (@end_week-1), 5)))  --end of week

--/* testing 0
--select @start_of_week_for_start_date, @end_of_week_for_end_date
--*/ end testing 0 


--@Start_Date must be less at least 2 weeks for comparison to make sense
IF @start_of_week_for_start_date > @end_of_week_for_end_date
BEGIN
  RETURN
END

/* 
--This must be hard coded since plex sde does not allow dynamic queries
-- These are the top 20 revenu parts
--	top 20 part revenue from 20200101 to 20200303
	part_no	part_key	revenue
1	H2GC 5K652 AB	2684943	1770503.43
2	H2GC 5K651 AB	2684942	1766723.02
3	10103353_Rev_A	2794731	1134512.64
4	10103355_Rev_A	2794706	1133359.68
5	AA96128_Rev_B	2793953	760716.65
6	727110F	2807625	470113.32
7	10103357_Rev_A	2794748	343601.28
8	10103358_Rev_A	2794752	334984.32
9	A52092_Rev_T	2794182	277641.60
10	10103353CX_Rev_A	2820236	264720.00
11	68400221AA_Rev_08	2811382	259226.38
12	18190-RNO-A012-S10_Rev_02	2800943	256015.20
13	10103355CX_Rev_A	2820251	240986.88
14	R558149_Rev_E	2793937	214091.68
15	A92817_Rev_B	2794044	202662.00
16	R559324RX1_Rev_A	2795919	191594.72
17	10046553_Rev_N	2795866	167388.48
18	26088054_Rev_07B	2803944	158389.50
19	2017707_Rev_J	2795740	149811.84
20	2017710_Rev_J	2795739	148435.20

*/

create table #filter
(
  part_key int
)
--When does the sum of high revenue parts roughly equal 'other' parts?
--best match revenue @separator = 7 , top 7 aprox = sum of all other parts.
--When does the sum of volume of these high revenue parts roughly equal 'other' parts?
--best match volume @separator = 20
insert into #filter (part_key)
(
select 2684943 as part_key  --1
union
select 2684942	as part_key  --2
union
select 2794731	as part_key  --3
union
select 2794706	as part_key  --4
union
select 2793953	as part_key  --5
union
select 2807625	as part_key  --6
union
select 2794748	as part_key  --7
union
select 2794752	as part_key  --8
union
select 2794182	as part_key  --9
union
select 2820236	as part_key  --10
union
select 2811382	as part_key  --11
union
select 2800943	as part_key  --12
union
select 2820251	as part_key  --13
union
select 2793937	as part_key  --14
union
select 2794044	as part_key  --15
union
select 2795919	as part_key  --16
union
select 2795866	as part_key  --17
union
select 2803944	as part_key  --18
union
select 2795740	as part_key  --19
union
select 2795739	as part_key  --20
)
--select * from #filter

/*
primary_key: Determine primary key of result set.
*/
create table #primary_key
(
  primary_key int,
  year_week int,
  year_week_fmt varchar(20),
  start_week datetime,
  end_week datetime,
  part_key int
)
/*
Use the ???Forecast??? sales release to calculate current and future week revenue. 
You must filter for release type = ???Forecast??? in this case since there are ???ship_schedule??? 
sales release items that you do not want to include in this estimate.  The idea is that the 
future weeks sum of ???Forecast??? sales release should be a good estimate of what the quantity_shipped sum will equal.    

Use ???Ship_schedule??? sales release to calculate revenue for previous weeks revenue; Since all sales releases with 
a shipped_quantity are of type ???ship_schedule??? you do not need to check the sales release type only sum the quantity_shipped. 
*/

insert into #primary_key(primary_key,year_week,year_week_fmt,start_week,end_week,part_key)
(
  select 
  --top 10
  ROW_NUMBER() OVER (
    ORDER BY year_week,part_key
  ) primary_key,
  year_week,
  year_week_fmt,
  start_week,
  end_week,
  part_key

    --FORMAT ( pk.start_week, 'd', 'en-US' ) start_week, 
		--FORMAT ( pk.end_week, 'd', 'en-US' ) end_week, 
--    DATEADD(wk, DATEDIFF(wk, 6, '1/1/' + CONVERT(varchar, year)) + (week-1), 6) start_week, 
--    DATEADD(wk, DATEDIFF(wk, 5, '1/1/' + CONVERT(varchar, year)) + (week-1), 5) end_week, 

  from 
  (
    select
    --BUG: THIS WAS SR.SHIP_DATE SHOULD BE SH.SHIP_DATE
    --DATEPART(YEAR,DATEADD(wk, DATEDIFF(wk, 6, '1/1/' + CONVERT(varchar, DATEPART(YEAR,sr.ship_date))) + (DATEPART(WEEK,sr.ship_date)-1), 6)) * 100 + 
    --DATEPART(isowk,DATEADD(wk, DATEDIFF(wk, 6, '1/1/' + CONVERT(varchar, DATEPART(YEAR,sr.ship_date))) + (DATEPART(WEEK,sr.ship_date)-1), 6)) year_week,
    DATEPART(YEAR,sr.ship_date) * 100 + DATEPART(WEEK,sr.ship_date) year_week,
    case     
    when DATEPART(WEEK,sr.ship_date) < 10 then convert(varchar,DATEPART(YEAR,sr.ship_date)) +'-0' + convert(varchar,DATEPART(WEEK,sr.ship_date)) + ' (Release)'
    else 
    convert(varchar,DATEPART(YEAR,sr.ship_date)) +'-' + convert(varchar,DATEPART(WEEK,sr.ship_date)) + ' (Releases)'
    end year_week_fmt,

    case 
    when DATEPART(WEEK,sr.ship_date) = 1 then datefromparts(DATEPART(YEAR,sr.ship_date), 1, 1)
    else DATEADD(wk, DATEDIFF(wk, 6, '1/1/' + CONVERT(varchar, DATEPART(YEAR,sr.ship_date))) + (DATEPART(WEEK,sr.ship_date)-1), 6) 
    end start_week, 
    case                                                        
    when DATEPART(WEEK,sr.ship_date) > 51 and  (DATEPART(MONTH,DATEADD(wk, DATEDIFF(wk, 5, '1/1/' + CONVERT(varchar, DATEPART(YEAR,sr.ship_date))) + (DATEPART(WEEK,sr.ship_date)-1), 5))=1)  then DATEADD(second,-1,convert(datetime,DATEADD(day, 1,datefromparts(DATEPART(YEAR,sr.ship_date), 12, 31))))
    else DATEADD(second,-1,DATEADD(day, 1,DATEADD(wk, DATEDIFF(wk, 5, '1/1/' + CONVERT(varchar, DATEPART(YEAR,sr.ship_date))) + (DATEPART(WEEK,sr.ship_date)-1), 5)))
    end end_week,
    pl.part_key
    from sales_v_release sr
    inner join sales_v_release_type rt
    on sr.release_type_key=rt.release_type_key  --1 to 1
    inner join sales_v_release_status rs
    on sr.release_status_key = rs.release_status_key  --1 to 1
    inner join sales_v_po_line pl --1 to 1
    on sr.po_line_key=pl.po_line_key 
    inner join sales_v_po po  -- 1 to 1
    on pl.po_key = po.po_key  
    where sr.ship_date between @start_of_week_for_start_date and @end_of_week_for_end_date
    and pl.part_key in (select * from #filter)
    and rt.release_type ='Forecast'
    and rs.release_status != 'Canceled'
  )s1 
  group by year_week,year_week_fmt,start_week,end_week,part_key

)
--select * from #primary_key  --26
/*
1	2684943
2	2684942
3	2794706
4	2794731
5	2793953
6	2807625
7	2794748
8	2794752
--2684943,2684942,2794731,2794706,2793953,2807625,2794748,2794752
*/
--select * from #primary_key


--select count(*) #primary_key from #primary_key  --169
--select top(1) * from #primary_key


--Use this set to calculate volume shipped and revenue.
--Although shipped is calculated from sales_release.quantity_shipped column
-- The revenue can only be calculated from the shipper_line since it has
-- the price that we charged customer.
-- select * from sales_v_shipper_status
-- 	shipper_status_key	shipper_status	active
--	90	Open	1
--	91	Shipped	0
--	92	Canceled	0
--	93	Pending	1  --??

--2684943,2684942,2794731,2794706,2793953,2807625,2794748,2794752
    --1/1/2020-5/1/2020 - Open sales release items {4325}

create table #set2group
(
  primary_key int,
  quantity decimal (18,3),  
  price decimal (18,6)
)

insert into #set2group (primary_key,quantity,price)
(
  select 
  pk.primary_key,
  sl.quantity,
  sl.price
  from
  (
    select
    DATEPART(YEAR,sr.ship_date) * 100 + DATEPART(WEEK,sr.ship_date) year_week,
    pl.part_key,
    sr.quantity,
    pr.price
    from sales_v_release sr
    inner join sales_v_release_type rt
    on sr.release_type_key=rt.release_type_key  --1 to 1
    inner join sales_v_release_status rs
    on sr.release_status_key = rs.release_status_key  --1 to 1
    inner join sales_v_po_line pl --1 to 1
    on sr.po_line_key=pl.po_line_key 
    inner join sales_v_po po  -- 1 to 1
    on pl.po_key = po.po_key  
    inner join sales_v_price pr
    on pl.po_line_key=pr.po_line_key
    where sr.ship_date between @start_of_week_for_start_date and @end_of_week_for_end_date
    and pl.part_key in (select * from #filter)
    and rt.release_type ='Forecast'
    and rs.release_status != 'Canceled'
  )sl
  inner join #primary_key pk
  on pk.year_week=sl.year_week
  and pk.part_key=sl.part_key

)
--select top(100) * from #set2group
--order by primary_key

/*
--select release_type from sales_v_release_type
 	release_type
1	Forecast
2	Pull Signal
3	Ship Schedule
4	Planned
5	Spot Buy
*/
/*
--select release_status from sales_v_release_status
 	release_status
1	Canceled
2	Closed
3	Hold
4	Open
5	Open - Scheduled
6	Scheduled
7	Staged
*/

--select count(*) #set2groupC from #set2group  --324
--select top(100) * from #set2group
create table #volume_revenue
(
  primary_key int,
  volume  decimal (18,3),   
  revenue decimal (18,6)
  
)


--isert top 5 revenue parts.
insert into #volume_revenue (primary_key,volume,revenue)
(

  select 
  --sc.*
  pk.primary_key,
  sum(gr.quantity) volume,
  sum(gr.price*gr.quantity) revenue
  from #primary_key pk  
  inner join #set2group gr
  on pk.primary_key=gr.primary_key
  group by pk.primary_key

)

--select count(*) #volume_revenue from #volume_revenue  --83
--select top(100) * from #volume_revenue


/*
Final set: Join of all intermediate sets.
*/

create table #sales_release_week_high_volume_revenue_releases
(
  primary_key int,
  part_key int,
--  revenue_rank int,  Plex does not allow dynamic queries.
  year_week int,
  year_week_fmt varchar(20),
  start_week datetime,
  end_week datetime,
  part_no varchar (113),
  volume decimal,
  revenue decimal(18,2)
)


insert into #sales_release_week_high_volume_revenue_releases (primary_key,part_key,year_week,year_week_fmt,start_week,end_week,part_no,volume,revenue)
(
  select
  primary_key,
  part_key,
--  ROW_NUMBER() OVER (PARTITION BY year_week ORDER BY revenue DESC),
  year_week,
  year_week_fmt,
  start_week,
  end_week,
  part_no,
  volume,
  revenue
  from
  (
    select 
    pk.primary_key,
    pk.part_key,
    pk.year_week,
    pk.year_week_fmt,
    pk.start_week,
    pk.end_week,
    case 
    when p.revision = '' then p.part_no
    else p.part_no + '_Rev_' + p.revision 
    end part_no, 
    case
      when vr.volume is null then 0
      else vr.volume
    end volume, 
    case
      when vr.revenue is null then 0
      else vr.revenue
    end revenue
    from #primary_key pk
    inner join part_v_part p -- 1 to 1
    on pk.part_key=p.part_key 
    inner join #volume_revenue vr
    on pk.primary_key=vr.primary_key
  )s1
  
)

--select count(*) #sales_release_week_high_volume_revenue from #sales_release_week_high_volume_revenue
--select top(100) * from #sales_release_weekly 
--where qty_loaded > 0

select
*
--distinct part_key
from #sales_release_week_high_volume_revenue_releases
--order by revenue desc
order by year_week,part_no

--revenue
--2971958
--2309176
--volume
--94062
--240414

--order by primary_key


--insert into #sales_release_weekly (primary_key,customer_code,part_no,year_week,year_week_fmt,start_week,end_week,rel_qty,shipped,short)
--exec sproc300758_11728751_1681704 @Start_Date,@End_Date
--sales_release_diff_v2