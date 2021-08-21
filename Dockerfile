ARG NEXTCLOUD_DATA_DIR=/s3/data
ARG IMAGE_TAG=22.1.0-apache

FROM nextcloud:${IMAGE_TAG}

ARG NEXTCLOUD_DATA_DIR

RUN mkdir /s3

VOLUME ${NEXTCLOUD_DATA_DIR}

RUN apt-get update -y; apt-get install -y s3fs inotify-tools

COPY myentrypoint.sh /myentrypoint.sh
COPY sync.sh /sync.sh
RUN chmod +x /myentrypoint.sh /sync.sh
ENTRYPOINT ["/myentrypoint.sh"]
CMD ["apache2-foreground"]
