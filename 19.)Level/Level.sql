
LEVEL

Used in DUAL to generate numbers in a loop

Syntax:

SELECT LEVEL, 'abcd'
FROM DUAL
CONNECT BY LEVEL <= 10;

SELECT LEVEL, SUBSTR('INDIA',LEVEL,1)
FROM DUAL
CONNECT BY LEVEL <= LENGTH('INDIA');

--converting above to WITH clause
WITH abc
AS
(SELECT 'INDIA' ctry FROM DUAL)
SELECT LEVEL, SUBSTR(abc.ctry,LEVEL,1)
FROM DUAL, abc
CONNECT BY LEVEL <= LENGTH(abc.ctry);

----------------------------------------------------------------------------------

I have added LEVEL concept with examples. Please check

Use the below 2 queries (already sent in whatsapp) for reference
SELECT LEVEL, 'abcd'
FROM DUAL
CONNECT BY LEVEL <= 10;

SELECT LEVEL, SUBSTR('INDIA',LEVEL,1)
FROM DUAL
CONNECT BY LEVEL <= LENGTH('INDIA');
---------------------------------------------------------------------


Analyse patiently all the below questions

1	Write a query to generate the following numbers as output in SQL - till 100
4
8
12
16
20
. . .
100
Multiples of 4

select level*(4)
from dual 
connect by level <= 25;

---------------------------------------------------------------------------------------

SELECT TO_CHAR(SYSDATE, 'MONTH') a,
       TO_CHAR(SYSDATE, 'mon') B,
       TO_CHAR(SYSDATE, 'MM') c,
       TO_CHAR(SYSDATE, 'DY') d,
       TO_CHAR(SYSDATE, 'DD') E,
       TO_CHAR(SYSDATE, 'MM/YY') f,
       TO_CHAR(SYSDATE, 'DD "of" MONTH') G,
       TO_CHAR(SYSDATE, 'DD "aaAH$$GKSFJFG12SDasas" MONTH') h,
       TO_CHAR(SYSDATE, 'ddspth') i,
       TO_CHAR(SYSDATE, 'ddspth mmspth') j        
FROM  DUAL;

select  * from employees;


2 Analyse these 2 queries

a.) LAST_DAY function returns the last day of the month based on a date value.

b.) To_char:

TO_CHAR(value [, format_mask ], [, nls_language]))

value : A nunmber or date that will be converted to a string
format mask : optional. This is the format that will be used to converts value to a string 
nls_language : Optional. This is a nls language used to convert value to a string. 

c.) 

CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(g.dt),'DD')      -->  It tends to process till 01 date of particular month 
DD -   ?

SELECT level l,TO_CHAR(LAST_DAY(g.dt) - (level-1),'fmdd-mon-yyyy day') d1, 
                             TO_CHAR(LAST_DAY(g.dt) - (level-1),'fmd') d2

TO_CHAR(LAST_DAY(g.dt) - (level-1),'fmdd-mon-yyyy day') d1     ---- >   For.eg 27-06-2019   O/p: 27-jun-2019 friday 
TO_CHAR(LAST_DAY(g.dt) - (level-1),'fmd') d2     ---- >   fmd ? 


DD -   ?
fmd ?





SELECT d1 FROM
(
  SELECT ROWNUM rn, g.*
  FROM
  (
      SELECT e.* FROM
            (
                      WITH given_date
                      AS 
                      (SELECT '27-JUN-2019' dt FROM DUAL)
                      SELECT level l,TO_CHAR(LAST_DAY(g.dt) - (level-1),'fmdd-mon-yyyy day') d1, 
                             TO_CHAR(LAST_DAY(g.dt) - (level-1),'fmd') d2
                      FROM DUAL, given_date g
                      CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(g.dt),'DD')
              ) e
      WHERE d2 NOT IN (1,7)
      ORDER BY l
  ) g
)
WHERE rn IN (1,2);

SELECT d1 FROM
(
  SELECT ROWNUM rn, g.*
  FROM
  (
      SELECT e.* FROM
            (
                      WITH given_date
                      AS 
                      (SELECT '27-JUN-2019' dt FROM DUAL)
                      SELECT level l,LAST_DAY(g.dt) - (level-1) d1
                      FROM DUAL, given_date g
                      CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(g.dt),'DD')
              ) e
      WHERE TO_CHAR(d1,'DAYfm') NOT IN ('SUNDAY','SATURDAY')
      ORDER BY l
  ) g
)
WHERE rn IN (1,2);



3 Analyse this query

SELECT TRUNC(ADD_MONTHS(SYSDATE, LEVEL-1),  'MONTH')
FROM DUAL
CONNECT BY LEVEL <= 10;


------------------------------------------


Print like below

20-sep-2019
21-sep-2019
till 10 days from today

In SQL using LEVEL

SELECT LEVEL, SYSDATE + (LEVEL - 1)
FROM DUAL
CONNECT BY LEVEL <= 11;

-----------------------------------------------------------------


I guess, the query to find last 2 working days will be tricky...

Spend more time on it

- it has LEVEL and DATE single row functions








