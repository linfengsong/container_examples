FROM registry.access.redhat.com/ubi8/openjdk-17
LABEL "prisma_email_alert"="dsong@yahoo.com"
ARG APP_JAR=application.jar
COPY $APP_JAR /deployments/application.jar
WORKDIR /deployments
ENTRYPOINT ["java"]
CMD ["-jar", "/deployments/application.jar"]