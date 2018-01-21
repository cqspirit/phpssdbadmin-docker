#!/usr/bin/env bash

LOCK_FILE=/tmp/initialized.lock

if [[ -f ${LOCK_FILE} ]]; then
	echo "Captcha is patched already!"
else
    LOGIN_SCRIPT=/var/www/html/app/controllers/login.php
    sed -e '/if(!SafeUtil::verify_captcha/,+3 s/^/#/' \
        -i ${LOGIN_SCRIPT}

    LOGIN_TPL=/var/www/html/app/views/login.tpl.php
    sed -e '/<img id="captcha"/,+1d' \
        -i ${LOGIN_TPL}

    touch ${LOCK_FILE}
fi

SSDB_HOST=${SSDB_HOST:-ssdb}
SSDB_PORT=${SSDB_PORT:-8888}
SSDB_PASSWORD=${SSDB_PASSWORD:-}
USERNAME=${USERNAME:-admin}
PASSWORD=${PASSWORD:-password}

CONF_FILE=/var/www/html/app/config/config.php
cat <<EOM >${CONF_FILE}
<?php
define('ENV', 'online');
return array(
	'env' => ENV,
	'logger' => array(
		'level' => 'all', // none/off|(LEVEL)
		'dump' => 'file', // none|html|file, 可用'|'组合
		'files' => array( // ALL|(LEVEL)
			#'ALL'	=> dirname(__FILE__) . '/../../logs/' . date('Y-m') . '.log',
		),
	),
	'servers' => array(
		array(
			'host' => '${SSDB_HOST}',
			'port' => '${SSDB_PORT}',
			'password' => '${SSDB_PASSWORD}',
		),
	),
	'login' => array(
		'name' => '${USERNAME}',
		'password' => '${PASSWORD}', // at least 6 characters
	),
);
EOM

echo "phpssdbadmin configuration:"
echo " - SSDB_HOST     : ${SSDB_HOST}"
echo " - SSDB_PORT     : ${SSDB_PORT}"
echo " - SSDB_PASSWORD : ${SSDB_PASSWORD}"
echo " - USERNAME      : ${USERNAME}"
echo " - PASSWORD      : ${PASSWORD}"

exec "$@"