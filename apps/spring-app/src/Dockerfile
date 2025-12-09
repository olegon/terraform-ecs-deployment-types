FROM maven:3-amazoncorretto-21 AS build

WORKDIR /opt/app

COPY src ./src
COPY pom.xml .

RUN mvn package

FROM amazoncorretto:21

WORKDIR /opt/app

COPY --from=build /opt/app/target/spring-app*.jar app.jar

USER nobody

CMD [ "java", "-jar", "app.jar" ]
