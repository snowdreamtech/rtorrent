#!/bin/sh

DOCKER_HUB_PROJECT=snowdreamtech/rtorrent

GITHUB_PROJECT=ghcr.io/snowdreamtech/rtorrent

docker buildx build --platform=linux/386,linux/amd64,linux/arm64,linux/ppc64le,linux/s390x \
-t ${DOCKER_HUB_PROJECT}:flood-latest \
-t ${DOCKER_HUB_PROJECT}:flood-3.20.0 \
-t ${DOCKER_HUB_PROJECT}:flood-3.20 \
-t ${DOCKER_HUB_PROJECT}:flood-3 \
-t ${GITHUB_PROJECT}:flood-latest \
-t ${GITHUB_PROJECT}:flood-3.20.0 \
-t ${GITHUB_PROJECT}:flood-3.20 \
-t ${GITHUB_PROJECT}:flood-3 \
. \
--push
