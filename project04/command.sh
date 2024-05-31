# -------------------- #
#  Basic
# Hostname
hostname [tag]

# Shutdown all unused interfaces 
interface [int]
shutdown

# Set to Rapid PVST+
spanning-tree mode rapid-pvst

# AAA
# router
aaa new-model
radius server radius
address ipv4 140.113.2.138
key T@_1s-H4nds0m3
aaa authentication login vty_login group radius local

# switch
aaa new-model
radius-server host 140.113.2.138 key T@_1s-H4nds0m3
aaa authentication login vty_login group radius local

# Configure ssh
ip domain-name cs.nctu.edu.tw
crypto key generate rsa (modulus 2048)
ip ssh version 2

line vty 0 15
login authentication vty_login
transport input ssh

write memory
# ----- FINISHED ----- #

# -------------------- #
# VLANs
vlan 10
 name VLAN10
 exit

vlan 20
 name VLAN20
 exit

vlan 30
 name VLAN30
 exit

vlan 209
 name VLAN209
 exit

vlan 316
 name VLAN316
 exit

vlan 324
 name VLAN324
 exit

# Core-1
interface vlan 10
 ip address 140.113.10.21 255.255.255.0
 exit

interface vlan 20
 ip address 140.113.2.140 255.255.255.192
 exit

interface vlan 30
 ip address 140.113.2.201 255.255.255.192
 exit

interface vlan 316
 ip address 140.113.16.251 255.255.255.0
 exit

interface vlan 324
 ip address 140.113.24.251 255.255.255.0
 exit

ip routing

# Core-2
interface vlan 10
 ip address 140.113.10.22 255.255.255.0
 exit

interface vlan 20
 ip address 140.113.2.142 255.255.255.192
 exit

interface vlan 30
 ip address 140.113.2.196 255.255.255.192
 exit

interface vlan 316
 ip address 140.113.16.252 255.255.255.0
 exit

interface vlan 324
 ip address 140.113.24.252 255.255.255.0
 exit

ip routing

# CSCC-intranet1-Sw
interface vlan 10
 ip address 140.113.10.11 255.255.255.0
 exit

ip default-gateway 140.113.10.254

# CSCC-intranet2-Sw
interface vlan 10
 ip address 140.113.10.12 255.255.255.0
 exit

ip default-gateway 140.113.10.254

# PCRoom-Sw
interface vlan 10
 ip address 140.113.10.23 255.255.255.0
 exit

ip default-gateway 140.113.10.254

# Link Trunk settings
# Core-1 - Core-2
interface Fa0/1
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk allowed vlan 20,30

# Core-1 - CSCC-intranet1-Sw
interface Fa0/21
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk allowed vlan 10,316,324

# Core-1 - CSCC-intranet2-Sw
interface Fa0/16
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk allowed vlan 20,30,209

# Core-2 - CSCC-intranet1-Sw
interface Fa0/16
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk allowed vlan 20,30,209

# Core-2 - CSCC-intranet2-Sw
interface Fa0/21
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk allowed vlan 10,316,324

# CSCC-intranet1-Sw - CSCC-intranet2-Sw
interface range Gig0/1-2
 switchport mode trunk
 switchport trunk allowed vlan 10,20,30,209,316,324

interface Po2
 switchport mode trunk
 switchport trunk allowed vlan 10,20,30,209,316,324

# Core-2 - PCRoom-Sw
int range Fa0/11-12
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk allowed vlan 10,316,324

interface Po3
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk allowed vlan 10,316,324

# PCRoom-Sw
int range Fa0/1-3
 switchport mode access
 switchport access vlan 324

int range Fa0/4-6
 switchport mode access
 switchport access vlan 316

# CSCC-intranet1-Sw
int Fa0/1
 switchport mode access
 switchport access vlan 30

int Fa0/2
 switchport mode access
 switchport access vlan 20

int Fa0/24
 switchport mode access
 switchport access vlan 209

# CSCC-intranet2-Sw
int Fa0/1
 switchport mode access
 switchport access vlan 10
# ----- FINISHED ----- #

# -------------------- #
# Channel group
# Core-2 - PCRoom-Sw
interface range Fa0/11-12
# PCRoom-Sw
channel-group 3 mode passive
exit

# Core-2
channel-group 3 mode active
exit

# CSCC-intranet1-Sw - CSCC-intranet2-Sw
interface range Gig0/1-2
channel-group 2 mode on
exit

show etherchannel summary
# ----- FINISHED ----- #

# -------------------- #
# ACLs
ip access-list standard Outgoing
 deny 140.113.10.0 0.0.0.255
 permit any

ip access-list standard Incoming
 deny 192.168.0.0 0.0.255.255
 deny 10.0.0.0 0.255.255.255
 permit any

access-list 10 permit 140.113.2.128 0.0.0.127
access-list 10 permit 140.113.10.0 0.0.0.255

access-list 20 permit 140.113.2.128 0.0.0.63
access-list 20 permit 140.113.10.0 0.0.0.255

access-list 30 permit host 140.113.10.1

access-list 100 permit tcp any any eq 80
access-list 100 permit tcp any any eq 443
access-list 100 permit ip 140.113.2.128 0.0.0.127 any

access-list 110 deny tcp any any eq 80
access-list 110 deny tcp any any eq 443
access-list 110 permit ip any any

# Core-1
interface Fa0/22
 ip access-group Outgoing out
 ip access-group Incoming in

interface vlan10
 ip access-group 20 in

interface vlan20
 ip access-group 10 in

interface vlan30
 ip access-group 100 in

interface vlan316
 ip access-group 110 in

interface vlan324
 ip access-group 110 in

line vty 0 15
 access-class 30 in

# Core-2
interface Fa0/23
 ip access-group Outgoing out
 ip access-group Incoming in

interface vlan10
 ip access-group 20 in

interface vlan20
 ip access-group 10 in

interface vlan30
 ip access-group 100 in

interface vlan316
 ip access-group 110 in

interface vlan324
 ip access-group 110 in

line vty 0 15
 access-class 30 in
# ----- FINISHED ----- #

# -------------------- #
# OSPF
# Core-1
vlan 209
 name VLAN209
 exit

interface vlan 209
 ip address 140.113.69.11 255.255.255.248
 no shutdown
 exit

interface Fa0/22
 no switchport
 ip address 140.113.69.1 255.255.255.248
 exit

router ospf 10
 network 140.113.69.0 0.0.0.7 area 0
 network 140.113.69.8 0.0.0.7 area 0
 network 140.113.16.0 0.0.0.255 area 0
 network 140.113.24.0 0.0.0.255 area 0
 exit

# Core-2
vlan 209
 name VLAN209
 exit

interface vlan 209
 ip address 140.113.69.12 255.255.255.248
 no shutdown
 exit

interface Fa0/23
 no switchport
 ip address 140.113.69.2 255.255.255.248
 exit

router ospf 10
 network 140.113.69.0 0.0.0.7 area 0
 network 140.113.69.8 0.0.0.7 area 0
 network 140.113.16.0 0.0.0.255 area 0
 network 140.113.24.0 0.0.0.255 area 0
 exit

# NYCU-IT
interface Gig0/0/0
 ip address 140.113.69.3 255.255.255.248
 ip ospf 10 area 0
 no shutdown
 exit

# CHT
interface Gig0/0/0
 ip address 140.113.69.9 255.255.255.248
 ip ospf 10 area 0
 no shutdown
 exit
# ----- FINISHED ----- #

# -------------------- #
# RIP
# CHT
router rip
 version 2
 network 1.0.0.0
 exit

interface Gig0/0/1
 ip address 1.1.1.0 255.0.0.0
 no shutdown

router ospf 10
 redistribute rip subnets
 redistribute rip metric-type 1
# ----- FINISHED ----- #

# -------------------- #
# FHRP
# Core-1
interface vlan 316
 standby version 2
 standby 0 ip 140.113.16.254
 standby 0 priority 200
 standby 0 preempt
 exit

interface vlan 324
 standby version 2
 standby 0 ip 140.113.24.254
 standby 0 priority 200
 standby 0 preempt
 exit

interface vlan 10
 standby version 2
 standby 10 ip 140.113.10.254
 standby 10 priority 200
 standby 10 preempt
 exit

interface vlan 20
 standby version 2
 standby 20 ip 140.113.2.146
 standby 20 priority 200
 standby 20 preempt
 exit

interface vlan 30
 standby version 2
 standby 30 ip 140.113.2.203
 standby 30 priority 200
 standby 30 preempt
 exit

# Core-2
interface vlan 316
 standby version 2
 standby 0 ip 140.113.16.254
 standby 0 priority 100
 standby 0 preempt
 exit

interface vlan 324
 standby version 2
 standby 0 ip 140.113.24.254
 standby 0 priority 100
 standby 0 preempt
 exit

interface vlan 10
 standby version 2
 standby 10 ip 140.113.10.254
 standby 10 priority 100
 standby 10 preempt
 exit

interface vlan 20
 standby version 2
 standby 20 ip 140.113.2.146
 standby 20 priority 100
 standby 20 preempt
 exit

interface vlan 30
 standby version 2
 standby 30 ip 140.113.2.203
 standby 30 priority 100
 standby 30 preempt
 exit
# ----- FINISHED ----- #

# -------------------- #
# GRE tunnel
# CHT
interface Tunnel69
 ip address 192.168.88.69 255.255.255.252
 tunnel source GigabitEthernet0/0/0
 tunnel destination 140.113.69.3

# NYCU-IT
interface Tunnel69
 ip address 192.168.88.70 255.255.255.252
 tunnel source GigabitEthernet0/0/0
 tunnel destination 140.113.69.9

ip route 0.0.0.0 0.0.0.0 192.168.88.69

router ospf 10
 default-information originate
# ----- FINISHED ----- #