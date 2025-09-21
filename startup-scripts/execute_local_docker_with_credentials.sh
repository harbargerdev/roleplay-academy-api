#!/bin/bash
./gradlew clean

echo "POSTGRES_PASSWORD=$(openssl rand -base64 16)" >> .env
echo "POSTGRES_USER=postgres" >> .env
echo "POSTGRES_DB=roleplayacademy" >> .env
echo "POSTGRES_HOST=postgres" >> .env
echo "POSTGRES_PORT=5432" >> .env
echo "APP_USER=app_role" >> .env
echo "MIGRATION_USER=migration_role" >> .env

# Run the Docker container with the generated credentials
docker compose -f docker-compose.local.yml --env-file .env up --build