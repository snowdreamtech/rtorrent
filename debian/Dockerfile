FROM snowdreamtech/build-essential:bookworm AS builder

ARG TARGETPLATFORM
ENV UNRAR_VERSION=7.0.9

RUN wget https://www.rarlab.com/rar/unrarsrc-${UNRAR_VERSION}.tar.gz \ 
    && tar zxvf unrarsrc-${UNRAR_VERSION}.tar.gz \ 
    && cd unrar \ 
    && sed -i "s|CXX=c++|CXX?=c++|g" ./makefile \
    && sed -i "s|CXXFLAGS=.*|CXXFLAGS=-march=native\nCXXFLAGS?=-O2\nCXXFLAGS+=-std=c++11 -Wno-logical-op-parentheses -Wno-switch -Wno-dangling-else|g" ./makefile \
    && if [[ "${TARGETPLATFORM}" == "linux/ppc64le" ]] ; then sed -i "s|-march=native|-mcpu=native -mtune=native -m64|g" ./makefile ; fi \ 
    && sed -i "s|LDFLAGS=-pthread|LDFLAGS+=-pthread|g" ./makefile \
    && make \
    && chmod 755 unrar 


FROM snowdreamtech/php:8.2.26-fpm-bookworm

# OCI annotations to image
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Rtorrent Image Based On Debian" \
    org.opencontainers.image.description="Docker Images for Rtorrent on Debian. (i386,amd64,arm32v5,arm32v7,arm64,mips64le,ppc64le,s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/rtorrent" \
    org.opencontainers.image.base.name="snowdreamtech/rtorrent:debian" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/rtorrent" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="12.8" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/rtorrent"

# Switch to the user
USER root

# Set the workdir
WORKDIR /root

# keep the docker container running
ENV KEEPALIVE=1 \
    # The cap_net_bind_service capability in Linux allows a process to bind a socket to Internet domain privileged ports, 
    # which are port numbers less than 1024. 
    CAP_NET_BIND_SERVICE=0

ENV RTORRENT_VERSION=0.9.8-1 \
    RPC_HOST=localhost \
    RPC_PORT=50000 \
    RPC_SOCKET="/var/lib/rtorrent/.session/rtorrent.sock" 

ENV RUTORRENT_VERSION=5.1.5

ARG GID=1000 \
    UID=1000  \
    USER=rtorrent \
    WORKDIR=/var/lib/rtorrent

# Create a user with UID and GID
RUN set -eux \
    && if [ "${USER}" != "root" ]; then \
    addgroup --gid ${GID} ${USER}; \
    adduser --home ${WORKDIR} --uid ${UID} --gid ${GID} --gecos ${USER} --shell /bin/bash --disabled-password ${USER}; \
    # sed -i "/%sudo/c ${USER} ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers; \
    fi \
    && apt-get -qqy --purge autoremove \
    && apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/* 

# Enable CAP_NET_BIND_SERVICE
RUN set -eux \
    && if [ "${USER}" != "root" ] && [ "${CAP_NET_BIND_SERVICE}" -eq 1 ]; then \
    apt-get -qqy update; \
    apt-get -qqy install --no-install-recommends libcap2-bin; \
    # setcap 'cap_net_bind_service=+ep' `which nginx`; \
    fi \
    && apt-get -qqy --purge autoremove \
    && apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/* 

RUN set -eux \
    && apt-get -qqy update  \
    && apt-get -qqy install --no-install-recommends \ 
    rtorrent=${RTORRENT_VERSION} \
    screen \
    && mkdir -p /var/lib/rtorrent/  \
    && mkdir -p /var/lib/rtorrent/config/  \
    && mkdir -p /var/lib/rtorrent/.session/  \
    && mkdir -p /var/lib/rtorrent/download/  \
    && mkdir -p /var/lib/rtorrent/watch/  \
    && mkdir -p /var/lib/rtorrent/log/  \
    # Chown the files to USER
    && chown -R  ${USER}:${USER} /var/lib/rtorrent \
    && find / -name "*rtorrent*" -exec chown -Rv ${USER}:${USER} {} \; \
    && apt-get -qqy --purge autoremove \
    && apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

# Copy the config files
COPY --chown=${USER}:${USER} config /var/lib/rtorrent/config

# Install Python3
RUN set -eux \
    && apt-get -qqy update  \
    && apt-get -qqy install --no-install-recommends \ 
    sox \ 
    ffmpeg \
    mediainfo \ 
    unzip \
    python3 \ 
    python3-pip \ 
    python3-setuptools \ 
    && pip3 install --upgrade --break-system-packages pip \
    && pip3 install --break-system-packages cfscrape cloudscraper \
    && apt-get -qqy --purge autoremove \
    && apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

# Install ruTorrent
RUN wget https://github.com/Novik/ruTorrent/archive/refs/tags/v${RUTORRENT_VERSION}.tar.gz \ 
    && tar zxvf v${RUTORRENT_VERSION}.tar.gz  \ 
    && mv ruTorrent-${RUTORRENT_VERSION} /usr/share/nginx/html/rutorrent  \ 
    && rm -rfv v${RUTORRENT_VERSION}.tar.gz  \
    && chown -Rfv nginx:nginx /usr/share/nginx/html

# Switch to the user
USER ${USER}

# Set the workdir
WORKDIR ${WORKDIR}

COPY --from=builder /home/build/unrar/unrar /usr/bin

EXPOSE 80 443 50000/tcp 50000/udp

COPY --chown=${USER}:${USER} docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]