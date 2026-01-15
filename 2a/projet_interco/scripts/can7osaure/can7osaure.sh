# Afficher les commandes lancées
set -x

# Reglage IP interface
ip link set dev enp1s0f0 up
ip link set dev enp1s0f1 up
ip a a 120.0.72.2/25 dev enp1s0f0
ip a a 120.0.64.1/21 dev enp1s0f1

# DNS pour boxs
cp dnsmasq.conf /etc/
systemctl start dnsmasq

# Routeur OSPF
cp daemons ospfd.conf /etc/quagga/
systemctl restart quagga

# Ne plus afficher les commandes lancées
set +x