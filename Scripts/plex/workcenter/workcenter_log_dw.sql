/*
	PCN
	310507/Avilla
	300758/Albion
	295933/Franklin
	300757/Alabama
	306766/Edon
	312055/ BPG WorkHolding
	1	123681 / Southfield
2	295932 FruitPort
3	295933
4	300757
5	300758
6	306766
7	310507
8	312055
	*/
/*
create PCN table from param
*/
create table #list
(
 tuple int
)
declare @delimiter varchar(1)
set @delimiter = ','
declare @in_string varchar(max)
set @in_string = @PCNList
WHILE LEN(@in_string) > 0
BEGIN
    INSERT INTO #list
    SELECT cast(left(@in_string, charindex(@delimiter, @in_string+',') -1) as int) as tuple

    SET @in_string = stuff(@in_string, 1, charindex(@delimiter, @in_string + @delimiter), '')
end;
--select tuple from #list

select wl.plexus_customer_no, wl.log_key,wl.workcenter_key,wl.log_date,wl.log_hours
,ws.description ws_status
,wl.workcenter_event_key
,we.description ws_status_type
,wl.add_by,wl.update_date,wl.part_key,wl.part_operation_key,wl.shift_key
,wl.job_op_key,wl.report_date
from part_v_workcenter_log_e wl  -- many records

join  part_v_Workcenter_Status_e ws
on wl.plexus_customer_no=ws.plexus_customer_no
and wl.workcenter_status_key=ws.workcenter_status_key

join part_v_Workcenter_Event_e  we -- 32 rows
on wl.plexus_customer_no=we.plexus_customer_no
and wl.workcenter_event_key=we.workcenter_event_key

join Plexus_Control_v_Customer_Group_Member cg 
on ws.plexus_customer_no=cg.plexus_customer_no
where wl.plexus_customer_no in (
select tuple from #list
)
and wl.log_date > '06/20/2022'
and ws.description like '%unplanned%'

order by wl.plexus_customer_no, wl.workcenter_key,wl.log_date