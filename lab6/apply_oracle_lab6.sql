-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab5/apply_oracle_lab5.sql
--@/home/student/Data/cit225/oracle/lib/cleanup_oracle.sql
--@/home/student/Data/cit225/oracle/lib/create_oracle_store.sql

SPOOL apply_oracle_lab6.txt

--add colomns to rental_item  
ALTER TABLE rental_item
   ADD (rental_item_type NUMBER)
   ADD (rental_item_price NUMBER);

-- query to verify completion of this step:
SET NULL ''
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


--step 2 create the Price table
BEGIN
  FOR i IN (SELECT null FROM user_table WHERE table_name = 'PRICE') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE PRICE CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'PRICE_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE price_s1';
  END LOOP;
END;
;

/
CREATE TABLE price
( price_id		      NUMBER
, item_id		      NUMBER 	   CONSTRAINT price_1 NOT NULL
, price_type		      NUMBER       
, active_flag		      VARCHAR2(1)  CONSTRAINT price_2 NOT NULL
, start_date                  DATE	   CONSTRAINT price_3 NOT NULL
, end_date		      DATE		
, amount	              NUMBER	   CONSTRAINT price_4 NOT NULL
, created_by                  NUMBER       CONSTRAINT price_5 NOT NULL
, creation_date               DATE         CONSTRAINT price_6 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT price_7 NOT NULL
, last_update_date            DATE         CONSTRAINT price_8 NOT NULL
, CONSTRAINT pk_price_1 PRIMARY KEY(price_id)
, CONSTRAINT fk_price_1 FOREIGN KEY(item_id) REFERENCES item(item_id)
, CONSTRAINT fk_price_2 FOREIGN KEY(price_type) REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_price_3 FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_price_4 FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id)
, CONSTRAINT yn_price   CHECK(active_flag IN ('Y', 'N')));

-- Create sequence.
CREATE SEQUENCE price_s1 START WITH 1001;


--query to verify completion of this step:
SET NULL ''
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
WHERE    table_name = 'PRICE'
ORDER BY 2;

--verify completion of the constraint step:
COLUMN constraint_name   FORMAT A16
COLUMN search_condition  FORMAT A30
SELECT   uc.constraint_name
,        uc.search_condition
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('price')
AND      ucc.column_name = UPPER('active_flag')
AND      uc.constraint_name = UPPER('yn_price')
AND      uc.constraint_type = 'C';

--Rename the ITEM_RELEASE_DATE column of the ITEM table to RELEASE_DATE.
ALTER TABLE item RENAME COLUMN item_release_date TO release_date;

--query checks whether you’ve renamed the column correctly:
SET NULL ''
COLUMN TABLE_NAME   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   TABLE_NAME
,        column_id
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS NULLABLE
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    TABLE_NAME = 'ITEM'
ORDER BY 2;

--Insert three new DVD releases into the ITEM table. 
-- TRON
INSERT INTO item VALUES
(item_s1.NEXTVAL
,  '78693616878'
,  (SElECT common_lookup_id
   FROM  common_lookup
   WHERE common_lookup_type ='DVD_WIDE_SCREEN')
,  'TRON'
,  '20th Anniversary Collectors Edition'
,  'PG'
,  TRUNC(SYSDATE) - 31
,  3, SYSDATE, 3, SYSDATE); 

-- ENDERS Games
INSERT INTO item VALUES
(item_s1.NEXTVAL
,  '78693616893'
,  (SElECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type ='DVD_WIDE_SCREEN')
,  'ENDER''S GAME'
,  ''
,  'PG-13'
,  TRUNC(SYSDATE) - 15
,  3, SYSDATE, 3, SYSDATE); 

--ESYISUM
INSERT INTO item VALUES
(item_s1.NEXTVAL
,  '78693616324'
,  (SElECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type ='DVD_WIDE_SCREEN')
,  'ELYSIUM'
,  ''
,  'R'
,  TRUNC(SYSDATE) - 15
,  3, SYSDATE, 3, SYSDATE); 
--query checks whether you’ve entered three compliant rentals and rental items:
SELECT   i.item_title
,        SYSDATE AS today
,        i.release_date
FROM     item i
WHERE   (SYSDATE - i.release_date) < 31;

-- step 3 c
--Insert a new row in the MEMBER table, and three new rows in the CONTACT, ADDRESS, STREET_ADDRESS, and TELEPHONE tables. 
INSERT INTO member
VALUES
( member_s1.NEXTVAL
, (SELECT common_lookup_id FROM common_lookup 
       WHERE common_lookup_context = 'MEMBER'
       AND common_lookup_type = 'GROUP')
, 'X21-777-01'
, '9876-5432-1234-5678'
, (SELECT common_lookup_id FROM common_lookup 
       WHERE common_lookup_context = 'MEMBER'
       AND common_lookup_type = 'DISCOVER_CARD')
, 1
, SYSDATE
, 1
, SYSDATE
);

-- insert contact for Harry Potter 
INSERT INTO contact
VALUES
( contact_s1.NEXTVAL
, member_s1.CURRVAL
, (SELECT common_lookup_id FROM common_lookup 
       WHERE common_lookup_context = 'MEMBER'
       AND common_lookup_type = 'GROUP')
, 'Harry'
, ''
, 'Potter'
, 1
, SYSDATE
, 1
, SYSDATE);

-- update Harry addres

INSERT INTO address
VALUES
( address_s1.NEXTVAL
, contact_s1.CURRVAL
, (SELECT common_lookup_id FROM common_lookup
       WHERE common_lookup_context = 'MULTIPLE'
       AND common_lookup_type = 'HOME')
, 'Provo'f
, 'Utah'
, '84604'
, 1
, SYSDATE
, 1
, SYSDATE);

--Insert Harry Potter into Street_address
INSERT INTO street_address
VALUES
( street_address_s1.NEXTVAL
, address_s1.CURRVAL
, '1212 Main St'
, 1
, SYSDATE
, 1
, SYSDATE);


--insert Harry Potter into telephone
INSERT INTO telephone
VALUES
( telephone_s1.NEXTVAL
, contact_s1.CURRVAL
, address_s1.CURRVAL
, (SELECT common_lookup_id FROM common_lookup 
       WHERE common_lookup_context = 'MULTIPLE'
       AND common_lookup_type = 'HOME')
, '001'
, '801'
, '342-8932'
, 1
, SYSDATE
, 1
, SYSDATE);



------ insert contact for Ginny Potter 
INSERT INTO contact
VALUES
( contact_s1.NEXTVAL
, member_s1.CURRVAL
, (SELECT common_lookup_id FROM common_lookup 
       WHERE common_lookup_context = 'MEMBER'
       AND common_lookup_type = 'GROUP')
, 'Ginny'
, ''
, 'Potter'
, 1
, SYSDATE
, 1
, SYSDATE);

-- update Ginny addres

INSERT INTO address
VALUES
( address_s1.NEXTVAL
, contact_s1.CURRVAL
, (SELECT common_lookup_id FROM common_lookup
       WHERE common_lookup_context = 'MULTIPLE'
       AND common_lookup_type = 'HOME')
, 'Provo'
, 'Utah'
, '84604'
, 1
, SYSDATE
, 1
, SYSDATE);

--Insert Ginny Potter into Street_address
INSERT INTO street_address
VALUES
( street_address_s1.NEXTVAL
, address_s1.CURRVAL
, '1212 Main St'
, 1
, SYSDATE
, 1
, SYSDATE);


--insert Ginny Potter into telepone
INSERT INTO telephone
VALUES
( telephone_s1.NEXTVAL
, contact_s1.CURRVAL
, address_s1.CURRVAL
, (SELECT common_lookup_id FROM common_lookup 
       WHERE common_lookup_context = 'MULTIPLE'
       AND common_lookup_type = 'HOME')
, '001'
, '801'
, '342-8932'
, 1
, SYSDATE
, 1
, SYSDATE);

----- insert contact for Lily Luna Potter 
INSERT INTO contact
VALUES
( contact_s1.NEXTVAL
, member_s1.CURRVAL
, (SELECT common_lookup_id FROM common_lookup 
       WHERE common_lookup_context = 'MEMBER'
       AND common_lookup_type = 'GROUP')
, 'Lily'
, 'Luna'
, 'Potter'
, 1
, SYSDATE
, 1
, SYSDATE);

-- update Lily addres

INSERT INTO address
VALUES
( address_s1.NEXTVAL
, contact_s1.CURRVAL
, (SELECT common_lookup_id FROM common_lookup
       WHERE common_lookup_context = 'MULTIPLE'
       AND common_lookup_type = 'HOME')
, 'Provo'
, 'Utah'
, '84604'
, 1
, SYSDATE
, 1
, SYSDATE);

--Insert Lily Potter into Street_address
INSERT INTO street_address
VALUES
( street_address_s1.NEXTVAL
, address_s1.CURRVAL
, '1212 Main St'
, 1
, SYSDATE
, 1
, SYSDATE);


--insert Lily Potter into telepone
INSERT INTO telephone
VALUES
( telephone_s1.NEXTVAL
, contact_s1.CURRVAL
, address_s1.CURRVAL
, (SELECT common_lookup_id FROM common_lookup 
       WHERE common_lookup_context = 'MULTIPLE'
       AND common_lookup_type = 'HOME')
, '001'
, '801'
, '342-8932'
, 1
, SYSDATE
, 1
, SYSDATE);

COLUMN full_name FORMAT A20
COLUMN city      FORMAT A10
COLUMN state     FORMAT A10
SELECT   c.last_name || ', ' || c.first_name AS full_name
,        a.city
,        a.state_province AS state
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN street_address sa
ON       a.address_id = sa.address_id INNER JOIN telephone t
ON       c.contact_id = t.contact_id
WHERE    c.last_name = 'Potter';


-- Harrys Renal  

INSERT INTO rental
VALUES
( rental_s1.NEXTVAL
, (SElECT contact_id
   FROM contact
   WHERE first_name ='Harry' AND last_name = 'Potter')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 1
, 1
, SYSDATE
, 1
, SYSDATE);


INSERT INTO rental_item
VALUES
( rental_item_s1.NEXTVAL
, rental_s1.CURRVAL
, (SELECT item_id FROM item  
       WHERE item_title = 'TRON')
, 1
, SYSDATE
, 1
, SYSDATE
, (SElECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type ='DVD_WIDE_SCREEN')
, '');

INSERT INTO rental_item
VALUES
( rental_item_s1.NEXTVAL
, rental_s1.CURRVAL
, (SELECT item_id FROM item  
       WHERE item_title = 'ENDER''S GAME')
, 1
, SYSDATE
, 1
, SYSDATE
, (SElECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type ='DVD_WIDE_SCREEN')
, '');

-- Ginny Renal  

INSERT INTO rental
VALUES
( rental_s1.NEXTVAL
, (SElECT contact_id
   FROM contact
   WHERE first_name ='Ginny' AND last_name = 'Potter')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 3
, 1
, SYSDATE
, 1
, SYSDATE);


INSERT INTO rental_item
VALUES
( rental_item_s1.NEXTVAL
, rental_s1.CURRVAL
, item_s1.CURRVAL
, 1
, SYSDATE
, 1
, SYSDATE
, (SElECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type ='DVD_WIDE_SCREEN')
, '');


-- Lily Luna Renal  

INSERT INTO rental
VALUES
( rental_s1.NEXTVAL
, (SElECT contact_id
   FROM contact
   WHERE first_name ='Lily' AND last_name = 'Potter')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 5
, 1
, SYSDATE
, 1
, SYSDATE);


INSERT INTO rental_item
VALUES
( rental_item_s1.NEXTVAL
, rental_s1.CURRVAL
, item_s1.CURRVAL
, 1
, SYSDATE
, 1
, SYSDATE
, (SElECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type ='DVD_WIDE_SCREEN')
, '');


COLUMN full_name   FORMAT A18
COLUMN rental_id   FORMAT 9999
COLUMN rental_days FORMAT A14
COLUMN rentals     FORMAT 9999
COLUMN items       FORMAT 9999
SELECT   c.last_name||', '||c.first_name||' '||c.middle_name AS full_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL' AS rental_days
,        COUNT(DISTINCT r.rental_id) AS rentals
,        COUNT(ri.rental_item_id) AS items
FROM     rental r INNER JOIN rental_item ri
ON       r.rental_id = ri.rental_id INNER JOIN contact c
ON       r.customer_id = c.contact_id
WHERE   (SYSDATE - r.check_out_date) < 15
AND      c.last_name = 'Potter'
GROUP BY c.last_name||', '||c.first_name||' '||c.middle_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL'
ORDER BY 2;


-- Step 4
-- drop index 
DROP INDEX common_lookup_n1;
DROP INDEX common_lookup_u2;

COLUMN table_name FORMAT A14
COLUMN index_name FORMAT A20
SELECT   table_name
,        index_name
FROM     user_indexes
WHERE    table_name = 'COMMON_LOOKUP';

-- Add three new columns to the COMMON_LOOKUP table.
ALTER TABLE common_lookup
   ADD (common_lookup_table VARCHAR2(30))
   ADD (common_lookup_column VARCHAR2(30))
   ADD (common_lookup_code VARCHAR2(30));

SET NULL ''
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
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;


-- step C 

--common_lookup_table column
UPDATE common_lookup
SET common_lookup_table = common_lookup_context
WHERE common_lookup_context != 'MULTIPLE';

UPDATE common_lookup
SET common_lookup_table ='ADDRESS'
WHERE common_lookup_context = 'MULTIPLE';

-- common_lookup_column
UPDATE common_lookup
SET common_lookup_column = common_lookup_context||'_TYPE'
WHERE common_lookup_table = 'MEMBER'
AND common_lookup_type IN('INDIVIDUAL', 'GROUP');

UPDATE common_lookup
SET common_lookup_column = 'CREDIT_CARD_TYPE'
WHERE common_lookup_type IN('VISA_CARD', 'MASTER_CARD', 'DISCOVER_CARD');

UPDATE common_lookup
SET common_lookup_column = 'ADDRESS_TYPE'
WHERE common_lookup_context ='MULTIPLE';

UPDATE common_lookup
SET common_lookup_column = common_lookup_context||'_TYPE'
WHERE common_lookup_context NOT IN ('MEMBER', 'Multiple');

--add two new rows 
INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, 'TELEPHONE'
, 'HOME'
, 'HOME'
, 1
, SYSDATE
, 1
, SYSDATE
, 'TELEPHONE'
, 'TELEPHONE_TYPE'
, 'HOME');


INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, 'TELEPHONE'
, 'WORK'
, 'WORK'
, 1
, SYSDATE
, 1
, SYSDATE
, 'TELEPHONE'
, 'TELEPHONE_TYPE'
, 'WORK');


-- update the now obsolete fk 
UPDATE telephone
SET telephone type=
	(SELECT common_lookup_id
	 FROM common_lookup
	 WHERE common_lookup_table = 'TELEPHONE'
	 AND common_lookup_type ='HOME')
	 WHERE telephone_type =
	 (SELECT common_lookup_id
	 FROM common_lookup
	 WHERE common_lookup_table = 'ADDRESS'
	 AND common_lookup_type ='HOME');

UPDATE telephone
SET telephone type=
	(SELECT common_lookup_id
	 FROM common_lookup
	 WHERE common_lookup_table = 'TELEPHONE'
	 AND common_lookup_type ='WORK')
	 WHERE telephone_type =
	 (SELECT common_lookup_id
	 FROM common_lookup
	 WHERE common_lookup_table = 'ADDRESS'
	 AND common_lookup_type ='WORK');



SET NULL ''
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
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

COLUMN common_lookup_table  FORMAT A20
COLUMN common_lookup_column FORMAT A20
COLUMN common_lookup_type   FORMAT A20
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
ORDER BY 1, 2, 3;

COLUMN common_lookup_table  FORMAT A14 HEADING "Common|Lookup Table"
COLUMN common_lookup_column FORMAT A14 HEADING "Common|Lookup Column"
COLUMN common_lookup_type   FORMAT A8  HEADING "Common|Lookup|Type"
COLUMN count_dependent      FORMAT 999 HEADING "Count of|Foreign|Keys"
COLUMN count_lookup         FORMAT 999 HEADING "Count of|Primary|Keys"
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(a.address_id) AS count_dependent
,        COUNT(DISTINCT cl.common_lookup_table) AS count_lookup
FROM     address a RIGHT JOIN common_lookup cl
ON       a.address_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'ADDRESS'
AND      cl.common_lookup_column = 'ADDRESS_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
UNION
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(t.telephone_id) AS count_dependent
,        COUNT(DISTINCT cl.common_lookup_table) AS count_lookup
FROM     telephone t RIGHT JOIN common_lookup cl
ON       t.telephone_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'TELEPHONE'
AND      cl.common_lookup_column = 'TELEPHONE_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type;




ALTER TABLE common_lookup DROP COLUMN common_lookup_context;
ALTER TABLE common_lookup MODIFY common_lookup_table VARCHAR2(30) NOT NULL;
ALTER TABLE common_lookup MODIFY common_lookup_column VARCHAR2(30) NOT NULL;

SET NULL ''
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
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

-- create a unique Inedex

CREATE UNIQUE INDEX common_lookup_pk_c_lookup_1
  ON common_lookup(common_lookup_table,common_lookup_coloumn, common_lookup_type);




COLUMN table_name FORMAT A14
COLUMN index_name FORMAT A20
SELECT   table_name
,        index_name
FROM     user_indexes
WHERE    table_name = 'COMMON_LOOKUP';

ALTER TABLE rental_item MODIFY rental_item_type NUMBER NOT NULL;



SPOOL OFF


