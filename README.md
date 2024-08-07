# roleplay-academy-api
This repository is the back-end API repository for the Roleplay Academy API.

Latest CI Build: ![CI](https://codebuild.us-east-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoia0NjMjdZeGxmWkN2SUJFOFQzZC9hcFA5UytGWmlKaVVxK3dJbkdnU1ZITkFkQUMydDliOVk2K3JDSDJNdXBNYU1lbmM3bHNDd0FaSWRuWEhIRTAwSzZ3PSIsIml2UGFyYW1ldGVyU3BlYyI6Ik5OM1lTaGN3WGF5OUY2ZEkiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=main)

## Getting Started
To get started with this project, you will need to have the following installed on your machine:
- Docker
- Java 21
- Gradle
- IntelliJ IDEA or any other IDE of your choice

## Running the project
To run the project, you will need to have Docker installed on your machine. Once you have Docker installed, you can run the following command to start the project:
```shell
Docker compose -f .\roleplay-academy-api\docker-compose.yml -f .\roleplay-academy-api\docker-compose.local.yml -p roleplay-academy-api up -d --build spring-api
```

## Running the tests
```shell
./gradlew clean build test
```

## Authorization
The project does include Spring Security. The only open endpoints is the '/actuator/**' and the '/api/hello'. Use these
endpoints to test the docker container is running after rucking the docker compose command.