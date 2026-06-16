#!/usr/bin/env bash
set -euo pipefail
TS=$(date +%F-%H%M%S)
DEST="/backup/wordpress-enterprise-security-platform/$TS"
mkdir -p "$DEST"
mysqldump --single-transaction --routines --triggers npm > "$DEST/npm.sql"
mysqldump --single-transaction --routines --triggers wp01_db > "$DEST/wp01_db.sql"
tar -czf "$DEST/wp01-files.tar.gz" /var/www/wp01
tar -czf "$DEST/npm-data.tar.gz" data letsencrypt logs
find "$DEST" -type f -exec sha256sum {} \; > "$DEST/SHA256SUMS"
echo "Backup saved to $DEST"
