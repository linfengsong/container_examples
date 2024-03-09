FROM registry.example.com/ubi8-minimal:latest
RUN microdnf install httpd mode_ssl && microdnf clean all

EXPOSE 8080

WORKDIR /var/www/html/

RUN rm /etc/httpd/conf.d/ssl.conf && \
    ls -la /etc/httpd/conf.d/ && \
    ls -la /etc/httpd/logs && \
    chmod -R 775 /etc/httpd/conf/httpd.conf && \
    chmod -R 775 /etc/httpd/logs && \
    chmod -R 775 /run/httpd && \
    chmod -R 775 apache:apache /run/httpd && \
    chgrp -R 0 /run && \
    chmod -R g=u /run
    
COPY dist /var/www/html/
COPY httpd.conf /etc/httpd/conf/httpd.conf

USER apache

ENTRYPOINT apachectl -D FOREGROUND