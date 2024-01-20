-- drop table mbx_test
CREATE TABLE mbx_test (
	col1 int null,
	col2 varchar(5) null
--	PCN int NULL,
--	Production_No int NULL,
--	Workcenter_Code varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	Part_No varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	Part_Key int NULL,
--	Revision varchar(8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	Serial_No varchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	Record_Date datetime2 NULL,
--	Quantity decimal(19,5) NULL,
--	Shift varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	Workcenter_Type varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	Standard_Production_Rate decimal(18,0) NULL,
--	Operation_Code varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	Note varchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	Job_No varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	Tracking_No varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	Master_Unit_No varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	Location varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	Add_By varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
);
--TRUNCATE table plx_Detailed_Production_History
select top 10 * from mbx_test
select count(*) cnt from mbx_test
select count(*)

insert into dbo.mbx_test (col1,col2) 
values (1,'a')


DECLARE @count INT;

EXEC uspFindProductByModel
    @model_year = 2018,
    @product_count = @count OUTPUT;

SELECT @count AS 'Number of products found';
exec [dbo].[mp_output_param_test] 6

DECLARE @count INT;
exec [dbo].[mp_output_param_test] 
    @col1 = 7,
    @col2 = @count OUTPUT;
SELECT @count AS 'Number of products found';

-- drop PROCEDURE [dbo].[mp_insert_test]
create PROCEDURE [dbo].[mp_output_param_test]
(
	@col1 int,
	@col2 int output
)
AS
BEGIN
	insert into dbo.mbx_test (col1) 
	values(@col1)  
	SELECT @col2 = @@ROWCOUNT;
end;

DECLARE @count INT;
exec [dbo].[mp_output_param_test_1_param] 
    @col1 = @count OUTPUT;
SELECT @count AS 'rowcount';

-- drop PROCEDURE [dbo].[mp_output_param_test_1_param]
create PROCEDURE [dbo].[mp_output_param_test_1_param]
(
	@col1 int output
)
AS
BEGIN
	insert into dbo.mbx_test (col1) 
	values(100)  
	SELECT @col1 = @@ROWCOUNT;
--	select 1 as one;
end;

exec [dbo].[mp_insert_int_test] 2

-- drop PROCEDURE [dbo].[mp_insert_test]
create PROCEDURE [dbo].[mp_insert_int_test]
(
	@col1 int
)
AS
BEGIN
	insert into dbo.mbx_test (col1) 
	values(@col1)  
end;

select top 10 * from mbx_test

exec [dbo].[mp_insert_char_test] 'b'
create PROCEDURE [dbo].[mp_insert_char_test]
(
	@col2 varchar(1)
)
AS
BEGIN
	insert into dbo.mbx_test (col2) 
	values(@col2)  
end;

exec mp_select_test
create PROCEDURE [dbo].[mp_select_test]
AS
BEGIN
	select * from dbo.mbx_test;  
end;



