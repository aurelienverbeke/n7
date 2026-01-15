# !/bin/bash

# Attendre la fin des autres installations apt
while fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
    echo "Attente du lock dpkg..."
    sleep 2
done

# Installation des paquets nécessaires pour Asterisk
dpkg -i ./scripts/tyrannosaure/dilophosaure/pkgs/*.deb

# Copie des fichiers de configuration d'Asterisk
cp ./scripts/tyrannosaure/dilophosaure/*.conf /etc/asterisk/

# Lancement d'Asterisk en mode console avec utilisateur asterisk
systemctl stop asterisk
asterisk -g -f -U asterisk -cvvvvv
