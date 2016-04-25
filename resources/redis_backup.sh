#!/bin/bash

mkdir /tmp/redis
cp /data/redis/appendonly.aof /tmp/redis \
 && S3_USE_SIGV4="True" duplicity --allow-source-mismatch --full-if-older-than 1W /tmp/redis/ --s3-use-new-style --s3-european-buckets "s3://s3-$AWS_REGION.amazonaws.com/$AWS_BUCKET/redis/"