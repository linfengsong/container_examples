ARG BASE_IMAGE_NAME
ARG BASE_IMAGE_TAG
ARG PRISMA_EMAIL
FROM $BASE_IMAGE_NAME:$BASE_IMAGE_TAG
LABEL "prisma_email_alert"="$PRISMA_EMAIL"

RUN apt-get update; apt-get install -y --no-install-recommends wget tar unzip curl vim tar
    
EXPOSE 8080

WORKDIR /usr/local/apache2/htdocs/

COPY dist /usr/local/apache2/htdocs/
