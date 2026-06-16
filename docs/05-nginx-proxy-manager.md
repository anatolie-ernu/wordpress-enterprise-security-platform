# 05. Nginx Proxy Manager

## Purpose

Nginx Proxy Manager is the public reverse proxy and certificate manager. It terminates HTTP/HTTPS traffic and forwards requests to local backend Nginx websites.

## Directory Layout

```bash
mkdir -p /opt/docker/nginx-proxy-manager/data
mkdir -p /opt/docker/nginx-proxy-manager/letsencrypt
mkdir -p /opt/docker/nginx-proxy-manager/logs
cd /opt/docker/nginx-proxy-manager
```

## Docker Compose

Create:

```bash
nano /opt/docker/nginx-proxy-manager/docker-compose.yml
```

Content:

```yaml
services:
  nginx-proxy-manager:
    image: jc21/nginx-proxy-manager:latest
    container_name: nginx-proxy-manager
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "10.10.10.20:81:81"
    environment:
      DB_MYSQL_HOST: "host.docker.internal"
      DB_MYSQL_PORT: 3306
      DB_MYSQL_USER: "npm_user"
      DB_MYSQL_PASSWORD: "CHANGE_THIS_COMPLEX_PASSWORD"
      DB_MYSQL_NAME: "npm"
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
      - ./logs:/data/logs
    extra_hosts:
      - "host.docker.internal:host-gateway"
```

## Deploy

```bash
docker compose up -d
docker ps
```

## Admin UI

Access from LAN only:

```text
http://10.10.10.20:81
```

Immediately change the default admin credentials.

## Proxy Host for wp01

| Field | Value |
|---|---|
| Domain Names | `wp01.ernu.sec` |
| Scheme | `http` |
| Forward Hostname/IP | `127.0.0.1` or host gateway IP |
| Forward Port | `8081` |
| Websockets Support | Enabled if needed |
| Block Common Exploits | Enabled |

For Docker-to-host communication, use the host gateway address when `127.0.0.1` refers to the container itself.

## Proxy Host for wp02

| Field | Value |
|---|---|
| Domain Names | `wp02.ernu.sec` |
| Scheme | `http` |
| Forward Hostname/IP | `127.0.0.1` or host gateway IP |
| Forward Port | `8082` |
| Websockets Support | Enabled if needed |
| Block Common Exploits | Enabled |

## Advanced Headers

Use NPM Advanced configuration to preserve visitor IP:

```nginx
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_set_header X-Forwarded-Host $host;
```

## Logs

NPM logs are stored in:

```text
/opt/docker/nginx-proxy-manager/logs
/opt/docker/nginx-proxy-manager/data/logs
```
