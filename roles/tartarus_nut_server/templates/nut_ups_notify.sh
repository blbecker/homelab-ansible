#!/bin/bash

# This script is called by NUT when an event occurs.
# https://networkupstools.org/docs/user-manual.chunked/ar01s07.html

set -eu 

tools="{{ tartarus.tools_dir }}"

message="${1:-UPS Event Type: ${NOTIFYTYPE}}"

${tools}/gotify_notify "{{ gotify_app_token }}" "UPS Event: ${UPSNAME}" "${message}"

