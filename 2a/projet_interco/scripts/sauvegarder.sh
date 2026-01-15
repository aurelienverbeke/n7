# Afficher les commandes lancées
set -x

# Sauvegarder les fichiers initiaux
mkdir -p sauvegardes
cp /etc/dnsmasq.conf sauvegardes/
cp /etc/quagga/daemons /etc/quagga/zebra.conf /etc/quagga/ospfd.conf sauvegardes/

# Ne plus afficher les commandes lancées
set +x