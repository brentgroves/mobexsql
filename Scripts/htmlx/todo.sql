--https://coderonfleek.medium.com/htmx-go-build-a-crud-app-with-golang-and-htmx-081383026466

--We will keep things simple, no complicated schema design. First we create a database with the name testdb and inside this database, we create a todos table (feel free to give your database and table any name you prefer but ensure you use the same names in your SQL statements)
--
--Inside the todos table, implement the schema below:
--
--id: PK, Auto incrementing
--task : VARCHAR(200) - Contains the task item
--done: INT(1), default = 0 (Boolean field)
create database testdb;
use ETL;
use testdb;

CREATE TABLE todos (
  id int NOT NULL AUTO_INCREMENT,
  task varchar(200),
  done int(1) default 0,
  PRIMARY KEY (id)
);

insert into todos (task,done)
values 
('task 1',true),
('task 2',false)

select * from todos