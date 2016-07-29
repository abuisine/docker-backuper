FROM abuisine/fcron:2.0.0
MAINTAINER Alexandre Buisine <alexandrejabuisine@gmail.com>
LABEL version="1.2.0"

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

ADD http://ppa.launchpad.net/duplicity-team/ppa/ubuntu/pool/main/d/duplicity/duplicity_0.7.09-0ubuntu0ppa1231~ubuntu16.04.1_amd64.deb .

RUN dpkg -i duplicity_0.7.09-0ubuntu0ppa1231~ubuntu16.04.1_amd64.deb

VOLUME ["/data/redis", "/restore/redis", "/restore/mariadb"]

ENV PASSPHRASE="" AWS_REGION="" AWS_BUCKET="" AWS_ACCESS_KEY_ID="" AWS_SECRET_ACCESS_KEY=""