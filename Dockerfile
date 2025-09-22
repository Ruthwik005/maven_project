# Stage 1: Build the Maven project
# This stage uses Maven to compile the code and create the .war file.
FROM maven:3-eclipse-temurin-17 AS build

WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Create the final image with Tomcat
# This stage takes the .war file and deploys it on a Tomcat server.
FROM tomcat:9-jdk17-temurin

# Remove the default Tomcat welcome pages.
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the .war file from the build stage into Tomcat's deployment directory.
# Renaming it to ROOT.war makes your app available at the main URL.
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose the port that Tomcat runs on.
EXPOSE 8080

