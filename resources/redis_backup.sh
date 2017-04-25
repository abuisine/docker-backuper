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

file_env 'PASSPHRASE'
file_env 'AWS_ACCESS_KEY_ID'
file_env 'AWS_SECRET_ACCESS_KEY'

mkdir /tmp/redis
cp /data/redis/appendonly.aof /tmp/redis \
	&& S3_USE_SIGV4="True" \
	duplicity --allow-source-mismatch --full-if-older-than 1W /tmp/redis/ --s3-use-new-style --s3-european-buckets "s3://s3-$AWS_REGION.amazonaws.com/$AWS_BUCKET/redis/"