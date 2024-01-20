-- create schema tutors;
+--------------+---------+------+-----+---------+-------+
| Field        | Type    | Null | Key | Default | Extra |
+--------------+---------+------+-----+---------+-------+
| number       | int(11) | NO   | PRI | NULL    |       |
| squareNumber | int(11) | NO   |     | NULL    |       |
+--------------+---------+------+-----+---------+-------+
-- truncate table tutors.squareNum
-- DROP TABLE IF EXISTS tutors.square;
CREATE TABLE tutors.squareNum (
  number      int   NOT NULL,
  squareNumber int   NOT NULL
);
insert into tutors.squareNum values (1,1)
show variables like 'max_connections';  
SELECT squareNumber FROM tutors.squareNum
SELECT squareNumber FROM tutors.squareNum WHERE number = 1
SELECT VERSION()
-- delete 
-- from tutors.squareNum
-- where number < 26
