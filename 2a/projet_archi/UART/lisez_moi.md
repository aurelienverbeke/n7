Travail à réaliser
==================

Le travail est en deux étapes :

- étape 3 : valider l'UART en émission (TxUnit) 

  les instructions sont données dans les fichiers *validation_uart_émission.md* pour le développement à réaliser et *minicom 9600 8N1.md* pour le fonctionnement avec l'ordinateur.

  En plus des fichiers VHDL à écrire ou compléter, vous écrirez un script tcl (vous pouvez vous inspirer de celui du répertoire **clkUnit**) permettant de générer le fichier _bitstream_.

  Les développements de cette étape font l'objet du rendu du 10 janvier (voir instructions de rendu sous Moodle)

- étape 4 :

  - étape 4.1 : développer et valider le composant RxUnit en simulation

    Vous devez en particulier écrire les tests montrant le bon fonctionnement de votre composant dans les différentes situations possibles de réception (un et plusieurs réception OK, bit de stop faux, pas de lecture de la donnée) ainsi que le fichier Makefile permettant d'obtenir les résultats de ces simulations

  - étape 4.2 : le valider sur la carte (le fonctionnement complet est aussi décrit dans les 2 fichiers *validation_uart_émission.md et *minicom 9600 8N1.md*)

    Normalement pour cette étape, il n'y a pas de nouveau fichier VHDL à développer.

   Les développements de cette étape 4 font l'objet du rendu final du 16 janvier (voir instructions de rendu sous Moodle)