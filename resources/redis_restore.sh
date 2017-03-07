#!/bin/bash

PASSPHRASE=$(< "${DUPLICITY_PASSPHRASE_FILE}") \
AWS_ACCESS_KEY_ID=$(< "${AWS_ACCESS_KEY_ID_FILE}") \
AWS_SECRET_ACCESS_KEY=$(< "${AWS_SECRET_ACCESS_KEY_FILE}") \
S3_USE_SIGV4="True" \
duplicity restore --s3-use-new-style --s3-european-buckets "s3://s3-$AWS_REGION.amazonaws.com/$AWS_BUCKET/redis/" /restore/redis