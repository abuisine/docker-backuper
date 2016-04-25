FROM abuisine/fcron:2.0.0
MAINTAINER Alexandre Buisine <alexandrejabuisine@gmail.com>
LABEL version="1.0.0"

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update \
 && apt-get install -yqq \
	python-pip \
	duplicity \
 && apt-get -yqq clean \
 && rm -rf /var/lib/apt/lists/*

COPY resources/*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh && pip install boto

VOLUME ["/data/redis", "/data/mariadb", "/restore/redis", "/restore/mariadb"]

ENV MARIADB_PASSPHRASE="" REDIS_PASSPHRASE="" AWS_REGION="" AWS_BUCKET="" AWS_ACCESS_KEY_ID="" AWS_SECRET_ACCESS_KEY=""