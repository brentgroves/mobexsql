-- mgdw.Plex.accounting_account_summary_open_period  definition

-- Drop table

-- DROP TABLE Plex.accounting_account_summary_open_period ;

CREATE TABLE Plex.accounting_account_summary_open_period  (
	pcn int NOT NULL,
	period int NOT NULL,
	account_no varchar(20) NOT NULL,
	debit decimal(19,5) NULL,
	credit decimal(19,5) NULL,
	balance decimal(19,5) NULL,
	CONSTRAINT PK_accounting_account_summary_open_period PRIMARY KEY (pcn,period,account_no)
);
show indexes from Plex.accounting_account_summary_open_period
select *
-- select count(*) 
from Plex.accounting_account_summary_open_period  -- 313
