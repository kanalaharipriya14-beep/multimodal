#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICE_FILE="$SCRIPT_DIR/antigravity-ui.service"

if [ ! -f "$SERVICE_FILE" ]; then
  echo "Error: antigravity-ui.service not found in $SCRIPT_DIR"
  exit 1
fi

echo "Installing Antigravity UI service..."
echo "Make sure you've edited antigravity-ui.service with your username and paths first!"
echo ""

sudo cp "$SERVICE_FILE" /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable antigravity-ui
sudo systemctl start antigravity-ui
sudo systemctl status antigravity-ui
