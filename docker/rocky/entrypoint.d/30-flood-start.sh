#!/bin/sh
set -e

if [ "$DEBUG" = "true" ]; then echo "→ [flood] Starting flood..."; fi

# Wait for rtorrent socket to be created if using socket auth
if [ "${FLOOD_AUTH}" != "default" ]; then
  if [ "$DEBUG" = "true" ]; then echo "→ [flood] Waiting for rtorrent socket ${RPC_SOCKET}..."; fi
  SOCKET_WAIT=0
  while [ ! -S "${RPC_SOCKET}" ] && [ "$SOCKET_WAIT" -lt 15 ]; do
    sleep 1
    SOCKET_WAIT=$((SOCKET_WAIT + 1))
  done
  if [ ! -S "${RPC_SOCKET}" ]; then
    echo "⚠️ [flood] Warning: rtorrent socket not found at ${RPC_SOCKET} after 15 seconds. Flood may fail to connect."
  fi
fi
# flood
if [ "${FLOOD_AUTH}" = "default" ]; then
  if [ "${USER}" != "root" ]; then
    su - "${USER}" -c "flood --host 0.0.0.0 --port \"${FLOOD_PORT}\" --auth default >/dev/null 2>&1 &"
  else
    flood --host 0.0.0.0 --port "${FLOOD_PORT}" --auth default >/dev/null 2>&1 &
  fi
else
  if [ "${USER}" != "root" ]; then
    su - "${USER}" -c "flood --host 0.0.0.0 --port \"${FLOOD_PORT}\" --auth none --rtsocket \"${RPC_SOCKET}\" >/dev/null 2>&1 &"
  else
    flood --host 0.0.0.0 --port "${FLOOD_PORT}" --auth none --rtsocket "${RPC_SOCKET}" >/dev/null 2>&1 &
  fi
fi

if [ "$DEBUG" = "true" ]; then echo "→ [flood] Flood started."; fi
