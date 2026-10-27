#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/.env" ]; then
    set -a; source "$SCRIPT_DIR/.env"; set +a
fi

LOG_DIR="${LOG_DIR:-/var/log/nginx}"
BACKUP_DIR="${BACKUP_DIR:-$HOME/backups}"
RETENTION_DAYS="${RETENTION_DAYS:-7}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
ARCHIVE="$BACKUP_DIR/logs_$TIMESTAMP.tar.gz"

mkdir -p "$BACKUP_DIR"
echo "[$(date)] Starting backup of $LOG_DIR"

tar -czf "$ARCHIVE" -C "$LOG_DIR" .
echo "[$(date)] Created $ARCHIVE"

find "$BACKUP_DIR" -name "logs_*.tar.gz" -mtime +"$RETENTION_DAYS" -delete
echo "[$(date)] Done"
