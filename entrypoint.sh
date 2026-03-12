#!/bin/bash
set -e

REPO_URL="https://github.com/ByMykel/CSGO-API.git"
DATA_DIR="/data/csgo-api"
SERVE_DIR="/usr/share/nginx/html/api"
INTERVAL="${UPDATE_INTERVAL:-3600}"

update_data() {
  echo "[$(date)] Updating CSGO-API data..."
  if [ -d "$DATA_DIR/.git" ]; then
    git -C "$DATA_DIR" pull --ff-only
  else
    git clone --depth 1 "$REPO_URL" "$DATA_DIR"
  fi
  rm -rf "$SERVE_DIR"
  cp -r "$DATA_DIR/public/api" "$SERVE_DIR"
  echo "[$(date)] Update complete."
}

# Initial fetch
update_data

# Start periodic updates in the background
(
  while true; do
    sleep "$INTERVAL"
    update_data
  done
) &

# Start nginx
exec nginx -g "daemon off;"
