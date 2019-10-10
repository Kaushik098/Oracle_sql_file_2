
--READ ONLY VIEW
/*
You can ensure that no DML operations occur by adding the WITH READ ONLY option to your view definition.
Any attempt to perform a DML operation on any row in the view results in an Oracle server error.
*/

drop table t_another_tab;
CREATE TABLE t_another_tab
(
  num NUMBER
);

INSERT INTO t_another_Tab (num) VALUES (100);
COMMIT;

SELECT * FROM t_another_tab;

CREATE OR REPLACE VIEW v_another_tab AS
SELECT * FROM t_another_tab;

SELECT * FROM v_another_tab;

--will this INSERT work?
INSERT INTO v_another_Tab (num) VALUES (200);
COMMIT;
SELECT * FROM t_another_tab;
--------------------------------------------------------------------------------
--Requirment: Create a simple view - already created above
--that view should be used only for SELECT, no I/U/D

CREATE OR REPLACE VIEW v_another_tab AS
SELECT * FROM t_another_tab
WITH READ ONLY;

--will this INSERT work?
INSERT INTO v_another_Tab (num) VALUES (200);
--read the error carefully
2 ORA-42399: cannot perform a DML operation on a read-only view 


DELETE FROM v_another_tab;
2 ORA-42399: cannot perform a DML operation on a read-only view 

UPDATE v_another_tab
SET num = num;
2 ORA-42399: cannot perform a DML operation on a read-only view 
--check the read_only column value
SELECT * FROM USER_VIEWS
WHERE VIEW_NAME = 'V_ANOTHER_TAB';

