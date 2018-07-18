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
--   sql> @apply_oracle_lab11.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@../lab9/apply_oracle_lab9.sql

Select c.first_name || ' ' ||c.last_name AS person
FROM contact c FULL JOIN address a
On c.contact_id = a.contact_id
MINUS
SELECT c.first_name || ' ' || c.last_name AS person
FROM contact c Left Join address a
ON c.contact_id = a.contact_id;
