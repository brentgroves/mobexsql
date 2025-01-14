
select s.Name,sh.*
from ETL.script_history sh 
join ETL.script s 
on sh.script_key=s.Script_Key 
where sh.script_key in (1,3,4,5,6,7,8,9,10,11,116,117)
and start_time between '2024-05-05 00:00:00' and '2024-12-06 00:00:00' 
order by script_history_key desc
use master;
-- drop database mgdw