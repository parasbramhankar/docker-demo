

FROM eclipse-temurin:21-jdk-alpine

COPY target/docker-demo-0.0.1-SNAPSHOT.jar /usr/app/app.jar

WORKDIR /user/app

EXPOSE 8080

ENTRYPOINT ["java","-jar","/usr/app/app.jar"]