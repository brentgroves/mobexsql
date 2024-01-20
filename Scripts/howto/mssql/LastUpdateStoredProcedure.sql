https://www.mssqltips.com/sqlservertip/6147/find-sql-server-stored-procedure-create-modified-last-execution-date-and-code/

-- list stored procedures with database name and schema name
-- from sys.procedures
select 
 db_name() [database name]
,[schema name] = SCHEMA_NAME([schema_id])
,name [stored proc name]
FROM sys.procedures
where type_desc = N'SQL_STORED_PROCEDURE'
order by name

-- list the T-SQL code for a stored procedure identified by its object_id
select 
 db_name() [database name]
,[schema name] = SCHEMA_NAME([schema_id])
,name [stored proc name]
,object_definition (object_id) [T-SQL Definition]
FROM sys.procedures
where type_desc = N'SQL_STORED_PROCEDURE'
and name = 'account_period_balance_recreate_period_range'

-- display create datetime and last modified datetime
-- for uspMyFifthStoredProcedure's full name (db_name, schema_name, name)
select 
 [database name] = db_name() 
,[schema name] =  SCHEMA_NAME([schema_id])
,name [stored proc name]
,create_date [create date]
,modify_date [last modify date]
from sys.objects
where type = 'P'
and name = 'account_period_balance_recreate_period_range'

Plex.account_period_balance_recreate_period_range
-- when did it last run
select
 db_name() [database name]
,[schema name] = SCHEMA_NAME([schema_id])
,o.name
,ps.last_execution_time 
from   sys.dm_exec_procedure_stats ps 
inner join
       sys.objects o 
       ON ps.object_id = o.object_id 
where o.type = 'P'
--and o.schema_id = schema_name(schema_id)
and o.name = 'account_period_balance_recreate_period_range'
order by
       ps.last_execution_time