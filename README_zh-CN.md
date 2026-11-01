# rTorrent

[![CI 流水线](https://img.shields.io/github/actions/workflow/status/snowdreamtech/rtorrent/ci.yml?branch=main&label=CI%20Pipeline)](https://github.com/snowdreamtech/rtorrent/actions/workflows/ci.yml)
[![CD 流水线](https://img.shields.io/github/actions/workflow/status/snowdreamtech/rtorrent/cd.yml?branch=main&label=CD%20Pipeline)](https://github.com/snowdreamtech/rtorrent/actions/workflows/cd.yml)
[![CodeQL](https://img.shields.io/github/actions/workflow/status/snowdreamtech/rtorrent/codeql.yml?branch=main&label=CodeQL&logo=github)](https://github.com/snowdreamtech/rtorrent/actions/workflows/codeql.yml)
[![安全审计](https://img.shields.io/badge/Security-Zizmor%20%7C%20Trivy%20%7C%20Gitleaks-brightgreen)](https://github.com/snowdreamtech/rtorrent/actions/workflows/ci.yml)
[![许可证: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/license/MIT)
![Docker 镜像版本](https://img.shields.io/docker/v/snowdreamtech/rtorrent)
![Docker 镜像大小](https://img.shields.io/docker/image-size/snowdreamtech/rtorrent/latest)
![Docker 拉取量](https://img.shields.io/docker/pulls/snowdreamtech/rtorrent)
![Docker 收藏量](https://img.shields.io/docker/stars/snowdreamtech/rtorrent)

[English](README.md) | [简体中文](README_zh-CN.md)

rTorrent 的 Docker 镜像，在 Alpine、Debian 和 Rocky Linux 发行版上提供标准化的容器基础，包含灵活的入口点系统、多架构支持和一致的配置模式，并提供可选的 ruTorrent 与 Flood Web 用户界面。

## 概述

rTorrent 容器提供：

- **标准化的 Dockerfile**，包含 OCI 注释和最佳实践
- **灵活的入口点系统**，支持自定义初始化脚本
- **一致的环境变量配置**，适用于所有变体
- **多架构支持**，适用于多样化的硬件平台
- **用户/组管理**，支持 PUID/PGID 进行权限处理
- **三种发行版变体**：Alpine（轻量级）、Debian（默认/广泛兼容）、Rocky（企业级）
- **三种风味版本**：
  - `rtorrent`：核心 CLI BitTorrent 客户端守护进程，支持 SCGI/RPC
  - `rutorrent`：基于 ruTorrent（Nginx + PHP-FPM）的经典 Web 界面
  - `flood`：基于 Flood（Node.js）的现代 Web 界面

## 快速开始

```bash
# 拉取并运行默认的 Debian 变体
docker pull snowdreamtech/rtorrent:debian
docker run -d \
  --name=rtorrent \
  -e TZ=Asia/Shanghai \
  -p 50000:50000 \
  -v ./downloads:/var/lib/rtorrent/download \
  -v ./session:/var/lib/rtorrent/.session \
  --restart unless-stopped \
  snowdreamtech/rtorrent:debian

# 或使用 docker compose
docker compose up -d
```

## 使用说明

### Docker CLI

#### 1. 核心 CLI 守护进程 (`rtorrent`)

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

#### 2. ruTorrent Web UI 风味 (`rutorrent`)

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

Web UI 访问地址：`http://localhost:80`。

#### 3. Flood Web UI 风味 (`flood`)

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

Web UI 访问地址：`http://localhost:3000`。

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

## 发行版变体

### Debian（默认）

推荐用于大多数场景，具备广泛的兼容性和丰富的软件包生态。

```bash
docker run -d \
  --name=rtorrent \
  -e TZ=Asia/Shanghai \
  -p 50000:50000 \
  -v ./downloads:/var/lib/rtorrent/download \
  --restart unless-stopped \
  snowdreamtech/rtorrent:debian
```

**支持架构**：amd64, arm/v7, arm64, ppc64le, riscv64, s390x

**基础镜像**：`ghcr.io/snowdreamtech/debian:13.6.0`

### Alpine

针对最小镜像体积和极速启动优化的轻量变体。

```bash
docker run -d \
  --name=rtorrent \
  -e TZ=Asia/Shanghai \
  -p 50000:50000 \
  -v ./downloads:/var/lib/rtorrent/download \
  --restart unless-stopped \
  snowdreamtech/rtorrent:alpine
```

**支持架构**：386, amd64, arm/v7, arm64

**基础镜像**：`ghcr.io/snowdreamtech/alpine:3.24.1`

### Rocky

针对企业级环境基于 Rocky Linux 的变体，适合需要 RHEL 兼容性的生产环境。

**支持架构**：amd64, arm64, ppc64le, s390x

**基础镜像**：`ghcr.io/snowdreamtech/rocky:10.2.0`

## 构建说明

### 单架构构建

```bash
# 构建 Debian 变体（rtorrent 核心风味）
docker build -f ./docker/debian/Dockerfile.rtorrent -t snowdreamtech/rtorrent:debian ./docker/debian/

# 构建 Alpine 变体（rtorrent 核心风味）
docker build -f ./docker/alpine/Dockerfile.rtorrent -t snowdreamtech/rtorrent:alpine ./docker/alpine/

# 构建 ruTorrent WebUI 风味
docker build -f ./docker/debian/Dockerfile.rutorrent -t snowdreamtech/rtorrent:latest-rutorrent ./docker/debian/

# 构建 Flood WebUI 风味
docker build -f ./docker/debian/Dockerfile.flood -t snowdreamtech/rtorrent:latest-flood ./docker/debian/
```

### 多架构构建

使用 `docker buildx` 进行多架构交叉构建：

```bash
# 创建并启用 buildx 构建器
docker buildx create --use --name build --node build --driver-opt network=host

# 构建 Debian 多架构镜像
docker buildx build \
  --platform=linux/amd64,linux/arm/v7,linux/arm64,linux/riscv64,linux/ppc64le,linux/s390x \
  -f ./docker/debian/Dockerfile.rtorrent \
  -t snowdreamtech/rtorrent:debian \
  ./docker/debian/ \
  --push

# 构建 Alpine 多架构镜像
docker buildx build \
  --platform=linux/386,linux/amd64,linux/arm/v7,linux/arm64 \
  -f ./docker/alpine/Dockerfile.rtorrent \
  -t snowdreamtech/rtorrent:alpine \
  ./docker/alpine/ \
  --push
```

## 环境变量

所有变体均支持以下运行时配置环境变量：

| 变量名 | 默认值 | 描述 |
|--------|--------|------|
| `KEEPALIVE` | `1` | 保持容器持续运行（1=启用，0=禁用） |
| `CAP_NET_BIND_SERVICE` | `0` | 允许绑定特权端口（<1024） |
| `LANG` | `C.UTF-8` | 支持 UTF-8 字符集的区域设置 |
| `UMASK` | `022` | 默认文件创建掩码 |
| `DEBUG` | `false` | 启用入口点脚本的调试输出 |
| `PGID` | `0` | 自定义用户的主要组 ID |
| `PUID` | `0` | 自定义用户的用户 ID |
| `USER` | `root` | 自定义用户的用户名 |
| `WORKDIR` | `/root` | 工作目录路径 |
| `TZ` | - | 时区（例如 `Asia/Shanghai`） |
| `RPC_HOST` | `localhost` | SCGI RPC 主机地址 |
| `RPC_PORT` | `50000` | SCGI RPC 端口 |
| `RPC_SOCKET` | `/var/lib/rtorrent/.session/rtorrent.sock` | SCGI RPC Unix 套接字路径 |
| `FLOOD_AUTH` | `none` | Flood 鉴权模式（`none` 或 `default`） |
| `FLOOD_PORT` | `3000` | Flood Web UI 端口 |

**Debian 专属变量**：

| 变量名 | 默认值 | 描述 |
|--------|--------|------|
| `DEBIAN_FRONTEND` | `noninteractive` | Debian 软件包安装交互模式 |

## 架构支持

各发行版变体支持的 CPU 架构：

| 变体 | 架构支持 |
|------|----------|
| **Debian** | amd64, arm/v7, arm64, ppc64le, riscv64, s390x |
| **Alpine** | 386, amd64, arm/v7, arm64 |
| **Rocky** | amd64, arm64, ppc64le, s390x |

拉取镜像时，Docker 会自动匹配适合您宿主机的架构。

## 入口点系统

镜像包含灵活的入口点系统，在启动应用之前按顺序执行自定义初始化脚本。

### 工作原理

1. 容器启动时运行 `docker-entrypoint.sh` 脚本
2. 按字典顺序执行 `/usr/local/bin/entrypoint.d/` 中的所有可执行脚本
3. 每个脚本都会接收容器的命令行参数
4. 任何脚本执行失败都会导致容器退出（fail-fast 机制）

### 调试模式

启用调试模式以排查入口点执行问题：

```bash
docker run -e DEBUG=true snowdreamtech/rtorrent:debian
```

## 开发与规范

### 前置要求

- Docker (>= 20.10) 与 Docker Buildx 插件
- [UniRTM](https://github.com/snowdreamtech/UniRTM) 用于工作区质量守卫与工具链管理

### 质量校验与工具命令

```bash
# 初始化工具链并校验环境
unirtm run setup

# 运行完整的工作区代码质量与合规检查（格式化、Lint、安全审计）
unirtm run verify

# 运行安全专项审计（Zizmor, Gitleaks, OSV-Scanner, Trivy）
unirtm run audit

# 自动修复支持自动修正的 Lint 与格式化问题
unirtm run fix
```

## 参考文档

1. [rTorrent 官方仓库](https://github.com/rakshasa/rtorrent)
2. [ruTorrent 官方仓库](https://github.com/Novik/ruTorrent)
3. [Flood - Modern Web UI for Torrent Clients](https://github.com/jesec/flood)

## 联系方式 (备注：rtorrent)

- 邮箱: <sn0wdr1am@qq.com>
- QQ: 3217680847
- QQ群: 949022145
- 微信/微信群: sn0wdr1am

## 许可证

MIT
