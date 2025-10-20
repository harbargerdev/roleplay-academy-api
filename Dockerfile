# Build Stage
FROM gradle:latest AS build
WORKDIR /usr/build
COPY . .
RUN gradle build --stacktrace

# Package Stage
FROM amazoncorretto:21-jdk-alpine

# Set the working directory in the container
RUN mkdir -p /usr/app
WORKDIR /usr/app
COPY --from=build /usr/build/build/libs/rpa-api-*-SNAPSHOT.jar /usr/app/app.jar

# Copy entrypoint script for local use
COPY startup-scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose the port the application runs on
EXPOSE 8080

# Run the jar file
ENTRYPOINT ["java", "-jar", "/usr/app/app.jar"]