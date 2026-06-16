# 10. Firewall UFW

## Policy

Default policy:

```bash
ufw default deny incoming
ufw default allow outgoing
```

## Required Rules

```bash
ufw allow from 10.10.10.0/24 to any port 2222 proto tcp comment 'SSH admin LAN only'
ufw allow 80/tcp comment 'Public HTTP to NPM'
ufw allow 443/tcp comment 'Public HTTPS to NPM'
ufw allow from 10.10.10.0/24 to any port 81 proto tcp comment 'NPM admin LAN only'
ufw deny 81/tcp comment 'Block public NPM admin'
ufw deny 3306/tcp comment 'Block public MariaDB'
ufw deny 8081/tcp comment 'Block public wp01 backend'
ufw deny 8082/tcp comment 'Block public wp02 backend'
ufw enable
```

## Docker-Aware Protection

Docker can bypass UFW if ports are published on `0.0.0.0`. Use the DOCKER-USER chain protection from:

```text
configs/ufw/docker-user-chain.rules.sh
```

## Validation

```bash
ufw status verbose
ss -tulpn
```

Expected public exposure:

```text
0.0.0.0:80
0.0.0.0:443
```

Expected LAN-only or local exposure:

```text
10.10.10.20:81
127.0.0.1:3306
127.0.0.1:8081
127.0.0.1:8082
```
