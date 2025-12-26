#!/bin/bash

# Pulse Server Standalone Installation Script
# This script installs Pulse Server as a standalone binary with systemd service

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="/opt/pulse"
SERVICE_NAME="pulse-server"
GITHUB_REPO="xhhcn/Pulse"
VERSION="latest"  # Can be changed to specific version like "v1.2.3"

# Print colored message
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    print_message "$RED" "❌ Please run as root (use sudo)"
    exit 1
fi

print_message "$GREEN" "🚀 Starting Pulse Server installation..."

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        BINARY_NAME="pulse-server-standalone-linux-amd64"
        ;;
    aarch64|arm64)
        BINARY_NAME="pulse-server-standalone-linux-arm64"
        ;;
    *)
        print_message "$RED" "❌ Unsupported architecture: $ARCH"
        print_message "$YELLOW" "   Supported: x86_64, aarch64/arm64"
        exit 1
        ;;
esac

print_message "$GREEN" "✅ Detected architecture: $ARCH"
print_message "$GREEN" "📦 Binary: $BINARY_NAME"

# Create installation directory
print_message "$YELLOW" "📁 Creating installation directory..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR/data"

# Download binary
print_message "$YELLOW" "⬇️  Downloading Pulse Server..."
if [ "$VERSION" = "latest" ]; then
    DOWNLOAD_URL="https://github.com/$GITHUB_REPO/releases/latest/download/$BINARY_NAME"
else
    DOWNLOAD_URL="https://github.com/$GITHUB_REPO/releases/download/$VERSION/$BINARY_NAME"
fi

if ! wget -q --show-progress "$DOWNLOAD_URL" -O "$INSTALL_DIR/pulse-server"; then
    print_message "$RED" "❌ Failed to download binary"
    print_message "$YELLOW" "   URL: $DOWNLOAD_URL"
    exit 1
fi

chmod +x "$INSTALL_DIR/pulse-server"
print_message "$GREEN" "✅ Binary downloaded and made executable"

# Create systemd service
print_message "$YELLOW" "⚙️  Creating systemd service..."
cat > /etc/systemd/system/$SERVICE_NAME.service << EOF
[Unit]
Description=Pulse Server Monitor (Standalone)
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$INSTALL_DIR
ExecStart=$INSTALL_DIR/pulse-server
Restart=always
RestartSec=5
Environment="PORT=8008"
# Log to systemd journal (auto-managed)
StandardOutput=journal
StandardError=journal
SyslogIdentifier=pulse-server

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
systemctl daemon-reload
print_message "$GREEN" "✅ Systemd service created"

# Start service
print_message "$YELLOW" "🚀 Starting Pulse Server..."
systemctl start $SERVICE_NAME
systemctl enable $SERVICE_NAME

# Wait a moment for service to start
sleep 2

# Check service status
if systemctl is-active --quiet $SERVICE_NAME; then
    print_message "$GREEN" "✅ Pulse Server is running!"
    
    # Get server IP
    SERVER_IP=$(hostname -I | awk '{print $1}')
    
    print_message "$GREEN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_message "$GREEN" "🎉 Installation completed successfully!"
    print_message "$GREEN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    print_message "$YELLOW" "📍 Access your dashboard:"
    print_message "$GREEN" "   http://$SERVER_IP:8008"
    print_message "$GREEN" "   http://localhost:8008 (if local)"
    echo ""
    print_message "$YELLOW" "🔧 Useful commands:"
    print_message "$GREEN" "   sudo systemctl status $SERVICE_NAME   # Check status"
    print_message "$GREEN" "   sudo systemctl stop $SERVICE_NAME     # Stop service"
    print_message "$GREEN" "   sudo systemctl restart $SERVICE_NAME  # Restart service"
    print_message "$GREEN" "   sudo journalctl -u $SERVICE_NAME -f   # View logs (live)"
    echo ""
    print_message "$YELLOW" "📁 Installation directory: $INSTALL_DIR"
    print_message "$YELLOW" "💾 Data directory: $INSTALL_DIR/data"
    echo ""
    print_message "$YELLOW" "🗑️  Uninstall:"
    print_message "$GREEN" "   sudo systemctl stop $SERVICE_NAME && sudo systemctl disable $SERVICE_NAME"
    print_message "$GREEN" "   sudo rm -f $INSTALL_DIR/pulse-server /etc/systemd/system/$SERVICE_NAME.service"
    print_message "$GREEN" "   sudo rm -rf $INSTALL_DIR/data && sudo systemctl daemon-reload"
    echo ""
    print_message "$GREEN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    print_message "$RED" "❌ Failed to start Pulse Server"
    print_message "$YELLOW" "   Check logs: sudo journalctl -u $SERVICE_NAME -n 50"
    exit 1
fi

