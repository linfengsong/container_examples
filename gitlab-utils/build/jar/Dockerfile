FROM python:3-alpine

RUN apk update
RUN apk add \
    openjdk8

RUN mkdir -p /home/app
COPY app.jar /home/app/app.jar

ENTRYPOINT ["java"]
CMD ["-jar", "/home/app/app.jar"]
