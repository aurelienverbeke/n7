Carte utilisée
==============

Nexys4 DDR

Travail à réaliser
==================

compléter l'architecture du composant clkUnit (clkUnit.vhd)

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
    - vivado -mode tcl -source script_bitstream.tcl (on utilise le script compiler.sh)
    - nexys2prog Nexys4.bit
