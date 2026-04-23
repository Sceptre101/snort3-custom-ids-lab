#!/bin/bash
# Description: Prepares the environment, starts honeypots, and launches Snort.
# MUST BE RUN WITH SUDO.

if [ "$EUID" -ne 0 ]; then
  echo "[-] Error: Please run this script with sudo."
  exit
fi

echo "[*] Phase 1: Cleaning up old processes and freeing ports..."
killall -9 snort 2>/dev/null
killall -9 python3 2>/dev/null
killall -9 nc 2>/dev/null

echo "[*] Phase 2: Optimizing Network Interface (eth0)..."
ip link set eth0 promisc on
ethtool -K eth0 gro off lro off 2>/dev/null

echo "[*] Phase 3: Setting Defender Traps (Honeypots)..."
# Start a background Python web server on Port 80
echo "    [+] Opening Port 80 (Web Trap)..."
python3 -m http.server 80 > /dev/null 2>&1 &

# Start a background Netcat listener on Port 21
echo "    [+] Opening Port 21 (FTP Trap)..."
nc -lvnp 21 > /dev/null 2>&1 &

echo "[*] Phase 4: Launching Snort 3 in Live Mode..."
echo "======================================================================"
echo " Snort is now monitoring eth0. Waiting for attacks from the network..."
echo "======================================================================"
snort -c /etc/snort/snort.lua -R /etc/snort/rules/local.rules -i eth0 --daq afpacket -A alert_fast -k none