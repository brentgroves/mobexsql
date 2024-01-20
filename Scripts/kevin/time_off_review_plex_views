/* -Personnel_v_employee_e - customer_employee_no, payroll_no, employee_status, last_name, first_name, pay_type
need 1129 after time off periods added


Plexus_control_v_customer_group_member - Plexus_customer_code
  join on plexus_customer_no
  
-plexus_control_v_plexus_user_e - last_name, first_name
  left outer join on plexus_user_no
  
-personnel_v_time_off_period_e - active, period_begin, period_end, allowed_hours, accrued_hours
  left outer join on pcn and pun
  
-Personnel_v_time_off_type_e - time_off_type
  join (with personnel_v_time_off_period_e) on pcn and time_off_type_key
  
need 2667 results
*/

;WITH EMPLOYEE_INFO -- employees 1312
AS (
SELECT plexus_customer_no, plexus_user_no, customer_employee_no as employee_no, payroll_no,
employee_status, pay_type
FROM personnel_v_employee_e
WHERE employee_status = 'Active' or employee_status = 'ADA'
),

TIMEOFFPERIODS
AS (
SELECT pcn, pun, active, time_off_period_key, period_begin, period_end, allowed_hours, accrued_hours, time_off_type_key
FROM personnel_v_time_off_period_e
WHERE period_begin >= DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)
--AND active IS NOT NULL
AND (active = 'TRUE' or accrued_hours > 0)
),

TIMEOFFSTATUS
AS (
SELECT pcn, time_off_status_key
FROM personnel_v_time_off_status_e
WHERE Approved_status ='1'
),

TIMEOFF
AS (
SELECT toff.pcn, toff.time_off_key
FROM personnel_v_time_off_e toff

JOIN TIMEOFFSTATUS tos
ON toff.time_off_status_key = tos.time_off_status_key
AND toff.pcn = tos.pcn

WHERE Applied_Date >= DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0) AND Applied_Date < '2023-11-01'
)


--AGGTIME
--AS (
SELECT tod.pcn, todp.time_off_period_key, SUM(tod.hours) as dayhours
FROM personnel_v_time_off_day_e as tod

JOIN TIMEOFF as toff
ON tod.time_off_key = toff.time_off_key
AND tod.pcn = toff.pcn

JOIN personnel_v_time_off_day_period_e as todp
ON tod.time_off_day_key = todp.time_off_day_key
AND tod.pcn = todp.pcn

GROUP BY tod.pcn, todp.time_off_period_key
)



-- 2681 
SELECT COUNT(*)
--SELECT cgm.plexus_customer_code, ei.plexus_user_no, ei.employee_no, ei.payroll_no, ei.employee_status, usr.last_name, 
--usr.first_name, ei.pay_type, tt.time_off_type, tps.active as period_active, tps.time_off_period_key, tps.period_begin, tps.period_end, 
--tps.allowed_hours, tps.accrued_hours
FROM TIMEOFFPERIODS as tps

-- 4501
JOIN EMPLOYEE_INFO as ei
on tps.pun = ei.plexus_user_no
and tps.pcn = ei.plexus_customer_no

-- 2681
JOIN plexus_control_v_customer_group_member as cgm
on tps.pcn = cgm.plexus_customer_no

INNER JOIN plexus_control_v_plexus_user_e as usr
on tps.pun = usr.plexus_user_no
and tps.pcn = usr.plexus_customer_no

-- 2681
JOIN personnel_v_time_off_type_e as tt
ON tps.time_off_type_key = tt.time_off_type_key
AND tps.pcn = tt.pcn