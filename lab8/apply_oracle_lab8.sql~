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
--   sql> @apply_oracle_lab8.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab7/apply_oracle_lab7.sql

SPOOL apply_oracle_lab8.txt

INSERT INTO price
SELECT
      price_s1.NEXTVAL AS price_id
    , i.item_id
    , cl.common_lookup_id AS price_type
    , af.active_flag    
    , CASE WHEN (TRUNC(SYSDATE) - i.release_date) <= 30 OR (TRUNC(SYSDATE) - i.release_date) > 30 AND af.active_flag = 'N'
        THEN i.release_date
        ELSE i.release_date + 31
        END AS start_date
    , CASE 
        WHEN (TRUNC(SYSDATE) - i.release_date) > 30 AND af.active_flag = 'N'
        THEN i.release_date + 30
        END AS end_date
    , CASE WHEN (TRUNC(SYSDATE) - i.release_date) <= 30 Then
        CASE 
            WHEN dr.rental_days = 1 THEN 3
            WHEN dr.rental_days = 3 THEN 10
            WHEN dr.rental_days = 5 then 15
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
    , 1 AS created_by
    , SYSDATE AS creation_date
    , 1 AS last_updated_by
    , SYSDATE AS last_updated_date
    FROM item i 
    CROSS JOIN
    (SELECT 'Y' AS active_flag FROM DUAL
        UNION ALL
        SELECT 'N' AS active_flag FROM DUAL) af
    CROSS JOIN
    (SELECT '1' AS rental_days FROM DUAL
        UNION ALL
        SELECT '3' AS rental_days FROM DUAL
        UNION ALL
        SELECT '5' AS rental_days FROM DUAL) dr
    INNER JOIN common_lookup cl
    ON dr.rental_days =SUBSTR(cl.common_lookup_type,1,1)
    WHERE cl.common_lookup_table = 'PRICE'
    AND cl.common_lookup_column = 'PRICE_TYPE'
    AND NOT (af.active_flag = 'N' AND (TRUNC(SYSDATE) -30) < i.release_date);

--testing step 1
SELECT  'OLD Y' AS "Type"
,        COUNT(CASE WHEN amount = 1 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 3 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 5 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'Y' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
AND      end_date IS NULL
UNION ALL
SELECT  'OLD N' AS "Type"
,        COUNT(CASE WHEN amount =  3 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 10 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 15 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'N' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
AND NOT end_date IS NULL
UNION ALL
SELECT  'NEW Y' AS "Type"
,        COUNT(CASE WHEN amount =  3 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 10 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 15 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'Y' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
AND      end_date IS NULL
UNION ALL
SELECT  'NEW N' AS "Type"
,        COUNT(CASE WHEN amount = 1 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 3 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 5 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'N' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
AND      NOT (end_date IS NULL);

--- STEP 2  add the NOT NULL constraint to the PRICE_TYPE column of the PRICE table
ALTER TABLE price MODIFY price_type NOT NULL;


--testing step 2
COLUMN CONSTRAINT FORMAT A10
SELECT   TABLE_NAME
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE 'NULLABLE'
         END AS CONSTRAINT
FROM     user_tab_columns
WHERE    TABLE_NAME = 'PRICE'
AND      column_name = 'PRICE_TYPE';

-- STEP 3 


UPDATE   rental_item ri
SET      rental_item_price =
          (SELECT   p.amount
           FROM     price p INNER JOIN common_lookup cl1
           ON       p.price_type = cl1.common_lookup_id CROSS JOIN rental r
                    CROSS JOIN common_lookup cl2 
           WHERE    p.item_id = ri.item_id AND ri.rental_id = r.rental_id
           AND      ri.rental_item_type = cl2.common_lookup_id
           AND      cl1.common_lookup_code = cl2.common_lookup_code
           AND      r.check_out_date
                       BETWEEN p.start_date AND NVL(p.end_date, TRUNC(SYSDATE+1)));


--Confirm step 3
COL customer_name          FORMAT A20  HEADING "Customer Name"
COL rental_id              FORMAT 9999 HEADING "Rental|ID #"
COL rental_item_id         FORMAT 9999 HEADING "Rental|Item ID"
COL rental_item_price      FORMAT 9999 HEADING "Rental|Item|Price"
COL amount                 FORMAT 9999 HEADING "Price|Amount"
COL price_type_code        FORMAT 9999 HEADING "Price|Type|Code"
COL rental_item_type_code  FORMAT 9999 HEADING "Rental|Item|Type|Code"
SELECT   c.last_name||', '||c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name
         END AS customer_name
,        r.rental_id
,        ri.rental_item_id
,        ri.rental_item_price
,        p.amount
,        TO_NUMBER(cl2.common_lookup_code) AS price_type_code
,        TO_NUMBER(cl2.common_lookup_code) AS rental_item_type_code
FROM     price p INNER JOIN common_lookup cl1
ON       p.price_type = cl1.common_lookup_id
AND      cl1.common_lookup_table = 'PRICE'
AND      cl1.common_lookup_column = 'PRICE_TYPE' INNER JOIN rental_item ri 
ON       p.item_id = ri.item_id INNER JOIN common_lookup cl2
ON       ri.rental_item_type = cl2.common_lookup_id
AND      cl2.common_lookup_table = 'RENTAL_ITEM'
AND      cl2.common_lookup_column = 'RENTAL_ITEM_TYPE' INNER JOIN rental r
ON       ri.rental_id = r.rental_id INNER JOIN contact c
ON       r.customer_id = c.contact_id
WHERE    cl1.common_lookup_code = cl2.common_lookup_code
AND      r.check_out_date
BETWEEN  p.start_date AND NVL(p.end_date,TRUNC(SYSDATE) + 1)
ORDER BY 2, 3;


-- STEP 4 Add a not null constraint to the RENTAL_ITEM_PRICE column of the RENTAL_ITEM table.
ALTER TABLE rental_item MODIFY rental_item_price NOT NULL;

-- test step 4
COLUMN CONSTRAINT FORMAT A10
SELECT   TABLE_NAME
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE 'NULLABLE'
         END AS CONSTRAINT
FROM     user_tab_columns
WHERE    TABLE_NAME = 'RENTAL_ITEM'
AND      column_name = 'RENTAL_ITEM_PRICE';

SPOOL OFF
