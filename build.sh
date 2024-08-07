#!/bin/sh

DOCKER_HUB_PROJECT=snowdreamtech/rtorrent

GITHUB_PROJECT=ghcr.io/snowdreamtech/rtorrent

docker buildx build --platform=linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/ppc64le,linux/s390x \
    -t ${DOCKER_HUB_PROJECT}:latest \
    -t ${DOCKER_HUB_PROJECT}:0.9.8 \
    -t ${DOCKER_HUB_PROJECT}:0.9 \
    -t ${DOCKER_HUB_PROJECT}:0 \
    -t ${GITHUB_PROJECT}:latest \
    -t ${GITHUB_PROJECT}:0.9.8 \
    -t ${GITHUB_PROJECT}:0.9 \
    -t ${GITHUB_PROJECT}:0 \
    . \
    --push
