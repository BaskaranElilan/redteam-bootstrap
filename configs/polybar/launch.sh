#!/usr/bin/env bash
set -Eeuo pipefail

killall -q polybar || true
while pgrep -x polybar >/dev/null; do
  sleep 1
done
polybar main &
