# User the official Amazon Corretto 21 image as the base image
FROM amazoncorretto:21

# Set the working directory in the container
WORKDIR /app

# Copy the jar file into the container at /app
COPY build/libs/*.jar /app

# Expose the port the application runs on
EXPOSE 8080

# Run the jar file
ENTRYPOINT ["java", "-jar", "roleplayacademyapi-0.0.1-SNAPSHOT.jar"]