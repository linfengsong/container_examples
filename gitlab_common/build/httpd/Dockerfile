FROM httpd:2.4
 
USER root

RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    wget \
    tar \
    unzip \
    curl \
    vim \
    tar
    
ADD ./src/ /usr/local/apache2/htdocs/

RUN pwd

ADD ./docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod -R g+rw /usr/local/apache2/htdocs/

EXPOSE 80

WORKDIR /usr/local/apache2/htdocs/

ENTRYPOINT ["/bin/bash", "/docker-entrypoint.sh"]
