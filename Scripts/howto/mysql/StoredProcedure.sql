-- recordings.accounting_period_ranges definition

-- Drop table

-- DROP TABLE recordings.accounting_period_ranges;

CREATE TABLE recordings.accounting_period_ranges (
	id int NOT NULL AUTO_INCREMENT,
	pcn int NULL,
	start_period int NULL,
	end_period int NULL,
	start_open_period int NULL,
	end_open_period int NULL,
	no_update bit null,
	CONSTRAINT PK_accounting_period_range PRIMARY KEY (id)
);
show indexes from recordings.accounting_period_ranges;
SHOW CREATE TABLE recordings.accounting_period_ranges;

select * from recordings.accounting_period_ranges 

-- show indexes from Plex.accounting_account 
-- CREATE INDEX idx_accounting_account_pcn_account_no ON Plex.accounting_account(pcn,account_no);
-- CREATE INDEX idx_accounting_account_pcn_account_no ON Plex.accounting_account(pcn,account_no,peri);

select * from recordings.accounting_period_ranges
-- delete from recordings.accounting_balance_update_period_range

INSERT INTO recordings.accounting_period_ranges (pcn,start_period,end_period,start_open_period,end_open_period,no_update)
VALUES
(123681,202301,202311,202312,202401,1)

-- update Plex.accounting_balance_update_period_range
set period_start = 202103,
period_end = 202202

select * from recordings.accounting_period_ranges
set @pcn := 123681;
call recordings.accounting_get_period_ranges(@pcn,@start_period,@end_period,@start_open_period,@end_open_period,@no_update);
select @pcn pcn,@start_period start_period,@end_period end_period,@start_open_period,@end_open_period,@no_update;
-- drop procedure recordings.accounting_get_period_ranges
create procedure recordings.accounting_get_period_ranges
(	
	IN v_pcn int,
	OUT v_start_period int,
	OUT v_end_period int,
	OUT v_start_open_period int,
	OUT v_end_open_period int,
	out v_no_update bit
)
BEGIN   
	select start_period,end_period,start_open_period,end_open_period,no_update 
	into v_start_period,v_end_period,v_start_open_period,v_end_open_period,v_no_update 
	from recordings.accounting_period_ranges
	WHERE pcn=v_pcn;
	
END; 

    declare @period_start_out int; 
    declare @period_end_out int;
    EXEC records.accounting_balance_get_period_range @pcn = ?,@period_start = @period_start_out OUTPUT,@period_end = @period_end_out OUTPUT;
    SELECT @period_start_out AS period_start, @period_end_out as period_end;

   	set @pcn := 123681;
	call Plex.accounting_balance_get_period_range(@pcn,@period_start,@period_end);
	select @period_start period_start,@period_end period_end;

   
    plsql = """\
	call Plex.accounting_balance_get_period_range(@pcn = ?,@period_start,@period_end);
	select @period_start period_start,@period_end period_end;
    """


call recordings.getAlbumsByArtist( "John Coltrane")
call recordings.getAlbumsByArtist( "Gerry Mulligan")
SELECT * FROM recordings.album WHERE artist = v_name;
-- drop procedure recordings.getAlbumsByArtis;
create procedure recordings.getAlbumsByArtist
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
