FROM debian:stable-slim

LABEL maintainer.0="João Fonseca (@joaopaulofonseca)" \
  maintainer.1="Pedro Branco (@pedrobranco)" \
  maintainer.2="Rui Marinho (@ruimarinho)"

RUN useradd -r komodo \
  && apt-get update -y \
  && apt-get install -y curl gnupg git build-essential dnsutils pkg-config libcurl4-gnutls-dev libc6-dev libevent-dev m4 g++-multilib autoconf libtool libncurses5-dev unzip python zlib1g-dev wget bsdmainutils automake libboost-all-dev libssl-dev libprotobuf-dev protobuf-compiler libqt4-dev libqrencode-dev libdb++-dev ntp ntpdate \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN set -ex \
  && for key in \
    B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" ; \
  done;

ENV GOSU_VERSION=1.10

RUN curl -o /usr/local/bin/gosu -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
  && curl -o /usr/local/bin/gosu.asc -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu

ENV KOMODO_DATA=/home/komodo/.komodo

WORKDIR /tmp/build

ARG KOMODO_GIT_URL=https://github.com/KomodoPlatform/komodo
ARG KOMODO_BRANCH=master

RUN git clone --depth 1 -b ${KOMODO_BRANCH} ${KOMODO_GIT_URL} komodo \
  && cd komodo \
  && ./zcutil/build.sh -j$(nproc) \
  && install -s -c src/komodo-tx src/komodod src/komodo-cli -t /usr/local/bin/ \
  && cp ./zcutil/fetch-params.sh / \
  && cd - \
  && rm -rf /tmp/build/

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/home/komodo/.komodo", "/home/komodo/.zcash-params"]

EXPOSE 7770 7771

ENTRYPOINT ["/entrypoint.sh"]

CMD ["komodod"]

ADD VERSION .