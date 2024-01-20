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