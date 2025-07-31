# Build Stage
FROM gradle:latest AS BUILD
WORKDIR /usr/build
COPY . .
RUN gradle build --stacktrace

# Package Stage
FROM amazoncorretto:21

# Set the working directory in the container
RUN mkdir -p /usr/app
ENV JAR_NAME=roleplayacademyapi-0.0.1-SNAPSHOT.jar
ENV APP_HOME=/usr/app
WORKDIR $APP_HOME
COPY --from=BUILD /usr/build/build/libs/$JAR_NAME $APP_HOME

# For debug purposes
RUN pwd
RUN ls -la $APP_HOME

# Expose the port the application runs on
EXPOSE 8080

# Run the jar file
ENTRYPOINT exec java -jar $APP_HOME/$JAR_NAME