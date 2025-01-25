FROM snowdreamtech/debian:12.8.0

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

# keep the docker container running
ENV KEEPALIVE=1 \
    # The cap_net_bind_service capability in Linux allows a process to bind a socket to Internet domain privileged ports, 
    # which are port numbers less than 1024. 
    CAP_NET_BIND_SERVICE=0

ENV RTORRENT_VERSION=0.9.8-1 \
    RPC_HOST=localhost \
    RPC_PORT=50000 \
    RPC_SOCKET="/var/lib/rtorrent/.session/rtorrent.sock" 

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

# Switch to the user
USER ${USER}

# Set the workdir
WORKDIR ${WORKDIR}

EXPOSE 50000/tcp 50000/udp

COPY --chown=${USER}:${USER} docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]