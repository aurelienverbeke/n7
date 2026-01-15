# Afficher les commandes lancées
set -x

# Adresses IP
IP_MGMT="120.0.73.3" # Tyrannosaure
IP_DNS="120.0.73.254" # Velociraptor
IP_VOIP="120.0.73.252" # Dilophosaure
IP_MC="120.0.73.251" # Triceratops

IP_ROUTEUR="120.0.73.1"

# Activation des interfaces réseau
ip link set dev enp1s0f0 up
ip link set dev enp1s0f1 up
ip link set dev enp1s0f2 up
ip link set dev enp1s0f3 up

# Création des namespaces réseaux
ip netns add ns-dns
ip netns add ns-voip
ip netns add ns-mc

# Création des interfaces macvlan
ip link add macvlan-dns link enp1s0f0 type macvlan mode bridge
ip link add macvlan-voip link enp1s0f1 type macvlan mode bridge
ip link add macvlan-mc link enp1s0f2 type macvlan mode bridge

# Attribution des interfaces macvlan aux namespaces
ip link set macvlan-dns netns ns-dns
ip link set macvlan-voip netns ns-voip
ip link set macvlan-mc netns ns-mc

# Attribution des adresses IP
ip netns exec ns-dns ip addr add $IP_DNS/24 dev macvlan-dns
ip netns exec ns-voip ip addr add $IP_VOIP/24 dev macvlan-voip
ip netns exec ns-mc ip addr add $IP_MC/24 dev macvlan-mc
ip a add $IP_MGMT/24 dev enp1s0f3

# Activation des interfaces dans les namespaces
ip netns exec ns-dns ip link set macvlan-dns up
ip netns exec ns-dns ip link set lo up

ip netns exec ns-voip ip link set macvlan-voip up
ip netns exec ns-voip ip link set lo up

ip netns exec ns-mc ip link set macvlan-mc up
ip netns exec ns-mc ip link set lo up

# Route par défaut dans les namespaces
ip netns exec ns-dns ip route add default via $IP_ROUTEUR dev macvlan-dns
ip netns exec ns-voip ip route add default via $IP_ROUTEUR dev macvlan-voip
ip netns exec ns-mc ip route add default via $IP_ROUTEUR dev macvlan-mc

# Execution des scripts individuels
gnome-terminal --window -- bash -c "ip netns exec ns-dns bash ./scripts/tyrannosaure/velociraptor/velociraptor.sh; exec bash" & \
gnome-terminal --window -- bash -c "ip netns exec ns-voip bash ./scripts/tyrannosaure/dilophosaure/dilophosaure.sh; exec bash" & \
gnome-terminal --window -- bash -c "ip netns exec ns-mc bash ./scripts/tyrannosaure/triceratops/triceratops.sh; exec bash" &
