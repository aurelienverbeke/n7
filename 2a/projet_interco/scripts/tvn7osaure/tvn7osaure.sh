# Afficher les commandes lancées
set -x

# Reglage IP interface
ip link set dev enp1s0f0 up
ip link set dev enp1s0f1 up
ip a a 120.0.72.1/25 dev enp1s0f0
ip a a 120.0.73.1/24 dev enp1s0f1

#Pour devenir un routeur
echo 1 > /proc/sys/net/ipv4/ip_forward

# Routeur OSPF
cp daemons ospfd.conf /etc/quagga/
systemctl restart quagga

# Ne plus afficher les commandes lancées
set +x
