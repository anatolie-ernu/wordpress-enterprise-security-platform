> **Project:** WordPress Enterprise Security Platform  
> **Author:** Anatolie Ernu - IT & Security Solutions  
> **Website:** https://www.ernu.eu  
> **Example technical domain:** `ernu.sec`


# 04. Nginx Proxy Manager

## Purpose

Nginx Proxy Manager is the public reverse proxy and SSL certificate manager. It owns TCP/80 and TCP/443 on the server.

## Directory Layout

```text
/opt/wordpress-enterprise-security-platform/
├── docker-compose.yml
├── data/
├── letsencrypt/
└── logs/
```

## Volumes

```yaml
volumes:
  - ./data:/data
  - ./letsencrypt:/etc/letsencrypt
  - ./logs:/data/logs
```

Meaning:

| Volume | Purpose |
|---|---|
| `./data` | NPM application data and proxy host configuration |
| `./letsencrypt` | SSL certificates and ACME account data |
| `./logs` | NPM proxy logs for review and Fail2Ban integrations |

## docker-compose.yml

```yaml
services:
  npm-app:
    image: jc21/nginx-proxy-manager:latest
    container_name: npm-app
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "10.10.10.20:81:81"
    environment:
      DB_MYSQL_HOST: "host.docker.internal"
      DB_MYSQL_PORT: 3306
      DB_MYSQL_USER: "npm_user"
      DB_MYSQL_PASSWORD: "CHANGE_ME_NPM_DB_PASSWORD"
      DB_MYSQL_NAME: "npm"
      TZ: "Europe/Chisinau"
    extra_hosts:
      - "host.docker.internal:host-gateway"
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
      - ./logs:/data/logs
    networks:
      npm_net:
        ipv4_address: 172.30.10.10

networks:
  npm_net:
    driver: bridge
    ipam:
      config:
        - subnet: 172.30.10.0/24
```

## Management Access

The NPM Admin UI is exposed only on the LAN IP:

```text
http://10.10.10.20:81
```

UFW must restrict access to the LAN:

```bash
ufw allow from 10.10.10.0/24 to any port 81 proto tcp comment 'NPM admin LAN only'
ufw deny 81/tcp comment 'Block public NPM admin'
```

## Initial Login

Default credentials are usually:

```text
Email: admin@example.com
Password: changeme
```

Change them immediately on first login.

## Proxy Host Creation

For each WordPress site:

1. Go to `Hosts` -> `Proxy Hosts`.
2. Click `Add Proxy Host`.
3. Enter the domain name.
4. Set scheme to `http`.
5. Set forward host to `127.0.0.1`.
6. Set forward port to the matching backend port.
7. Enable `Block Common Exploits`.
8. Enable WebSocket support if required.
9. Configure SSL certificate through Cloudflare DNS Challenge.
