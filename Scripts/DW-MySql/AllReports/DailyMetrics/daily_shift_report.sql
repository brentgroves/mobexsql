-- CREATE SCHEMA DailyMetrics
-- DailyMetrics.daily_shift_report definition

-- Drop table

-- DROP TABLE DailyMetrics.daily_shift_report;

CREATE TABLE DailyMetrics.daily_shift_report (
	pcn int NOT NULL,
	report_date datetime not NULL,
--	department_no int NULL,
--	department_code varchar(60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	manager_first_name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	manager_middle_name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	manager_last_name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	workcenter_key int not NULL,
	workcenter_code varchar(50) NULL,
	part_key int not NULL,
	part_no varchar(100) NULL,
	part_revision varchar(8)  NULL,
	part_name varchar(100) NULL,
	operation_no int NULL,
	operation_code varchar(30) NULL,
--	downtime_hours decimal(18,6) NULL,
--	planned_production_hours decimal(18,6) NULL,
	parts_produced int NULL,
	parts_scrapped int NULL,
--	scrap_rate decimal(18,6) NULL,
--	utilization decimal(18,6) NULL,
--	efficiency decimal(18,6) NULL,
--	oee decimal(18,6) NULL,
	earned_hours decimal(18,6) NULL,
	actual_hours decimal(18,6) NULL,
--	labor_efficiency decimal(18,6) NULL,
--	earned_machine_hours decimal(18,6) NULL,
--	actual_machine_hours decimal(18,6) NULL,
	part_operation_key int not NULL,
	quantity_produced int NULL,
--	workcenter_rate decimal(18,6) NULL,
	labor_rate decimal(18,6) NULL,
--	crew_size decimal(18,6) NULL,
--	department_unassigned_hours varchar(1020) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	child_part_count int NULL,
--	operators varchar(1020) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	note varchar(1020) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
--	accounting_job_nos varchar(1020) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK_DailyMetrics_daily_shift_report PRIMARY KEY (pcn,report_date,workcenter_key,part_key,part_operation_key)
);


show indexes from DailyMetrics.daily_shift_report 
CREATE INDEX pk_dm_daily_shift_report ON DailyMetrics.daily_shift_report(pcn,report_date,workcenter_key,part_key,part_operation_key);


-- delete from DailyMetrics.daily_shift_report
--  insert into DailyMetrics.daily_shift_report 
  (pcn,report_date,workcenter_key,workcenter_code,part_key,part_no,part_revision,
   part_name,operation_no,operation_code,parts_produced,parts_scrapped,
   earned_hours,actual_hours,part_operation_key,quantity_produced,labor_rate)
 -- values ('123681', '08/10/2022 00:00:00', '58321', 'CD4 RH Pack', '2684942', 'H2GC 5K651 AB', '', 'CD4.2 RH', '120', 'Final', '370', '0', '3.854167', '20.65834', '7471212', '370', '48')
   values  ('123681', '2022-08-10 00:00:00', '60958', 'CNC 432 Uplift 6K Knuckle Assembly', '2820236', 
	'10103353CX', 'A', 'P558 6K Knuckle Right Hand', '140', 'Final', '58', '0', '4.264706', '3.472964823', '7961801', '58', '6.8')

-- truncate table DailyMetrics.daily_shift_report
select * from DailyMetrics.daily_shift_report
