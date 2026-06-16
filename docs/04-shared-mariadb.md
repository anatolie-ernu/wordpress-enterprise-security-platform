# 04. Shared MariaDB

## Purpose

This project uses one local MariaDB instance for all WordPress websites and for Nginx Proxy Manager metadata. Each component must use its own database and database user.

## Install MariaDB

```bash
apt update
apt install -y mariadb-server mariadb-client
systemctl enable --now mariadb
```

## Secure MariaDB

Run:

```bash
mysql_secure_installation
```

Recommended choices:

```text
Switch to unix_socket authentication: Y
Change root password: Y, if password auth is used
Remove anonymous users: Y
Disallow root login remotely: Y
Remove test database: Y
Reload privilege tables: Y
```

## Bind MariaDB to Localhost

Edit:

```bash
nano /etc/mysql/mariadb.conf.d/50-server.cnf
```

Set:

```ini
[mysqld]
bind-address = 127.0.0.1
skip-name-resolve
local-infile = 0
```

Recommended tuning:

```ini
max_connections = 200
innodb_buffer_pool_size = 512M
innodb_file_per_table = 1
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
```

Restart:

```bash
systemctl restart mariadb
ss -tulpn | grep 3306
```

Expected:

```text
127.0.0.1:3306
```

## Create NPM Database

```sql
CREATE DATABASE npm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'npm_user'@'127.0.0.1' IDENTIFIED BY 'CHANGE_THIS_COMPLEX_PASSWORD';
GRANT ALL PRIVILEGES ON npm.* TO 'npm_user'@'127.0.0.1';
FLUSH PRIVILEGES;
```

## Create WordPress Databases

```sql
CREATE DATABASE wp01_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'wp01_user'@'localhost' IDENTIFIED BY 'CHANGE_THIS_COMPLEX_PASSWORD';
GRANT ALL PRIVILEGES ON wp01_db.* TO 'wp01_user'@'localhost';

CREATE DATABASE wp02_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'wp02_user'@'localhost' IDENTIFIED BY 'CHANGE_THIS_COMPLEX_PASSWORD';
GRANT ALL PRIVILEGES ON wp02_db.* TO 'wp02_user'@'localhost';

FLUSH PRIVILEGES;
```

## Backup Important Database Metadata

```bash
mysqldump --single-transaction --routines --events npm > /backup/wordpress-platform/npm.sql
mysqldump --single-transaction --routines --events wp01_db > /backup/wordpress-platform/wp01_db.sql
mysqldump --single-transaction --routines --events wp02_db > /backup/wordpress-platform/wp02_db.sql
```
