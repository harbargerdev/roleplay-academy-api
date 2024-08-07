# User the official Amazon Corretto 21 image as the base image
FROM amazoncorretto:21

# Set the working directory in the container
ENV APP_HOME /app
WORKDIR $APP_HOME

# For debug purposes
RUN pwd
RUN ls -la $APP_HOME
RUN ls -la build

# Copy the jar file into the container at /app
COPY build/libs/*.jar $APP_HOME

# Expose the port the application runs on
EXPOSE 8080

# Run the jar file
ENTRYPOINT ["java", "-jar", "roleplayacademyapi-0.0.1-SNAPSHOT.jar"]