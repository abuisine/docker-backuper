#!/bin/bash

mkdir /tmp/mariadb
mysqldump --single-transaction --quick -h $MYSQL_HOST -u $MYSQL_USER -p${MYSQL_PASSWORD} $MYSQL_DATABASE > /tmp/mariadb/dump.sql \
 && S3_USE_SIGV4="True" duplicity --allow-source-mismatch --full-if-older-than 1W /tmp/mariadb/ --s3-use-new-style --s3-european-buckets "s3://s3-$AWS_REGION.amazonaws.com/$AWS_BUCKET/mariadb/"