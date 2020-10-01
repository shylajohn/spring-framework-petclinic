FROM maven:3.6.3-jdk-8 AS build
COPY $WORKSPACE/src /usr/src/app/src
COPY $WORKSPACE/pom.xml /usr/src/app
RUN mvn -f /usr/src/app/pom.xml clean package
FROM openjdk:9
COPY --from=build /usr/src/app/target/petclinic-1.0.0-SNAPSHOT.jar /usr/app/petclinic-1.0.0-SNAPSHOT.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/app/petclinic-1.0.0-SNAPSHOT.jar"]
