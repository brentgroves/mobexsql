https://www.mysqltutorial.org/mysql-select-into-variable/

MySQL SELECT INTO Variable syntax
To store query result in one or more variables, you use the SELECT INTO variable syntax:

SELECT 
    c1, c2, c3, ...
INTO 
    @v1, @v2, @v3,...
FROM 
    table_name
WHERE 
    condition;