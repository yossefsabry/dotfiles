#!/bin/bash

CPU=$(top -bn1 | awk '/Cpu/ {print int(100 - $8)}')
MEM=$(free | awk '/Mem/ {printf "%.0f", $3/$2 * 100}')

# GPU (NVIDIA / AMD fallback)
GPU="N/A"
command -v nvidia-smi &>/dev/null && \
GPU=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)

echo "CPU: ${CPU}% | MEM: ${MEM}% | GPU: ${GPU}%"
