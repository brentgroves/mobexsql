/*
select *
into Scratch.accounting_account
from Plex.accounting_account
*/
-- truncate table Scratch.accounting_account

select count(*)
from Scratch.accounting_account