
select schema_name(t.schema_id) as schema_name,
       t.name as table_name,
       t.create_date,
       t.modify_date
from sys.tables t
where schema_name(t.schema_id) = 'Archive' -- put schema name here
and t.name like '%account_per%'
order by table_name;