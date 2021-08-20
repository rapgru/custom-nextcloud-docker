ARG NEXTCLOUD_DATA_DIR=/data
ARG IMAGE_TAG=22.1.0-apache

FROM nextcloud:${IMAGE_TAG}

ARG NEXTCLOUD_DATA_DIR

RUN mkdir -p ${NEXTCLOUD_DATA_DIR}; \
	chown -R www-data:root ${NEXTCLOUD_DATA_DIR}; \
	chmod -R 0770 ${NEXTCLOUD_DATA_DIR}

VOLUME ${NEXTCLOUD_DATA_DIR}

RUN apt-get update -y; apt-get install -y s3fs inotify-tools

COPY myentrypoint.sh /myentrypoint.sh
COPY myentrypoint.sh /sync.sh
RUN chmod +x /myentrypoint.sh /sync.sh
ENTRYPOINT ["/myentrypoint.sh"]
CMD ["apache2-foreground"]
