# -------------------- #
# Advertise Networks
router ospf 42

# CS-Core1 - 140.113.0.21
network 10.0.12.0 0.0.0.3 area 0 # CT-Core
network 10.2.11.0 0.0.0.3 area 20 # CS-Lab
network 10.2.12.0 0.0.0.3 area 20 # CS-Colo
network 10.2.13.0 0.0.0.3 area 20 # CS-Intra

# CS-Core2 - 140.113.0.22
network 10.0.13.0 0.0.0.3 area 0 # CT-Core
network 10.2.21.0 0.0.0.3 area 20 # CS-Lab
network 10.2.22.0 0.0.0.3 area 20 # CS-Colo
network 10.2.23.0 0.0.0.3 area 20 # CS-Intra

# CS-Lab - 140.113.0.23
network 10.2.11.0 0.0.0.3 area 20 # CS-Core1
network 10.2.21.0 0.0.0.3 area 20 # CS-Core2
network 140.113.22.0 0.0.0.255 area 20 # 140.113.22.5

# CS-Colo - 140.113.0.24
network 10.2.12.0 0.0.0.3 area 20 # CS-Core1
network 10.2.22.0 0.0.0.3 area 20 # CS-Core2
network 140.113.24.0 0.0.0.255 area 20 # 140.113.24.5

# CS-Intra - 140.113.0.25
network 10.2.13.0 0.0.0.3 area 20 # CS-Core1
network 10.2.23.0 0.0.0.3 area 20 # CS-Core2
network 140.113.26.0 0.0.0.255 area 20 # 140.113.26.5
network 140.113.28.0 0.0.0.255 area 20 # 140.113.28.5
# ----- FINISHED ----- #

# -------------------- #
# Private Network 
# CS-Core1 - 140.113.0.21
ip route 140.113.28.0 255.255.255.0 null0

# CS-Core2 - 140.113.0.22
ip route 140.113.28.0 255.255.255.0 null0
# ----- FINISHED ----- #

# -------------------- #
# Passive Interface
router ospf 42

# Dorm-10 - 140.113.0.12
no passive-interface GigabitEthernet1/0/1

# Dorm-12 - 140.113.0.13
no passive-interface GigabitEthernet1/0/1
# ----- FINISHED ----- #

# -------------------- #
# Intergate with RIP
# Med-Core - 140.113.0.31
router ospf 42
redistribute rip subnets
redistribute rip metric-type 1
# ----- FINISHED ----- #

# -------------------- #
# Stub Area
# Med - *
# Med-Core - 140.113.0.31
router ospf 42
area 30 nssa no-summary

# Med-FooLab - 140.113.0.32
router ospf 42
area 30 nssa

# YM-Dorm - *
# YM-Dorm-Core - 140.113.0.41
router ospf 42
area 40 stub no-summary

# Dorm-B3 - 140.113.0.42
# Dorm-G1 - 140.113.0.43
router ospf 42
area 40 stub
# ----- FINISHED ----- #

# -------------------- #
# Cost
# ---------- #
# CT - Core1 10.0.12.x
# CT - Core2 10.0.13.x
# Core1 - Lab 10.2.11.x
# Core1 - Colo 10.2.12.x
# Core1 - Intra 10.2.13.x
# Core2 - Lab 10.2.21.x
# Core2 - Colo 10.2.22.x
# Core2 - Intra 10.2.23.x
# ---------- #

# CT-Core - 140.113.0.2
# CT-Core#show ip route
#     10.0.0.0/30 is subnetted, 21 subnets
# O IA    10.2.11.0 [110/2] via 10.0.12.2, 00:19:40, GigabitEthernet1/0/4
# O IA    10.2.12.0 [110/2] via 10.0.12.2, 00:19:40, GigabitEthernet1/0/4
# O IA    10.2.13.0 [110/2] via 10.0.12.2, 00:19:40, GigabitEthernet1/0/4
# O IA    10.2.21.0 [110/2] via 10.0.13.2, 00:19:40, GigabitEthernet1/0/5
# O IA    10.2.22.0 [110/2] via 10.0.13.2, 00:19:40, GigabitEthernet1/0/5
# O IA    10.2.23.0 [110/2] via 10.0.13.2, 00:19:40, GigabitEthernet1/0/5
#     140.113.0.0/24 is subnetted, 10 subnets
# O IA    140.113.22.0 [110/3] via 10.0.13.2, 00:19:40, GigabitEthernet1/0/5
#                      [110/3] via 10.0.12.2, 00:19:40, GigabitEthernet1/0/4
# O IA    140.113.24.0 [110/3] via 10.0.13.2, 00:19:40, GigabitEthernet1/0/5
#                      [110/3] via 10.0.12.2, 00:19:40, GigabitEthernet1/0/4
# O IA    140.113.26.0 [110/3] via 10.0.13.2, 00:19:40, GigabitEthernet1/0/5
#                      [110/3] via 10.0.12.2, 00:19:40, GigabitEthernet1/0/4
# O IA    140.113.28.0 [110/3] via 10.0.13.2, 00:19:40, GigabitEthernet1/0/5
#                      [110/3] via 10.0.12.2, 00:19:40, GigabitEthernet1/0/4

# CT-Core#show ip route
#      10.0.0.0/30 is subnetted, 21 subnets
# O IA    10.2.11.0 [110/101] via 10.0.12.2, 00:07:06, GigabitEthernet1/0/4
# O IA    10.2.12.0 [110/2] via 10.0.12.2, 00:07:06, GigabitEthernet1/0/4
# O IA    10.2.13.0 [110/2] via 10.0.12.2, 00:07:06, GigabitEthernet1/0/4
# O IA    10.2.21.0 [110/2] via 10.0.13.2, 00:07:06, GigabitEthernet1/0/5
# O IA    10.2.22.0 [110/101] via 10.0.13.2, 00:07:06, GigabitEthernet1/0/5
# O IA    10.2.23.0 [110/101] via 10.0.13.2, 00:07:06, GigabitEthernet1/0/5
#      140.113.0.0/24 is subnetted, 10 subnets
# O IA    140.113.22.0 [110/3] via 10.0.13.2, 00:07:06, GigabitEthernet1/0/5
# O IA    140.113.24.0 [110/3] via 10.0.12.2, 00:07:06, GigabitEthernet1/0/4
# O IA    140.113.26.0 [110/3] via 10.0.12.2, 00:06:46, GigabitEthernet1/0/4
# O IA    140.113.28.0 [110/3] via 10.0.12.2, 00:06:46, GigabitEthernet1/0/4
# S*   0.0.0.0/0 [1/0] via 10.0.10.2
#                [1/0] via 10.0.20.2

# CS-Core1 - 140.113.0.21
interface GigabitEthernet1/0/2 # CS-Lab
ip ospf cost 100 

# CS-Core2 - 140.113.0.22
interface GigabitEthernet1/0/3 # CS-Colo
ip ospf cost 100 

interface GigabitEthernet1/0/4 # CS-Intra
ip ospf cost 100 

# CS-Lab - 140.113.0.23 
# CS-Lab <–> CS-Core2
interface GigabitEthernet1/0/1 # CS-Core1
ip ospf cost 100 

# CS-Colo - 140.113.0.24
# CS-Colo <–> CS-Core1
interface GigabitEthernet1/0/2 # CS-Core2
ip ospf cost 100 

# CS-Intra - 140.113.0.25
# CS-Intra <–> CS-Core1
interface GigabitEthernet1/0/2 # CS-Core2
ip ospf cost 100 
# ----- FINISHED ----- #

# -------------------- #
# Debug YM-Dorm
# YM-Dorm-Core - 140.113.0.41
# YM-Dorm-Core#show ip ospf 42 neighbor 
# Neighbor ID     Pri   State           Dead Time   Address         Interface
# 140.113.0.41      1   EXSTART/BDR     00:00:32    10.4.1.2        GigabitEthernet1/0/2
# 140.113.0.41      1   EXSTART/BDR     00:00:32    10.4.2.2        GigabitEthernet1/0/3
# 140.113.0.3       1   FULL/BDR        00:00:32    10.0.21.1       GigabitEthernet1/0/1

# YM-Dorm-Core#show ip ospf 42 neighbor 
# Neighbor ID     Pri   State           Dead Time   Address         Interface
# 140.113.0.42      1   FULL/DR         00:00:32    10.4.1.2        GigabitEthernet1/0/2
# 140.113.0.43      1   FULL/DR         00:00:32    10.4.2.2        GigabitEthernet1/0/3
# 140.113.0.3       1   FULL/BDR        00:00:32    10.0.21.1       GigabitEthernet1/0/1

# Dorm-B3 - 140.113.0.42
# Dorm-B3#show ip protocols 
# Routing Protocol is "ospf 42"
#   Outgoing update filter list for all interfaces is not set 
#   Incoming update filter list for all interfaces is not set 
#   Router ID 140.113.0.41
#   Number of areas in this router is 1. 0 normal 1 stub 0 nssa
#   Maximum path: 4
#   Routing for Networks:
#     10.4.1.0 0.0.0.3 area 40
#     140.113.43.0 0.0.0.255 area 40
#   Routing Information Sources:  
#     Gateway         Distance      Last Update 
#     140.113.0.41         110      00:08:28
#   Distance: (default is 110)

router ospf 42
router-id 140.113.0.42

# Dorm-G1 - 140.113.0.43
# Dorm-G1#show ip protocols 
# Routing Protocol is "ospf 42"
#   Outgoing update filter list for all interfaces is not set 
#   Incoming update filter list for all interfaces is not set 
#   Router ID 140.113.0.41
#   Number of areas in this router is 1. 0 normal 1 stub 0 nssa
#   Maximum path: 4
#   Routing for Networks:
#     10.4.2.0 0.0.0.3 area 40
#     140.113.41.0 0.0.0.255 area 40
#   Routing Information Sources:  
#     Gateway         Distance      Last Update 
#     140.113.0.41         110      00:08:32
#   Distance: (default is 110)

router ospf 42
router-id 140.113.0.43
# ----- FINISHED ----- #

# -------------------- #
# Debug Med 
# Med-Core - 140.113.0.31
# ---------- #
# interface GigabitEthernet1/0/1
#  no switchport
#  ip address 10.0.22.2 255.255.255.252
#  ip ospf priority 0
#  duplex auto
#  speed auto
# ---------- #
# Med-Core#show ip ospf neighbor 
# Neighbor ID     Pri   State           Dead Time   Address         Interface
# 140.113.0.3       1   FULL/DR         00:00:30    10.0.22.1       GigabitEthernet1/0/1
# 140.113.0.32      0   2WAY/DROTHER    00:00:30    10.3.1.2        GigabitEthernet1/0/2

interface GigabitEthernet1/0/1
no ip ospf priority 0

# Med-Core#show ip ospf 42 neighbor 
# Neighbor ID     Pri   State           Dead Time   Address         Interface
# 140.113.0.3       1   FULL/BDR        00:00:33    10.0.22.1       GigabitEthernet1/0/1
# 140.113.0.32      1   FULL/DR         00:00:33    10.3.1.2        GigabitEthernet1/0/2

# Med-FooLab - 140.113.0.32
# ---------- #
# interface GigabitEthernet1/0/1
#  no switchport
#  ip address 10.3.1.2 255.255.255.252
#  ip ospf priority 0
#  duplex auto
#  speed auto
# ---------- #
# Med-FooLab#show ip ospf neighbor 
# Neighbor ID     Pri   State           Dead Time   Address         Interface
# 140.113.0.31      0   2WAY/DROTHER    00:00:39    10.3.1.1        GigabitEthernet1/0/1

interface GigabitEthernet1/0/1
no ip ospf priority 0

# Med-FooLab#show ip ospf 42 neighbor 
# Neighbor ID     Pri   State           Dead Time   Address         Interface
# 140.113.0.31      0   FULL/DROTHER    00:00:31    10.3.1.1        GigabitEthernet1/0/1
# ----- FINISHED ----- #
