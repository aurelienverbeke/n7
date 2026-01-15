# Afficher les commandes lancées
set -x

# Reglage IP interface
ip link set dev enp1s0f0 up
ip link set dev enp1s0f1 up
ip link set dev enp1s0f2 up
ip link set dev enp1s0f3 up
ip a a 120.0.72.3/25 dev enp1s0f0


#Pour devenir un routeur
echo 1 > /proc/sys/net/ipv4/ip_forward

#On crée un bridge
brctl addbr netbridge
brctl addif netbridge enp1s0f1
brctl addif netbridge enp1s0f2
brctl addif netbridge enp1s0f3
ifconfig enp1s0f1 0.0.0.0
ifconfig enp1s0f2 0.0.0.0
ifconfig enp1s0f3 0.0.0.0
ifconfig netbridge up

ip a a 120.0.72.129/25 dev netbridge

# Routeur OSPF
cp daemons ospfd.conf /etc/quagga/
systemctl restart quagga

#On rajoute des routes
ip r a 120.0.73.0/24 via 120.0.72.1

# Ne plus afficher les commandes lancées
set +x
