select top 10 *
-- select count(*) 
from mgdw.Plex.trial_balance_multi_level_py -- 4,204


CREATE TABLE mgdw.Plex.trial_balance_multi_level_py (
	pcn int NULL,
	period int NULL,
	period_display varchar(7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	category_type varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	category_name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	sub_category_name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_no varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	account_name varchar(110) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	current_debit_credit decimal(18,2) NULL,
	ytd_debit_credit decimal(18,2) NULL,
	CONSTRAINT PK__trial_ba__42B3FBF342BDBF9D PRIMARY KEY (period_display,account_no)
);

select top 10 *
-- select count(*) 
from Plex.trial_balance_multi_level -- 794,556

CREATE TABLE mgdw.Plex.trial_balance_multi_level (
	pcn int NULL,
	period int NULL,
	period_display varchar(7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	category_type varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	category_name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	sub_category_name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_no varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	account_name varchar(110) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	current_debit_credit decimal(18,2) NULL,
	ytd_debit_credit decimal(18,2) NULL,
	CONSTRAINT PK__trial_ba__42B3FBF34116C87C PRIMARY KEY (period_display,account_no)
);

select top 10 *
-- select count(*) 
from Plex.account_period_balance -- 318,504

CREATE TABLE mgdw.Plex.account_period_balance (
	pcn int NULL,
	account_no varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	period int NULL,
	period_display varchar(7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	debit decimal(19,5) NULL,
	ytd_debit decimal(19,5) NULL,
	credit decimal(19,5) NULL,
	ytd_credit decimal(19,5) NULL,
	balance decimal(19,5) NULL,
	ytd_balance decimal(19,5) NULL
);

select top 10 *
-- select count(*) 
from Plex.account_activity_summary -- 166,441

CREATE TABLE mgdw.Plex.account_activity_summary (
	pcn int NOT NULL,
	period int NOT NULL,
	account_no varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	beginning_balance decimal(19,5) NULL,
	debit decimal(19,5) NULL,
	credit decimal(19,5) NULL,
	balance decimal(19,5) NULL,
	ending_balance decimal(19,5) NULL,
	CONSTRAINT PK_account_activity_summary PRIMARY KEY (pcn,period,account_no)
);

select top 10 *
-- select count(*) 
FROM Plex.accounting_balance -- 55,008

CREATE TABLE mgdw.Plex.accounting_balance (
	pcn int NOT NULL,
	account_key int NOT NULL,
	account_no varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	period int NOT NULL,
	debit decimal(19,5) NULL,
	credit decimal(19,5) NULL,
	balance decimal(19,5) NULL,
	CONSTRAINT PK__accounti__34E7554F34C584AF PRIMARY KEY (pcn,account_key,period)
);

select top 10 *
-- select count(*) 
--from Plex.accounting_period_ranges  --2,032

CREATE TABLE mgdw.Plex.accounting_period_ranges (
	id int IDENTITY(1,1) NOT NULL,
	pcn int NULL,
	start_period int NULL,
	end_period int NULL,
	start_open_period int NULL,
	end_open_period int NULL,
	no_update bit NULL,
	CONSTRAINT PK__accounti__3213E83FA52AEBCA PRIMARY KEY (id)
);

select top 10 *
-- select count(*) 
from Plex.accounting_period  --2,032

CREATE TABLE mgdw.Plex.accounting_period (
	pcn int NOT NULL,
	period_key int NOT NULL,
	period int NULL,
	fiscal_order int NULL,
	begin_date datetime NULL,
	end_date datetime NULL,
	period_display varchar(7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	quarter_group tinyint NULL,
	period_status int NULL,
	add_date datetime NULL,
	update_date datetime NULL,
	ordinal int NOT NULL,
	CONSTRAINT IX_accounting_period_pcn_period_no_newest UNIQUE (pcn,period,ordinal),
	CONSTRAINT PK__accounting_period PRIMARY KEY (pcn,period_key,ordinal)
);


select top 10 *
-- select count(*) 
from Plex.accounting_account  -- 19,827/19,286,19,176


CREATE TABLE mgdw.Plex.accounting_account (
	pcn int NOT NULL,
	account_key int NOT NULL,
	account_no varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_name varchar(110) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	active bit NULL,
	category_type varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	category_no_legacy int NULL,
	category_name_legacy varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	category_type_legacy varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	sub_category_no_legacy int NULL,
	sub_category_name_legacy varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	sub_category_type_legacy varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	revenue_or_expense bit NULL,
	start_period int NULL,
	CONSTRAINT PK__accounti__F6D2783F78916262 PRIMARY KEY (pcn,account_key)
);


select top 10 *
-- select count(*) 
from Plex.accounting_account_year_category_type -- 55,922


CREATE TABLE mgdw.Plex.accounting_account_year_category_type (
	id int IDENTITY(1,1) NOT NULL,
	pcn int NULL,
	account_no varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[year] int NULL,
	category_type varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	revenue_or_expense bit NULL,
	CONSTRAINT PK__accounti__3213E83FF126C7A5 PRIMARY KEY (id),
	CONSTRAINT UQ__accounti__22DAE7B5B1F76486 UNIQUE (pcn,account_no,[year])
);


select top 10 *
-- select count(*) 
from mgdw.Plex.Account_Balances_by_Periods -- 705,481


CREATE TABLE mgdw.Plex.Account_Balances_by_Periods (
	pcn int NULL,
	revenue decimal(19,5) NULL,
	expense decimal(19,5) NULL,
	amount decimal(19,5) NULL,
	period int NULL,
	Period_Display varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Category_Type varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Category_No int NULL,
	Category_Name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[No] varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Name varchar(110) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Ytd_Debit decimal(18,2) NULL,
	Ytd_Credit decimal(18,2) NULL,
	Current_Debit decimal(18,2) NULL,
	Current_Credit decimal(18,2) NULL,
	Sub_Category_No int NULL,
	Sub_Category_Name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Subtotal_After int NULL,
	Subtotal_Name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
);