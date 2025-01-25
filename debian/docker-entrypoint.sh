#!/bin/sh
set -e

# set RPC_PORT
if [ -n "${RPC_PORT}" ]; then
    sed -i "s/network\.port_range\.set.*/network\.port_range\.set = ""${RPC_PORT}""-""${RPC_PORT}""/g" /var/lib/rtorrent/config/rtorrent.rc
fi

# rtorrent
/usr/bin/rtorrent -n -o import=/var/lib/rtorrent/config/rtorrent.rc

# start nginx
/usr/sbin/nginx -c /etc/nginx/nginx.conf

#fpm
/usr/bin/php-fpm --fpm-config /etc/php/8.2/fpm/php-fpm.conf

# exec commands
if [ -n "$*" ]; then
    sh -c "$*"
fi

# keep the docker container running
# https://github.com/docker/compose/issues/1926#issuecomment-422351028
if [ "${KEEPALIVE}" -eq 1 ]; then
    trap : TERM INT
    tail -f /dev/null & wait
    # sleep infinity & wait
fi