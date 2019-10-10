--check the status column - important
SELECT * FROM USER_OBJECTS
WHERE OBJECT_NAME = 'V_RESTRICTED_EMP_DATA';


--when will a view become invalid?
CREATE TABLE t_invalid
(
  num1 NUMBER,
  num2 NUMBER,
  num3 NUMBER
  );


--create a view on top of t_invalid and show only 2 columnsin that view
CREATE OR REPLACE VIEW v_invalid AS
SELECT num1, num2 FROM t_invalid;

DESC v_invalid

--select and check
SELECT * FROM v_invalid;
--Select in sqldeveloper Views and check

--what is the status
SELECT * FROM USER_OBJECTS
WHERE OBJECT_NAME = 'V_INVALID';

--suppose, num1 column is dropped from t_invalid
ALTER TABLE t_invalid DROP COLUMN num1; --DDL command/syntax

--check the status of view V_INVALID in connections window - refresh "views" and then check
--you will have a red mark - meaning status of v_invalid is INVALID

--what is the status
SELECT * FROM USER_OBJECTS
WHERE OBJECT_NAME = 'V_INVALID';

-(INVALID)

--what will happen if I do a select on this view?
SELECT * FROM v_invalid;
--read the error carefully
1 ORA-04063: view "HR.V_INVALID" has errors 


--what will happen now?
SELECT * FROM t_invalid;

--how to make the view valid again?
--Solution 1: Add the column in the table again
--Solution 2: recreate the view - remove the column from SELECT list - you can do it easily

--Solution 1: Add the column in the table again
ALTER TABLE t_invalid ADD num1 NUMBER; --DDL command/syntax
--the column will be added in the end only

--select and check
SELECT * FROM t_invalid;
select * from user_tab_columns where table_name = 'T_INVALID';

--Now check the status of view v_invalid in connections - View in sqldeveloper - refresh and check
--has the status changed?
SELECT * FROM USER_OBJECTS
WHERE OBJECT_NAME = 'V_INVALID';

--what will happen if I do a select on this view?
SELECT * FROM v_invalid;

--when you dropped the column in that table, the view status automatically got changed to invalid
--but when you fixed the issue, the view status will not auto change to VALID again

--how to change the status to valid again?
--option1:
ALTER VIEW v_invalid COMPILE;

--Now check the status of view v_invalid in connections - View in sqldeveloper - refresh and check
--has the status changed?
SELECT * FROM USER_OBJECTS
WHERE OBJECT_NAME = 'V_INVALID';

--OR option2:
--just do a simple SELECT
--this will change the status from invalid to valid
SELECT * FROM v_invalid;
--------------------------------------------------------------------------------


select * from user_objects where status = 'VALID';

create view v_invalid_objects as 
select * from user_objects where status = 'INVALID';

select * from v_test1;
select * from v_invalid_objects;

