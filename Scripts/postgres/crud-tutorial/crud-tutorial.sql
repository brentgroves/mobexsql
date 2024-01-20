-- https://www.w3schools.com/postgresql/postgresql_create_table.php

CREATE TABLE cars (
  brand VARCHAR(255),
  model VARCHAR(255),
  year INT
);

INSERT INTO cars (brand, model, year)
VALUES ('Ford', 'Mustang', 1964);

select * from cars;

--https://www.postgresqltutorial.com/postgresql-administration/postgresql-create-schema/
CREATE SCHEMA marketing;

CREATE TABLE marketing.cars2 (
  brand VARCHAR(255),
  model VARCHAR(255),
  year INT
);

SELECT * 
FROM pg_catalog.pg_namespace
ORDER BY nspname;

select * from marketing.cars2;

select * from cars;
--https://phpforever.com/postgresql/crud-example-using-php-object-oriented-and-postgresql/
select * from roles;
# some tables to test access to db.
CREATE TABLE roles(
   role_id serial PRIMARY KEY,
   role_name VARCHAR (255) UNIQUE NOT NULL
);
CREATE TABLE accounts (
 user_id serial PRIMARY KEY,
 username VARCHAR ( 50 ) UNIQUE NOT NULL,
 password VARCHAR ( 50 ) NOT NULL,
 email VARCHAR ( 255 ) UNIQUE NOT NULL,
 created_on TIMESTAMP NOT NULL,
        last_login TIMESTAMP 
);
select * from accounts;
CREATE TABLE account_roles (
  user_id INT NOT NULL,
  role_id INT NOT NULL,
  grant_date TIMESTAMP,
  PRIMARY KEY (user_id, role_id),
  FOREIGN KEY (role_id)
      REFERENCES roles (role_id),
  FOREIGN KEY (user_id)
      REFERENCES accounts (user_id)
);

CREATE TABLE public."user"
(
    id serial NOT NULL,
    name character varying(250),
    email character varying(250),
    mobile_no bigint,
    address text,
    PRIMARY KEY (id)
)