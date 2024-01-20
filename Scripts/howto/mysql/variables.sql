https://www.mysqltutorial.org/mysql-variables/

MySQL variable assignment
There are two ways to assign a value to a user-defined variable.

The first way is to use the SET statement as follows:

SET @variable_name := value;
Code language: SQL (Structured Query Language) (sql)
You can use either := or = as the assignment operator in the SET statement. For example, the statement assigns number 100 to the variable @counter.

SET @counter := 100;
Code language: SQL (Structured Query Language) (sql)
The second way to assign a value to a variable is to use the SELECT statement. In this case, you must use the := assignment operator because, within the SELECT statement, MySQL treats the = operator as the equal operator.

SELECT @variable_name := value;
Code language: SQL (Structured Query Language) (sql)
After the assignment, you can use the variable in the subsequent statement where an expression is permitted e.g., in WHERE clause, INSERT or UPDATE statement.

	declare v_min_id int;
	declare v_max_id int;
	select min(id),max(id) into v_min_id,v_max_id from Plex.accounting_balance_update_period_range; 
