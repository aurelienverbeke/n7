## Cette archive contient trois répertoires

1. le répertoire _tp2_work_ (VIDE !) où placer les fichiers source des nouveaux composants développés pendant cette séance.

2. le répertoire _dec7seg2025_ contient un composant fourni, décodeur 7 segments, qui est l'exemple sur lequel nous allons nous appuyer au cours de cette prise en main.

Ce composant est décrit sous la forme de 4 fichiers :

- un fichier *dec7seg.vhd* qui décrit un composant qui convertit un chiffre hexadécimal en 7 segments,
- un fichier *Nexys4_dec7seg.vhd* qui est le composant principal qui utilise le composant précédent et le connecte à certains ports de la carte (switchs, 7 segments, ...), utile quelque soit la carte utilisée,
- pour la carte Nexys 4,un fichier *Nexys4_dec7seg.xdc* qui fait le lien entre les noms de ports de la carte utilisés par le composant précédent et leurs noms réels sur la carte,
- pour la carte Nexys 4 DDR, un fichier *Nexys4_DDR_dec7seg.xdc* qui fait le lien entre les noms de ports de la carte utilisés par le composant précédent et leurs noms réels sur la carte.

3. le répertoire _config_ qui contient les 3 fichiers *Nexys4.vhd*, *Nexys4.xdc* et *Nexys4_DDR.xdc* plus complets.

Suivant votre carte, les 2 fichiers (*Nexys4.vhd* et le fichier *xdc* correspondant) du répertoire _config_ servent de base à tout nouveau projet ; ils seront à utiliser dans la 3ième partie de ce TP et dans la suite des TP et projet(s).

VOUS LES COPIEREZ DANS LE RÉPERTOIRE OÙ SONT LES SOURCES (les fichiers vhd) DE VOTRE COMPOSANT À IMPLANTER SUR LA CARTE AVANT DE LES MODIFIER