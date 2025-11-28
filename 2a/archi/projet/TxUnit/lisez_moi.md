Travail à réaliser
==================

- compléter architecture du composant TxUnit (TxUnit.vhd)
- bien lire le process stim_proc du test pour comprendre comment l'envoi est programmé
- compléter avec des tests qui montrent que la prise en compte de la demande d'émission d'un autre caractère se fait lorsqu'on émet un caractère et ceci quelque soit l'étape d'émission

Simulation
==========

simulation avec test fourni (un seul envoi) (../clkUnit/clkUnit.vhd, TxUnit.vhd, testTxUnit.vhd)

- avec Vivado
- avec ghdl
    - make
    - gtkwave output.vcd
    
attention à la durée de la simulation donnée dans le Makefile : il peut être nécessaire de l'allonger (c'est aussi vrai avec Vivado)

