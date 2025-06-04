--The following T-SQL shows how to create a contained database user for a Microsoft Entra identity:
--CREATE USER [MSEntraUser] FROM EXTERNAL PROVIDER
--CREATE USER [sJackson@linamar.com] FROM EXTERNAL PROVIDER;
--ALTER ROLE db_owner ADD MEMBER [sJackson@linamar.com];  

SELECT CAST(sid AS UNIQUEIDENTIFIER) AS EntraID, type, type_desc, authentication_type, authentication_type_desc    FROM sys.database_principals

--To get the original Microsoft Entra GUID that the SID is based on, use the following T-SQL conversion:

SELECT CAST(sid AS UNIQUEIDENTIFIER) AS EntraID FROM sys.database_principals

--Use the following T-SQL query to determine if a database user is a login-based user or a contained database user:


SELECT CASE
    WHEN CONVERT(VARCHAR(100), sid, 2) LIKE '%AADE' AND len(sid) = 18 THEN 'login-based user'
    ELSE 'contained database user'
    END AS user_type,
    *
FROM sys.database_principals WHERE TYPE = 'E' OR TYPE = 'X'

--Use the following T-SQL query to view all Microsoft Entra principals in a database:

SELECT
  name,
  CAST(sid AS UNIQUEIDENTIFIER) AS EntraID,
  CASE WHEN TYPE = 'E' THEN 'App/User' ELSE 'Group' end AS user_type,
  sid
FROM sys.database_principals WHERE TYPE = 'E' OR TYPE = 'X'

CREATE LOGIN [test0527] FROM EXTERNAL PROVIDER
