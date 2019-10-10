

/*
FORCE		Creates the view regardless of whether or not the base tables exist
NOFORCE		Creates the view only if the base tables exist (This is the default.)
*/

--will this view get created
CREATE OR REPLACE VIEW v_test1
AS
SELECT * FROM sgjkshgkjhsfjg;
--read the error carefully
1 ORA-00942: table or view does not exist 

SELECT * FROM USER_OBJECTS
WHERE object_name = 'V_TEST1';

SELECT * FROM USER_VIEWS
WHERE view_name = 'V_TEST1';
--------------------------------------------------------------------------------
--forcing the view to get created
--use FORCE
CREATE OR REPLACE force VIEW v_test1
AS
SELECT * FROM sgjkshgkjhsfjg;

SELECT * FROM USER_OBJECTS
WHERE object_name = 'V_TEST1';
--check the status column

SELECT * FROM USER_VIEWS
WHERE view_name = 'V_TEST1';

--what will happen"
SELECT * FROM v_test1;
3 ORA-04063: view "HR.V_TEST1" has errors 

