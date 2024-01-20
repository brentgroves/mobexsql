select * 
from Plex.account_period_balance p limit 10;

select 
pcn,
CAST(
case 
	when debit = 0 then ytd_debit
	else debit 
end as decimal(19,5) 
) test 
from Plex.account_period_balance p limit 10;

			cast(
				case 
				when (@first_period=0) and (a.revenue_or_expense = 1) and (b.debit is null) then p.ytd_debit 
				when (@first_period=0) and (a.revenue_or_expense = 1) and (b.debit is not null) then p.ytd_debit + b.debit 
				when (@first_period=0) and (a.revenue_or_expense = 0) and (b.debit is null) then p.ytd_debit 
				when (@first_period=0) and (a.revenue_or_expense = 0) and (b.debit is not null) then p.ytd_debit + b.debit
				when (@first_period=1) and (a.revenue_or_expense = 1) and (b.debit is null) then 0 
				when (@first_period=1) and (a.revenue_or_expense = 1) and (b.debit is not null) then b.debit 
				when (@first_period=1) and (a.revenue_or_expense = 0) and (b.debit is null) then p.ytd_debit 
				when (@first_period=1) and (a.revenue_or_expense = 0) and (b.debit is not null) then p.ytd_debit + b.debit 
				end as decimal(19,5) 
			) ytd_debit, 
