
select * from Plex.accounting_balance_update_period_range
set @pcn := 123681;
call Plex.accounting_balance_get_period_range(@pcn,@period_start,@period_end,@open_period,@no_update);
select @period_start period_start,@period_end period_end,@open_period,@no_update;
-- drop procedure Plex.accounting_balance_get_period_range
create procedure Plex.accounting_balance_get_period_range
(	
	IN v_pcn int,
	OUT v_period_start int,
	OUT v_period_end int,
	OUT v_open_period int,
	out v_no_update bit
)
BEGIN   
	select period_start,period_end,open_period,no_update into v_period_start,v_period_end,v_open_period,v_no_update 
	from Plex.accounting_balance_update_period_range
	WHERE pcn=v_pcn;
	
END; 

    declare @period_start_out int; 
    declare @period_end_out int;
    EXEC Plex.accounting_balance_get_period_range @pcn = ?,@period_start = @period_start_out OUTPUT,@period_end = @period_end_out OUTPUT;
    SELECT @period_start_out AS period_start, @period_end_out as period_end;

   	set @pcn := 123681;
	call Plex.accounting_balance_get_period_range(@pcn,@period_start,@period_end);
	select @period_start period_start,@period_end period_end;

   
    plsql = """\
	call Plex.accounting_balance_get_period_range(@pcn = ?,@period_start,@period_end);
	select @period_start period_start,@period_end period_end;
    """
