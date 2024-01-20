	with account_year_category_type
	as
	(
		select a.*
		-- select count(*)
		from Plex.accounting_account a  
		inner join Plex.accounting_account_year_category_type y
		on a.pcn = y.pcn 
		and a.account_no =y.account_no
		where y.`year` = (v_prev_period/100) 
		and a.pcn = v_pcn
	)
	-- select count(*) from account_year_category_type; -- 4,617
	,add_account_year_category_type
	as 
	( 
		select a.*
		from Plex.accounting_account a  
		left outer join account_year_category_type y 
		on a.pcn = y.pcn 
		and a.account_no = y.account_no
		where y.pcn is null 
		and a.pcn = v_pcn
	)
	-- select count(*) from add_account_year_category_type;
	-- select * from Plex.accounting_account_year_category_type
	select y.pcn,y.`year`,y.category_type,y.revenue_or_expense
	from Plex.accounting_account_year_category_type y
	where y.year = (@period_end/100) -- there is no account_year_category_type records for the @prev_period year so we must add them.
	and y.pcn = @pcn
	and y.account_no in 
	( 
		select account_no from add_account_year_category_type
	);
