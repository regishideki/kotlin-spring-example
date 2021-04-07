#!/usr/bin/env bash

set -e

ENVIRONMENT_NAME="${SERVER_ENV:-"dev"}"
PORT="${PORT:-"8080"}"
JVM_OPTS="${JVM_OPTS:-""}"

COMMAND=${1:-"web"}
echo $COMMAND

case "$COMMAND" in
  web)
    exec java -Xms380m \
        -Duser.Timezone=America/Sao_Paulo \
        -Dserver.port=${PORT} \
        -Djava.security.egd=file:/dev/./urandom \
        -Dspring.profiles.active="${ENVIRONMENT_NAME}" \
        -jar /app/kotlin-spring-example.jar
    ;;
  *)
    exec sh -c "$*"
    ;;
esac
