FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
COPY ssl/cert.pem ssl/cert.pem
COPY ssl/key.pem ssl/key.pem
EXPOSE 8443
ENTRYPOINT ["java", "-jar", "app.jar"]