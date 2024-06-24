FROM snowdreamtech/alpine:3.20.0

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

ENV RTORRENT_HOST=localhost \
    RTORRENT_PORT=50000 \
    RTORRENT_SOCKET="/var/lib/rtorrent/.session/rtorrent.sock" 

RUN apk add --no-cache rtorrent \
    screen \
    nginx \
    && mkdir -p /var/lib/rtorrent/  \
    && adduser -h /var/lib/rtorrent/ -s /sbin/nologin -g rtorrent -D rtorrent >/dev/null 2>&1 \
    && mkdir -p /var/lib/rtorrent/config/  \
    && mkdir -p /var/lib/rtorrent/.session/  \
    && mkdir -p /var/lib/rtorrent/download/  \
    && mkdir -p /var/lib/rtorrent/watch/  \
    && mkdir -p /var/lib/rtorrent/log/  \
    && chown -R  rtorrent:rtorrent /var/lib/rtorrent 

COPY http.d /etc/nginx/http.d

COPY config /var/lib/rtorrent/config

EXPOSE 80 443 50000/tcp 50000/udp

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]