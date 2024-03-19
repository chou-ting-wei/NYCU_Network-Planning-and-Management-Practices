# -------------------- #
# entry
# login: entry
# Password: 112550013

# playground
# login: playground
# Password: 112550013

# nuclear
# login: nuclear
# Password: 112550013

# WAN PC IP: 192.168.0.56
# AP IP: 192.168.0.113
# VPN IP: 192.168.87.30
# -------------------- #

# -------------------- #
# Ethernet Settings
sudo nano /etc/netplan/00-installer-config.yaml
# yaml (entry)
ethernets:
    enp0s8:
      dhcp4: no
      addresses:
        - 192.168.131.1/24
# ---------- #
# yaml (nuclear)
ethernets:
    enp0s3:
      dhcp4: no
      addresses:
        - 192.168.131.2/24
# ---------- #
sudo netplan apply
# -------------------- #

# -------------------- #
# SSH Settings
sudo apt-get install openssh-server
sudo nano /etc/ssh/sshd_config
# sshd_config
port 9400
# ---------- #
sudo systemctl restart ssh.service
service ssh status

grep Port /etc/ssh/sshd_config
sudo lsof -i -n -P | grep LISTEN

sudo iptables-save
sudo iptables-save > ~/iptables.txt
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
# -------------------- #

# -------------------- #
# WAN Connectivity
# host to WAN -------- #
ping 8.8.8.8
# FINISHED
# ----- FINISHED ----- #

# entry to WAN ------- #
ping 8.8.8.8
# ----- FINISHED ----- #

# playground to WAN -- #
ping 8.8.8.8
# ----- FINISHED ----- #

# nuclear to WAN ----- #
# ip forwarding / masquerade
# entry
sudo nano /etc/sysctl.conf
# sysctl(entry)
net.ipv4.ip_forward = 1
# ---------- #
sudo sysctl -p

sudo apt-get update
sudo apt-get install iptables
sudo iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE

# nuclear
sudo ip route add default via 192.168.131.1

ping 8.8.8.8
# ----- FINISHED ----- #

# SSH

# WAN to entry ------- #
# port forwarding
ssh entry@[AP IP] -p 9400
# ----- FINISHED ----- #

# host to playground-- #
# port forwarding
ssh playground@localhost -p 22
# ----- FINISHED ----- #

# host to nuclear ---- #
# ssh proxy jump / ssh tunnel
ssh nuclear@192.168.131.2 -p 9400 -J entry@192.168.87.5:9400
# ----- FINISHED ----- #

# WAN to playground -- #
# VPN + ssh tunnel
ssh playground@192.168.87.10 -p 22
# ----- FINISHED ----- #

# WAN to nuclear ----- #
# ssh tunnel + port forwarding
# WAN PC
ssh -N -L 4700:192.168.131.2:9400 entry@[AP IP] -p 9400
ssh nuclear@localhost -p 4700
# ----- FINISHED ----- #
