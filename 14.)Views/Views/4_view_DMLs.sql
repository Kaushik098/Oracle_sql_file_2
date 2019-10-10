--------------------------------------------------------------------------------
/*
Views are created for the main purpose of SELECT only
but you can do DMLs on views too - it will indirectly affect the base table

what are the DMLs in SQL?
INSERT INTO <table>
UPDATE <table>
DELETE <Table>

--similarly you can do DMLs on Views
INSERT INTO <simple_view>
UPDATE <simple_view>
DELETE <simple_view>
*/
--------------------------------------------------------------------------------
--DMLs on views
DROP TABLE t_my_table;
CREATE TABLE t_my_table
(
  emp_no NUMBER,
  first_name VARCHAR2(100),
  e_mail VARCHAR2(100),
  salary NUMBER
);

INSERT INTO t_my_table (emp_no, first_name, e_mail, salary) VALUES (1, 'A', '1@1.com', 1000);
INSERT INTO t_my_table (emp_no, first_name, e_mail) VALUES (2, 'B', '1@1.com'); --can you insert the same email id?
--what will be the salary for emp B?
COMMIT;

SELECT * FROM t_my_table;


--Requirement: Create a view on top of t_my_table
--SELECT only emp_no, first_name, e_mail
CREATE OR REPLACE VIEW v_my_table AS
SELECT emp_no, first_name, e_mail
FROM t_my_table;
--is this simple/complex view?

DESC v_my_table

--select and check
SELECT * FROM v_my_table;
--Select in sqldeveloper Views and check

--what is the status
SELECT * FROM USER_OBJECTS
WHERE OBJECT_NAME = 'V_MY_TABLE';

--can you INSERT INTO this simple view?
INSERT INTO v_my_table (emp_no, first_name, e_mail, salary) VALUES (3, 'C', '3@3.com', 1000);
--what is the error? why?
1 ORA-00904: "SALARY": invalid identifier 

--correcting the above 
INSERT INTO v_my_table (emp_no, first_name, e_mail) VALUES (3, 'C', '1@1.com');
--what will be the salary for emp C?
COMMIT;

SELECT * FROM t_my_table;
SELECT * FROM v_my_table;

--UPDATE using view
--will this UPDATE work?
UPDATE v_my_table
SET salary = salary + 100;
1 ORA-00904: "SALARY": invalid identifier 

--will this UPDATE work?
UPDATE v_my_table
SET first_name = 'Mr. '||first_name;
COMMIT;
--this will affect the base table
SELECT * FROM t_my_table;

SELECT * FROM v_my_table;


--DELETE using view
--will this DELETE work?
DELETE FROM v_my_table
WHERE salary > 0;
1 ORA-00904: "SALARY": invalid identifier 
--will this DELETE work?
DELETE FROM v_my_table;

--this will affect the base table
SELECT * FROM t_my_table;

SELECT * FROM v_my_table;
ROLLBACK;
--------------------------------------------------------------------------------
--Add a cosntraint - salary should not be null
ALTER TABLE t_my_table ADD CONSTRAINT nn_my_tab_sal NOT NULL (salary);
3 ORA-00904: : invalid identifier 
--you cannot add NOT NULL constraint like this

ALTER TABLE t_my_table ADD CONSTRAINT chk_my_tab_sal CHECK (salary IS NOT NULL);
--read the error carefully
1 ORA-02293: cannot validate (HR.CHK_MY_TAB_SAL) - check constraint violated 
--read the Action
--you are trying to add SALARY NOT NULL Constraint - but the table already has employees with NULL salary
--so you have to correct it first and then add constraints


SELECT * FROM t_my_table;
--you should be careful while adding constraints - after table creation
--all the available historical data should not violate the constraint you are going to add

--correcting the historical data
UPDATE t_my_table
SET salary = 0
WHERE salary IS NULL;
COMMIT;

SELECT * FROM t_my_table;

--now add the constraint
ALTER TABLE t_my_table ADD CONSTRAINT chk_my_tab_sal CHECK (salary IS NOT NULL);

desc t_my_table -- since you added as CHECK, you cannot see it in desc
--check in sqldeveloper - constraints tab
--or constraints data dictionary - USER_CONSTRAINTS, USER_CONS_COLUMNS

--will this insert violate your constraint?
INSERT INTO t_my_table (emp_no, first_name, e_mail, salary) VALUES (3, 'C', '3@3.com', 1000);
COMMIT;
SELECT * FROM t_my_table;

--will this insert violate your constraint?
INSERT INTO t_my_table (emp_no, first_name, e_mail) VALUES (4, 'D', '1@1.com');
1 ORA-02290: check constraint (HR.CHK_MY_TAB_SAL) violated
--now insert using the view
--will this insert violate your constraint?

INSERT INTO v_my_table (emp_no, first_name, e_mail) VALUES (5, 'E', '1@1.com');
1 ORA-02290: check constraint (HR.CHK_MY_TAB_SAL) violated
--so while creating a view, you should be careful to consider all constraint possibilities
--this view cannot be used for INSERT INTO base table t_my_table because of your constraint
--------------------------------------------------------------------------------

--Try UPDATE DELETE on Views with base tables having constraints

--------------------------------------------------------------------------------
DROP TABLE t_simple_table;
CREATE TABLE t_simple_table
(
  emp_no NUMBER,
  first_name VARCHAR2(100),
  salary NUMBER
);

INSERT INTO t_simple_table (emp_no, first_name, salary) VALUES (1, 'A',1000);
INSERT INTO t_simple_table (emp_no, first_name, salary) VALUES (2, 'B',2000);
INSERT INTO t_simple_table (emp_no, first_name, salary) VALUES (3, 'C',3000);
COMMIT;

SELECT * FROM t_simple_table;

--Requirement: SELECT and show the max salary in t_simple_table
SELECT MAX(salary) FROM t_simple_Table;

--Requirement: This query is required often, make it as an object in database
CREATE OR REPLACE v_simple_tab_max_sal AS
SELECT MAX(salary) FROM t_simple_Table;
--what is the error
1 ORA-00922: missing or invalid option 

--correct it
CREATE OR REPLACE VIEW v_simple_tab_max_sal AS
SELECT MAX(salary) FROM t_simple_Table;
--what is the error
1 ORA-00998: must name this expression with a column alias

CREATE OR REPLACE VIEW v_simlpe_tab_max_sal AS
SELECT MAX(salary) salary FROM t_simple_Table;
--now this is a simple view

--select and check
SELECT * FROM v_simlpe_tab_max_sal;

--now try to insert into this simple view
INSERT INTO v_simlpe_tab_max_sal (salary) VALUES (100);
--what is the error?
1 ORA-01732: data manipulation operation not legal on this view 

--you can only insert into a straight forward simple view

/*
try with:
Group functions
A GROUP BY clause
The DISTINCT keyword
SELECT salary +100
*/
--------------------------------------------------------------------------------
--trying DMLs with complex views
--create a complex view - like 2 base tables
SELECT employee_id, first_name, last_name, e.department_id, department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id;

CREATE OR REPLACE VIEW v_emp_dept AS
SELECT employee_id, first_name, last_name, e.department_id, department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id;

--Select and check
SELECT * FROM v_emp_dept;

--try to insert into this complex view
INSERT INTO v_emp_dept (employee_id, first_name, last_name, department_id, department_name)
VALUES (1,'A','b',30, 'Oracle');
--read the error carefully
ORA-01776:cannot modify more than one base table through a join view

--try with DELETE UPDATE on complex view





