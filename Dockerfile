FROM snowdreamtech/alpine:3.20.0

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

ENV RTORRENT_HOST=localhost \
    RTORRENT_PORT=50000 \
    RTORRENT_SOCKET="/var/lib/rtorrent/.session/rtorrent.sock" 

RUN apk add --no-cache rtorrent=0.9.8-r2 \
    screen \
    && mkdir -p /var/lib/rtorrent/  \
    && adduser -h /var/lib/rtorrent/ -s /sbin/nologin -g rtorrent -D rtorrent >/dev/null 2>&1 \
    && mkdir -p /var/lib/rtorrent/config/  \
    && mkdir -p /var/lib/rtorrent/.session/  \
    && mkdir -p /var/lib/rtorrent/download/  \
    && mkdir -p /var/lib/rtorrent/watch/  \
    && mkdir -p /var/lib/rtorrent/log/  \
    && chown -R  rtorrent:rtorrent /var/lib/rtorrent 

COPY config /var/lib/rtorrent/config

EXPOSE 50000/tcp 50000/udp

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]