ARG DOCKER_IMAGE_PATH
ARG DOCKER_IMAGE_TAG
ARG PRISMA_EMAIL
FROM $DOCKER_IMAGE_PATH:$DOCKER_IMAGE_TAG
LABEL "prisma_email_alert"="$PRISMA_EMAIL"

RUN apt-get update; apt-get install -y --no-install-recommends wget tar unzip curl vim tar
    
EXPOSE 8080

WORKDIR /var/www/html/

RUN rm /etc/httpd/conf.d/ssl.conf &&  \
    ls -la /etc/httpd/conf.d/ &&  \
    ls -la /etc/httpd/logs/ && \
    chmod -R 775 /etc/httpd/conf/httpd.conf && \
    chmod -R 775 /etc/httpd/logs && \
    chmod -R 775 /run/httpd && \
    chown -R apache:apache /run/httpd && \
    chgrp -R 0 /run && \
    chmod -R g=u /run

COPY dist /var/www/html/
COPY httpd.conf /etc/httpd/conf/httpd.conf

USER apache

ENTRYPOINT apachectl -D FOREGROUND
