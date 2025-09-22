#!/bin/bash
set -e

export PGPASSWORD="$POSTGRES_PASSWORD"

MAX_ATTEMPTS=30
ATTEMPT=1
until pg_isready -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER"; do
  echo "Waiting for PostgreSQL to be ready... (attempt $ATTEMPT/$MAX_ATTEMPTS)"
  sleep 2
  ATTEMPT=$((ATTEMPT+1))
  if [ $ATTEMPT -gt $MAX_ATTEMPTS ]; then
    echo "ERROR: PostgreSQL did not become ready after $MAX_ATTEMPTS attempts."
    echo "POSTGRES_HOST=$POSTGRES_HOST"
    echo "POSTGRES_PORT=$POSTGRES_PORT"
    echo "POSTGRES_USER=$POSTGRES_USER"
    echo "POSTGRES_DB=$POSTGRES_DB"
    exit 1
  fi
done

# Create schema
psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE SCHEMA IF NOT EXISTS roleplayacademy;"

# Add citext extension to roleplayacademy schema
psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA roleplayacademy;"

# Add pg_trgm extension to roleplayacademy schema
psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA roleplayacademy;"

# Generate a random password for the new App role
APP_ROLE_PASSWORD=$(openssl rand -base64 16 | sed 's/=*$//')

# Create or update the App role and database
psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE ROLE app_role LOGIN PASSWORD '${APP_ROLE_PASSWORD}';"

# Store the password in a file (mounted volume)
echo "APP_ROLE_PASSWORD=${APP_ROLE_PASSWORD}" > /run/secrets/app_role_password

# Generate a random password for migration role
MIGRATION_ROLE_PASSWORD=$(openssl rand -base64 16 | sed 's/=*$//')

# Create or update the migration role
psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE ROLE migration_role LOGIN PASSWORD '${MIGRATION_ROLE_PASSWORD}';"

# Store the migration password in a file (mounted volume)
echo "MIGRATION_ROLE_PASSWORD=${MIGRATION_ROLE_PASSWORD}" > /run/secrets/migration_role_password

# Update Schema Ownership
psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "ALTER SCHEMA roleplayacademy OWNER TO migration_role;" || { echo "ERROR: Failed to alter schema ownership."; exit 1; }

# Grant necessary privileges to the roles
psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "GRANT USAGE ON SCHEMA roleplayacademy TO app_role;" || { echo "ERROR: Failed to grant USAGE on schema."; exit 1; }
psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA roleplayacademy TO app_role;" || { echo "ERROR: Failed to grant DML on tables."; exit 1; }
psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA roleplayacademy TO app_role;" || { echo "ERROR: Failed to grant USAGE/SELECT on sequences."; exit 1; }
psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA roleplayacademy TO app_role;" || { echo "ERROR: Failed to grant EXECUTE on functions."; exit 1; }

# Revoke unnecessary privileges from the public role
psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "REVOKE ALL ON SCHEMA roleplayacademy FROM PUBLIC;" || { echo "ERROR: Failed to revoke schema from PUBLIC."; exit 1; }
psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "REVOKE ALL ON ALL TABLES IN SCHEMA roleplayacademy FROM PUBLIC;" || { echo "ERROR: Failed to revoke tables from PUBLIC."; exit 1; }
psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "REVOKE ALL ON ALL SEQUENCES IN SCHEMA roleplayacademy FROM PUBLIC;" || { echo "ERROR: Failed to revoke sequences from PUBLIC."; exit 1; }
psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "REVOKE ALL ON ALL FUNCTIONS IN SCHEMA roleplayacademy FROM PUBLIC;" || { echo "ERROR: Failed to revoke functions from PUBLIC."; exit 1; }

echo "Database roles and privileges have been set up successfully."