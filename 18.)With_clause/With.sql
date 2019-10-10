
WITH:

With clause is used for:
1.) Performance.
2.) Readability.
3.) Re-useability.


Req:

Fetch the employees getting the max salary in the company 

select * from employees 
where salary = (select max(salary) from employees);

WITH abc AS
(
SELECT MAX(salary) max_sal FROM employees)
SELECT * FROM employees
WHERE salary = (SELECT max_sal FROM abc);


SELECT E.first_name AS EMPLOYEE_NAME,
       DC1.dept_count AS EMP_DEPT_COUNT,
       M.first_name AS MANAGER_NAME,
       DC2.dept_count AS MGR_DEPT_COUNT
  FROM t_test_emp E,
       (SELECT department_id,
               COUNT(*) AS DEPT_COUNT
           FROM t_test_emp
           GROUP BY department_id) DC1,
       t_test_emp M,
       (SELECT department_id,
               COUNT(*) AS DEPT_COUNT
           FROM T_TEST_emp
           GROUP BY department_id) DC2
    WHERE E.department_id = DC1.department_id
    AND E.MANAGER_ID = M.EMPLOYEE_ID
    AND M.department_id = DC2.department_id;

-- below query is same as above (but using ANSI join)
SELECT E.first_name AS EMPLOYEE_NAME,
       DC1.dept_count AS EMP_DEPT_COUNT,
       M.first_name AS MANAGER_NAME,
       DC2.dept_count AS MGR_DEPT_COUNT
  FROM t_test_emp E JOIN
       (SELECT department_id,
               COUNT(*) AS DEPT_COUNT
           FROM t_test_emp
           GROUP BY department_id) DC1 
           ON (E.department_id = DC1.department_id) 
       JOIN  t_test_emp M
       ON (E.MANAGER_ID = M.EMPLOYEE_ID)
       JOIN (SELECT department_id,
               COUNT(*) AS DEPT_COUNT
           FROM T_TEST_emp
           GROUP BY department_id) DC2
       ON (M.department_id = DC2.department_id);


select * from t_test_emp;

emp_name, e.dept_count, manager_name, m.dept_count

Keerthi Java	3	Suresh Java Mgr	3
Surya Java	3	Suresh Java Mgr	3
Ashok Ora	3	Bala Ora Mgr	3
Augustin Ora	3	Bala Ora Mgr	3


Task 1 - find out why King row did not come out
Task 2 - convert the above query to ANSI join 
Task 3 - understand the query 

- Fetching the employees where their department total_salary > average salary of all departments which is present in employees and departments table.

Average of total_Salary of all departments available in employees table and department table is 

6,84,416/11 = 62,219

Output: Sales and Shipping

Query:

-- Fetch the employees whose salary is greater than the average salary of their whole department.
-- And also department which is present in Employees table and departments table.

SELECT *
  FROM (SELECT D.DEPARTMENT_NAME,
               SUM(E.SALARY) AS DEPT_TOTAL
      FROM EMPLOYEES E
        JOIN DEPARTMENTS D
          ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
      GROUP BY D.DEPARTMENT_NAME)
  WHERE dept_total > (SELECT dept_avg
        FROM (SELECT SUM(dept_total) / COUNT(*) AS DEPT_AVG
            FROM (SELECT D.DEPARTMENT_NAME,
                         SUM(E.SALARY) AS DEPT_TOTAL
                FROM EMPLOYEES E
                  JOIN DEPARTMENTS D
                    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
                GROUP BY D.DEPARTMENT_NAME)))
  ORDER BY DEPARTMENT_NAME;


---------------------------------------------


WITH abcd
AS
(SELECT SYSDATE today, 1111 E_ID FROM DUAL)
SELECT * FROM DUAL
WHERE SYSDATE = (SELECT today FROM abcd)
AND 1111 = (SELECT e_id FROM abcd)
AND SYSDATE = (SELECT today FROM abcd); 


WITH abcd
AS
(SELECT department_id, COUNT(*) cnt FROM employees GROUP BY department_id HAVING COUNT(*) > 5)
SELECT e.*, abcd.cnt FROM employees e, abcd
WHERE e.department_id = abcd.department_id;


WITH xyz AS
(SELECT TRUNC(SYSDATE) my_date FROM DUAL)
SELECT d.*
FROM DUAL d, xyz x
WHERE '12-AUG-2019' = x.my_date
 AND '12-AUG-2019' = x.my_date;

--reuse
WITH temp AS
(SELECT 1 ID FROM DUAL)
SELECT 'Thomas' employee FROM DUAL
WHERE 1 = (SELECT id FROM temp)
UNION ALL
SELECT 'Suresh' employee FROM DUAL
WHERE 1 = (SELECT id FROM temp)
UNION ALL
SELECT 'Peter' employee FROM DUAL
WHERE 1 = (SELECT id FROM temp);

--using WITH temp in FROM CLAUSE
WITH temp AS
(SELECT 1 ID FROM DUAL)
SELECT id  FROM temp;

---------------------------------------------------------------------
WITH abc as 
(
  SELECT department_id,
               COUNT(*) AS DEPT_COUNT
           FROM t_test_emp
           GROUP BY department_id
)
SELECT E.first_name AS EMPLOYEE_NAME,
       DC1.dept_count AS EMP_DEPT_COUNT,
       M.first_name AS MANAGER_NAME,
       DC2.dept_count AS MGR_DEPT_COUNT
  FROM t_test_emp E, abc DC1,t_test_emp M, abc DC2
    WHERE E.department_id = DC1.department_id
    AND E.MANAGER_ID = M.EMPLOYEE_ID
    AND M.department_id = DC2.department_id;


WITH abc as 
(
    SELECT department_id,
               COUNT(*) AS DEPT_COUNT
           FROM t_test_emp
           GROUP BY department_id
)
SELECT E.first_name AS EMPLOYEE_NAME,
       DC1.dept_count AS EMP_DEPT_COUNT,
       M.first_name AS MANAGER_NAME,
       DC2.dept_count AS MGR_DEPT_COUNT
  FROM t_test_emp E JOIN abc DC1 
  ON (E.department_id = DC1.department_id) 
  JOIN  t_test_emp M
  ON (E.MANAGER_ID = M.EMPLOYEE_ID)
  JOIN abc DC2
  ON (M.department_id = DC2.department_id);



----------------------------------------------------


--Parent Child WITH
WITH temp1 AS
(SELECT 1 ID FROM DUAL),
temp2 AS
(
 SELECT SYSDATE today FROM DUAL
 WHERE 1 = (SELECT id FROM temp1)
)
SELECT * FROM temp2;


------------------------------------------------------------

WITH abc as 
(
  SELECT D.DEPARTMENT_NAME, SUM(E.SALARY) AS DEPT_TOTAL
      FROM EMPLOYEES E
      JOIN DEPARTMENTS D
      ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
      GROUP BY D.DEPARTMENT_NAME
)
SELECT * FROM abc 
WHERE dept_total > (SELECT dept_avg
        FROM (SELECT SUM(dept_total) / COUNT(*) AS DEPT_AVG
            FROM abc ))
ORDER BY DEPARTMENT_NAME;

create or replace view view_1234 as 
WITH abc as 
(
  SELECT D.DEPARTMENT_NAME, SUM(E.SALARY) AS DEPT_TOTAL
      FROM EMPLOYEES E
      JOIN DEPARTMENTS D
      ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
      GROUP BY D.DEPARTMENT_NAME
),
abcd as 
 (SELECT dept_avg
 FROM (SELECT SUM(dept_total) / COUNT(*) AS DEPT_AVG
 FROM abc))
SELECT * from abc
WHERE dept_total > (select dept_avg from abcd)
ORDER BY DEPARTMENT_NAME;

select * from view_1234;

-- getting back the normal query without WITH
create or replace view view_123 as
SELECT * from
(
SELECT D.DEPARTMENT_NAME, SUM(E.SALARY) AS DEPT_TOTAL
      FROM EMPLOYEES E
      JOIN DEPARTMENTS D
      ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
      GROUP BY D.DEPARTMENT_NAME
) 
WHERE dept_total > (SELECT dept_avg
 FROM (SELECT SUM(dept_total) / COUNT(*) AS DEPT_AVG
 FROM (SELECT D.DEPARTMENT_NAME, SUM(E.SALARY) AS DEPT_TOTAL
      FROM EMPLOYEES E
      JOIN DEPARTMENTS D
      ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
      GROUP BY D.DEPARTMENT_NAME)))
ORDER BY DEPARTMENT_NAME;


select * from view_123;




