#!/bin/bash
# /usr/local/bin/smartd-apprise.sh

# Set your Apprise configuration (modify as needed)
APPRISE_URLS="discord://webhook_id/webhook_token" # Replace with your Apprise URL(s)

# Get the SMARTD event details
EVENT_TYPE=$1 # Event type (e.g., EmailTest, TestPassed, TestFailed, etc.)
DEVICE=$2     # Device that triggered the event (e.g., /dev/sda)
MESSAGE=$3    # Event message or details

# Construct the notification message
TITLE="smartd Alert: ${EVENT_TYPE}"
BODY="Device: ${DEVICE}\n\nDetails:\n${MESSAGE}"

# Send the notification using Apprise
echo -e "${BODY}" | apprise -b -t "${TITLE}" "${APPRISE_URLS}"
