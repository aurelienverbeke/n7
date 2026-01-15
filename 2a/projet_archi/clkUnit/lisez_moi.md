Travail à réaliser
==================

compléter l'architecture du composant clkUnit (clkUnit.vhd)

Carte cible :
==================

Nexys4 DDR

Simulation
==========

simulation avec un test simple (clkUnit.vhd, testClkUnit.vhd)

- avec Vivado
- avec ghdl
    - make
    - gtkwave output.vcd

Synthèse
========
 
synthèse pour vérifier que le composant développé est synthétisable
(clkUnit.vhd, diviseurClk10Hz.vhd, Nexys4.vhd, Nexys4.xdc ou Nexys4_DDR.xdc)

- avec vivado
- avec le script tcl (attention à choisir le bon fichier xdc)
    - vivado -mode tcl -source script_bitstream.tcl
    - nexys2prog Nexys4.bit
