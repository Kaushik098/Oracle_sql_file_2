

DROP TABLE emp_merge;

CREATE TABLE emp_merge
(
 emp_no NUMBER,
 ename VARCHAR2(100),
 salary NUMBER
);

--create sync-up table - like audit table
DROP TABLE emp_merge_sync;
CREATE TABLE emp_merge_sync
(
 emp_no NUMBER,
 ename VARCHAR2(100),
 salary NUMBER
);

select * from emp_merge;
--INSERT
--2 employees joined the company
INSERT INTO emp_merge (emp_no, ename, salary) VALUES (1,'A',100);
--do the same in sync_up table
INSERT INTO emp_merge_sync (emp_no, ename, salary) VALUES (1,'A',100);


INSERT INTO emp_merge (emp_no, ename, salary) VALUES (2,'B',200);
--do the same in sync_up table
INSERT INTO emp_merge_sync (emp_no, ename, salary) VALUES (2,'B',200);

COMMIT;

--Select and check
SELECT * FROM emp_merge;
SELECT * FROM emp_merge_sync;


--UPDATE
--Salary incremented by 100 for all the employees
UPDATE emp_merge SET salary = salary + 100;
UPDATE emp_merge_sync SET salary = salary + 100;

COMMIT;

--------------------------------------------------------------------------------
--one of the employee quit the company
DELETE FROM emp_merge WHERE emp_no = 2;
DELETE FROM emp_merge_sync WHERE emp_no = 2;

COMMIT;
--Select and check
SELECT * FROM emp_merge;
SELECT * FROM emp_merge_sync;
--------------------------------------------------------------------------------

--Assume, the sync-up was not done - was missed unfortunately

--insert into main table only
--2 new employees joined the company
INSERT INTO emp_merge (emp_no, ename, salary) VALUES (3,'C',300);
INSERT INTO emp_merge (emp_no, ename, salary) VALUES (4,'D',400);

--update into main table only
--increase salary by 50 for all
UPDATE emp_merge SET salary = salary + 50;
COMMIT;
--both the tables are not in sync
--pin it
SELECT * FROM emp_merge;

SELECT * FROM emp_merge_sync;

--------------------------------------------------------------------------------
--Now we have to sync both the tables. How?


select * from emp_merge;
select * from emp_merge_sync;

insert into emp_merger_sync values 
(
select emp_no from emp_merge  where emp_no = 3,
select ename from emp_merge  where emp_no = 3, 
select salary from emp_merge  where emp_no = 3,
)

insert into emp_merge_sync values (2,'B',300);

-- before 
emp_merge
1	A	250
3	C	350
4	D	450

emp_merge_sync
1	A	200

-- after insert/update
emp_merge
1	A	250
3	C	350
4	D	450

update emp_merge_sync es set es.salary = (select salary from emp_merge e where e.emp_no = es.EMP_NO) 

insert into emp_merge_sync
select * from EMP_MERGE
minus
select * from emp_merge_sync;

select * from emp_merge;
select * from emp_merge_sync;

rollback;
------------------------------------------------
- Option 2 

delete and insert 

delete from emp_merge_sync;

insert into emp_merge_sync 
select * from emp_merge;

select * from emp_merge;
select * from emp_merge_sync;
------------------------------------------------
-Option 3

emp_merge_sync - target table
emp_merge  - source table 

Syntax:
MERGE INTO <target_table> t
USING (<source>) s
ON (t.column = s.column)
WHEN MATCHED THEN
UPDATE SET t.ename = s.ename, t.salary = s.salary
WHEN NOT MATCHED THEN
INSERT (ename, salary)
VALUES (s.ename, t.salary);

- Example
merge into emp_merge_sync e1
using emp_merge e2
on (e1.emp_no = e2.emp_no)
when matched then
update set e1.ename = e2.ename, e1.salary = e2.salary
when not matched then
insert (emp_no, ename, salary)
values (e2.emp_no, e2.ename, e2.salary)

select * from emp_merge;
select * from emp_merge_sync;

rollback;


WHEN MATCHED THEN
UPDATE SET t.ename = s.ename, t.salary = s.salary
DELETE WHERE s.salary IS NULL

-----------------------------------------------------------------------
- Task - Find another example for merge 


-- before 
emp_merge
1	A	250
3	C	350
4	D	450

emp_merge_sync
1	A	200

-- after insert/update
emp_merge
1	A	250
3	C	350
4	D	450


-- Using join updated 

update emp_merge_sync set salary = (
select em.salary 
from emp_merge em join emp_merge_sync ems
on (em.emp_no = ems.emp_no)
);


insert into emp_merge_sync 
select emp_no, ename, salary from emp_merge 
minus
select emp_no, ename, salary from emp_merge_sync;

select * from emp_merge;
select * from emp_merge_sync;


---------------------------------------------------------
merge into emp_merge_sync ems 
using emp_merge em 
on (em.emp_no = ems.emp_no)
when matched then 
update set ems.ename = em.ename, ems.salary = em.salary
when not matched then
insert (emp_no,ename, salary) 
values (em.emp_no, em.ename, em.salary);

select * from emp_merge_sync;
rollback;


