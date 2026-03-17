#!/bin/bash

# Define variables
DAEMON_NAME="Battery-Daemon"
DAEMON_EXEC_PATH="/usr/local/bin/$DAEMON_NAME"
SERVICE_PATH="/etc/systemd/system/$DAEMON_NAME.service"
USER="root"  # Run the daemon as root
GROUP="root"  # Group is also root
INSTALL_DIR="/opt/$DAEMON_NAME"

# Step 1: Install the compiled Zig binary
echo "Installing the Zig daemon..."
mkdir -p "$INSTALL_DIR"
cp bin/$DAEMON_NAME "$DAEMON_EXEC_PATH"
chmod +x "$DAEMON_EXEC_PATH"

# Step 2: Create necessary directories
echo "Creating necessary directories..."
mkdir -p "$INSTALL_DIR/logs"
mkdir -p "$INSTALL_DIR/config"

# Step 3: Create the systemd service file
echo "Setting up systemd service..."

cat > "$SERVICE_PATH" <<EOL
[Unit]
Description=$DAEMON_NAME Daemon
After=network.target

[Service]
ExecStart=$DAEMON_EXEC_PATH
Restart=always
User=$USER
Group=$GROUP
WorkingDirectory=$INSTALL_DIR
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=$DAEMON_NAME
TimeoutSec=30
Environment=CONFIG_DIR=$INSTALL_DIR/config

[Install]
WantedBy=multi-user.target
EOL

# Step 4: Reload systemd, enable and start the service
echo "Reloading systemd and enabling the service..."
systemctl daemon-reload
systemctl enable $DAEMON_NAME.service
systemctl start $DAEMON_NAME.service

# Step 5: Check the status of the daemon
echo "Checking status of the daemon..."
systemctl status $DAEMON_NAME.service

echo "Setup complete!"
