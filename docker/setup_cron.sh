#!/bin/bash

# setup_cron.sh v1.0

# Ensure the log file exists and has the correct permissions
touch /app/nextcloud-news-filter.log
chmod 666 /app/nextcloud-news-filter.log

# Default to run every 5 minutes if INTERVAL is not set
: "${INTERVAL:=*/5 * * * *}"

# Run the script to create config.ini
/app/create_config.sh

# Set up the cron job
echo "$INTERVAL /usr/local/bin/python /app/main.py | grep -E '(filter|marking as read)' >> /app/nextcloud-news-filter.log 2>&1" | crontab -

# Start the cron service
cron

# Keep the container running
tail -f /app/nextcloud-news-filter.log
