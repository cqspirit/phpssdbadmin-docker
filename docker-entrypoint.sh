#!/usr/bin/env bash

LOCK_FILE=/tmp/initialized.lock

if [[ -f ${LOCK_FILE} ]]; then
	echo "Already initialized!"
	exec "$@"
fi

SSDB_HOST=${SSDB_HOST:-ssdb}
SSDB_PORT=${SSDB_PORT:-8888}
SSDB_PASSWORD=${SSDB_PASSWORD:-password}
USERNAME=${USERNAME:-admin}
PASSWORD=${PASSWORD:-password}

CONF_FILE=/var/www/html/app/config/config.php
sed -e "s/#'ALL'/'ALL'/g" \
    -e "s/127.0.0.1/${SSDB_HOST}/g" \
    -e "s/8888/${SSDB_PORT}/g" \
    -e "s/22222222/${SSDB_PASSWORD}/g" \
    -e "s/test/${USERNAME}/g" \
    -e "s/12345678/${PASSWORD}/g" \
    -i ${CONF_FILE}

echo "phpssdbadmin configuration:"
echo " - SSDB_HOST     : ${SSDB_HOST}"
echo " - SSDB_PORT     : ${SSDB_PORT}"
echo " - SSDB_PASSWORD : ${SSDB_PASSWORD}"
echo " - USERNAME      : ${USERNAME}"
echo " - PASSWORD      : ${PASSWORD}"

touch ${LOCK_FILE}
exec "$@"