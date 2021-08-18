ARG NEXTCLOUD_DATA_DIR=/data
ARG IMAGE_TAG=22.1.0-apache

FROM nextcloud:${IMAGE_TAG}

ARG NEXTCLOUD_DATA_DIR

RUN mkdir -p ${NEXTCLOUD_DATA_DIR}; \
	chown -R www-data:root ${NEXTCLOUD_DATA_DIR}; \
	chmod -R g=u ${NEXTCLOUD_DATA_DIR}

VOLUME ${NEXTCLOUD_DATA_DIR}

RUN apt-get install -y s3fs

COPY myentrypoint.sh /myentrypoint.sh
RUN chmod +x /myentrypoint.sh
ENTRYPOINT ["/myentrypoint.sh"]
CMD ["apache2-foreground"]
