#!/bin/sh
set -e

# set RTORRENT_PORT
if [ -n "${RTORRENT_PORT}" ]; then
    sed -i "s/network\.port_range\.set.*/network\.port_range\.set = ""${RTORRENT_PORT}""-""${RTORRENT_PORT}""/g" /var/lib/rtorrent/config/rtorrent.rc
fi

# rtorrent
# /usr/bin/screen -d -m -fa -S rtorrent /usr/bin/rtorrent -n -o import=/var/lib/rtorrent/config/rtorrent.rc
# /usr/bin/screen -r rtorrent
/usr/bin/rtorrent -n -o import=/var/lib/rtorrent/config/rtorrent.rc

# exec commands
exec "$@"