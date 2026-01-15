# L'interface enp1s0f3 doit être branchée sur le port 2 du switch

#On affiche les commandes qu'on a faire
set -x 

ip link set dev enp1s0f3 up

ip a a 192.168.198.4/24 dev enp1s0f3

#On récupère l'IP du switch
TARGET_IP=$(ping -c 1 -b 192.168.198.255 | grep "bytes from" | head -n 1 | awk '{print $4}' | cut -d: -f1)

#Ces commandes sont rentrées dans le menu telnet
 (sleep 2

echo "cisco"

echo "sleep 1"

echo "en"

echo "sleep 1"

echo "cisco"

echo "sleep 2"

echo "config terminal"

# On commence par créer les VLAN
echo "vlan 50"

echo "name sallereu"

echo "exit"

echo "vlan 100"

echo "name sousboo"

echo "exit

"echo "vlan 200"

echo "name salleserveur"

echo "exit"

echo "vlan 300"

echo "name stockage"

echo "exit"

# Puis on met les ports dans leur VLAN associé
echo "interface Fa1/0/1"

echo "switchport access vlan 50"

#Le port numéro 2 sera réservé pour la config

echo "interface Fa1/0/3"

echo "switchport access vlan 50"

echo "interface Fa1/0/5"

echo "switchport access vlan 50"

echo "interface Fa1/0/7"

echo "switchport access vlan 50"

echo "interface Fa1/0/9"

echo "switchport access vlan 50"

echo "interface Fa1/0/11"

echo "switchport access vlan 50"

echo "interface Fa1/0/13"

echo "switchport access vlan 50"

echo "interface Fa1/0/4"

echo "switchport access vlan 200"

echo "interface Fa1/0/6"

echo "switchport access vlan 200"

echo "interface Fa1/0/8"

echo "switchport access vlan 300"

echo "interface Fa1/0/10"

echo "switchport access vlan 300"

echo "interface Fa1/0/12"

echo "switchport access vlan 300"

echo "interface Fa1/0/14"

echo "switchport access vlan 300"

echo "interface Fa1/0/16"

echo "switchport access vlan 300"

echo "interface Fa1/0/18"

echo "switchport access vlan 300"

echo "interface Fa1/0/20"

echo "switchport access vlan 300"

echo "interface Fa1/0/22"

echo "switchport access vlan 300"

echo "interface Fa1/0/24"

echo "switchport access vlan 300"

echo "interface Fa1/0/15"

echo "switchport access vlan 100"

echo "interface Fa1/0/17"

echo "switchport access vlan 100"

echo "interface Fa1/0/19"

echo "switchport access vlan 100"

echo "interface Fa1/0/21"

echo "switchport access vlan 100"

echo "interface Fa1/0/23"

echo "switchport access vlan 100"

) | telnet "$TARGET_IP"



set +x
