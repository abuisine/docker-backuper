#!/bin/bash

export PASSPHRASE=$REDIS_PASSPHRASE

mkdir /tmp/redis
cp /data/redis/appendonly.aof /tmp/redis \
 && S3_USE_SIGV4="True" duplicity full /tmp/redis/ --s3-use-new-style --s3-european-buckets "s3://s3-$AWS_REGION.amazonaws.com/$AWS_BUCKET/redis/"