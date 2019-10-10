
Grants:

Giving privileges 

Types:
1.) System privileges - DBA (Granting from sys to business schemas)
2.) Object privileges - Granting within business schemas 

1.) system privileges:

>creating and granting schemas 
>login sysschema 

>how to unlock a business schema like HR ?
ALTER USER HR ACCOUNT UNLOCK;
(user is nothing but schema in oracle) 


>how to reset password for a business schema ?
ALTER USER HR identified by NeemTree; --password is case sensitive
-  ORA-01031: insufficient privileges(Can be done by DBA only)

> unlocking and password reset in one query 
ALTER USER HR ACCOUNT UNLOCK IDENTIFIED BY hr;
2 ORA-01031: insufficient privileges


>creating a business schema 
CREATE USER HR22 IDENTIFIED BY hr22;
1 ORA-01031: insufficient privileges (Can be done by DBA only)


After creating the new schema HR22 in sys, now connect to the HR22 
You will get the below error:
user HR22 lasks Create session privilege; logon denied

Connect to sys and run below:
SQL> grant create session to hr22;

Grant succeeded.

- Now connect to HR22, it will connect

select * from user_objects;

- Since this is a new schema there is no objects 

create the table in the new schema HR22

create table employees (id number, name varchar(100));
1 ORA-01031: insufficient privileges 

- Now login sys and run below
SQL> grant connect,resource to hr22;

Grant succeeded.

- Now login HR22 and try to create table 
create table employees2 (id number, name varchar(100));

select * from user_objects;


create sequence sequence1;

select * from user_objects;

- Drop schema

connect as sys

drop user hr22;
ERROR at line 1:
ORA-01940: cannot drop a user that is currently connected


user HR22 lasks Create session privilege; logon denied

drop user hr22;

drop user hr22
*
ERROR at line 1:
ORA-01922: CASCADE must be specified to drop 'HR22'

SQL> drop user hr22 cascade;


Revoke:

SQL> revoke connect,resource from hr26;

Revoke succeeded.

--other sys data dictionaries

SELECT * FROM DBA_TABLES;

SELECT * FROM DBA_TABLES
WHERE OWNER = 'HR';

SELECT * FROM DBA_SEQUENCES
WHERE SEQUENCE_OWNER = 'HR';

SELECT SEQUENCE_OWNER, COUNT(*) cnt
FROM DBA_SEQUENCES
GROUP BY SEQUENCE_OWNER
ORDER BY 2 DESC;

select owner, count(*) cnt_of tables 
from dba_tables 
group by owner
order by 2 desc;

select owner, count(*) cnt
from dba_views
group by owner
order by 2 desc;

select owner, count(*) cnt
    from dba_objects
    group by owner
    order by 2 desc;

select owner, object_type, count(*) count_of_obj_type
    from dba_objects
    group by (owner,object_type)
    order by 1 asc;


 Object Priviledge - Commuincate from one schema to another schema(Business Schema)

- new schema created name abcd

  connect as sys;
 
 grant create session to abcd;

 grant connect,resource to abcd;

 connect abcd/abcd;

- Trying to access employees table in abcd schema from another schema i.e.) HR 
 select * from employees;
 ORA-00942: table or view does not exist

 select * from hr.employees;
 ORA-00942: table or view does not exist
Since HR schema did not grant select priviledge on employees table to abcd schema, you got the above error. 

 grant select on employees to abcd;

 now connecting abcd.... 
 connecct abcd/abcd;

 select * from hr.employees;
 (success)

- now updating from abcd 
update hr.employees set salary = salary + 100;
ORA-01031: insufficient privileges

- now connecting hr schema and trying to grant 

grant update on employees to abcd;

select * from employees;


REVOKE

revoke select,update on employees from abcd;

- Following query grants all DML, DDL operations access to ABCD
grant all on employees to abcd;

SQL> alter table hr.employees add emp_extra_column varchar2(100);

Table altered.


alter table employees drop column emp_extra_column;

--------------------------------------------------------------

Accessing table from abcd in HR schema 

select * from abcd.emp_data;
1 ORA-00942: table or view does not exist 
 
granting select permission on abcd to access in employees table

grant select on emp_data to HR;

Now trying to access 
select * from abcd.emp_data;

---------------------

Data Dictionary 

select * from user_objects;

select * from user_tables;

select * from all_objects;

select * from all_objects where owner = 'ABCD';

select distinct owner from all_objects;

select * from all_views;

select owner, object_type, count(*) count_of_objects
from all_objects
group by (owner,object_type)
order by 1;


SELECT OWNER, COUNT(*) cnt FROM ALL_OBJECTS
GROUP BY OWNER
ORDER BY 2 DESC;
- it gives the count of own objects as well as granted object


--object privileges to multiple schemas
GRANT SELECT ON EMPLOYEES TO HR3, HR4;
REVOKE SELECT ON EMPLOYEES FROM HR3, HR4;

GRANT ALL ON EMPLOYEES TO HR3, HR4;
REVOKE ALL ON EMPLOYEES FROM HR3, HR4;

-- automatically it grant table to all existing schemas and also new schemas which will be created in future.
GRANT ALL ON EMPLOYEES TO public;
revoke all on employees from public;

grant all on departments to public;

select distinct owner, count(*) from all_objects
group by owner;

--Communication between more than 2 schemas

connect to abcd/abcd;

SQL> select  owner, object_name, object_type from all_objects where owner = 'HR';

OWNER                          OBJECT_NAME                    OBJECT_TYPE
------------------------------ ------------------------------ -------------------
HR                             DEPARTMENTS                    TABLE
HR                             EMPLOYEES                      TABLE
HR                             SECURE_EMPLOYEES               TRIGGER
HR                             UPDATE_JOB_HISTORY             TRIGGER

HR schema has granted access to four objects to abcd schemas as shown above 

-- Trying to grant HR.employees to another schema from abcd gives below error:
SQL> grant all on hr.employees to xyz;
grant all on hr.employees to xyz
                *
ERROR at line 1:
ORA-01929: no privileges to GRANT

Since abcd schema is not the owner of employees table, the above grant will fail

So HR schema can directly grant to xyz;

---------- another option for the above scenario 

login HR schema 

grant all on employees to abcd with grant option;

login to abcd/abcd and try now

SQL> grant all on hr.employees to xyz;

Grant succeeded.

-------------------

- Now trying to access employees table from xyz

SQL> select * from  hr.employees
(success)







 




 




