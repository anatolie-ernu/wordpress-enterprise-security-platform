# Firewall Plan

## Default Policy

| Direction | Policy |
|---|---|
| Incoming | Deny |
| Outgoing | Allow |
| Routed | Deny unless explicitly required |

## Allowed Inbound Traffic

| Source | Destination | Port | Protocol | Purpose |
|---|---|---:|---|---|
| Any | Server public IP | 80 | TCP | HTTP to NPM |
| Any | Server public IP | 443 | TCP | HTTPS to NPM |
| 10.10.10.0/24 | 10.10.10.20 | 81 | TCP | NPM Admin UI from LAN |
| 10.10.10.0/24 | 10.10.10.20 | 2222 | TCP | SSH Admin access |

## Explicitly Blocked Inbound Traffic

| Source | Destination | Port | Protocol | Reason |
|---|---|---:|---|---|
| Any non-LAN | Server | 81 | TCP | Block public NPM admin |
| Any | Server | 3306 | TCP | MariaDB must not be public |
| Any | Server | 8081 | TCP | wp01 backend must not be public |
| Any | Server | 8082 | TCP | wp02 backend must not be public |

## Validation

Run:

```bash
ufw status verbose
ss -tulpn
```

Expected exposure:

```text
0.0.0.0:80    NPM public HTTP
0.0.0.0:443   NPM public HTTPS
10.10.10.20:81 NPM Admin LAN only
127.0.0.1:3306 MariaDB local only
127.0.0.1:8081 wp01 backend local only
127.0.0.1:8082 wp02 backend local only
```
