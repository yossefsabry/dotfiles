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
    local deps=("hostapd" "dnsmasq" "python3" "ip" "aireplay-ng" "airodump-ng" "aircrack-ng" "iw")
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
    
    # Check if we should skip interface setup
    if [[ "${SKIP_INTERFACE_SETUP:-false}" == "true" ]]; then
        log "Skipping interface setup for $iface (pre-configured)"
        return 0
    fi
    
    log "Preparing interface: $iface"
    
    # Bring interface down
    ip link set "$iface" down 2>/dev/null || true
    
    # Set interface to managed mode for AP
    iw dev "$iface" set type managed 2>/dev/null || true
    
    # Flush any existing IP addresses
    ip addr flush dev "$iface" 2>/dev/null || true
    
    # Assign IP address
    ip addr add "$ip_addr" dev "$iface"
    
    # Bring interface up
    ip link set "$iface" up
    
    # Verify interface is up
    if ! ip link show "$iface" | grep -q "state UP"; then
        error_exit "Failed to bring interface $iface up"
    fi
    
    log "Interface $iface configured with IP $ip_addr"
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
    
    # Kill monitoring processes
    if [[ -f "$WORKDIR/monitor_http.pid" ]]; then
        local monitor_http_pid=$(cat "$WORKDIR/monitor_http.pid")
        log "Stopping HTTP monitor (PID: $monitor_http_pid)"
        kill "$monitor_http_pid" 2>/dev/null || true
    fi
    
    if [[ -f "$WORKDIR/monitor_dns.pid" ]]; then
        local monitor_dns_pid=$(cat "$WORKDIR/monitor_dns.pid")
        log "Stopping DNS monitor (PID: $monitor_dns_pid)"
        kill "$monitor_dns_pid" 2>/dev/null || true
    fi
    
    if [[ -f "$WORKDIR/monitor_dhcp.pid" ]]; then
        local monitor_dhcp_pid=$(cat "$WORKDIR/monitor_dhcp.pid")
        log "Stopping DHCP monitor (PID: $monitor_dhcp_pid)"
        kill "$monitor_dhcp_pid" 2>/dev/null || true
    fi
    
    if [[ -f "$WORKDIR/monitor_deauth.pid" ]]; then
        local monitor_deauth_pid=$(cat "$WORKDIR/monitor_deauth.pid")
        log "Stopping deauth monitor (PID: $monitor_deauth_pid)"
        kill "$monitor_deauth_pid" 2>/dev/null || true
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
        # Set interface back to managed mode
        ip link set "$DEAUTH_IFACE" down 2>/dev/null || true
        iw dev "$DEAUTH_IFACE" set type managed 2>/dev/null || true
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