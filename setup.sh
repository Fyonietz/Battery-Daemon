#!/bin/bash
set -euo pipefail

DAEMON_NAME="Battery-Daemon"
DAEMON_EXEC_PATH="/usr/local/bin/$DAEMON_NAME"
SERVICE_PATH="/etc/systemd/system/$DAEMON_NAME.service"
INSTALL_DIR="/opt/$DAEMON_NAME"

echo "Installing daemon..."

install -Dm755 "bin/$DAEMON_NAME" "$DAEMON_EXEC_PATH"

mkdir -p "$INSTALL_DIR"/{logs,config}

cat > "$SERVICE_PATH" <<EOL
[Unit]
Description=$DAEMON_NAME Daemon
After=network.target

[Service]
ExecStart=$DAEMON_EXEC_PATH
WorkingDirectory=$INSTALL_DIR
Restart=on-failure
RestartSec=2
User=root
Group=root
Environment=CONFIG_DIR=$INSTALL_DIR/config

NoNewPrivileges=true
PrivateTmp=true

StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload
systemctl enable --now $DAEMON_NAME.service

systemctl --no-pager --full status $DAEMON_NAME.service

echo "Setup complete!"
