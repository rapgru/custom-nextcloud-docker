#!/bin/sh -x
set -eu

ARGS="$@"
if [ -z "$@" ]; then
    ARGS="apache2-foreground"
fi

NC_ROOT=/var/www/html
# testing
# NC_ROOT=`readlink -f ./tmp`

if [ -n "$NEXTCLOUD_DATA_DIR" ]; then
    DATA="$NEXTCLOUD_DATA_DIR"
else
    DATA="$NC_ROOT/data"
fi
# fix perms
# if [ "$(id -u)" = 0 ]; then
#     mkdir "$DATA" || true
#     chown -R www-data:root "$DATA"
# fi

export AWSACCESSKEYID=${AWSACCESSKEYID:-$AWS_KEY}
export AWSSECRETACCESSKEY=${AWSSECRETACCESSKEY:-$AWS_SECRET_KEY}

echo "${AWS_KEY}:${AWS_SECRET_KEY}" > /etc/passwd-s3fs
chmod 0400 /etc/passwd-s3fs

echo 'IAM_ROLE is not set - mounting S3 with credentials from ENV'
/usr/bin/s3fs  ${S3_BUCKET} ${NEXTCLOUD_DATA_DIR} -d -d -f -o url=${S3_URL},endpoint=${S3_REGION},allow_other,retries=5 &
echo 'started...'

/copy.sh &

/entrypoint.sh "$ARGS"