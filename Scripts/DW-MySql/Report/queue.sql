-- https://linuxhint.com/sql-server-json-data-type/
-- drop table Report.queue
CREATE TABLE Report.queue (
	queue_id int not null AUTO_INCREMENT,
	params json not null, 
	done tinyint not null default 0,
	created datetime DEFAULT CURRENT_TIMESTAMP,
	updated datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	primary key (queue_id)
-- 	FOREIGN KEY (report_id) REFERENCES Report.report(report_id)	
);
-- truncate table Report.queue

select * from Report.queue q 
insert into Report.queue (params)
values('{"etl_only":0,"report_name":"daily_metrics","email":"bgroves@buschegroup.com","start_period":202201,"end_period":202207}')

update Report.queue set done=1 where queue_id=1
update Report.queue set done=0 where queue_id=1


https://dev.mysql.com/doc/refman/8.0/en/json.html
INSERT INTO t1 VALUES('{"key1": "value1", "key2": "value2"}');
-- drop table Report.report
CREATE TABLE Report.report (
	report_id int not null,
	name varchar(110),
	PRIMARY KEY (report_id)
)
insert into Report.report (report_id,name)
values(1,'TrialBalance')

-- show indexes from Plex.accounting_account 
-- CREATE INDEX idx_accounting_account_pcn_account_no ON Plex.accounting_account(pcn,account_no);
