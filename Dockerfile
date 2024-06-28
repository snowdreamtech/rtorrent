FROM snowdreamtech/alpine:3.20.0

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

ENV RTORRENT_HOST=localhost \
    RTORRENT_PORT=50000 \
    RTORRENT_SOCKET="/var/lib/rtorrent/.session/rtorrent.sock" \
    RUTORRENT_VERSION=4.3.5 \
    PYTHONPATH="/root/.venv/lib/python3.12/site-packages"

RUN apk add --no-cache rtorrent \
    screen \
    nginx \
    curl \ 
    sox \ 
    ffmpeg \
    mediainfo \ 
    python3 \ 
    py3-pip \ 
    py3-setuptools \ 
    php82 \
    php82-fpm \
    php82-cgi \
    php82-common \ 
    php82-gd \ 
    php82-dom \
    php82-xml \ 
    php82-mbstring \
    php82-session \
    && pip3 install --upgrade --break-system-packages pip \
    && pip3 install --break-system-packages cfscrape cloudscraper \
    && mkdir -p /var/lib/rtorrent/  \
    && adduser -h /var/lib/rtorrent/ -s /sbin/nologin -g rtorrent -D rtorrent >/dev/null 2>&1 \
    && mkdir -p /var/lib/rtorrent/config/  \
    && mkdir -p /var/lib/rtorrent/.session/  \
    && mkdir -p /var/lib/rtorrent/download/  \
    && mkdir -p /var/lib/rtorrent/watch/  \
    && mkdir -p /var/lib/rtorrent/log/  \
    && chown -R  rtorrent:rtorrent /var/lib/rtorrent \
    && wget https://github.com/Novik/ruTorrent/archive/refs/tags/v${RUTORRENT_VERSION}.tar.gz \ 
    && tar zxvf v${RUTORRENT_VERSION}.tar.gz  \ 
    && mv ruTorrent-${RUTORRENT_VERSION} /var/lib/nginx/html/rutorrent  \ 
    && rm -rfv v${RUTORRENT_VERSION}.tar.gz  \
    && chown -Rfv nginx:nginx /var/lib/nginx/html

COPY http.d /etc/nginx/http.d

COPY config /var/lib/rtorrent/config

EXPOSE 80 443 50000/tcp 50000/udp

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]