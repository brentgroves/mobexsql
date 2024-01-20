
CREATE SCHEMA planner

drop table mgdw.planner.planner
CREATE TABLE mgdw.planner.planner2 (
	ID int NOT NULL,
	Title varchar(110),
	CreatedDate datetime NULL,
	ClosedDate datetime NULL,
	AssignedTo varchar(110),
	[percent] decimal(19,5)
);
connection, database /schema 
mgsqlmi.public.48d444e7f69b.database.windows.net,mgdw,planner
The SQL table must have the columns: ID,Title,CreatedDate,ClosedDate,AssignedTo,percent.

tony
etdsv01
buschecnc1

CREATE LOGIN alex 
WITH PASSWORD = 'y1!JFs41Vf' 

CREATE USER [alex] 
FOR LOGIN [alex] 
WITH DEFAULT_SCHEMA = planner; 

-- add user to role(s) in db 
ALTER ROLE db_datareader ADD MEMBER [alex]; 
ALTER ROLE db_datawriter ADD MEMBER [alex]; 

select * from mgdw.planner.planner

