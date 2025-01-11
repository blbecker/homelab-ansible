#!/bin/bash

set -eu 

url="{{ gotify_url }}"

app_token="$1"
title="$2"
message="$3"

curl -X POST "https://${url}/message?token=${app_token}" -F "title=${title}" -F "message=${message}"s