# main compiler and package
FROM maven:3.9.8-amazoncorretto-21 AS builder
WORKDIR /app
COPY ./pom.xml .
RUN mvn -e -B dependency:go-offline
COPY ./src ./src
RUN mvn -Dmaven.test.skip=true clean install -B -Dmaven.source.skip

FROM public.ecr.aws/docker/library/amazoncorretto:21-alpine3.18 AS corretto-jdk
#FROM amazoncorretto:21-alpine3.18 AS corretto-jdk
RUN apk add --no-cache binutils
RUN $JAVA_HOME/bin/jlink \
         --verbose \
         --add-modules ALL-MODULE-PATH \
         --strip-debug \
         --no-man-pages \
         --no-header-files \
         --compress=2 \
         --output /customjre

# main app image
FROM public.ecr.aws/docker/library/alpine:latest
ENV JAVA_HOME=/jre
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# copy JRE from the base image
COPY --from=corretto-jdk /customjre $JAVA_HOME

# Add app user
ARG APPLICATION_USER="app-ms"
ARG TZ="America/Lima"
ENV TZ=$TZ
RUN adduser --no-create-home -u 1000 -D $APPLICATION_USER

# Configure working directory
RUN mkdir /app && \
    chown -R $APPLICATION_USER /app

USER 1000

WORKDIR /opt/app
COPY --chown=1000:1000 --from=builder /app/target/*.jar /opt/app/app.jar
COPY --chown=1000:1000 --from=builder /app/src /opt/app/classes
WORKDIR /opt/app

ENTRYPOINT ["java","-jar","app.jar"]