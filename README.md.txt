# Snort 3 Live Intrusion Detection Lab

## 🛡️ Project Overview
This project is a custom-built Intrusion Detection System (IDS) lab environment utilizing **Snort 3**. It demonstrates the creation of custom Snort rules, the configuration of dummy services to act as honeypots, and the execution of live network attacks to trigger real-time alerts. 

To overcome Linux terminal buffering and PCAP DAQ delays during single-packet testing, this lab successfully implements the `afpacket` Data Acquisition module to achieve true line-speed, real-time alert logging.

## ⚙️ Network Topology
* **Hypervisor:** VirtualBox (Internal/Bridged Network)
* **Defender Machine:** Ubuntu/Debian (IP: `192.168.1.6`) - Running Snort 3
* **Attacker Machine:** Kali/Ubuntu Linux

## 📜 Custom Rules Deployed
The `rules/local.rules` file contains 7 custom signatures designed to detect specific malicious behaviors:
1. **Large ICMP (Ping of Death Variant):** Detects anomalous `dsize` payloads.
2. **SQL Injection (UNION SELECT):** Detects database query manipulation in web traffic.
3. **Directory Traversal (../):** Detects attempts to escape the web root folder.
4. **Cleartext Credential Leak:** Tracks `POST` requests and subsequent `password=` payloads over unencrypted HTTP.
5. **FTP Anonymous Login:** Detects reconnaissance attempts on port 21.
6. **Unencrypted Windows CMD Shell:** Detects a reverse shell actively calling back to an attacker.
7. **SSH Brute Force:** Utilizes `detection_filter` to track excessive SYN packets within a 10-second rolling window.

---

## 🚀 Lab Setup & Execution

### Phase 1: Defender Initialization
On the Defender machine, run the master startup script. This script will automatically free up required ports, set the network interface to promiscuous mode, start the web/FTP honeypots in the background, and launch Snort 3 in live AFPacket mode.

```bash
sudo bash scripts/start_defender.sh

### Phase 2: Attack Simulation
Switch to the Attacker machine and execute the automated attack script. This will fire the network attacks in sequence and instantly trigger the Snort rules on the Defender machine.

```bash
bash scripts/attack_sim.sh