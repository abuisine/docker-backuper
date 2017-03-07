#!/bin/bash

mkdir /tmp/redis
cp /data/redis/appendonly.aof /tmp/redis \
	&& PASSPHRASE=$(< "${DUPLICITY_PASSPHRASE_FILE}") \
	AWS_ACCESS_KEY_ID=$(< "${AWS_ACCESS_KEY_ID_FILE}") \
	AWS_SECRET_ACCESS_KEY=$(< "${AWS_SECRET_ACCESS_KEY_FILE}") \
	S3_USE_SIGV4="True" \
	duplicity --allow-source-mismatch --full-if-older-than 1W /tmp/redis/ --s3-use-new-style --s3-european-buckets "s3://s3-$AWS_REGION.amazonaws.com/$AWS_BUCKET/redis/"