ARG DOCKER_IMAGE_PATH
ARG PRISMA_EMAIL
FROM $DOCKER_IMAGE_PATH
LABEL "prisma_email_alert"="$PRISMA_EMAIL"
ARG PUBLISH_DIR=/publish
COPY $PUBLISH_DIR /deployments
WORKDIR /deployments
ENTRYPOINT ["java"]
CMD ["-jar", "/deployments/application.jar"]