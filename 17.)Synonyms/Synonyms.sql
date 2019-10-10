

Synonyms:

Use the CREATE SYNONYM statement to create a synonym, which is an alternative name for a table, view, sequence, procedure,
stored function, package, or another synonym

CREATE TABLE t_country_state_city_details
(
id number
);

insert into t_country_state_city_details (id) values (1000);
commit;

select * from t_country_state_city_details;

- now creating/setting alternate name from above table name 

CREATE SYNONYM t_c_s_c_details FOR t_country_state_city_details;

select * from t_c_s_c_details;

insert into t_c_s_c_details (id) values (2000);

select * from t_c_s_c_details;
commit;

SELECT OBJECT_TYPE, COUNT(*) FROM USER_OBJECTS
GROUP BY OBJECT_TYPE
ORDER BY 2 DESC;

SELECT * FROM USER_SYNONYMS
WHERE SYNONYM_NAME = 'T_C_S_C_DETAILS';


------------------------

create sequence seq1001;

create synonym sq11 for seq1001;

select * from user_synonyms;

select * from user_objects;

----------------------------


Another main use of synonym 

select * from abcd.emp_data;

create synonym emp_data for abcd.emp_data;

select * from emp_data;

select * from user_objects where object_name = 'EMP_DATA';

select * from user_synonyms where synonym_name = 'EMP_DATA';

---------------------------------------------------------------
