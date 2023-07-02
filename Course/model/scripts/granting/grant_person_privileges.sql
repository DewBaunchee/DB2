GRANT SELECT ON ALL TABLES IN SCHEMA public TO person;
REVOKE SELECT ON person_credentials FROM person;

SELECT *
FROM information_schema.role_table_grants
where GRANTEE = 'person';