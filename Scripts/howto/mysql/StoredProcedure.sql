call recordings.getAlbumsByName( "John Coltrane")
-- drop procedure recordings.getAlbumsByName;
create procedure recordings.getAlbumsByName
(
	in v_name varchar(25)
)
begin
SELECT * FROM recordings.album WHERE artist = v_name;
end;

create procedure recordings.getAlbumsByName
(	
	IN v_pcn int,
	OUT v_period_start int,
	OUT v_period_end int
)
BEGIN   
	select period_start,period_end into v_period_start,v_period_end 
	from Plex.accounting_balance_update_period_range
	WHERE pcn=v_pcn;
	
END; 

select * from recordings.album a 

--RETURN CONDITION 
create procedure Plex.account_period_balance_recreate_open_period_range
(
	in v_pcn int
)
proc_Exit:begin
	declare v_start_open_period int;
	declare v_end_open_period int;
	declare v_period int;
	declare v_max_fiscal_period int;
	
	declare v_prev_period int;
	declare v_first_period int;
	declare v_anchor_period int;
	declare v_anchor_period_display varchar(7);
	
	declare v_cnt int;

	select r.start_open_period,r.start_open_period,r.end_open_period,m.max_fiscal_period 
	into v_start_open_period,v_period,v_end_open_period,v_max_fiscal_period
	from Plex.accounting_period_ranges r
	inner join Plex.max_fiscal_period_view m 
	on r.pcn=m.pcn
	and (r.start_open_period div 100) = m.`year`
	where r.pcn = v_pcn;

	if (v_no_update=1) then
-- 		select 'returning early', @no_update no_update;
 		LEAVE proc_Exit;
	end if;
end

set @pcn := 123681;
call Plex.accounting_balance_get_period_range(@pcn,@period_start,@period_end);
select @period_start period_start,@period_end period_end;
-- drop procedure Plex.accounting_balance_get_period_range
create procedure Plex.accounting_balance_get_period_range
(	
	IN v_pcn int,
	OUT v_period_start int,
	OUT v_period_end int
)
BEGIN   
	SET NOCOUNT ON; 
	select period_start,period_end into v_period_start,v_period_end 
	from Plex.accounting_balance_update_period_range
	WHERE pcn=v_pcn;
	
END; 


cursor = self.db.cursor()

sql = """\
DECLARE @period_start nvarchar(max);
EXEC [dbo].[storedProcedure] @x = ?, @y = ?, @z = ?,@param_out = @out OUTPUT;
SELECT @out AS the_output;
"""

cursor.execute(sql, (x, y, z))
row = cursor.fetchone()
print(row[0])
