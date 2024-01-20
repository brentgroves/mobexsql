CREATE an INDEX FOR columns used TO JOIN TABLE 

CREATE TABLE Plex.accounting_account (
	pcn int NOT NULL,
	account_key int NOT NULL,
	account_no varchar(20) NULL,
	account_name varchar(110) NULL,
	active bit NULL,
	category_type varchar(10) NULL,
	category_no_legacy int NULL,
	category_name_legacy varchar(50) NULL,
	category_type_legacy varchar(10) NULL,
	sub_category_no_legacy int NULL,
	sub_category_name_legacy varchar(50) NULL,
	sub_category_type_legacy varchar(10) NULL,
	revenue_or_expense bit NULL,
	start_period int NULL,
	PRIMARY KEY (pcn,account_key)
);
-- https://www.mysqltutorial.org/mysql-index/mysql-create-index/
show indexes from Plex.accounting_account 
CREATE INDEX idx_accounting_account_pcn_account_no ON Plex.accounting_account(pcn,account_no);

this query will be very slow WITHOUT the INDEX ON the pcn AND account_no columns.
Also remember TO ORDER the CTE VIEW BY the columns being joined.
	set @pcn = 123681;
	set @year = 2021;
	with account_year_category_type
	as
	(
		select a.*
		-- select count(*)
		from Plex.accounting_account a  
		inner join Plex.accounting_account_year_category_type y
		on a.pcn = y.pcn 
		and a.account_no =y.account_no
		where y.year = @year 
		and a.pcn = 123681
		order by a.pcn,a.account_no 
	)
--  	select * from account_year_category_type;
	,add_account_year_category_type
	as 
	( 
		select a.account_no  
		from Plex.accounting_account a  
-- 		from account_year_category_type y 
-- 		limit 100;
-- 		select a.*
-- 		from Plex.accounting_account a  
		left outer join account_year_category_type y 
		on a.pcn = y.pcn 
		and a.account_no = y.account_no
		where y.pcn is null 
		and a.pcn = @pcn
	)
	select count(*) from add_account_year_category_type;

	select count(*) from account_year_category_type;
