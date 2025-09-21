-- Creating initial schema and roles
CREATE SCHEMA IF NOT EXISTS roleplayacademy;
CREATE ROLE IF NOT EXISTS app_role LOGIN;
CREATE ROLE IF NOT EXISTS migration_role LOGIN;

-- Assign schema ownership
ALTER SCHEMA roleplayacademy OWNER TO migration_role;

-- Grant privileges to roles
GRANT USAGE ON SCHEMA roleplayacademy TO app_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA roleplayacademy TO app_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA roleplayacademy TO app_role;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA roleplayacademy TO app_role;

-- Revoke unnecessary privileges from public
REVOKE ALL ON SCHEMA roleplayacademy FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA roleplayacademy FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA roleplayacademy FROM PUBLIC;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA roleplayacademy FROM PUBLIC;