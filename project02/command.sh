# -------------------- #
# Basic Switch Configuration
enable
configure terminal
hostname [tag]

# Add local account
username ccna secret ccna
# CS-Core
line console 0
login local

# Set enable password
enable secret project2

# Configure ssh
ip domain-name cs.nycu.edu.tw
crypto key generate rsa (modulus 2048)
ip ssh version 2

line vty 0 15
transport input ssh
login local

# Shutdown all unused interfaces (interfaces not connected)
interface [int]
shutdown

# Switch should not send CDP to edge devices
interface [int]
no cdp enable

show cdp neighbors

# Save configuration
copy running-config startup-config
# ----- FINISHED ----- #

# -------------------- #
# VLAN
# ---------- #
# Use VLAN101 for Lab1
# Use VLAN102 for Lab2-1 & Lab2-2
# Use VLAN30 for Management
# Use VLAN324 for 324
# Use VLAN316 for 316
# Use VLAN321 for 321
# ---------- #
vlan 101
name VLAN{number}

# Configure Trunk Interface
interface [int0/x]
switchport mode trunk
switchport trunk allowed vlan 101,102

# Configure Access Interface
interface [int0/x]
switchport mode access
switchport access vlan 101

interface Fa0/5
switchport trunk native vlan 321
switchport mode trunk
# ----- FINISHED ----- #

# -------------------- #
# Switch IP Address & Gateway
vlan 30
name VLAN30
interface vlan30
ip address 140.113.10.x 255.255.255.0

ip default-gateway 140.113.10.254
# CS-Core
interface vlan30
ip address 140.113.10.254 255.255.255.0
interface vlan101
ip address 140.113.20.1 255.255.255.224
interface vlan102
ip address 140.113.20.33 255.255.255.224
interface vlan324
ip address 140.113.24.254 255.255.255.0
interface vlan316
ip address 140.113.16.254 255.255.255.0
interface vlan321
ip address 140.113.21.254 255.255.255.0
# ----- FINISHED ----- #

# -------------------- #
# STP
# Set to Rapid PVST+
spanning-tree mode rapid-pvst

# Set PortFast and BPDU Guard for edge connection ports
interface range [int0/x - x]
spanning-tree portfast
spanning-tree bpduguard enable

# CS-Core
# VLAN-num: 1, 30, 101, 102, 316, 321, 324
spanning-tree vlan [VLAN-num] priority root
# ----- FINISHED ----- #

# -------------------- #
# CS-Core
# Enable IP routing
ip routing

# Set default route
ip route 0.0.0.0 0.0.0.0 140.113.1.1

# Configure uplink interface as Layer 3 interface
interface Gig1/0/24
no switchport
ip address 140.113.1.2 255.255.255.252

# Enable sending and receiving LLDP packets
lldp run
# ----- FINISHED ----- #
