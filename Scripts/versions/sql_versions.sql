select @@version
--busche-sql/etdsv01 
Microsoft SQL Server 2012 (SP4-GDR) (KB4583465) - 11.0.7507.2 (X64) 
	Nov  1 2020 00:48:37 
	Copyright (c) Microsoft Corporation
	Standard Edition (64-bit) on Windows NT 6.3 <X64> (Build 9600: ) (Hypervisor)
	
CREATE DATABASE rsdw	
use rsdw
CREATE TABLE Persons (
    PersonID int,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255)
);
select * from  rsdw.dbo.PersonsB
-- drop TABLE rsdw.dbo.PersonsB
CREATE TABLE rsdw.dbo.PersonsB (
    PersonID int,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255)
);

select