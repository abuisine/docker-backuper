FROM	abuisine/fcron:4.1.1-debian9
LABEL	maintainer="Alexandre Buisine <alexandrejabuisine@gmail.com>"
LABEL	version="3.0.1"

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update \
 && apt-get install --no-install-recommends -yqq \
 	python-boto \
	mariadb-client \
	duplicity \
	gpg \
 && apt-get -yqq clean \
 && rm -rf /var/lib/apt/lists/*

COPY resources/backuper.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/backuper.sh

VOLUME ["/data/redis", "/restore/redis", "/restore/mariadb"]

ENV AWS_REGION= AWS_BUCKET= FOLDER=default MAX_INCREMENTAL_ITERATION=25
#ENV AWS_ACCESS_KEY_ID_FILE="" AWS_SECRET_ACCESS_KEY_FILE="" DUPLICITY_PASSPHRASE_FILE="" MYSQL_PASSWORD_FILE=""
#ENV AWS_ACCESS_KEY_ID="" AWS_SECRET_ACCESS_KEY="" DUPLICITY_PASSPHRASE="" MYSQL_PASSWORD=""