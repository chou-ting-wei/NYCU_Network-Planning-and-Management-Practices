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
# -------------------- #