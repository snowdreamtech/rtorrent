#!/bin/sh
set -e

# set RTORRENT_PORT
if [ -n "${RTORRENT_PORT}" ]; then
    sed -i "s/network\.port_range\.set.*/network\.port_range\.set = ""${RTORRENT_PORT}""-""${RTORRENT_PORT}""/g" /var/lib/rtorrent/config/rtorrent.rc
fi

# rtorrent
/usr/bin/screen -d -m -fa -S rtorrent /usr/bin/rtorrent -n -o import=/var/lib/rtorrent/config/rtorrent.rc

# flood
if [ "${FLOOD_AUTH}" == "default" ]; then
    flood --host 0.0.0.0 --port "${FLOOD_PORT}" --auth default --rtsocket "${RTORRENT_SOCKET}" >/dev/null 2>&1 
else
    flood --host 0.0.0.0 --port "${FLOOD_PORT}" --auth none --rtsocket "${RTORRENT_SOCKET}" >/dev/null 2>&1 
fi

# exec commands
exec "$@"
