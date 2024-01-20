/*
Clustered indexes only sort tables. Therefore, they do not consume extra storage. 
Non-clustered indexes are stored in a separate place from the actual table claiming more storage space. 
Clustered indexes are faster than non-clustered indexes since they don't involve any extra lookup step.Aug 28, 2017
*/

-- select @PCN_Currency_Code
CREATE TABLE #Accounts
(
  pcn INT NOT NULL,
  account_no VARCHAR(20) NOT NULL,
  account_name varchar(110)
  --/*  -- 17
  PRIMARY KEY CLUSTERED
  (
    pcn,account_no
  )
  --*/
);
--CREATE NONCLUSTERED INDEX IX_Accounts ON #Accounts(pcn, account_no);  -- same time as primary key clustered with 2 pcn


show indexex
EXEC sp_helpindex 'Plex.accounting_period'

-- create index on multiple columns
create index accounting_period_pcn_account_no_newest
on Plex.accounting_period(pcn,account_no,newest);

-- two rows can not have same category and brand_id key values
create unique index accounting_period_pcn_account_no_newest
on products(pcn,account_no,newest);

CREATE TABLE mgdw.Plex.accounting_period_2 (
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
	newest bit null, -- also works on mysql
	CONSTRAINT PK__accounting_period PRIMARY KEY clustered (pcn,period_key),
	CONSTRAINT IX_accounting_period_pcn_period_no_newest UNIQUE (pcn,period,newest)

);

CREATE TABLE MyTable(
    a int NOT NULL
    ,b smallint NOT NULL
    ,c smallint NOT NULL
    ,d smallint NOT NULL
    ,e smallint NOT NULL

    -- This creates a primary key
    ,CONSTRAINT PK_MyTable PRIMARY KEY CLUSTERED (a)

    -- This creates a unique nonclustered index on columns b and c
    ,CONSTRAINT IX_MyTable1 UNIQUE (b, c)

    -- This creates a standard non-clustered index on (d, e)
    ,INDEX IX_MyTable4 NONCLUSTERED (d, e)
);

https://www.sqlshack.com/what-is-the-difference-between-clustered-and-non-clustered-indexes-in-sql-server/
here are two types of Indexes in SQL Server:

Clustered Index
Non-Clustered Index
Clustered Index
A clustered index defines the order in which data is physically stored in a table. 
Table data can be sorted in only way, therefore, there can be only one clustered index per table. In SQL Server, 
the primary key constraint automatically creates a clustered index on that particular column.

Now, to create a new clustered Index, execute the following script:

 
use schooldb
 
CREATE CLUSTERED INDEX IX_tblStudent_Gender_Score
ON student(gender ASC, total_score DESC)