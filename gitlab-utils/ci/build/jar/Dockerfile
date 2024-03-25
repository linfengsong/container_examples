ARG BASE_IMAGE_NAME
ARG BASE_IMAGE_TAG
ARG PRISMA_EMAIL
FROM $BASE_IMAGE_NAME:$BASE_IMAGE_TAG
LABEL "prisma_email_alert"="$PRISMA_EMAIL"
ARG PUBLISH_DIR=/publish
COPY $PUBLISH_DIR /deployments
WORKDIR /deployments
ENTRYPOINT ["java"]
CMD ["-jar", "/deployments/application.jar"]