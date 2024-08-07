# Build Stage
FROM gradle:latest AS BUILD
WORKDIR /usr/build
COPY . .
RUN gradle build --stacktrace

# Package Stage
FROM amazoncorretto:21

# Set the working directory in the container
ENV JAR_NAME=roleplayacademyapi-0.0.1-SNAPSHOT.jar.jar
ENV APP_HOME=/usr/app
WORKDIR $APP_HOME
COPY --from=BUILD $APP_HOME .

# For debug purposes
RUN pwd
RUN ls -la $APP_HOME
RUN ls -la build

# Expose the port the application runs on
EXPOSE 8080

# Run the jar file
ENTRYPOINT exec java -jar build/libs/$JAR_NAME