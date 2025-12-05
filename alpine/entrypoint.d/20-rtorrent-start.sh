#!/bin/sh
set -e

if [ "$DEBUG" = "true" ]; then echo "→ [rtorrent] Starting rtorrent..."; fi

# set RPC_PORT
if [ -n "${RPC_PORT}" ]; then
    sed -i "s/network\.port_range\.set.*/network\.port_range\.set = ""${RPC_PORT}""-""${RPC_PORT}""/g" /var/lib/rtorrent/config/rtorrent.rc
fi

# rtorrent
/usr/bin/rtorrent -n -o import=/var/lib/rtorrent/config/rtorrent.rc

if [ "$DEBUG" = "true" ]; then echo "→ [rtorrent] Rtorrent started."; fi