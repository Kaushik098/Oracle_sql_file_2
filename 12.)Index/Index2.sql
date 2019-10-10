
Types of Index:

- Normal index 
- Unique index 
- Function Based Index
- Composite index 

Three important things to remember:

Full table scan
Range scan 
Unique scan 


Unique constraints will automatically create unique index 

But we are trying to create unique index on mobile number column of our own.

And we are trying to find the difference between normal index and unique index on mobile number.



create table index_details(mobile_no number);

-- Befor creating index 
explain plan for select * from index_details where mobile_no = 111;
select plan_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

Id  | Operation         | Name          | Rows  | Bytes | Cost (%CPU)| Time  
|   0 | SELECT STATEMENT  |               |     1 |    13 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| INDEX_DETAILS |     1 |    13 |     2   (0)| 00:00:01 |


create index idx_index_details on index_details(mobile_no);

-- After creating normal index 
explain plan for select * from index_details where mobile_no = 111;
select plan_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

Plan hash value: 4024224599
 
--------------------------------------------------------------------------------------
| Id  | Operation        | Name              | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT |                   |     1 |    13 |     1   (0)| 00:00:01 |
|*  1 |  INDEX RANGE SCAN| IDX_INDEX_DETAILS |     1 |    13 |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------

select * from user_constraints where table_name = 'INDEX_DETAILS';
select * from user_cons_columns where table_name = 'INDEX_DETAILS';

select * from user_indexes where table_name = 'INDEX_DETAILS';
select * from user_ind_columns where table_name = 'INDEX_DETAILS';

insert into index_details values (11111111);
insert into index_details values (22222222);


INDEX PAGE
MOBILE_NO
-----

11111111 - AAAFvOAAEAAAArvAAA, AAAFvOAAEAAAArvAAC
22222222 - AAAFvOAAEAAAArvAAB

select rowID, e.* from index_details e;

explain plan for select * from index_details where mobile_no = 11111111;
select plan_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

Plan hash value: 4024224599
 
--------------------------------------------------------------------------------------
| Id  | Operation        | Name              | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT |                   |     2 |    26 |     1   (0)| 00:00:01 |
|*  1 |  INDEX RANGE SCAN| IDX_INDEX_DETAILS |     2 |    26 |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------

drop index idx_index_details;

create unique index idx_index_details on index_details(mobile_no);
1 ORA-01452: cannot CREATE UNIQUE INDEX; duplicate keys found 

delete from index_details where rowID = 'AAAFvOAAEAAAArvAAC';

create unique index idx_index_details on index_details(mobile_no);

select * from user_constraints where table_name = 'INDEX_DETAILS';
select * from user_cons_columns where table_name = 'INDEX_DETAILS';

select * from user_indexes where table_name = 'INDEX_DETAILS';
select * from user_ind_columns where table_name = 'INDEX_DETAILS';


Note: Unique index will be faster than normal index because there will be one row ID  associated with one value

explain plan for select * from index_details where mobile_no = 11111111;
select plan_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

Plan hash value: 376589293
 
---------------------------------------------------------------------------------------
| Id  | Operation         | Name              | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |                   |     1 |     6 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| IDX_INDEX_DETAILS |     1 |     6 |     0   (0)| 00:00:01 |
 

- Normal index 
--------------------------------------------------------------------------------------
| Id  | Operation        | Name              | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT |                   |     2 |    26 |     1   (0)| 00:00:01 |
|*  1 |  INDEX RANGE SCAN| IDX_INDEX_DETAILS |     2 |    26 |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------

Note the difference between range scan and unique scan 

unique scan is faster than range scan 

when you know that your column will have unique values it is better to create unique index (or) create an unique constraint and let oracle 
automatically create unique index.

---------------------------------------------------------------------------


Composite primary key and automatic composite unique index 

select * from user_constraints where table_name = 'EMP_SKILLS';
select * from user_cons_columns where table_name = 'EMP_SKILLS';

select * from user_indexes where table_name = 'EMP_SKILLS';
select * from user_ind_columns where table_name = 'EMP_SKILLS';


---------------------------------------------------

Three important things to remember:

Full table scan
Range scan 
Unique scan 


------------------------------------------------------------------------------
20-08-2019:


select * from my_emp_index;

explain plan for select * from my_emp_index;
select plan_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

Plan hash value: 1331488862
 
----------------------------------------------------------------------------------
| Id  | Operation         | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |              |     7 |   231 |     3   (0)| 00:00:01 |
|   1 |  TABLE ACCESS FULL| MY_EMP_INDEX |     7 |   231 |     3   (0)| 00:00:01 |
----------------------------------------------------------------------------------

select * from my_emp_index where state = 'TN';

explain plan for select * from my_emp_index where state = 'TN';
select plan_table_output from table(DBMS_XPLAN.DISPLAY());

Plan hash value: 2503725207
 
------------------------------------------------------------------------------------------------------
| Id  | Operation                   | Name                   | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |                        |     3 |    99 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| MY_EMP_INDEX           |     3 |    99 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_MY_EMP_INDEX_STATE |     3 |       |     1   (0)| 00:00:01 |


SELECT * FROM my_emp_index
WHERE UPPER(state) = UPPER('tn');

explain plan 
for 
SELECT * FROM my_emp_index
WHERE UPPER(state) = UPPER('tn');

select plan_table_output from table (DBMS_XPLAN.DISPLAY());

Plan hash value: 1331488862
 
----------------------------------------------------------------------------------
| Id  | Operation         | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |              |     1 |    33 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| MY_EMP_INDEX |     1 |    33 |     3   (0)| 00:00:01 |
----------------------------------------------------------------------------------

(IMP) When functions are used on the indexed columns, oracle will go for full table scan 

create index idx_emp_state_upper on my_emp_index(UPPER(state));

select * from user_indexes where table_name = 'MY_EMP_INDEX';
select * from user_ind_columns where table_name = 'MY_EMP_INDEX';

-- Now checking whether the Functional Based index is coming through or not 

explain plan 
for 
SELECT * FROM my_emp_index
WHERE UPPER(state) = UPPER('tn');

select plan_table_output from table (DBMS_XPLAN.DISPLAY());

Plan hash value: 356091545
 
---------------------------------------------------------------------------------------------------
| Id  | Operation                   | Name                | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |                     |     1 |    33 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| MY_EMP_INDEX        |     1 |    33 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_STATE_UPPER |     1 |       |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------------


-- Following is the example of using lower function with state column

explain plan 
for 
SELECT * FROM my_emp_index
WHERE LOWER(state) = UPPER('tn');

select plan_table_output from table (DBMS_XPLAN.DISPLAY());

Plan hash value: 1331488862
 
----------------------------------------------------------------------------------
| Id  | Operation         | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |              |     1 |    33 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| MY_EMP_INDEX |     1 |    33 |     3   (0)| 00:00:01 |
----------------------------------------------------------------------------------

Here state column has normal index and function-based index (UPPER)

But we are using function Lower on state column. Hence, full table scan occurs 

We should not create index for all the scenarios like above, many indexes on a table will slow down it


-------------------------------------------------------------

Composite Index:

SELECT * FROM my_emp_index
WHERE state = 'TN'
AND city = 'Chennai';

explain plan for 
SELECT * FROM my_emp_index
WHERE state = 'TN'
AND city = 'Chennai';

select plan_table_output from table (DBMS_XPLAN.DISPLAY());

Plan hash value: 2014079207
 
-----------------------------------------------------------------------------------------------------
| Id  | Operation                   | Name                  | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |                       |     1 |    33 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| MY_EMP_INDEX          |     1 |    33 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_MY_EMP_INDEX_CITY |     2 |       |     1   (0)| 00:00:01 |
-----------------------------------------------------------------------------------------------------

create index idx_emp_state_city on my_emp_index(state,city);

select * from user_indexes where table_name = 'MY_EMP_INDEX';
select * from user_ind_columns where table_name = 'MY_EMP_INDEX';



explain plan for 
SELECT * FROM my_emp_index
WHERE state = 'TN'
AND city = 'Chennai';

select plan_table_output from table (DBMS_XPLAN.DISPLAY());

--------------------------------------------------------------------------------------------------
| Id  | Operation                   | Name               | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |                    |     1 |    33 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| MY_EMP_INDEX       |     1 |    33 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_STATE_CITY |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------------

COMPOSITE UNIQUE INDEX:

select * from user_indexes where table_name = 'EMP_SKILLS';
select * from user_ind_columns where table_name = 'EMP_SKILLS';

select * from user_constraints where table_name = 'EMP_SKILLS';
select * from user_cons_columns where table_name = 'EMP_SKILLS';

select * from emp_skills;
 

/*
- Index should be created for the columns frequently used in WHERE condition

- Indexes should not be used on columns that return a high percentage of data rows when used as a filter condition in a query's WHERE clause
Indexes can be very good for performance, but in some cases may actually hurt performance. Refrain from creating indexes on columns
that will contain few unique values, such as gender

- Indexes should not be used on columns that contain a high number of NULL values.

- Columns that are frequently manipulated should not be indexed. Maintenance on the index can become excessive.

*/

