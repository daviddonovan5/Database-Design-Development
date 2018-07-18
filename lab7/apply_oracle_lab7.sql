-- ----------------------------------------------------------------------
-- Instructions:
-- ----------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--   sqlplus student/student@xe
--
-- Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab7.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab6/apply_oracle_lab6.sql

SPOOL apply_oracle_lab7.txt
-- Insert two new rows into the COMMON_LOOKUP table to support the ACTIVE_FLAG 
INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, 'YES'
,  'Yes'
, 1
, SYSDATE
, 1
, SYSDATE
, 'PRICE'
, 'ACTIVE_FLAG'
, 'Y');

INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, 'NO'
,  'No'
, 1
, SYSDATE
, 1
, SYSDATE
, 'PRICE'
, 'ACTIVE_FLAG'
, 'N');

COLUMN common_lookup_table  FORMAT A20 HEADING "COMMON_LOOKUP_TABLE"
COLUMN common_lookup_column FORMAT A20 HEADING "COMMON_LOOKUP_COLUMN"
COLUMN common_lookup_type   FORMAT A20 HEADING "COMMON_LOOKUP_TYPE"
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table = 'PRICE'
AND      common_lookup_column = 'ACTIVE_FLAG'
ORDER BY 1, 2, 3 DESC;


-- Insert three new rows into the COMMON_LOOKUP table to support the PRICE_TYPE
INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, '1-DAY RENTAL'
,  '1-Day Rental'
, 1
, SYSDATE
, 1
, SYSDATE
, 'PRICE'
, 'PRICE_TYPE'
, '1');

INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, '3-DAY RENTAL'
, '3-Day Rental'
, 1
, SYSDATE
, 1
, SYSDATE
, 'PRICE'
, 'PRICE_TYPE'
, '3');

INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, '5-DAY RENTAL'
, '5-Day Rental'
, 1
, SYSDATE
, 1
, SYSDATE
, 'PRICE'
, 'PRICE_TYPE'
, '5');


INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, '1-DAY RENTAL'
,  '1-Day Rental'
, 1
, SYSDATE
, 1
, SYSDATE
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '1');

INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, '3-DAY RENTAL'
, '3-Day Rental'
, 1
, SYSDATE
, 1
, SYSDATE
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '3');

INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, '5-DAY RENTAL'
, '5-Day Rental'
, 1
, SYSDATE
, 1
, SYSDATE
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '5');


COLUMN common_lookup_table  FORMAT A20 HEADING "COMMON_LOOKUP_TABLE"
COLUMN common_lookup_column FORMAT A20 HEADING "COMMON_LOOKUP_COLUMN"
COLUMN common_lookup_type   FORMAT A20 HEADING "COMMON_LOOKUP_TYPE"
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN ('PRICE','RENTAL_ITEM')
AND      common_lookup_column IN ('PRICE_TYPE','RENTAL_ITEM_TYPE')
ORDER BY 1, 3;


UPDATE   rental_item ri
SET      rental_item_type =
           (SELECT   cl.common_lookup_id
            FROM     common_lookup cl
            WHERE    cl.common_lookup_code =
              (SELECT   r.return_date - r.check_out_date
               FROM     rental r
               WHERE    r.rental_id = ri.rental_id)
            AND      cl.common_lookup_table = 'RENTAL_ITEM'
            AND      cl.common_lookup_column = 'RENTAL_ITEM_TYPE');

COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'RENTAL_ITEM'
ORDER BY 2;


ALTER TABLE rental_item
ADD CONSTRAINT fk_rental_7 FOREIGN KEY(rental_item_type) REFERENCES common_lookup(common_lookup_id);

COLUMN table_name      FORMAT A12 HEADING "TABLE NAME"
COLUMN constraint_name FORMAT A18 HEADING "CONSTRAINT NAME"
COLUMN constraint_type FORMAT A12 HEADING "CONSTRAINT|TYPE"
COLUMN column_name     FORMAT A18 HEADING "COLUMN NAME"
SELECT   uc.table_name
,        uc.constraint_name
,        CASE
           WHEN uc.constraint_type = 'R' THEN
            'FOREIGN KEY'
         END AS constraint_type
,        ucc.column_name
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = 'RENTAL_ITEM'
AND      ucc.column_name = 'RENTAL_ITEM_TYPE';



SELECT   ROW_COUNT
,        col_count
FROM    (SELECT   COUNT(*) AS ROW_COUNT
         FROM     rental_item) rc CROSS JOIN
        (SELECT   COUNT(rental_item_type) AS col_count
         FROM     rental_item
         WHERE    rental_item_type IS NOT NULL) cc;

--ADDing a null constraint
ALTER TABLE rental_item MODIFY rental_item_type NUMBER NOT NULL;


COLUMN CONSTRAINT FORMAT A10
SELECT   TABLE_NAME
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE 'NULLABLE'
         END AS CONSTRAINT
FROM     user_tab_columns
WHERE    TABLE_NAME = 'RENTAL_ITEM'
AND      column_name = 'RENTAL_ITEM_TYPE';

SELECT
   i.item_id
,  af.active_flag
,  cl.common_lookup_id AS price_type
,  cl.common_lookup_type AS price_desc
,  CASE
      WHEN (TRUNC(SYSDATE) - i.release_date) <=30 
         OR (TRUNC(SYSDATE) - i.release_date) > 30 AND af.active_flag ='N'
	THEN i.release_date
      ELSE
	i.release_date + 31
   END AS start_date
,  CASE
      WHEN (TRUNC(SYSDATE) - i.release_date) > 30 AND af.active_flag = 'N'
	THEN i.release_date + 30
   END AS end_date
,  CASE
      WHEN (TRUNC(SYSDATE) - i.release_date) <= 30 THEN
	CASE
	   WHEN dr.rental_days = 1 THEN 3
	   WHEN dr.rental_days = 3 THEN 10
	   WHEN dr.rental_days = 5 THEN 15
	END
      WHEN (TRUNC(SYSDATE) - i.release_date) > 30 AND af.active_flag = 'N' THEN
	CASE
	   WHEN dr.rental_days = 1 THEN 3
	   WHEN dr.rental_days = 3 THEN 10
	   WHEN dr.rental_days = 5 THEN 15
	END
      ELSE
	CASE
	   WHEN dr.rental_days = 1 THEN 1
	   WHEN dr.rental_days = 3 THEN 3
	   WHEN dr.rental_days = 5 THEN 5
	END
   END AS amount
FROM     item i CROSS JOIN
        (SELECT 'Y' AS active_flag FROM dual
         UNION ALL
         SELECT 'N' AS active_flag FROM dual) af CROSS JOIN
        (SELECT '1' AS rental_days FROM dual
         UNION ALL
         SELECT '3' AS rental_days FROM dual
         UNION ALL
         SELECT '5' AS rental_days FROM dual) dr INNER JOIN
         common_lookup cl ON dr.rental_days = SUBSTR(cl.common_lookup_type,1,1)
WHERE    cl.common_lookup_table = 'PRICE'
AND      cl.common_lookup_column = 'PRICE_TYPE'
AND NOT (af.active_flag = 'N' AND (TRUNC(SYSDATE) -30) < i.release_date)
ORDER BY 1, 2, 3;



SPOOL OFF
