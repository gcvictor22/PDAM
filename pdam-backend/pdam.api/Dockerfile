FROM maven:3.8.4-openjdk-17-slim AS build

WORKDIR /app

COPY ./pom.xml .

RUN mvn dependency:go-offline -B

COPY ./src ./src
COPY ./uploads ./uploads

RUN mvn clean package -DskipTests

FROM openjdk:17-jdk-slim

WORKDIR /app

COPY --from=build /app/target/PDAM-0.0.1-SNAPSHOT.jar /app/pdam.jar

COPY --from=build /app/uploads ./uploads

EXPOSE 8080

CMD ["java", "-jar", "pdam.jar"]
