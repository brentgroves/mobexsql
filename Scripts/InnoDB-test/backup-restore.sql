use mysql;
select * from delme;

select @@version
SELECT require_table_primary_key_check FROM performance_schema.replication_applier_configuration;

-- create database Plex;
-- create database ETL;
-- create database Azure;
-- ETL.source_dependancy_type definition

select * from ETL.script s 

select * from ETL.source_dependancy_type

https://stackoverflow.com/questions/5132923/how-to-add-a-primary-key-to-a-mysql-table
ALTER TABLE ETL.source_dependancy_type ADD PRIMARY KEY(source_dependancy_type_key)
ALTER TABLE ETL.source_dependancy_type
MODIFY COLUMN source_dependancy_type_key int NOT NULL PRIMARY KEY;

rename table ETL.source_dependancy_type to ETL.source_dependancy_type_old;
-- drop table `ETL.source_dependancy_type`

CREATE TABLE `ETL.source_dependancy_type` (
  `source_dependancy_type_key` int NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`source_dependancy_type_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `ETL.source_dependancy_type` (source_dependancy_type_key,name) SELECT source_dependancy_type_key,name FROM ETL.source_dependancy_type_old; 

SET AUTOCOMMIT = 0; SET UNIQUE_CHECKS=0; SET FOREIGN_KEY_CHECKS=0;
    INSERT INTO goods (... your column names ...) SELECT ... your column names FROM goods_old; 
SET FOREIGN_KEY_CHECKS=1; SET UNIQUE_CHECKS=1; COMMIT; SET AUTOCOMMIT = 1;
select s.Name,sh.*
from ETL.script_history sh 
join ETL.script s 
on sh.script_key=s.Script_Key 
where sh.script_key in (1,3,4,5,6,7,8,9,10,11,116,117)
and start_time between '2023-10-18 00:00:00' and '2023-10-19 00:00:00' 
order by script_history_key desc

select * from ETL.source_dependancy  
select * from ETL.script_type