FROM snowdreamtech/alpine:3.21.3

# OCI annotations to image
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Rtorrent Image Based On Alpine" \
    org.opencontainers.image.description="Docker Images for Rtorrent on Alpine. (i386, amd64, arm32v6, arm32v7, arm64, ppc64le,riscv64, s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/rtorrent" \
    org.opencontainers.image.base.name="snowdreamtech/rtorrent:alpine" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/rtorrent" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="3.21.0" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/rtorrent"

# keep the docker container running
ENV KEEPALIVE=1 \
    # The cap_net_bind_service capability in Linux allows a process to bind a socket to Internet domain privileged ports, 
    # which are port numbers less than 1024. 
    CAP_NET_BIND_SERVICE=0

ENV RTORRENT_VERSION=0.10.0-r0 \
    RPC_HOST=localhost \
    RPC_PORT=50000 \
    RPC_SOCKET="/var/lib/rtorrent/.session/rtorrent.sock" 

ARG GID=1000 \
    UID=1000  \
    USER=rtorrent \
    WORKDIR=/var/lib/rtorrent

# Create a user with UID and GID
RUN if [ "${USER}" != "root" ]; then \
    addgroup -g ${GID} ${USER}; \
    adduser -h ${WORKDIR} -u ${UID} -g ${USER} -G ${USER} -s /bin/sh -D ${USER}; \
    # sed -i "/%sudo/c ${USER} ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers; \
    fi

# Enable CAP_NET_BIND_SERVICE
RUN if [ "${USER}" != "root" ] && [ "${CAP_NET_BIND_SERVICE}" -eq 1 ]; then \
    apk add --no-cache libcap; \
    # setcap 'cap_net_bind_service=+ep' `which nginx`; \
    fi

# Install rtorrent
RUN apk add --no-cache \
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
    && find / -name "*rtorrent*" -exec chown -Rv ${USER}:${USER} {} \; 

# Copy the config files
COPY --chown=${USER}:${USER} config /var/lib/rtorrent/config

# Switch to the user
USER ${USER}

# Set the workdir
WORKDIR ${WORKDIR}

EXPOSE 50000/tcp 50000/udp

COPY --chown=${USER}:${USER} docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]