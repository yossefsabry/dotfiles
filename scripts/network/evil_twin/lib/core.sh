#!/usr/bin/env bash

# Core functions for evil twin attack

# Logging function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Error handling function
error_exit() {
    log "ERROR: $1"
    exit 1
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error_exit "This script must be run as root (sudo)"
    fi
}

# Check if required binaries are installed
check_dependencies() {
    local deps=("hostapd" "dnsmasq" "python3" "ip" "aireplay-ng" "airodump-ng" "aircrack-ng")
    for bin in "${deps[@]}"; do
        command -v "$bin" >/dev/null 2>&1 || error_exit "Missing dependency: $bin"
    done
}

# Validate interface exists
validate_interface() {
    local iface=$1
    ip link show "$iface" >/dev/null 2>&1 || error_exit "Interface $iface does not exist"
}

# Check if directory exists
validate_directory() {
    local dir=$1
    [[ -d "$dir" ]] || error_exit "Directory not found: $dir"
}

# Set up interface with static IP
setup_interface() {
    local iface=$1
    local ip_addr=${2:-"10.23.0.1/24"}
    
    log "Preparing interface: $iface"
    ip link set "$iface" down 2>/dev/null || true
    ip addr flush dev "$iface" 2>/dev/null || true
    ip addr add "$ip_addr" dev "$iface"
    ip link set "$iface" up
}

# Clean up function
cleanup() {
    log "Cleaning up..."
    # Kill child processes
    pkill -P $$ 2>/dev/null || true
    
    # Kill specific processes if PID files exist
    [[ -f "$WORKDIR/hostapd.pid" ]] && kill "$(cat "$WORKDIR/hostapd.pid")" 2>/dev/null || true
    [[ -f "$WORKDIR/dnsmasq.pid" ]] && kill "$(cat "$WORKDIR/dnsmasq.pid")" 2>/dev/null || true
    [[ -f "$WORKDIR/http.pid" ]] && kill "$(cat "$WORKDIR/http.pid")" 2>/dev/null || true
    [[ -f "$WORKDIR/airodump.pid" ]] && kill "$(cat "$WORKDIR/airodump.pid")" 2>/dev/null || true
    
    # Clean up interfaces
    [[ -n "${AP_IFACE:-}" ]] && ip addr flush dev "$AP_IFACE" 2>/dev/null || true
    [[ -n "${DEAUTH_IFACE:-}" ]] && ip link set "$DEAUTH_IFACE" down 2>/dev/null || true
    
    # Remove temporary directory
    [[ -n "${WORKDIR:-}" ]] && rm -rf "$WORKDIR" 2>/dev/null || true
    
    log "Cleanup complete"
}

# Trap to ensure cleanup on exit
setup_trap() {
    trap cleanup EXIT INT TERM
}