
The Oracle/PLSQL ROWNUM function returns a number that represents the order that a row is selected by Oracle from a table or joined tables. 
The first row has aROWNUM of 1, the second has a ROWNUM of 2, and so on


SELECT e.*, ROWNUM AS rnum
FROM
(
 SELECT * FROM employees
 ORDER BY salary DESC
) e
WHERE ROWNUM <= 8;

-- select few rows from employees

SELECT * FROM employees
WHERE rownum <= 5;

--------------------------
Basic SQL

ROWNUM example

SELECT e.*, rownum AS rnum
        FROM   (
            SELECT *
            FROM   employees
            ORDER BY salary DESC
) e
        WHERE rownum <= 8;





Converting above to WITH clause:

WITH abcd AS
  (
            SELECT *
            FROM   employees
            ORDER BY salary DESC
)
SELECT *
FROM   abcd
WHERE  rownum <= 8;


------------------------

select rownum, last_name, first_name from employees 
where rownum <= 5
order by last_name ;

1	Abel	Ellen
2	Ande	Sundar
3	Atkinson	Mozhe
4	Austin	David
5	Baer	Hermann


select rownum, e.* from 
(
  select employee_id, first_name, last_name from employees  
  order by last_name 
) e
where rownum < 5

1	174	Ellen	Abel
2	166	Sundar	Ande
3	130	Mozhe	Atkinson
4	105	David	Austin



---------------------------------

select rowid, rownum, e.* from employees e;