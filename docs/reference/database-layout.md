> **Project:** WordPress Enterprise Security Platform  
> **Author:** Anatolie Ernu - IT & Security Solutions  
> **Website:** https://www.ernu.eu  
> **Example technical domain:** `ernu.sec`


# 03. Shared MariaDB

## Design

One MariaDB service is installed on the Debian host and used by:

- Nginx Proxy Manager database `npm`
- WordPress site database `wp01`
- WordPress site database `wp02`

Each component receives its own database and database user. This keeps administration simple while preserving logical separation.

## Install MariaDB

```bash
apt install -y mariadb-server mariadb-client
systemctl enable --now mariadb
mysql_secure_installation
```

## Bind to Localhost

Edit `/etc/mysql/mariadb.conf.d/50-server.cnf`:

```ini
[mysqld]
bind-address = 127.0.0.1
local-infile = 0
symbolic-links = 0
skip-show-database
max_connections = 150
max_allowed_packet = 128M
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow-query.log
long_query_time = 2
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
```

Restart:

```bash
systemctl restart mariadb
```

## Create Databases and Users

```sql
CREATE DATABASE npm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'npm_user'@'localhost' IDENTIFIED BY 'CHANGE_ME_NPM_DB_PASSWORD';
GRANT ALL PRIVILEGES ON npm.* TO 'npm_user'@'localhost';

CREATE DATABASE wp01 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'wp01_user'@'localhost' IDENTIFIED BY 'CHANGE_ME_WP01_DB_PASSWORD';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON wp01.* TO 'wp01_user'@'localhost';

CREATE DATABASE wp02 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'wp02_user'@'localhost' IDENTIFIED BY 'CHANGE_ME_WP02_DB_PASSWORD';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON wp02.* TO 'wp02_user'@'localhost';

FLUSH PRIVILEGES;
```

## Docker Connectivity for NPM

NPM runs in Docker but uses the host MariaDB. In `docker-compose.yml`, map host gateway:

```yaml
extra_hosts:
  - "host.docker.internal:host-gateway"
```

NPM connects to:

```text
DB_MYSQL_HOST=host.docker.internal
DB_MYSQL_PORT=3306
```

## Validation

```bash
mysql -u npm_user -p -h 127.0.0.1 npm
mysql -u wp01_user -p -h 127.0.0.1 wp01
mysql -u wp02_user -p -h 127.0.0.1 wp02
```
