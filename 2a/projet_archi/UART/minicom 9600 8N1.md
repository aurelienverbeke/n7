lancement de minicom
--------------------

minicom -s

configuration du port série
---------------------------
- A :

        Port série /dev/ttyUSB? (à vérifier en regardant ce qui est actif)

- E :   

        Speed     C : 9600 bauds
        
        Parity    L : Aucune (ou None)
        
        Data      V : 8
        
        Stopbits  W : 1

    
        résultat 9600 8N1

- F : 

        Contrôle de flux matériel : Non

sortir de la configuration
--------------------------

fonctionnement
--------------

- vous avez maintenant à votre disposition un terminal minicom

- les caractères qui sont tapés au clavier sont transmis à la carte via le cable série votre uart les réceptionne un à un et les transmet au terminal via le port série

- tout ce que vous tapez doit apparaître dans le terminal minicom

- test émission seule : reset sur la carte -> la chaîne "Hello" s'affiche dans le terminal 

Quitter minicom
---------------

Crtl-A Z
Sortir et ràz  X
