#!/bin/sh
set -e

# set RPC_PORT
if [ -n "${RPC_PORT}" ]; then
    sed -i "s/network\.port_range\.set.*/network\.port_range\.set = ""${RPC_PORT}""-""${RPC_PORT}""/g" /var/lib/rtorrent/config/rtorrent.rc
fi

# rtorrent
# /usr/bin/rtorrent -n -o import=/var/lib/rtorrent/config/rtorrent.rc
# rtorrent
/usr/bin/screen -d -m -fa -S rtorrent /usr/bin/rtorrent -n -o import=/var/lib/rtorrent/config/rtorrent.rc

# flood
if [ "${FLOOD_AUTH}" = "default" ]; then
    flood --host 0.0.0.0 --port "${FLOOD_PORT}" --auth default
else
    flood --host 0.0.0.0 --port "${FLOOD_PORT}" --auth none --rtsocket "${RPC_SOCKET}" >/dev/null 2>&1
fi

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