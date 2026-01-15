# Afficher les commandes lancées
set -x

# Reglage IP interface
ip link set dev eth0 up
ip a a 120.0.72.254/25 dev eth0
ip r a default via 120.0.72.129

# DNS Bind9
systemctl restart bind9

# Ne plus afficher les commandes lancées
set +x
