#!/bin/bash
# Daily database backup script (schedule it with cron)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PYTHON_BIN="${PYTHON_BIN:-python3}"

cd "$SCRIPT_DIR" || exit 1
"$PYTHON_BIN" manage.py backup_database --compress
mkdir -p "$SCRIPT_DIR/backups"
echo "$(date): Backup ejecutado" >> "$SCRIPT_DIR/backups/backup.log"
