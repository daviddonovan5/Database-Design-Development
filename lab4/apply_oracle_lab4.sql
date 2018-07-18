--apply_oracle_lab4.sql

@/home/student/Data/cit225/oracle/lab2/apply_oracle_lab2.sql

 
SPOOL apply_oracle_lab4.txt


--insert row into the system_user_lab

INSERT INTO system_user_lab
( system_user_lab_id
, system_user_name
, system_user_group_id
, system_user_type
, first_name
, middle_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( system_user_lab_s1.NEXTVAL
, 'REACHERJ'
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'SYSTEM_USER_LAB'
       AND common_lookup_meaning = 'Database Administrator')
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'MULTIPLE'
       AND common_lookup_meaning = 'Home')
, 'Jack'
, ''
, 'Reacher'
, 1
, SYSDATE
, 1
, SYSDATE);


-- insert into common_lookup_lab
INSERT INTO common_lookup_lab
VALUES
( common_lookup_lab_s1.NEXTVAL
, 'MEMBER_LAB'
, 'AMERICAN_EXPRESS_CARD'
, 'American Express Card'
, 1
, SYSDATE
, 1
, SYSDATE);

-- insert row in Member_lab

INSERT INTO member_lab
VALUES
( member_lab_s1.NEXTVAL
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'MEMBER'
       AND common_lookup_type = 'INDIVIDUAL')
, 'X15-500-01'
, '9876-5432-1234-5678'
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'MEMBER_LAB'
       AND common_lookup_type = 'AMERICAN_EXPRESS_CARD')
, 1
, SYSDATE
, 1
, SYSDATE
);


-- insert row for contact_lab

INSERT INTO contact_lab
VALUES
( contact_lab_s1.NEXTVAL
, member_lab_s1.CURRVAL
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'CONTACT'
       AND common_lookup_type = 'CUSTOMER')
, 'John'
, ''
, 'Jones'
, 1
, SYSDATE
, 1
, SYSDATE);

-- insert address_lab
INSERT INTO address_lab
VALUES
( address_lab_s1.NEXTVAL
, contact_lab_s1.CURRVAL
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'MULTIPLE'
       AND common_lookup_type = 'HOME')
, 'Draper'
, 'Utah'
, '84020'
, 1
, SYSDATE
, 1
, SYSDATE);

--Insert row into Street_address_lab
INSERT INTO street_address_lab
VALUES
( street_address_lab_s1.NEXTVAL
, address_lab_s1.CURRVAL
, '372 East 12300 South'
, 1
, SYSDATE
, 1
, SYSDATE);

--insert row into telepone lab
INSERT INTO telephone_lab
VALUES
( telephone_lab_s1.NEXTVAL
, contact_lab_s1.CURRVAL
, address_lab_s1.CURRVAL
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'MULTIPLE'
       AND common_lookup_type = 'HOME')
, '001'
, '801'
, '435-7654'
, 1
, SYSDATE
, 1
, SYSDATE);

--insert row into rental lab
INSERT INTO rental_lab
VALUES
( rental_lab_s1.NEXTVAL
, contact_lab_s1.CURRVAL
, '02-JAN-15'
, '06-JAN-15'
, 1
, SYSDATE
, 1
, SYSDATE);


--insert row into item lab
INSERT INTO item_lab
VALUES
( item_lab_s1.NEXTVAL
, 'B00N1JQ2UO'
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'ITEM'
       AND common_lookup_type = 'DVD_WIDE_SCREEN')
, 'Guardians of the Galaxy'
, ''
, 'PG-13'
, '09-DEC-14'
, 1
, SYSDATE
, 1
, SYSDATE);

--insert row into rental item lab
INSERT INTO rental_item_lab
VALUES
( rental_item_lab_s1.NEXTVAL
, rental_lab_s1.CURRVAL
, item_lab_s1.CURRVAL
, 1
, SYSDATE
, 1
, SYSDATE);

--insert row into the system_user_lab
-- Start of the new row

INSERT INTO system_user_lab
( system_user_lab_id
, system_user_name
, system_user_group_id
, system_user_type
, first_name
, middle_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( system_user_lab_s1.NEXTVAL
, 'OWENSR'
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'SYSTEM_USER_LAB'
       AND common_lookup_meaning = 'Database Administrator')
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'MULTIPLE'
       AND common_lookup_meaning = 'Home')
, 'Ray'
, ''
, 'Ownes'
, 1
, SYSDATE
, 1
, SYSDATE);


-- insert into common_lookup_lab
INSERT INTO common_lookup_lab
VALUES
( common_lookup_lab_s1.NEXTVAL
, 'MEMBER_LAB'
, 'DINERS_CLUB_CARD'
, 'diners Club Card'
, 1
, SYSDATE
, 1
, SYSDATE);

-- insert row in Member_lab

INSERT INTO member_lab
VALUES
( member_lab_s1.NEXTVAL
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'MEMBER'
       AND common_lookup_type = 'INDIVIDUAL')
, 'X15-500-02'
, '9876-5432-1234-5679'
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'MEMBER_LAB'
       AND common_lookup_type = 'DINERS_CLUB_CARD')
, 1
, SYSDATE
, 1
, SYSDATE
);


-- insert row for contact_lab

INSERT INTO contact_lab
VALUES
( contact_lab_s1.NEXTVAL
, member_lab_s1.CURRVAL
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'CONTACT'
       AND common_lookup_type = 'CUSTOMER')
, 'Jane'
, ''
, 'Jones'
, 1
, SYSDATE
, 1
, SYSDATE);

-- insert address_lab
INSERT INTO address_lab
VALUES
( address_lab_s1.NEXTVAL
, contact_lab_s1.CURRVAL
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'MULTIPLE'
       AND common_lookup_type = 'HOME')
, 'Draper'
, 'Utah'
, '84020'
, 1
, SYSDATE
, 1
, SYSDATE);

--Insert row into Street_address_lab
INSERT INTO street_address_lab
VALUES
( street_address_lab_s1.NEXTVAL
, address_lab_s1.CURRVAL
, '1872 West 5400 South'
, 1
, SYSDATE
, 1
, SYSDATE);

--insert row into telepone lab
INSERT INTO telephone_lab
VALUES
( telephone_lab_s1.NEXTVAL
, contact_lab_s1.CURRVAL
, address_lab_s1.CURRVAL
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'MULTIPLE'
       AND common_lookup_type = 'HOME')
, '001'
, '801'
, '435-7654'
, 1
, SYSDATE
, 1
, SYSDATE);

--insert row into rental lab
INSERT INTO rental_lab
VALUES
( rental_lab_s1.NEXTVAL
, contact_lab_s1.CURRVAL
, '03-JAN-15'
, '05-JAN-15'
, 1
, SYSDATE
, 1
, SYSDATE);


--insert row into item lab
INSERT INTO item_lab
VALUES
( item_lab_s1.NEXTVAL
, 'B00OY7YPGK'
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'ITEM'
       AND common_lookup_type = 'BLU_RAY')
, 'The Maze Runner'
, ''
, 'PG-13'
, '16-DEC-14'
, 1
, SYSDATE
, 1
, SYSDATE);

--insert row into item lab
INSERT INTO item_lab
VALUES
( item_lab_s1.NEXTVAL
, 'B00OY7YPGK'
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'ITEM'
       AND common_lookup_type = 'BLU-RAY')
, 'The Maze Runner'
, ''
, 'PG-13'
, '09-DEC-14'
, 1
, SYSDATE
, 1
, SYSDATE);

--insert row into rental item lab
INSERT INTO rental_item_lab
VALUES
( rental_item_lab_s1.NEXTVAL
, rental_lab_s1.CURRVAL
, item_lab_s1.CURRVAL
, 1
, SYSDATE
, 1
, SYSDATE);


--Group membership 
-- Step 11

-- insert into common_lookup_lab
INSERT INTO common_lookup_lab
VALUES
( common_lookup_lab_s1.NEXTVAL
, 'CONTACT'
, 'GROUP'
, 'Group Membership'
, 1
, SYSDATE
, 1
, SYSDATE);


-- insert row in Member_lab

INSERT INTO member_lab
VALUES
( member_lab_s1.NEXTVAL
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'MEMBER'
       AND common_lookup_type = 'GROUP')
, 'X21-777-01'
, '9876-5432-1234-5678'
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'MEMBER'
       AND common_lookup_type = 'DISCOVER_CARD')
, 1
, SYSDATE
, 1
, SYSDATE
);

-- insert row for contact_lab

INSERT INTO contact_lab
VALUES
( contact_lab_s1.NEXTVAL
, member_lab_s1.CURRVAL
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'CONTACT'
       AND common_lookup_type = 'GROUP')
, 'Yondu'
, ''
, 'Udonta'
, 1
, SYSDATE
, 1
, SYSDATE);


-- insert address_lab
INSERT INTO address_lab
VALUES
( address_lab_s1.NEXTVAL
, contact_lab_s1.CURRVAL
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'MULTIPLE'
       AND common_lookup_type = 'HOME')
, 'Draper'
, 'Utah'
, '84020'
, 1
, SYSDATE
, 1
, SYSDATE);

--Insert row into Street_address_lab
INSERT INTO street_address_lab
VALUES
( street_address_lab_s1.NEXTVAL
, address_lab_s1.CURRVAL
, '12129 South State Street'
, 1
, SYSDATE
, 1
, SYSDATE);

--insert row into telepone lab
INSERT INTO telephone_lab
VALUES
( telephone_lab_s1.NEXTVAL
, contact_lab_s1.CURRVAL
, address_lab_s1.CURRVAL
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'MULTIPLE'
       AND common_lookup_type = 'HOME')
, '001'
, '801'
, '342-8940'
, 1
, SYSDATE
, 1
, SYSDATE);



-- insert row for contact_lab

INSERT INTO contact_lab
VALUES
( contact_lab_s1.NEXTVAL
, member_lab_s1.CURRVAL
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'CONTACT'
       AND common_lookup_type = 'GROUP')
, 'Peter'
, ''
, 'Quill'
, 1
, SYSDATE
, 1
, SYSDATE);


-- insert address_lab
INSERT INTO address_lab
VALUES
( address_lab_s1.NEXTVAL
, contact_lab_s1.CURRVAL
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'MULTIPLE'
       AND common_lookup_type = 'HOME')
, 'Draper'
, 'Utah'
, '84020'
, 1
, SYSDATE
, 1
, SYSDATE);

--Insert row into Street_address_lab
INSERT INTO street_address_lab
VALUES
( street_address_lab_s1.NEXTVAL
, address_lab_s1.CURRVAL
, '12129 South State Street'
, 1
, SYSDATE
, 1
, SYSDATE);

--insert row into telepone lab
INSERT INTO telephone_lab
VALUES
( telephone_lab_s1.NEXTVAL
, contact_lab_s1.CURRVAL
, address_lab_s1.CURRVAL
, (SELECT common_lookup_lab_id FROM common_lookup_lab 
       WHERE common_lookup_context = 'MULTIPLE'
       AND common_lookup_type = 'HOME')
, '001'
, '801'
, '342-8941'
, 1
, SYSDATE
, 1
, SYSDATE);


SPOOL OFF;

