-- Creates the login admin with password '340$Uuxwp7Mcxo7Khy' with default database master.
CREATE LOGIN admin
WITH PASSWORD = '340$Uuxwp7Mcxo7Khy';

-- Creates a database user for the login created previously in the mgdw database.
use mgdw;
CREATE USER admin
FOR LOGIN admin;

-- Add a admin user to db_owner role
ALTER ROLE db_owner ADD MEMBER admin;

select s.Name,sh.*
from ETL.script_history sh 
join ETL.script s 
on sh.script_key=s.Script_Key 
where sh.script_key in (1,3,4,5,6,7,8,9,10,11,116,117)
and start_time between '2024-07-05 00:00:00' and '2024-08-08 00:00:00' 
--and start_time between '2024-01-09 00:00:00' and '2024-01-10 00:00:00' 
order by name,start_time desc


CREATE TABLE Persons (
    PersonID int,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255)
);

select * from Persons;