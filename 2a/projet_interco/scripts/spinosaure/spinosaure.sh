# Afficher les commandes lancées
set -x

# Activation interfaces
ip link set dev enp1s0f0 up
ip link set dev enp1s0f1 up
ip link set dev enp1s0f2 up
ip link set dev enp1s0f3 up

# Obtention IP publique
dhclient enp1s0f0

# Bridge sur interfaces partie privee
ip link add bridge_clients type bridge
ip link set dev bridge_clients up
ip link set enp1s0f1 master bridge_clients
ip link set enp1s0f2 master bridge_clients
ip link set enp1s0f3 master bridge_clients
ip a a 192.168.0.1/24 dev bridge_clients

# DNS partie privee
cp dnsmasq.conf /etc/
systemctl start dnsmasq

# Masquarade
iptables -t nat -A POSTROUTING -o enp1s0f0 -j MASQUERADE

# Ne plus afficher les commandes lancées
set +x