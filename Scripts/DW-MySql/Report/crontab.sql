-- drop table Report.crontab
CREATE TABLE Report.crontab (
	crontab_id int not null AUTO_INCREMENT,
	job_name varchar(150) not null,
	params json not null, 
	on_hold tinyint not null default 0,
	created datetime DEFAULT CURRENT_TIMESTAMP,
	updated datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	primary key (crontab_id),
	unique (job_name)
);
-- truncate table Report.crontab
select * from Report.crontab  
select crontab_id,job_name,params,on_hold,created,updated from Report.crontab  
select crontab_id,job_name,params,on_hold,created,updated from Report.crontab where on_hold = 0
insert into Report.crontab (job_name,params)
values
('ETLTrialBalance','{"etl_only":1,"report_name":"trial_balance","email":"bgroves@buschegroup.com","start_period":202201,"end_period":202207,"frequency":"10 3,7,11,15,19,23 * * *"}'),
('DanWeeklyTrialBalance','{"etl_only":0,"report_name":"trial_balance","email":"bgroves@buschegroup.com","start_period":202201,"end_period":202207,"frequency":"10 19 * * 1"}')

update Report.crontab set on_hold=1 where crontab_id=1
update Report.crontab set on_hold =0 where crontab_id=1

# insert_queue(report_id=report_id,etl_only=etl_only,params='{"etl_only":0,"report_name":"daily_metrics","email":"bgroves@buschegroup.com","start_period":202201,"end_period":202207}')
