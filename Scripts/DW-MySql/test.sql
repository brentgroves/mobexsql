drop database test;
create database test;
use test;
create table mytable 
( 
	c char(20)
)
-- CREATE TABLE t (c CHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin);

INSERT INTO tbl_name (a,b,c)
    VALUES(1,2,3), (4,5,6), (7,8,9);
   
insert into mytable 
values 
('a')
,('b')
,('c')
select * from mytable


-- DROP TABLE test.accounting_account;

CREATE TABLE test.accounting_account (
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
select * from test.accounting_account
