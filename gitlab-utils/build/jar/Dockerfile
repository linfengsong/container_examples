FROM registry.access.redhat.com/ubi8/openjdk-17
ARG APP_JAR=application.jar
RUN mkdir -p /deployments
COPY $APP_JAR /deployments/application.jar
WORKDIR /deployments
ENTRYPOINT ["java"]
CMD ["-jar", "/deployments/application.jar"]
