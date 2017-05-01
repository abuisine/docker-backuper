FROM	abuisine/fcron:4.0.0
LABEL	maintainer="Alexandre Buisine <alexandrejabuisine@gmail.com>"
LABEL	version="2.2.1"

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update \
 && apt-get install -yqq \
	python-pip \
	python-pexpect \
	python-lockfile \
	librsync1 \
	mariadb-client \
 && apt-get -yqq clean \
 && rm -rf /var/lib/apt/lists/*

COPY resources/*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh && pip install boto

ENV DUPLICITY_VERSION="0.7.12" DUPLICITY_PPA_VERSION="0ubuntu0ppa1276"

ADD http://ppa.launchpad.net/duplicity-team/ppa/ubuntu/pool/main/d/duplicity/duplicity_${DUPLICITY_VERSION}-${DUPLICITY_PPA_VERSION}~ubuntu16.04.1_amd64.deb .

RUN dpkg -i duplicity_${DUPLICITY_VERSION}-${DUPLICITY_PPA_VERSION}~ubuntu16.04.1_amd64.deb

VOLUME ["/data/redis", "/restore/redis", "/restore/mariadb"]

ENV AWS_REGION="" AWS_BUCKET=""
#ENV AWS_ACCESS_KEY_ID_FILE="" AWS_SECRET_ACCESS_KEY_FILE="" DUPLICITY_PASSPHRASE_FILE="" MYSQL_PASSWORD_FILE=""
#ENV AWS_ACCESS_KEY_ID="" AWS_SECRET_ACCESS_KEY="" DUPLICITY_PASSPHRASE="" MYSQL_PASSWORD=""