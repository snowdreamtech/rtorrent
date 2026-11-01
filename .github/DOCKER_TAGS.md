# Docker Image Tags Reference

This document describes the Docker image tagging strategy for the rtorrent project.

## Tag Naming Convention

All images use the format: `snowdreamtech/rtorrent:TAG`

Where `TAG` follows these patterns:

- **Variant-specific tags**: `TAG-variant` (e.g., `nightly-alpine`, `0.16.12-alpine`)
- **Default tags** (Debian only): `TAG` (e.g., `nightly`, `latest`, `0.9.8`)
- **Flavor tags**:
  - `rtorrent`: Core daemon (CLI)
  - `rutorrent`: Web UI powered by ruTorrent (e.g., `latest-rutorrent`, `latest-rutorrent-alpine`, `0.16.12-rutorrent-alpine`)
  - `flood`: Web UI powered by Flood (e.g., `latest-flood`, `latest-flood-alpine`, `0.16.12-flood-alpine`)

## Supported Registries

All tags are pushed to two registries:

- **GitHub Container Registry**: `ghcr.io/snowdreamtech/rtorrent:TAG`
- **DockerHub**: `snowdreamtech/rtorrent:TAG`

## Tag Scenarios

### 1. Branch Builds (dev/main)

#### Push to `dev` branch

```bash
git push origin dev
```

**Generated tags:**

```
snowdreamtech/rtorrent:dev-alpine
snowdreamtech/rtorrent:dev-debian
snowdreamtech/rtorrent:dev              # ← Debian (default)
```

#### Push to `main` branch

```bash
git push origin main
```

**Generated tags:**

```
snowdreamtech/rtorrent:main-alpine
snowdreamtech/rtorrent:latest-alpine
snowdreamtech/rtorrent:main-debian
snowdreamtech/rtorrent:latest-debian
snowdreamtech/rtorrent:main             # ← Debian (default)
snowdreamtech/rtorrent:latest           # ← Debian (default)
```

---

### 2. Release Tags (Semantic Versioning)

#### Alpine Release

```bash
git tag alpine-v0.16.12
git push origin alpine-v0.16.12
```

**Generated tags:**

```
snowdreamtech/rtorrent:0.16.12-alpine
snowdreamtech/rtorrent:latest-alpine
snowdreamtech/rtorrent:0.16.12-rutorrent-alpine
snowdreamtech/rtorrent:latest-rutorrent-alpine
snowdreamtech/rtorrent:0.16.12-flood-alpine
snowdreamtech/rtorrent:latest-flood-alpine
```

#### Debian Release

```bash
git tag debian-v0.9.8
git push origin debian-v0.9.8
```

**Generated tags:**

```
snowdreamtech/rtorrent:0.9.8-debian
snowdreamtech/rtorrent:latest-debian
snowdreamtech/rtorrent:0.9.8           # ← Debian (default)
snowdreamtech/rtorrent:latest          # ← Debian (default)
snowdreamtech/rtorrent:0.9.8-rutorrent-debian
snowdreamtech/rtorrent:latest-rutorrent-debian
snowdreamtech/rtorrent:0.9.8-rutorrent # ← Debian (default)
snowdreamtech/rtorrent:latest-rutorrent # ← Debian (default)
snowdreamtech/rtorrent:0.9.8-flood-debian
snowdreamtech/rtorrent:latest-flood-debian
snowdreamtech/rtorrent:0.9.8-flood     # ← Debian (default)
snowdreamtech/rtorrent:latest-flood    # ← Debian (default)
```

---

### 3. Nightly Builds (Scheduled)

**Trigger:** Automatically every day at 17:00 UTC

**Generated tags:**

```
# Alpine
snowdreamtech/rtorrent:nightly-alpine
snowdreamtech/rtorrent:nightly-rutorrent-alpine
snowdreamtech/rtorrent:nightly-flood-alpine

# Debian (with default tags)
snowdreamtech/rtorrent:nightly-debian
snowdreamtech/rtorrent:nightly          # ← Debian (default)
snowdreamtech/rtorrent:nightly-rutorrent-debian
snowdreamtech/rtorrent:nightly-rutorrent # ← Debian (default)
snowdreamtech/rtorrent:nightly-flood-debian
snowdreamtech/rtorrent:nightly-flood    # ← Debian (default)
```

---

## Tag Priority

Tags are generated with the following priority (higher number = higher priority):

| Priority | Type | Example Tags | Trigger |
|----------|------|--------------|---------|
| 1000 | Nightly | `nightly`, `nightly-alpine` | Schedule |
| 800 | Version | `0.16.12-alpine`, `0.9.8` | Tag push |
| 600 | Branch | `dev-alpine`, `main-debian` | Branch push |
| 200 | Latest | `latest`, `latest-alpine` | Main/Tag |

---

## Default Variant (Debian)

Debian is designated as the **default variant** (`is_latest: true`), which means:

✅ **Debian gets BOTH suffixed AND unsuffixed tags:**

```
snowdreamtech/rtorrent:nightly-debian   # Variant-specific
snowdreamtech/rtorrent:nightly          # Default (no suffix)

snowdreamtech/rtorrent:0.9.8-debian     # Variant-specific
snowdreamtech/rtorrent:0.9.8            # Default (no suffix)

snowdreamtech/rtorrent:latest-debian    # Variant-specific
snowdreamtech/rtorrent:latest           # Default (no suffix)
```

❌ **Alpine and Rocky get ONLY suffixed tags:**

```
snowdreamtech/rtorrent:nightly-alpine   # Variant-specific only
snowdreamtech/rtorrent:nightly-rocky    # Variant-specific only
```

---

## Usage Examples

### Pull the latest Debian image (default CLI)

```bash
docker pull snowdreamtech/rtorrent:latest
# or
docker pull snowdreamtech/rtorrent:latest-debian
```

### Pull the latest Alpine image

```bash
docker pull snowdreamtech/rtorrent:latest-alpine
```

### Pull a specific version

```bash
# Alpine 0.16.12
docker pull snowdreamtech/rtorrent:0.16.12-alpine

# Debian 0.9.8 (two ways)
docker pull snowdreamtech/rtorrent:0.9.8-debian
docker pull snowdreamtech/rtorrent:0.9.8
```

### Pull ruTorrent Web UI images

```bash
docker pull snowdreamtech/rtorrent:latest-rutorrent
docker pull snowdreamtech/rtorrent:latest-rutorrent-debian
docker pull snowdreamtech/rtorrent:latest-rutorrent-alpine
```

### Pull Flood Web UI images

```bash
docker pull snowdreamtech/rtorrent:latest-flood
docker pull snowdreamtech/rtorrent:latest-flood-debian
docker pull snowdreamtech/rtorrent:latest-flood-alpine
```

---

## Metadata Action Configuration

The key configuration that enables this tagging strategy:

```yaml
images: |
  name=ghcr.io/snowdreamtech/rtorrent,enable=true
  name=snowdreamtech/rtorrent,enable=true
flavor: |
  latest=false
  prefix=
  suffix=
```
