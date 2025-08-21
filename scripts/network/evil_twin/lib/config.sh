#!/usr/bin/env bash

# Configuration for evil twin attack

# Default settings
DEFAULT_SSID="LabPortal"
DEFAULT_CHANNEL="6"
DEFAULT_AP_IFACE="wlan1mon"
DEFAULT_DEAUTH_IFACE="wlan0mon"
DEFAULT_PORTAL_DIR="~/testing/fluxion/attacks/Captive Portal/sites/HUAWEI_en.portal/"
DEFAULT_TARGET_BSSID=""
DEFAULT_TARGET_CHANNEL=""

# Network settings
AP_IP="10.23.0.1"
AP_SUBNET="10.23.0.0/24"
AP_DHCP_START="10.23.0.10"
AP_DHCP_END="10.23.0.100"
AP_DHCP_LEASE="12h"