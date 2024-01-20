SELECT  'robot' AS `set`, r.*
FROM    robot r
WHERE   ROW(r.col1, r.col2, …) NOT IN
        (
        SELECT  col1, col2, ...
        FROM    tbd_robot
        )
UNION ALL
SELECT  'tbd_robot' AS `set`, t.*
FROM    tbd_robot t
WHERE   ROW(t.col1, t.col2, …) NOT IN
        (
        SELECT  col1, col2, ...
        FROM    robot
        )
        
SELECT  'NotInAzure' AS `set`, p.*
FROM    Plex.account_period_balance p 
WHERE   ROW(pcn,account_no,period,period_display,debit,ytd_debit,credit,ytd_credit,balance,ytd_balance) NOT IN
        (
        SELECT  pcn,account_no,period,period_display,debit,ytd_debit,credit,ytd_credit,balance,ytd_balance
        FROM    Azure.account_period_balance 
        )
UNION ALL
SELECT  'NotInMCP' AS `set`, a.*
FROM    Azure.account_period_balance a  
WHERE   ROW(pcn,account_no,period,period_display,debit,ytd_debit,credit,ytd_credit,balance,ytd_balance) NOT IN
        (
        SELECT  pcn,account_no,period,period_display,debit,ytd_debit,credit,ytd_credit,balance,ytd_balance
        FROM    Plex.account_period_balance 
        )
        