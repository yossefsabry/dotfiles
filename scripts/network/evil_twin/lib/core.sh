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
    # Check if interface is in monitor mode
    if iw dev "$iface" info 2>&1 | grep -q "type monitor"; then
        log "Interface $iface is in monitor mode, temporarily disabling monitor mode for AP setup"
        # For AP creation, we need managed mode, but we'll preserve the original state
        # This is a limitation - hostapd requires managed mode
        log "Warning: Interface $iface is in monitor mode. AP may not work correctly."
    fi
    
    ip link set "$iface" down 2>/dev/null || true
    ip addr flush dev "$iface" 2>/dev/null || true
    ip addr add "$ip_addr" dev "$iface"
    ip link set "$iface" up
    
    # Verify interface is up
    if ! ip link show "$iface" | grep -q "state UP"; then
        error_exit "Failed to bring interface $iface up"
    fi
}

# Clean up function
cleanup() {
    log "Cleaning up..."
    
    # Kill specific processes if PID files exist
    if [[ -f "$WORKDIR/hostapd.pid" ]]; then
        local hostapd_pid=$(cat "$WORKDIR/hostapd.pid")
        log "Stopping hostapd (PID: $hostapd_pid)"
        kill "$hostapd_pid" 2>/dev/null || true
        # Wait for process to terminate
        timeout 5 tail --pid="$hostapd_pid" -f /dev/null 2>/dev/null || true
    fi
    
    if [[ -f "$WORKDIR/dnsmasq.pid" ]]; then
        local dnsmasq_pid=$(cat "$WORKDIR/dnsmasq.pid")
        log "Stopping dnsmasq (PID: $dnsmasq_pid)"
        kill "$dnsmasq_pid" 2>/dev/null || true
        # Wait for process to terminate
        timeout 5 tail --pid="$dnsmasq_pid" -f /dev/null 2>/dev/null || true
    fi
    
    if [[ -f "$WORKDIR/http.pid" ]]; then
        local http_pid=$(cat "$WORKDIR/http.pid")
        log "Stopping HTTP server (PID: $http_pid)"
        kill "$http_pid" 2>/dev/null || true
        # Wait for process to terminate
        timeout 5 tail --pid="$http_pid" -f /dev/null 2>/dev/null || true
    fi
    
    if [[ -f "$WORKDIR/airodump.pid" ]]; then
        local airodump_pid=$(cat "$WORKDIR/airodump.pid")
        log "Stopping airodump-ng (PID: $airodump_pid)"
        kill "$airodump_pid" 2>/dev/null || true
        # Wait for process to terminate
        timeout 5 tail --pid="$airodump_pid" -f /dev/null 2>/dev/null || true
    fi
    
    # Kill any remaining related processes
    pkill -f "hostapd.*$AP_IFACE" 2>/dev/null || true
    pkill -f "dnsmasq.*$AP_IFACE" 2>/dev/null || true
    pkill -f "airodump-ng.*$DEAUTH_IFACE" 2>/dev/null || true
    pkill -f "aireplay-ng.*$DEAUTH_IFACE" 2>/dev/null || true
    
    # Clean up interfaces
    if [[ -n "${AP_IFACE:-}" ]]; then
        log "Cleaning up AP interface: $AP_IFACE"
        ip addr flush dev "$AP_IFACE" 2>/dev/null || true
        ip link set "$AP_IFACE" down 2>/dev/null || true
    fi
    
    if [[ -n "${DEAUTH_IFACE:-}" ]] && [[ "$DEAUTH_IFACE" != "$AP_IFACE" ]]; then
        log "Cleaning up deauth interface: $DEAUTH_IFACE"
        ip link set "$DEAUTH_IFACE" down 2>/dev/null || true
    fi
    
    # Remove temporary directory
    if [[ -n "${WORKDIR:-}" ]] && [[ -d "$WORKDIR" ]]; then
        log "Removing temporary directory: $WORKDIR"
        rm -rf "$WORKDIR" 2>/dev/null || true
    fi
    
    log "Cleanup complete"
}

# Trap to ensure cleanup on exit
setup_trap() {
    trap cleanup EXIT INT TERM
}