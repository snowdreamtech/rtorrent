# rTorrent

[![CI Pipeline](https://img.shields.io/github/actions/workflow/status/snowdreamtech/rtorrent/ci.yml?branch=main&label=CI%20Pipeline)](https://github.com/snowdreamtech/rtorrent/actions/workflows/ci.yml)
[![CD Pipeline](https://img.shields.io/github/actions/workflow/status/snowdreamtech/rtorrent/cd.yml?branch=main&label=CD%20Pipeline)](https://github.com/snowdreamtech/rtorrent/actions/workflows/cd.yml)
[![CodeQL](https://img.shields.io/github/actions/workflow/status/snowdreamtech/rtorrent/codeql.yml?branch=main&label=CodeQL&logo=github)](https://github.com/snowdreamtech/rtorrent/actions/workflows/codeql.yml)
[![Security Audit](https://img.shields.io/badge/Security-Zizmor%20%7C%20Trivy%20%7C%20Gitleaks-brightgreen)](https://github.com/snowdreamtech/rtorrent/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/license/MIT)
![Docker Image Version](https://img.shields.io/docker/v/snowdreamtech/rtorrent)
![Docker Image Size](https://img.shields.io/docker/image-size/snowdreamtech/rtorrent/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/snowdreamtech/rtorrent)
![Docker Stars](https://img.shields.io/docker/stars/snowdreamtech/rtorrent)

[English](README.md) | [简体中文](README_zh-CN.md)

Docker image for rTorrent providing standardized container foundations with flexible entrypoint systems, multi-architecture support, and consistent configuration patterns across Alpine, Debian, and Rocky Linux distributions, with optional ruTorrent and Flood web user interfaces.

## Overview

The rTorrent container provides:

- **Standardized Dockerfiles** with OCI annotations and best practices
- **Flexible entrypoint system** supporting custom initialization scripts
- **Consistent environment variable configuration** across all variants
- **Multi-architecture support** for diverse hardware platforms
- **User/group management** with PUID/PGID support for permission handling
- **Three distribution variants**: Alpine (lightweight), Debian (default/widely-compatible), Rocky (enterprise)
- **Three flavors**:
  - `rtorrent`: Core CLI BitTorrent client daemon with SCGI/RPC support
  - `rutorrent`: Web UI powered by ruTorrent (Nginx + PHP-FPM)
  - `flood`: Modern Web UI powered by Flood (Node.js)

## Quick Start

```bash
# Pull and run the default Debian variant
docker pull snowdreamtech/rtorrent:debian
docker run -d \
  --name=rtorrent \
  -e TZ=Asia/Shanghai \
  -p 50000:50000 \
  -v ./downloads:/var/lib/rtorrent/download \
  -v ./session:/var/lib/rtorrent/.session \
  --restart unless-stopped \
  snowdreamtech/rtorrent:debian

# Or use docker compose
docker compose up -d
```

## Usage

### Docker CLI

#### 1. Core CLI Daemon (`rtorrent`)

```bash
docker run -d \
  --name=rtorrent \
  -e TZ=Asia/Shanghai \
  -p 50000:50000 \
  -v ./downloads:/var/lib/rtorrent/download \
  -v ./session:/var/lib/rtorrent/.session \
  -v ./watch:/var/lib/rtorrent/watch \
  --restart unless-stopped \
  snowdreamtech/rtorrent:latest
# snowdreamtech/rtorrent:alpine
# snowdreamtech/rtorrent:debian
```

#### 2. ruTorrent Web UI Flavor (`rutorrent`)

```bash
docker run -d \
  --name=rutorrent \
  -e TZ=Asia/Shanghai \
  -p 80:80 \
  -p 443:443 \
  -p 50000:50000 \
  -v ./downloads:/var/lib/rtorrent/download \
  -v ./session:/var/lib/rtorrent/.session \
  --restart unless-stopped \
  snowdreamtech/rtorrent:latest-rutorrent
```

Access Web UI at `http://localhost:80`.

#### 3. Flood Web UI Flavor (`flood`)

```bash
docker run -d \
  --name=flood \
  -e TZ=Asia/Shanghai \
  -p 3000:3000 \
  -p 50000:50000 \
  -v ./downloads:/var/lib/rtorrent/download \
  -v ./session:/var/lib/rtorrent/.session \
  --restart unless-stopped \
  snowdreamtech/rtorrent:latest-flood
```

Access Web UI at `http://localhost:3000`.

### Docker Compose

```yaml
services:
  rtorrent:
    image: snowdreamtech/rtorrent:latest
    container_name: rtorrent
    environment:
      - TZ=Asia/Shanghai
      - PUID=1000
      - PGID=1000
    ports:
      - "50000:50000"
    volumes:
      - ./downloads:/var/lib/rtorrent/download
      - ./session:/var/lib/rtorrent/.session
      - ./watch:/var/lib/rtorrent/watch
    restart: unless-stopped
```

## Distribution Variants

### Debian (Default)

The recommended variant for most use cases, providing wide compatibility and extensive package availability.

```bash
docker run -d \
  --name=rtorrent \
  -e TZ=Asia/Shanghai \
  -p 50000:50000 \
  -v ./downloads:/var/lib/rtorrent/download \
  --restart unless-stopped \
  snowdreamtech/rtorrent:debian
```

**Supported Architectures**: amd64, arm/v7, arm64, ppc64le, riscv64, s390x

**Base Image**: `ghcr.io/snowdreamtech/debian:13.6.0`

### Alpine

Lightweight variant optimized for minimal image size and fast startup times.

```bash
docker run -d \
  --name=rtorrent \
  -e TZ=Asia/Shanghai \
  -p 50000:50000 \
  -v ./downloads:/var/lib/rtorrent/download \
  --restart unless-stopped \
  snowdreamtech/rtorrent:alpine
```

**Supported Architectures**: 386, amd64, arm/v7, arm64

**Base Image**: `ghcr.io/snowdreamtech/alpine:3.24.1`

### Rocky

Enterprise-focused variant based on Rocky Linux, ideal for production environments requiring RHEL compatibility.

**Supported Architectures**: amd64, arm64, ppc64le, s390x

**Base Image**: `ghcr.io/snowdreamtech/rocky:10.2.0`

## Build Instructions

### Single Architecture Build

```bash
# Build Debian variant (rtorrent flavor)
docker build -f ./docker/debian/Dockerfile.rtorrent -t snowdreamtech/rtorrent:debian ./docker/debian/

# Build Alpine variant (rtorrent flavor)
docker build -f ./docker/alpine/Dockerfile.rtorrent -t snowdreamtech/rtorrent:alpine ./docker/alpine/

# Build ruTorrent flavor
docker build -f ./docker/debian/Dockerfile.rutorrent -t snowdreamtech/rtorrent:latest-rutorrent ./docker/debian/

# Build Flood flavor
docker build -f ./docker/debian/Dockerfile.flood -t snowdreamtech/rtorrent:latest-flood ./docker/debian/
```

### Multi-Architecture Build

Build images for multiple architectures using `docker buildx`:

```bash
# Create and use a buildx builder
docker buildx create --use --name build --node build --driver-opt network=host

# Build Debian for multiple architectures
docker buildx build \
  --platform=linux/amd64,linux/arm/v7,linux/arm64,linux/riscv64,linux/ppc64le,linux/s390x \
  -f ./docker/debian/Dockerfile.rtorrent \
  -t snowdreamtech/rtorrent:debian \
  ./docker/debian/ \
  --push

# Build Alpine for multiple architectures
docker buildx build \
  --platform=linux/386,linux/amd64,linux/arm/v7,linux/arm64 \
  -f ./docker/alpine/Dockerfile.rtorrent \
  -t snowdreamtech/rtorrent:alpine \
  ./docker/alpine/ \
  --push
```

## Environment Variables

All variants support the following environment variables for runtime configuration:

| Variable | Default | Description |
|----------|---------|-------------|
| `KEEPALIVE` | `1` | Keep container running (1=enabled, 0=disabled) |
| `CAP_NET_BIND_SERVICE` | `0` | Enable binding to privileged ports (<1024) |
| `LANG` | `C.UTF-8` | Locale setting for UTF-8 character support |
| `UMASK` | `022` | Default file creation mask |
| `DEBUG` | `false` | Enable debug output in entrypoint scripts |
| `PGID` | `0` | Primary group ID for custom user creation |
| `PUID` | `0` | User ID for custom user creation |
| `USER` | `root` | Username for custom user creation |
| `WORKDIR` | `/root` | Working directory path |
| `TZ` | - | Timezone (e.g., `Asia/Shanghai`, `America/New_York`) |
| `RPC_HOST` | `localhost` | SCGI RPC host |
| `RPC_PORT` | `50000` | SCGI RPC port |
| `RPC_SOCKET` | `/var/lib/rtorrent/.session/rtorrent.sock` | SCGI RPC unix socket path |
| `FLOOD_AUTH` | `none` | Flood authentication mode (`none` or `default`) |
| `FLOOD_PORT` | `3000` | Flood Web UI port |

**Debian-specific**:

| Variable | Default | Description |
|----------|---------|-------------|
| `DEBIAN_FRONTEND` | `noninteractive` | Debian package installation mode |

## Architecture Support

Each distribution variant supports multiple CPU architectures for deployment across diverse hardware platforms:

| Variant | Architectures |
|---------|---------------|
| **Debian** | amd64, arm/v7, arm64, ppc64le, riscv64, s390x |
| **Alpine** | 386, amd64, arm/v7, arm64 |
| **Rocky** | amd64, arm64, ppc64le, s390x |

Docker automatically selects the appropriate architecture for your platform when pulling images.

## Entrypoint System

The image includes a flexible entrypoint system that executes custom initialization scripts before starting your application.

### How It Works

1. The `docker-entrypoint.sh` script runs at container startup
2. It executes all executable scripts in `/usr/local/bin/entrypoint.d/` in lexical order
3. Each script receives the container's command-line arguments
4. If any script fails, the container stops (fail-fast behavior)

### Debug Mode

Enable debug output to troubleshoot entrypoint execution:

```bash
docker run -e DEBUG=true snowdreamtech/rtorrent:debian
```

## Development

### Prerequisites

- Docker (>= 20.10) with Docker Buildx plugin
- [UniRTM](https://github.com/snowdreamtech/UniRTM) for workspace quality guard and toolchain management

### Quality & Verification

```bash
# Setup toolchain and verify environment
unirtm run setup

# Run comprehensive workspace quality check (formatters, linters, security)
unirtm run verify

# Run security audits (Zizmor, Gitleaks, OSV-Scanner, Trivy)
unirtm run audit

# Automatically fix linting and formatting issues where supported
unirtm run fix
```

## Reference

1. [rTorrent Official Repository](https://github.com/rakshasa/rtorrent)
2. [ruTorrent Official Repository](https://github.com/Novik/ruTorrent)
3. [Flood - Modern Web UI for Torrent Clients](https://github.com/jesec/flood)

## Contact (备注：rtorrent)

- Email: <sn0wdr1am@qq.com>
- QQ: 3217680847
- QQ群: 949022145
- WeChat/微信群: sn0wdr1am

## License

MIT
