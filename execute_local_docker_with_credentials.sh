#!/bin/bash
./gradlew clean

echo "MYSQL_ROOT_PASSWORD=$(openssl rand -base64 16)" > .env
echo "MYSQL_PASSWORD=$(openssl rand -base64 16)" >> .env
echo "MYSQL_USER=myuser" >> .env
echo "MYSQL_DATABASE=mydatabase" >> .env

# Run the Docker container with the generated credentials
docker compose -f docker-compose.local.yml --env-file .env up --build