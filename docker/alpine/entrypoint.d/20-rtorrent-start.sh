#!/bin/sh
set -e

if [ "$DEBUG" = "true" ]; then echo "→ [rtorrent] Starting rtorrent..."; fi

# Setup directories
mkdir -p /var/lib/rtorrent/config \
  /var/lib/rtorrent/.session \
  /var/lib/rtorrent/download \
  /var/lib/rtorrent/watch \
  /var/lib/rtorrent/log

if [ ! -f /var/lib/rtorrent/config/rtorrent.rc ]; then
  cp /etc/rtorrent/rtorrent.rc /var/lib/rtorrent/config/rtorrent.rc
fi

# set RPC_PORT
if [ -n "${RPC_PORT}" ]; then
  sed -i "s/network\.port_range\.set.*/network\.port_range\.set = \"${RPC_PORT}\"-\"${RPC_PORT}\"/g" /var/lib/rtorrent/config/rtorrent.rc
fi

# allow rutorrent to access the socket
sed -i 's/chmod,770/chmod,777/g' /var/lib/rtorrent/config/rtorrent.rc

# Set ownership if running as specific user
if [ "${USER}" != "root" ]; then
  chown -R "${USER}:${USER}" /var/lib/rtorrent
fi

# Run rtorrent in daemon mode using screen
if [ "${USER}" != "root" ]; then
  su - "${USER}" -c "/usr/bin/screen -d -m -fa -S rtorrent /usr/bin/rtorrent -n -o import=/var/lib/rtorrent/config/rtorrent.rc"
else
  /usr/bin/screen -d -m -fa -S rtorrent /usr/bin/rtorrent -n -o import=/var/lib/rtorrent/config/rtorrent.rc
fi

if [ "$DEBUG" = "true" ]; then echo "→ [rtorrent] Rtorrent started."; fi
