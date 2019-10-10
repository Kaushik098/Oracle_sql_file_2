
/*
Types of views
-Simple view - View having one base table is Simple view
-Complex view - View having more than one base table is Complex view
                 --SELECT having Joins, subqueries, SET
- can you identify the simple and complex views we created till now in all the folders
*/

Create simple and complex views in this file


create view simp_view as
select * from t_test_emp;

create view complex_view as
select * from t_test_emp e join t_test_dept d
on (e.DEPARTMENT_ID = d.DEPARTMENT_ID);
1 ORA-00957: duplicate column name 


create view complex_view as
select e.employee_id, e.first_name, d.DEPARTMENT_NAME from t_test_emp e join t_test_dept d
on (e.DEPARTMENT_ID = d.DEPARTMENT_ID);
-- created ?

select * from COMPLEX_VIEW;

insert into COMPLEX_VIEW (employee_id, first_name, department_name) values (1,'aaa','xyz');
1 ORA-01776: cannot modify more than one base table through a join view 










