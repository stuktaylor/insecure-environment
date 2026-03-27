#!/bin/bash
# MongoDB backup script — runs nightly via cron, uploads to S3.
set -euo pipefail

BUCKET="${bucket_name}"
REGION="${aws_region}"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/tmp/mongodb_backup_$DATE"
ARCHIVE="/tmp/mongodb_backup_$DATE.tar.gz"

echo "[$(date)] Starting MongoDB backup to s3://$BUCKET"

mongodump --out "$BACKUP_DIR"
tar -czf "$ARCHIVE" -C /tmp "mongodb_backup_$DATE"
aws s3 cp "$ARCHIVE" "s3://$BUCKET/backups/mongodb_backup_$DATE.tar.gz" --region "$REGION"

rm -rf "$BACKUP_DIR" "$ARCHIVE"

echo "[$(date)] Backup complete: backups/mongodb_backup_$DATE.tar.gz"
