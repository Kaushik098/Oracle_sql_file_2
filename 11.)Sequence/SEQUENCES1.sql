--Creating Other schema objects

/*
Table - Basic unit of storage; composed of rows
View - Logically represents subsets of data from one or more tables
Sequence - Generates numeric values
Index - Improves the performance of some queries
Synonym - Gives alternative names to objects
*/


--Sequence - Generates numeric values
--Requirement:
--Create a table to store emp details - make emp_id as Primary key
select * from T_emp_test;
DROP TABLE t_emp_Test;
CREATE TABLE t_emp_test
(
  emp_id NUMBER CONSTRAINT pk_emp_test_id PRIMARY KEY,
  e_name VARCHAR2(100),
  salary NUMBER NOT NULL
);


INSERT INTO t_emp_Test (emp_id, e_name, salary) values (1, 'A', 100);
COMMIT;
SELECT * FROM t_emp_Test;

--will this row get inserted?
INSERT INTO t_emp_Test (emp_id, e_name, salary) values (1, 'B', 200);
--read the error carefully(unique constraint ORA-00001)

--will this row get inserted?
INSERT INTO t_emp_Test (emp_id, e_name, salary) values (2, 'B', 100);
COMMIT;
SELECT * FROM t_emp_Test;

--Requirement: 3rd employee has joined in the company. Insert his details in the database
--how will you know the next employee_id to be inserted?
SELECT * FROM t_emp_Test;

SELECT MAX(emp_id) FROM t_emp_test;

INSERT INTO t_emp_Test (emp_id, e_name, salary) values (3, 'C', 300);
COMMIT;
SELECT * FROM t_emp_Test;

--4th employee
INSERT INTO t_emp_Test (emp_id, e_name, salary) values (4, 'D', 400);
COMMIT;
SELECT * FROM t_emp_Test;

--How to automate this emp_id column value insertion?
--use sequence

/*
Sequence -
- Can automatically generate unique numbers
*/


CREATE SEQUENCE t_emp_Test;
3 ORA-00955: name is already used by an existing object 

--what is the error?

DROP SEQUENCE seq_emp_test_emp_id;
CREATE SEQUENCE seq_emp_test_emp_id;

--check in sqldeveloper - connections window - under Sequences
/*
important columns
START WITH - default 1
MINVALUE - default 1
MAXVALUE - default 9999999999999999999999999999
INCREMENT BY - default 1
*/
--data dictionary
SELECT * FROM USER_OBJECTS
WHERE object_name = 'SEQ_EMP_TEST_EMP_ID';

SELECT * FROM USER_SEQUENCES
WHERE sequence_name = 'SEQ_EMP_TEST_EMP_ID';

SELECT OBJECT_TYPE, COUNT(*)
FROM USER_OBJECTS
GROUP BY OBJECT_TYPE
ORDER BY 2 DESC;

--how to find the value in the sequence?
--sequence has a pseudo column CURRVAL
SELECT SEQ_EMP_TEST_EMP_ID.CURRVAL FROM DUAL;
--what is the error?
3 ORA-08002: sequence SEQ_EMP_TEST_EMP_ID.CURRVAL is not yet defined in this session 

--For the first time usage of sequence, NEXTVAL (another Sequence pseudo column) must be issued for that sequence before CURRVAL.
SELECT SEQ_EMP_TEST_EMP_ID.NEXTVAL FROM DUAL;
--so sequence.NEXTVAL is the main way of using a sequence

--what will be the output?
SELECT SEQ_EMP_TEST_EMP_ID.CURRVAL FROM DUAL;

--------------
--what will be the output?
SELECT SEQ_EMP_TEST_EMP_ID.NEXTVAL FROM DUAL;

--what will be the output?
SELECT SEQ_EMP_TEST_EMP_ID.CURRVAL FROM DUAL;

/*
NEXTVAL returns the next available sequence value. 
It returns a unique value every time it is referenced, even for different users.

CURRVAL obtains the current sequence value.
*/

--check in sqldeveloper - connections window - under Sequences

SELECT * FROM USER_SEQUENCES
WHERE sequence_name = 'SEQ_EMP_TEST_EMP_ID';
--------------------------------------------------------------------------------
--How to use this sequence and insert into t_emp_Test?

--we will start from first
DELETE FROM t_emp_test;
COMMIT;

SELECT * FROM t_emp_test;

--we will start from first
DROP SEQUENCE seq_emp_test_emp_id;
CREATE SEQUENCE seq_emp_test_emp_id;

INSERT INTO t_emp_Test (emp_id, e_name, salary) values (SEQ_EMP_TEST_EMP_ID.nextval, 'A', 100);
INSERT INTO t_emp_Test (emp_id, e_name, salary) values (SEQ_EMP_TEST_EMP_ID.nextval, 'B', 200);
INSERT INTO t_emp_Test (emp_id, e_name, salary) values (SEQ_EMP_TEST_EMP_ID.nextval, 'C', 400);
INSERT INTO t_emp_Test (emp_id, e_name, salary) values (SEQ_EMP_TEST_EMP_ID.nextval, 'D', 500);
COMMIT;

SELECT * FROM t_emp_Test;


--what will be the output?
SELECT SEQ_EMP_TEST_EMP_ID.CURRVAL FROM DUAL;
(4)
--by mistake I ran the below query
--what will be the output?
SELECT SEQ_EMP_TEST_EMP_ID.NEXTVAL FROM DUAL;
(5)
--what will be the output?
SELECT SEQ_EMP_TEST_EMP_ID.CURRVAL FROM DUAL;
(5)
--------------------------------------------------------------------------------
--Requirement: Insert a 5th employee
--what will be the sequence no getting inserted
INSERT INTO t_emp_Test (emp_id, e_name, salary) values (SEQ_EMP_TEST_EMP_ID.nextval, 'E', 600);

--what will be the sequence no getting inserted
SELECT * FROM t_emp_test;

--they are asking to rollback the insert
ROLLBACK; -- TCLs will not affect sequence

--what will be the output?
SELECT SEQ_EMP_TEST_EMP_ID.CURRVAL FROM DUAL;
(6)

--after sometime, asking to reinsert
INSERT INTO t_emp_Test (emp_id, e_name, salary) values (SEQ_EMP_TEST_EMP_ID.nextval, 'E', 600);
--now they are asking you to commit - no further changes for Employee E
--so commit
COMMIT;

--what will be the output?
SELECT SEQ_EMP_TEST_EMP_ID.CURRVAL FROM DUAL;
(7)
--what will be the sequence no getting inserted
SELECT * FROM t_emp_test;

--emp_id does not start from 1 or doesnot follow sequential order - not an issue - it should satisy PK rules - NOT NULL and UNIQUE
--for readibility, it should be in a sequence
--------------------------------------------------------------------------------
--what will happen, if there is any run time error

--what will be the output?
SELECT SEQ_EMP_TEST_EMP_ID.CURRVAL FROM DUAL;

--can you guess the error which will occur?
INSERT INTO t_emp_Test (emp_id, e_name, salary) values (SEQ_EMP_TEST_EMP_ID.nextval, 'F', '');
--read the error
3 ORA-01400: cannot insert NULL into ("HR"."T_EMP_TEST"."SALARY") 

--what will be the output?
SELECT SEQ_EMP_TEST_EMP_ID.CURRVAL FROM DUAL;
(8)
--The sequence got incremented and then was used for insertion - the insertion failed which does not matter to the sequence
--once sequence got incremented, then thats it
--------------------------------------------------------------------------------
--I want the sequence to be like 4, 8, 12, 16, 20 ...
--If you are going to create a new sequence then
DROP SEQUENCE seq_name;
CREATE SEQUENCE seq_name START WITH 4 INCREMENT BY 4;

--run this SELECT again and again
SELECT seq_name.nextVAL from dual;

--Modifying an existing Sequence
--for our case
SELECT seq_emp_test_emp_id.CURRVAL from dual;
ALTER SEQUENCE seq_emp_test_emp_id INCREMENT BY 4;

--what will be the output?
SELECT seq_emp_test_emp_id.CURRVAL from dual;
(8)
--what will be the output?
--run again
SELECT seq_emp_test_emp_id.NEXTVAL from dual;

INSERT INTO t_emp_Test (emp_id, e_name, salary) values (SEQ_EMP_TEST_EMP_ID.nextval, 'G', 6000);
INSERT INTO t_emp_Test (emp_id, e_name, salary) values (SEQ_EMP_TEST_EMP_ID.nextval, 'H', 7000);
COMMIT;
SELECT * FROM t_emp_test;
--------------------------------------------------------------------------------
--Modifying a Sequence
--create a sequence with maxvalue 3
DROP sequence seq_max_3;
CREATE SEQUENCE seq_max_3 MAXVALUE 3;
--check the sequence in sqldeveloper connections and data dictionary

--what will be the output?
SELECT seq_max_3.CURRVAL FROM DUAL;
3 ORA-08002: sequence SEQ_MAX_3.CURRVAL is not yet defined in this session 

--what will be the output?
--run again and again
SELECT seq_max_3.NEXTVAL FROM DUAL;
--read the error
3 ORA-08004: sequence SEQ_MAX_3.NEXTVAL exceeds MAXVALUE and cannot be instantiated 
--how to increase the maxvalue?
ALTER SEQUENCE seq_max_3 MAXVALUE 100;

--run again and again
SELECT seq_max_3.NEXTVAL FROM DUAL;


--------------------------------------------------------------------------------


11/08/2109

-- We should not use sequence in Sub query

SELECT * FROM DUAL
WHERE 1 = (SELECT my_seq.nextval FROM DUAL);


SELECT (SELECT my_seq.nextval FROM DUAL) FROM DUAL;


SELECT * 
FROM
( 
SELECT my_seq.nextval FROM DUAL
);