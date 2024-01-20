
-- mgdw.Plex.accounting_balance_update_period_range definition

-- Drop table

-- DROP TABLE Plex.accounting_balance_update_period_range;

CREATE TABLE Plex.accounting_balance_update_period_range (
	id int NOT NULL AUTO_INCREMENT,
	pcn int NULL,
	period_start int NULL,
	period_end int NULL,
	open_period int null,
	no_update bit null,
	CONSTRAINT PK__accounting_balance_update_period_range PRIMARY KEY (id)
);
show indexes from Plex.accounting_balance_update_period_range;
SHOW CREATE TABLE Plex.accounting_balance_update_period_range;

select * from Plex.accounting_balance_update_period_range abupr 

-- show indexes from Plex.accounting_account 
-- CREATE INDEX idx_accounting_account_pcn_account_no ON Plex.accounting_account(pcn,account_no);
-- CREATE INDEX idx_accounting_account_pcn_account_no ON Plex.accounting_account(pcn,account_no,peri);

select * from Plex.accounting_balance_update_period_range
-- delete from Plex.accounting_balance_update_period_range

INSERT INTO Plex.accounting_balance_update_period_range (pcn,period_start,period_end)
VALUES
(123681,202106,202205)
,(300758,202106,202205)

-- update Plex.accounting_balance_update_period_range
set period_start = 202103,
period_end = 202202