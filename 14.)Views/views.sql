-Creating Other schema objects

1) what is a view?
         - A view is a logical table based on a table or another view. 
         - A view contains no data of its own, but is like a window through which data 
           from tables can be viewed or changed. 
         - The tables on which a view is based are called base tables.

2) types of views
- simple view - single base table
- complex view - more than one base table - join/subquery/set

3) can u do DML in views?
- yes, but only in simple views

4) invalid views

5) read only view

/*
DDL - Data Definition Language
--will create objects like
Table	- Basic unit of storage; composed of rows
View	- Logically represents subsets of data from one or more tables
Sequence	- Generates numeric values
Index	- Improves the performance of some queries
Synonym	- Gives alternative name to an object
*/

--------------------------------------------------------------------------------
/*
VIEW - 
- A view is a logical table based on a table or another view. 
- A view contains no data of its own, but is like a window through which data 
from tables can be viewed or changed. 
- The tables on which a view is based are called base tables.
*/

CREATE VIEW v_restricted_emp_data AS
SELECT employee_id, first_name, department_id FROM employees;

select * from V_RESTRICTED_EMP_DATA;

select * from user_objects where object_type = 'VIEW';

select * from user_views where view_name = 'V_RESTRICTED_EMP_DATA';

-- Req:

Add another column job_id

CREATE VIEW v_restricted_emp_data AS
SELECT employee_id, first_name, department_id, job_id FROM employees;
1 ORA-00955: name is already used by an existing object 

DROP VIEW v_restricted_emp_data;

CREATE VIEW v_restricted_emp_data AS
SELECT employee_id, first_name, department_id, job_id FROM employees;

select * from v_restricted_emp_data;

-----------

create or replace view v_restricted_sales_emp as
select employee_id, first_name, last_name, salary, department_name 
from employees e join departments d 
on (e.DEPARTMENT_ID = d.DEPARTMENT_ID)
where d.DEPARTMENT_NAME = 'Sales';

select * from V_RESTRICTED_SALES_EMP;

- Now adding another column in created view 

create or replace view v_restricted_sales_emp as
select employee_id, first_name, last_name, salary, job_id, department_name 
from employees e join departments d 
on (e.DEPARTMENT_ID = d.DEPARTMENT_ID)
where d.DEPARTMENT_NAME = 'Sales';

select * from V_RESTRICTED_SALES_EMP;

--------------------------------------------------------

Fetching some queries and trying to create views 

- From string Functions 

1.)

create view v_reverse_region as
SELECT REVERSE(region_name) FROM regions;
1 ORA-00998: must name this expression with a column alias 


create view v_reverse_region as
SELECT REVERSE(region_name) rev FROM regions;

select * from V_REVERSE_REGION;


2.)

 create or replace view v_trm_name as
 SELECT TRIM('    naina    ') FROM dual;
 1 ORA-00998: must name this expression with a column alias 
         
 create or replace view v_trm_name as
 SELECT TRIM('    naina    ') name_trim FROM dual;

 select * from v_trm_name;
 

 -- (IMP) Always use alias name while creating a view based upon any string functions  
----------------------------------------------------------------------------------------------------
- From Null Functions 

1.)

  create or replace view v_coalesce_test as
  SELECT * FROM T_COALESCE_TEST 
  WHERE COALESCE(FATHER_NUMBER, MOTHER_NUMBER,SPOUSE_NUMBER) IS NULL ;  

select * from V_COALESCE_TEST;


2.) 

create or replace view v_null_func_usage as
SELECT first_name, last_name, NVL(Length(first_name),100) n1, NVL(Length(last_name),100) n2 FROM employees;

select * from v_null_func_usage;

----------------------------------------------------------------------------------------------------

- From Group Row Functions

1.)
create view v_sum_num as
select sum (10+20+30) add_num from dual; 

select * from v_sum_num;


2.)
create view v_avg_num as 
SELECT AVG(nvl(com_pct,0)) avg_num FROM GRPWORK;

select * from v_avg_num;

select round(avg_num,2) from v_avg_num;


3.)
create or replace view v_all_group_row_func as
SELECT  SUM(com_pct) a1,
       MIN(com_pct) a2,
       MAX(com_pct) a3,
       AVG(NVL(com_pct,0)) a4,
       COUNT(NVL(com_pct,0)) a5
FROM grpwork;

select * from v_all_group_row_func;

--------------------------------------------------------------------------------------

- From Group By and Having 

1.)
create or replace view v_dept_count as
select department_id, count(*) dept_count from EMPLOYEES
group by department_id order by department_id;

select * from v_dept_count;

2.)
create or replace view v_city_group_by as
select city, max(course_fees) max_course_fees from T_GRP_EXAMPLE
group by city
having max(course_fees) > 3000;

select * from v_city_group_by;

---------------------------------------------------------------------------------------------------
- From Set Operators


1.)
create or replace view v_union_test as
SELECT * FROM setTest1
UNION  
SELECT * FROM setTest2;   

select * from v_union_test;

2.)
create or replace view v_union_all_test as
SELECT * FROM setTest1
UNION ALL 
SELECT * FROM setTest2;

select * from v_union_all_test;


---------------------------------------------------------------------------------------
- From joins

1.)
create or replace view v_ansi_join_example as
select *
from employees e join departments d 
on (e.DEPARTMENT_ID = d.DEPARTMENT_ID)
1 ORA-00957: duplicate column name 

create or replace view v_ansi_join_example as
select e.employee_id, e.first_name, d.department_id
from employees e join departments d 
on (e.DEPARTMENT_ID = d.DEPARTMENT_ID)


select * from v_ansi_join_example;

2.)
create or replace view v_emp_mgr_details as
select wkr.employee_id, wkr.first_name, mgr.EMPLOYEE_ID, mgr.FIRST_NAME
from t_test_emp wkr join t_test_emp mgr
on (wkr.MANAGER_ID = mgr.EMPLOYEE_ID)
1 ORA-00957: duplicate column name 

- Question: So we cannot create a self join view ?

------------------------------------------------------------------------------------------------

- From Sub_query 

1.)
create or replace view v_child_tables_of_departments as
select * from
(
select uc.table_name
from user_constraints uc
where UC.R_CONSTRAINT_NAME = 'DEPT_ID_PK'
)

select * from v_child_tables_of_departments;

create or replace view v_select_sub_query as
SELECT  (SELECT SYSDATE FROM DUAL) today,
        (SELECT 1 ID FROM DUAL) num, --ID alias name will be overridden
        (SELECT 1 ID FROM DUAL) z
FROM DUAL;

select * from v_select_sub_query;

----------------------------------------------------------------

v_select_sub_query
v_child_tables_of_departments

select * from user_objects where OBJECT_NAME like '%RETIRED%';

select * from EMPLOYEES_TABLE1_RETIRED;
select * from EMPLOYEES_TABLE2_RETIRED;

create view v_retired_emp_det1 as
select * from EMPLOYEES_TABLE1_RETIRED;

create view v_retired_emp_det2 as
select * from EMPLOYEES_TABLE2_RETIRED;

select * from V_RETIRED_EMP_DET1;
select * from V_RETIRED_EMP_DET2;


create view v_all as 
select * from V_RETIRED_EMP_DET1 
union select * from v_retired_emp_det2;

select * from v_all;
-------------------------------------------------
create or replace view v_calls as 
select * from t_calls;
2 ORA-00942: table or view does not exist 
- just assume 

create or replace view v_sms as
select * from t_sms
- just assume 

create or replace view v_mms as
select * from t_mms

create or replace v_full_bill_details as
select * from v_calls
union all 
select * from v_sms
union all 
select * from v_mms

- It fetches the details of Customer
select * from v_full_bill_details where customer_name = 'Kaushik'


create or replace view v_all_message_service as 
select * from v_sms 
union all 
select * from v_mms;

select * from v_all_message_service where customer_name = 'Kaushik';



