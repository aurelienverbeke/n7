Carte cible : Nexys4 DDR

Travail à réaliser
==================

une fois que l'émetteur est validé par la simulation, vous pouvez le valider en
synthèse :

1. écrire une architecture "vide" de l'unité de réception RxUnit (il s'agit de donner des valeurs nulles aux 4 signaux de sortie)

2. écrire l'architecture de l'UART en connectant les 4 unités (Figure 2 du sujet)

3. UART_FPGA_N4.vhd est à modifier pour représenter le composant principal sur le FPGA (voir uart_fpga.pdf)
   (n'oubliez pas de rajouter dans l'interface et le fichier UART_FPGA_N4.xdc ou UART_FPGA_N4_DDR.xdc, les signaux correspondant à la ligne série, voir _reference manual_, au besoin enlever les ports inutiles).

Cette configuration vous permettra de tester l'UART complète lors de la dernière étape mais aussi l'émission seule pour l'étape courante.

Il faut pour cela ouvrir un terminal _minicom_ (voir fichier "minicom 9600 8N1.md").

Pour cette étape et pour tester l'émetteur en synthèse, il suffit de faire un reset : le reset de l'echoUnit initiant l'émission de la chaîne "Hello", caractères par caractère, qui doit s'afficher dans le _minicom_.

En fonctionnement final (dernière étape), un caractère tapé au clavier est

    - transmis via la liaison RS232 à l'UART implantée sur la carte,
    - réceptionné par cette UART,
    - lu par l'unité echoUnit qui joue le rôle du processeur
    - demandé à être émis par cette unité
    - transmis par l'UART via la liaison RS232 et afficher dans le minicom 

Si le TxUnit fonctionne (vous transmettez bien "Hello" de l'UART vers le minicom), il ne vous restera plus "qu'à développer" l'unité de réception RxUnit, les autres composants ne devant pas, a priori, évoluer.

