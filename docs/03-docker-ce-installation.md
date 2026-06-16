# 03. Docker CE Installation on Debian 13

## Purpose

Nginx Proxy Manager is deployed as a Docker container. Docker Engine and the Docker Compose plugin must be installed before the reverse proxy layer is deployed.

## Remove Conflicting Packages

```bash
apt remove -y docker.io docker-compose docker-doc podman-docker containerd runc || true
```

## Install Required Packages

```bash
apt update
apt install -y ca-certificates curl gnupg lsb-release
```

## Add Docker GPG Key

```bash
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
```

## Add Docker Repository

```bash
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/debian \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
> /etc/apt/sources.list.d/docker.list
```

For Debian 13, verify that the codename is `trixie`:

```bash
. /etc/os-release
echo "$VERSION_CODENAME"
```

## Install Docker Engine

```bash
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## Enable Docker

```bash
systemctl enable --now docker
systemctl status docker
```

## Validate

```bash
docker version
docker compose version
docker run --rm hello-world
```

## Directory Layout

```bash
mkdir -p /opt/docker/nginx-proxy-manager/data
mkdir -p /opt/docker/nginx-proxy-manager/letsencrypt
mkdir -p /opt/docker/nginx-proxy-manager/logs
```

## Docker and UFW Warning

Docker manipulates iptables directly. UFW rules alone may not fully protect ports published by Docker if those ports are bound to `0.0.0.0`.

For NPM Admin UI use LAN binding:

```yaml
ports:
  - "80:80"
  - "443:443"
  - "10.10.10.20:81:81"
```

Also apply the DOCKER-USER chain rules from `configs/ufw/docker-user-chain.rules.sh`.
