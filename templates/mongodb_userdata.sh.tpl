#!/bin/bash
# EC2 user data — installs MongoDB 7.0 on Amazon Linux 2023, configures the
# backup script, and schedules the nightly cron job.
set -euo pipefail

# Add the MongoDB 7.0 repository for Amazon Linux 2023
cat > /etc/yum.repos.d/mongodb-org-7.0.repo << 'EOF'
[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-7.0.asc
EOF

dnf install -y mongodb-org-7.0.11

# Allow MongoDB to accept connections from the private subnet
sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf

systemctl enable mongod
systemctl start mongod

# Write the backup script (bucket name and region are baked in by Terraform)
cat > /usr/local/bin/mongodb_backup.sh << 'END_BACKUP_SCRIPT'
${backup_script}
END_BACKUP_SCRIPT

chmod +x /usr/local/bin/mongodb_backup.sh

# Schedule nightly backup via cron
echo "${backup_cron_schedule} root /usr/local/bin/mongodb_backup.sh >> /var/log/mongodb_backup.log 2>&1" \
  > /etc/cron.d/mongodb-backup
chmod 644 /etc/cron.d/mongodb-backup
