select * from role_sys_privs;

select * from all_users;

SELECT * FROM user_role_privs;

create user TESTUSER IDENTIFIED BY testpassword;

GRANT CREATE SESSION TO TESTUSER;

GRANT
    CREATE TABLE,
    CREATE PROCEDURE,
    CREATE TRIGGER,
    CREATE INDEXTYPE,
    CREATE SEQUENCE
TO TESTUSER;

GRANT ALTER ANY TABLE TO TESTUSER;

GRANT DROP ANY TABLE TO TESTUSER;

GRANT DELETE ANY TABLE TO TESTUSER;

CREATE ROLE FIRST_TEST_ROLE;

GRANT
    CREATE TABLE,
    CREATE PROCEDURE,
    CREATE TRIGGER,
    CREATE INDEXTYPE,
    CREATE SEQUENCE
TO FIRST_TEST_ROLE;

GRANT FIRST_TEST_ROLE TO TESTUSER;