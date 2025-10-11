#!/bin/bash
# Usage: ./scripts/uptime_check.sh http://<ip-or-host>
URL="$1"
if [ -z "$URL" ]; then
  echo "Usage: $0 http://<host>"
  exit 2
fi
STATUS=$(curl -s -o /dev/null -w '%{http_code}' "$URL" || echo "000")
if [ "$STATUS" = "200" ]; then
  echo "OK - $URL returned 200"
  exit 0
else
  echo "ALERT - $URL returned $STATUS"
  exit 1
fi
