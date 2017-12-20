#!/bin/bash
set -eo pipefail

file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

redis() {
	file_env 'PASSPHRASE'
	file_env 'AWS_ACCESS_KEY_ID'
	file_env 'AWS_SECRET_ACCESS_KEY'

	if [ "$1" == "cleanup" ]; then
		S3_USE_SIGV4="True" duplicity \
			remove-all-inc-of-but-n-full "${MAX_INCREMENTAL_ITERATION}" "${@:2}" \
			--s3-use-new-style --s3-european-buckets "s3://s3-${AWS_REGION}.amazonaws.com/${AWS_BUCKET}/${FOLDER}/redis/"
	elif [ "$1" == "backup" ]; then
		mkdir -p /tmp/redis
		cp /data/redis/appendonly.aof /tmp/redis \
		 && S3_USE_SIGV4="True" duplicity \
		 	incr --allow-source-mismatch --full-if-older-than 1W /tmp/redis/ \
		 	--s3-use-new-style --s3-european-buckets "s3://s3-${AWS_REGION}.amazonaws.com/${AWS_BUCKET}/${FOLDER}/redis/"
	elif [ "$1" == "restore" ]; then
		S3_USE_SIGV4="True" duplicity \
			restore "${@:2}" \
			--s3-use-new-style --s3-european-buckets "s3://s3-${AWS_REGION}.amazonaws.com/${AWS_BUCKET}/${FOLDER}/redis/" /restore/redis
	else
		echo "Usage: backuper redis <action>"
	fi
}

mariadb() {
	file_env 'PASSPHRASE'
	file_env 'AWS_ACCESS_KEY_ID'
	file_env 'AWS_SECRET_ACCESS_KEY'

	if [ "$1" == "cleanup" ]; then
		S3_USE_SIGV4="True" duplicity \
		remove-all-inc-of-but-n-full "${MAX_INCREMENTAL_ITERATION}" "${@:2}" \
		--s3-use-new-style --s3-european-buckets "s3://s3-${AWS_REGION}.amazonaws.com/${AWS_BUCKET}/${FOLDER}/mariadb/"
	elif [ "$1" == "backup" ]; then
		file_env 'MYSQL_PASSWORD'

		rm -f /tmp/mariadb/* || true
		mkdir -p /tmp/mariadb
		mysqldump --single-transaction --quick -h ${MYSQL_HOST} -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} > /tmp/mariadb/dump.sql \
		 && S3_USE_SIGV4="True" duplicity \
		 	incr --allow-source-mismatch --full-if-older-than 1W /tmp/mariadb/ \
		 	--s3-use-new-style --s3-european-buckets "s3://s3-${AWS_REGION}.amazonaws.com/${AWS_BUCKET}/${FOLDER}/mariadb/"
	elif [ "$1" == "restore" ]; then
		S3_USE_SIGV4="True" duplicity \
			restore "${@:2}" --force \
			--s3-use-new-style --s3-european-buckets "s3://s3-${AWS_REGION}.amazonaws.com/${AWS_BUCKET}/${FOLDER}/mariadb/" /restore/mariadb
	else
		echo "Usage: backuper mariadb <action>"
	fi
}

if [ "$1" == "redis" ]; then
	redis "${@:2}"
elif [ "$1" == "mariadb" ]; then
	mariadb "${@:2}"
else
	echo "Database $1 not supported, should be either redis or mariadb"
fi