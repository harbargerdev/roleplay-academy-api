#!/bin/bash
if [ ! -f /run/secrets/app_role_password ]; then
  echo "ERROR: /run/secrets/app_role_password not found!"
  exit 1
fi
if [ ! -f /run/secrets/migration_role_password ]; then
  echo "ERROR: /run/secrets/migration_role_password not found!"
  exit 1
fi

export SPRING_DATASOURCE_PASSWORD=$(grep APP_ROLE_PASSWORD /run/secrets/app_role_password | cut -d '=' -f2 | tr -d '\n')
export LIQUIBASE_PASSWORD=$(grep MIGRATION_ROLE_PASSWORD /run/secrets/migration_role_password | cut -d '=' -f2 | tr -d '\n')

if [ -z "$SPRING_DATASOURCE_PASSWORD" ]; then
  echo "ERROR: SPRING_DATASOURCE_PASSWORD is empty!"
  exit 2
fi
if [ -z "$LIQUIBASE_PASSWORD" ]; then
  echo "ERROR: LIQUIBASE_PASSWORD is empty!"
  exit 2
fi

echo "SPRING_DATASOURCE_USERNAME=$SPRING_DATASOURCE_USERNAME"
echo "SPRING_DATASOURCE_PASSWORD=$SPRING_DATASOURCE_PASSWORD"
echo "LIQUIBASE_USER=$LIQUIBASE_USER"
echo "LIQUIBASE_PASSWORD=$LIQUIBASE_PASSWORD"

exec java -jar /usr/app/app.jar