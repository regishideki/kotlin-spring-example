# --------------------------------------------------------------------------------
# Layer: builder
# Install dependencies and builds a JAR with the application
FROM gradle:6.6-jdk8 as builder

# Prevents volume permission mismatch (Gradle image user is 'gradle')
USER root

RUN mkdir /gradle-cache

WORKDIR /app

COPY build.gradle.kts settings.gradle.kts /app/
RUN mkdir -p /app/src/main/kotlin/
RUN echo 'package build\n\class DummyApp\n\fun main(){}\n' >> /app/src/main/kotlin/DummyApp.kt

# force download all the dependencies
RUN gradle -g /gradle-cache compileKotlin --no-daemon

RUN rm src/main/kotlin/DummyApp.kt

COPY src /app/src

# Build project
RUN gradle -g /gradle-cache build -x test --no-daemon

RUN cp /app/build/libs/kotlin-spring-example.jar /app/kotlin-spring-example.jar

# -----------------------------------------------------------------------------
# Layer: prod
# Runs the application as if in a prod environment
FROM openjdk:8-jre-slim as prod

# Add Tini
ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini /tini
RUN chmod +x /tini

ENTRYPOINT ["/tini", "--", "sh", "init.sh"]

WORKDIR /app

COPY init.sh /app
COPY --from=builder /app/kotlin-spring-example.jar /app/kotlin-spring-example.jar

EXPOSE 8080

CMD ["web"]
