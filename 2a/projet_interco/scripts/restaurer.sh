# Afficher les commandes lancées
set -x

# Restaurer les fichiers initiaux
cp sauvegardes/dnsmasq.conf /etc/
cp sauvegardes/daemons sauvegardes/zebra.conf sauvegardes/ospfd.conf /etc/quagga/

# Ne plus afficher les commandes lancées
set +x