FROM python:3-alpine

RUN apk update
RUN apk add \
    openjdk8

RUN mkdir -p /home/app
COPY rest-api-0.0.1-SNAPSHOT.jar /home/app/app.jar

ENTRYPOINT ["java"]
CMD ["-jar", "/home/app/app.jar"]
