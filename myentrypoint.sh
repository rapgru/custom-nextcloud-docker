#!/bin/sh -x
set -eu

# check argument given to entrypoint script
# in standard nextcloud image this is apache2-foreground
# it will just be passed to the actual entrypoint
ARGS="$@"
if [ -z "$@" ]; then
    ARGS="apache2-foreground"
fi

# nextcloud webroot
NC_ROOT=/var/www/html

# set default for data dir
if [ -n "$NEXTCLOUD_DATA_DIR" ]; then
    DATA="$NEXTCLOUD_DATA_DIR"
else
    DATA="$NC_ROOT/data"
fi

# sleep to ensure remotely stored data dir is available
sleep 20

# create data dir and fix permissions
mkdir -p ${NEXTCLOUD_DATA_DIR}; \
chown -R www-data:root ${NEXTCLOUD_DATA_DIR}; \
chmod -R 0770 ${NEXTCLOUD_DATA_DIR}

# start appdata sync and actual nextcloud entrypoint in parallel with gnu parallel
(echo /sync.sh "$NC_ROOT" "$DATA"; echo /entrypoint.sh "$ARGS") | parallel
