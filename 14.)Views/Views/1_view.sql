--Creating Other schema objects


/*
DDL - Data Definition Language
--will create objects like
Table		- Basic unit of storage; composed of rows
View		- Logically represents subsets of data from one or more tables
Sequence	- Generates numeric values
Index		- Improves the performance of some queries
Synonym		- Gives alternative name to an object

DDLs - auto commit
CREATE
ALTER
RENAME
DROP
TRUNCATE
*/
--------------------------------------------------------------------------------
/*
VIEW - 
- A view is a logical table based on a table or another view. 
- A view contains no data of its own, but is like a window through which data 
from tables can be viewed or changed. 
- The tables on which a view is based are called base tables.
*/

--just add "CREATE VIEW" on top of the SELECT
CREATE VIEW <view_name> AS --view name cannot exceed 30 characters
<your query>; -- it can be any lengthy query - subqueries - complex queries - join queries


--Advantages of Views
--1) Views restrict access to the data because it displays selected columns from the table.
--we saw in the above example
--------------------------------------------------------------------------------

--for our requirement
CREATE VIEW v_restricted_emp_data AS
SELECT employee_id, first_name, department_id FROM employees;

--now you have created an object in database and that object is VIEW

--how to run and check the view?
SELECT * FROM v_restricted_emp_data;

DESC v_restricted_emp_data

/*
important note: 
- View is like a window for table employees
- View does not have data of its own
- when ever you query a view, it internally queries the base table (employees) and retrieves data
- this is like indirectly accessing employees table
*/


--get sqldeveloper help - connections window - see under Views

--data dictionary
--check the status column - important
SELECT * FROM USER_OBJECTS
WHERE OBJECT_NAME = 'V_RESTRICTED_EMP_DATA';

SELECT * FROM USER_VIEWS;

--------------------------------------------------------------------------------
--Requirement: Instead of column first_name - show as f_name, last_name as l_name, department_id as d_id
CREATE OR REPLACE VIEW v_restricted_emp_data AS --view name cannot exceed 30 characters
SELECT employee_id, first_name f_name, last_name l_name, email, department_id d_id FROM employees;

--select and check
SELECT * FROM v_restricted_emp_data;

--OR you can do like this
CREATE OR REPLACE VIEW v_restricted_emp_data (employee_id, f_name, l_name, email, d_id)
AS
SELECT employee_id, first_name, last_name, email, department_id FROM employees;

select * from V_RESTRICTED_EMP_DATA;

--select and check
SELECT * FROM v_restricted_emp_data;

--the first approach is best practice
--------------------------------------------------------------------------------
--Requirement: In the above view, add 'E_' for all employees and display
CREATE OR REPLACE VIEW v_restricted_emp_data AS --view name cannot exceed 30 characters
SELECT '888'||employee_id, first_name f_name, last_name l_name, email, department_id d_id FROM employees;
--what is the error?
1 ORA-00998: must name this expression with a column alias 

CREATE OR REPLACE VIEW v_restricted_emp_data AS
SELECT '888'||employee_id employee_id, first_name f_name, last_name l_name, email, department_id d_id FROM employees;

select * from V_RESTRICTED_EMP_DATA;

--select and check
SELECT * FROM v_restricted_emp_data;
--Select in sqldeveloper Views and check

--can you create a view like this for this requirement?
CREATE OR REPLACE VIEW v_restricted_emp_data ('888'||employee_id + 1, f_name, l_name, email, d_id)
AS
SELECT employee_id, first_name, last_name, email, department_id FROM employees;
--No
1 ORA-00904: : invalid identifier 

--------------------------------------------------------------------------------
--check the status column - important
SELECT * FROM USER_OBJECTS
WHERE OBJECT_NAME = 'V_RESTRICTED_EMP_DATA';


--Requirement: Select and show me employee_id, first_name, last_name, email, department_id from employees table
--fetch and show only the employees in dept 30

CREATE VIEW v_restricted_emp_data2 AS --view name cannot exceed 30 characters
SELECT employee_id, first_name, last_name, department_id
FROM employees
WHERE department_id = 30;

--check the status in data dictionary

--select and check
SELECT * FROM v_restricted_emp_data2;
--slide 5
--------------------------------------------------------------------------------
--how to drop views?
DROP VIEW v_restricted_emp_data3; --DDL
--will this DELETE the data?
--will this DROP the base table

--------------------------------------------------------------------------------

CREATE VIEW 	empvu80
 AS SELECT  employee_id, last_name, salary
    FROM    employees
    WHERE   department_id = 80;

select * from empvu80;

CREATE VIEW 	salvu50
 AS SELECT  employee_id ID_NUMBER, last_name NAME,
            salary*12 ANN_SALARY
    FROM    employees
    WHERE   department_id = 50;


CREATE OR REPLACE VIEW empvu80
  (id_number, name, sal, department_id)
AS SELECT  employee_id, first_name || ' ' 
           || last_name, salary, department_id
   FROM    employees
   WHERE   department_id = 80;

CREATE OR REPLACE VIEW dept_sum_vu
  (name, minsal, maxsal, avgsal)
AS SELECT   d.department_name, MIN(e.salary), 
            MAX(e.salary),AVG(e.salary)
   FROM     employees e JOIN departments d
   ON       (e.department_id = d.department_id)
   GROUP BY d.department_name;

select * from DEPT_SUM_VU;

