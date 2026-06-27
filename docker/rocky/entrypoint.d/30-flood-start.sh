#!/bin/sh
set -e

if [ "$DEBUG" = "true" ]; then echo "→ [flood] Starting flood..."; fi

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
