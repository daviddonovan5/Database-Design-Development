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
--   sql> @apply_oracle_lab5.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lib/cleanup_oracle.sql
@/home/student/Data/cit225/oracle/lib/create_oracle_store.sql
@/home/student/Data/cit225/oracle/lib/seed_oracle_store.sql
-- Add your lab here:
-- ----------------------------------------------------------------------
SPOOL apply_oracle_lab5.txt

---Step 1.A
SELECT
   member_id
,  contact.contact_id
FROM member
INNER JOIN contact
USING (member_id); 

---STEP 1.B
SELECT
   contact_id
,  address_id
FROM contact
INNER JOIN address
USING (contact_id); 

-- Step 1.C
SELECT
   address_id
,  street_address_id
FROM address
INNER JOIN street_address
USING (address_id);

-- STEP 1.D
SELECT
   contact_id
,  telephone_id
FROM contact
INNER JOIN telephone
USING (contact_id);


---STEP 2.A
SELECT
   c.contact_id
,  su .system_user_id
FROM contact c
INNER JOIN system_user su
ON c.created_by = su.system_user_id; 

--STEP 2.B
SELECT
   c.contact_id
,  su.system_user_id
FROM contact c
INNER JOIN system_user su
ON c.last_updated_by = su.system_user_id;


--STEP 3.A
SELECT
   su1.system_user_id
,  su1.created_by
,  su2.system_user_id
FROM system_user su1
INNER JOIN system_user su2
ON su1.created_by = su2.system_user_id;

-- STEP 3.B
SELECT
   su1.system_user_id
,  su1.last_updated_by
,  su2.system_user_id
FROM system_user su1
INNER JOIN system_user su2
ON su1.last_updated_by = su2.system_user_id;

--STEP 3.C

SELECT
   su1.system_user_name
,  su1.system_user_id
,  su2.system_user_name AS "Created User"
,  su2.system_user_id AS "Created By"
,  su3.system_user_name AS "Udated user"
,  su3.system_user_id AS "Udated By"
FROM system_user su1
INNER JOIN system_user su2
ON su1.created_by = su2.system_user_id
INNER JOIN system_user su3
ON su1.last_updated_by = su3.system_user_id;   


--STEP 4
SELECT
   r.rental_id
,  ri.rental_id
,  ri.item_id
,  i.item_id
FROM rental r
INNER JOIN rental_item ri
ON r.rental_id = ri.rental_id
INNER JOIN item i
ON ri.item_id = i.item_id;

ALTER TABLE rental DROP CONSTRAINT nn_rental_3;


SPOOL OFF
