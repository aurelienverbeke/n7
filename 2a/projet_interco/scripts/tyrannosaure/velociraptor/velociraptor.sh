# !/bin/bash

# Copie des fichiers de configuration de Bind9
cp -R ./scripts/tyrannosaure/velociraptor/bind/ /etc/bind/

# Lancement de Bind9 en mode console
named -g
