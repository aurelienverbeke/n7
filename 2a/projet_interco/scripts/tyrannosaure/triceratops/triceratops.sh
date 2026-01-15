# !/bin/bash

# Attendre la fin des autres installations apt
while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
    echo "Attente du lock dpkg..."
    sleep 2
done

# Installation des paquets nécessaires pour le serveur Minecraft
dpkg -i ./scripts/tyrannosaure/triceratops/pkgs/*.deb

# Lancement du serveur Minecraft
cd ./scripts/tyrannosaure/triceratops/mc
java -Xms4G -Xmx4G -jar paper.jar nogui
