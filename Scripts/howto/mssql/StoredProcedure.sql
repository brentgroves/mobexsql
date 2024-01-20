select * from Plex.accounting_balance_update_period_range

DECLARE @pcn INT;
declare @period_start int; 
declare @period_end int;
set @pcn = 123681;

EXEC Plex.accounting_balance_get_period_range @pcn,@period_start output,@period_end output

select @period_start period_start,@period_end period_end;

-- drop procedure Plex.accounting_balance_get_period_range
create procedure Plex.accounting_balance_get_period_range
(	
	@pcn int,
	@period_start int output,
	@period_end int output
)
as 
BEGIN   
	select 
	@period_start = period_start,
	@period_end = period_end 
	from Plex.accounting_balance_update_period_range
	WHERE pcn=@pcn;
	
END; 

select * from Plex.accounting_balance_update_period_range;