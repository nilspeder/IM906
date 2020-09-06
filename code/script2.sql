
USE dissertation;




SET sql_log_bin = OFF;

set session sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

select event_name, current_alloc, high_alloc 
from sys.memory_global_by_current_bytes 
where current_count > 0;



/*Run once*/

update data1m  
SET hit_date = STR_TO_hit_date(hit_date, "%Y-%m-%d %H:%i:%s.%f");

LOCK TABLES data1m WRITE;
UNLOCK TABLES;
ALTER TABLE data1m MODIFY device_id varchar(20);
ALTER TABLE data1m MODIFY gateway varchar(3);
ALTER TABLE data1m MODIFY hit_issue_id varchar(20);
ALTER TABLE data1m MODIFY hit_module varchar(255);
ALTER TABLE data1m MODIFY cu_id varchar(10);

/* Removing first character of value - if present */
update data1m set device_id=substr(device_id,2) WHERE device_id LIKE 'd%';
update data1m set gateway=substr(gateway,2) WHERE gateway LIKE 'g%';
update data1m set hit_issue_id=substr(hit_issue_id,2);
update data1m set cu_id=substr(cu_id,2);

update data1m set hit_severity=3 WHERE hit_severity LIKE 'emergency';
update data1m set hit_severity=3 WHERE hit_severity LIKE 'alert';
update data1m set hit_severity=3 WHERE hit_severity LIKE 'critical';
update data1m set hit_severity=3 WHERE hit_severity LIKE 'error';
update data1m set hit_severity=2 WHERE hit_severity LIKE 'warning';
update data1m set hit_severity=1 WHERE hit_severity LIKE 'notice';
update data1m set hit_severity=1 WHERE hit_severity LIKE 'info';
update data1m set hit_severity=1 WHERE hit_severity LIKE 'debug';
update data1m set hit_severity=0 WHERE hit_severity LIKE 'ok';

/* Changing column datatypes to integer */
ALTER TABLE data1m MODIFY device_id INTEGER;
ALTER TABLE data1m MODIFY gateway INTEGER;
ALTER TABLE data1m MODIFY hit_issue_id INTEGER;
ALTER TABLE data1m MODIFY cu_id INTEGER;
ALTER TABLE data1m MODIFY hit_severity INTEGER;


SELECT DISTINCT gateway FROM data326m;
SELECT COUNT(DISTINCT(hit_severity)) FROM data326m;
SELECT COUNT(DISTINCT(hit_module)) FROM data326m;
SELECT gateway Architecture
       ,COUNT(DISTINCT(hit_module)) `Fault Type`
       ,COUNT(DISTINCT(hit_date)) Hits
       ,COUNT(DISTINCT(cu_id)) Customers 
       FROM data326m
       GROUP BY gateway;

SELECT hit_module, COUNT(DISTINCT(hit_module)) FROM data326m GROUP BY device_id;

SELECT hit_module, COUNT(hit_date) FROM data1m WHERE hit_module LIKE '%Prod126%' GROUP BY hit_module;

SELECT device_id, COUNT(hit_date) hits FROM long_cpu_hog_prod126 GROUP BY device_id ORDER BY hits DESC;


show create table hits_devices_with_severity3;


CREATE TABLE `hits_devices_with_severity3` (
  `hit_date` datetime DEFAULT NULL,
  `device_id` int DEFAULT NULL,
  `gateway` int DEFAULT NULL,
  `hit_issue_id` int DEFAULT NULL,
  `hit_labels` text,
  `hit_module` varchar(255) DEFAULT NULL,
  `hit_severity` int DEFAULT NULL,
  `cu_id` int DEFAULT NULL);


SELECT hit_severity, hit_module,COUNT(1) as count 
FROM data1m 
GROUP BY hit_module
ORDER BY count DESC;

SELECT hit_module
, count(distinct(device_id))
, count(hit_date)
FROM hits_devices_with_severity3 
GROUP BY hit_module;

SELECT hit_severity,COUNT(1) as count 
FROM data1m 
GROUP BY hit_severity
ORDER BY count DESC;
SELECT cu_id,COUNT(1) as count 
FROM data1m 
GROUP BY cu_id
ORDER BY count DESC;

SELECT hit_issue_id,COUNT(1) as count 
FROM data1k
GROUP BY hit_issue_id
ORDER BY hit_issue_id DESC;

SELECT * FROM data1m WHERE hit_issue_id = 898;
SELECT * FROM flap WHERE hit_issue_id = 898;
SELECT * FROM data1m WHERE hit_module = 'crypto_low_lifetime_seconds';
SELECT * FROM data1m WHERE cu_id = 3 AND hit_module = 'crypto_low_lifetime_seconds';
SELECT * FROM data1m WHERE hit_module = 'telnet_input_enabled';
SELECT * FROM data1m WHERE hit_issue_id = 4;

SELECT distinct(hit_module) FROM data1k;


DROP TABLE Customers;
CREATE TABLE Customers AS    
SELECT cu_id
, MIN(hit_date) first_occurance
, MAX(hit_date) last_occurance
, DATEDIFF(MAX(hit_date),MIN(hit_date)) AS participation_length
, COUNT(1) alert_count
, COUNT(DISTINCT(hit_module)) alert_types
, COUNT(DISTINCT(device_id)) no_of_devices
FROM data1m
GROUP BY cu_id;

SELECT
    hi.hit_issue_id
    ,hi.first_occurance
    ,fhi.hit_severity
    ,hi.last_occurance
    ,hi.hit_count
FROM (
     SELECT 
        hit_issue_id
        ,MIN(hit_date) AS first_occurance
        ,MAX(hit_date) AS last_occurance
        ,COUNT(1) AS hit_count
     FROM data1m
     GROUP BY hit_issue_id
     ) AS hi
INNER JOIN data1k AS fhi
    ON hi.first_occurance = fhi.hit_date
GROUP BY hit_issue_id;

DROP TABLE issues;
CREATE TABLE issues AS
SELECT DISTINCT T1.hit_issue_id
     , T1.first_occurance
     , FIRST_VALUE(T2.hit_severity) OVER (PARTITION BY T2.hit_issue_id) first_hit_severity
     , T1.last_occurance
     , LAST_VALUE(T2.hit_severity) OVER (PARTITION BY T2.hit_issue_id) last_hit_severity
     , T1.total_events  
     , T1.device_id
     , T1.hit_module
 FROM    (
SELECT hit_issue_id
     , MIN(hit_date) first_occurance
     , MAX(hit_date) last_occurance
     , COUNT(1)  total_events
     , device_id
     , hit_module
FROM data1m
where 1=1
GROUP BY hit_issue_id 
) T1
INNER JOIN data1m T2
WHERE 1=1
AND T1.hit_issue_id = T2.hit_issue_id
;

SELECT hit_module, hit_labels
     , COUNT(*) module_count
     , COUNT(DISTINCT(device_id)) no_of_devices
FROM data326m
WHERE hit_severity = 3
GROUP BY hit_module
order by module_count DESC;

SELECT hit_issue_id, device_id, hit_module
     , COUNT(*) issue_count
FROM data1m
WHERE cu_id=1
GROUP BY hit_issue_id;

SELECT hit_issue_id, device_id, hit_module
     , COUNT(*) issue_count
FROM data1m
WHERE cu_id=1
GROUP BY hit_module, device_id;

SELECT *
FROM data1m
WHERE hit_issue_id=186772;

 SELECT * from data1m
 WHERE hit_severity = 3
 ;
 
SELECT r.* from data1k r
INNER JOIN data1k e ON (e.device_id = r.device_id)
WHERE e.hit_severity = 3;

SELECT r.* from data1m r
WHERE 1=1
AND EXISTS(SELECT 1 from data1m e WHERE e.device_id = r.device_id and e.hit_severity = 3)
;



DROP TABLE flap;
CREATE TABLE flap AS 
WITH CTE_TABLE AS (
    SELECT  *,
            CASE WHEN LAG(hit_severity) OVER (PARTITION BY hit_issue_id ORDER BY hit_date) <> hit_severity /* OR
                      LEAD(hit_severity) OVER (PARTITION BY hit_issue_id ORDER BY hit_date) <> hit_severity */ THEN 
                1
            END As Filter1
    FROM data326m
) SELECT  hit_date,
        hit_issue_id,
        device_id,
        hit_severity,
        hit_module
FROM CTE_TABLE
WHERE Filter1 = 1;


SELECT *,
   SUM(CASE
        WHEN hit_severity = 0 THEN 1
        ELSE 0
    END) AS 'ok',
    SUM(CASE
        WHEN hit_severity = 1 THEN 1
        ELSE 0
    END) AS 'info',
    SUM(CASE
        WHEN hit_severity = 2 THEN 1
        ELSE 0
    END) AS 'warning',
    SUM(CASE
        WHEN hit_severity = 3 THEN 1
        ELSE 0
    END) AS 'danger'
FROM
  flap
GROUP BY
  hit_date;


SELECT hit_date, hit_issue_id, device_id, hit_module
     , COUNT(*) flap_count
FROM flap
GROUP BY hit_issue_id;



    


