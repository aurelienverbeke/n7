# Questions

### Réseau sémaphore

Un PS par CA ou CTS et un PTS au milieu.

### Routage à partage de charge

##### Intro

Le routage est statique et repose sur la topologie du réseau et l’adressage géographique et hiérarchique. Pas de lien direct entre les deux CA donc on envoie la demande d’appel vers un CTS – par exemple le CTS-1. (si pas de place appel refusé). Il y a un lien depuis le CTS-1 vers CA-3 on y envoie l’appel (si pas de place, appel refusé) Routage bond par bond.

##### Infos nécessaires

- Etat des liens
- Capacité des liens
- Table de routage

##### Implémentation

Si l’on ne considère que le routage des appels entre CA1 et CA3. Vu de CA1, On constate qu’il y a trois chemins de longueur 2 et on peut s’en arrêter là. Dans ce cas, on peut envoyer 1/3 des appels à CA2, 1/3 des appels à CTS1 et 1/3 des appels à CTS2. Vu la symétrie du réseau, la prise en compte des chemins de longueur 3, n’apporterait pas grand chose car on constate qu’il y autant de chemins de longueur 3 qui passent par CA2, CT1 et CTS2. Quels que soient les poids que l’on accorderait alors à ces chemins (et du coup la réduction des poids attribués aux chemins de longueur 2), on obtiendrait qu’il faut envoyer 1/3 des appels à CA2, CTS1 et CTS2. Maintenant si l’on se place du point de vue de CTS1 (qui voit passer 1/3 de ces appels). On fait du routage « bond par bond » donc il va dépendre de l’adresse du destinataire qui est sur CA3. On a un seul chemin de longueur 1. On peut s’arrêter là. On peut tenir compte des chemins de longueur 2, il y en a 2 (un par CA2 et l’autre par CTS2). On peut donc décider d’envoyer 1/2 des appels sur le lien direct ; 1/4 des appels par CA2 et 1/4 à CTS2.

##### Risques

Attention le premier lien peut être plein et sans connaissance supplémentaire provenant des autres commutateurs, on peut simplement faire évoluer ces poids en enlevant les liens pleins. Les risques encourus sont les suivants :

- Sauf sur les chemins de longueur 1, on peut avoir des saturations sur les liens suivants alors que l’on aurait eu de la place sur d’autres chemins
- Boucle

### Routage adaptatif

Le principe du routage adaptatif, comme son nom l’indique va être de donner lieu à des calculs de route régulièrement et à le paramétrer en fonction de l’état du réseau. On ne le déroule pas à l’échelle de temps de la communication téléphonique, ce serait trop lent (mais c’était déjà le cas des routages précédents). En l’occurrence, il ne pourra pas garantir qu’il y aura de la place sur le chemin qui va finalement emprunter car entre le moment où l’information d’encombrement qui a été transmise par les autres commutateurs puis le calcul du routage et enfin l’arrivée de la demande de communication téléphonique, l’état du réseau a changé et il peut très bien ne plus y avoir de place sur l’un des liens qui a été choisi. Attention, on fait bien du routage bond par bond et donc quand on va arriver sur le lien qui sera plein, on pourra ne pas l’envoyer sur ce lien-là… mais il peut ne plus y avoir de choix (à moins de provoquer des boucles). Notons tout de même qu’au moment où on a pris la décision avec l’algorithme de routage, on avait sélectionné un chemin court et où il y avait de la place. Pour essayer d’améliorer, on peut prendre de la marge et donc ne retenir un chemin que s’il y a encore un certain nombre de places et le cas échéant pré-sélectionner un chemin un peu plus long. Pour ce qui est des boucles, on retombe dans le problème des algorithmes distribués. Néanmoins, cette fois-ci, on ne retient qu’un chemin dans l’algorithme, celui qui est le meilleur au sens des métriques (longueur, capacité résiduelle) et donc un prochain commutateur, ce qui évite une partie des risques liés au partage de charge entre plusieurs chemins. Attention, les incohérences des tables de routage sont toujours des problèmes épineux.

### Routage MTP-3

Le niveau MTP-3 gère le routage des messages de signalisation.

- **CA1 vers CA2 :** Routage direct si le lien sémaphore existe, sinon via un CTS (PTS).
- **CA1 vers CTS1 :** Routage direct (mode associé).
- **CA1 vers CA3 :** Routage en mode quasi-associé. CA1 envoie le message à CTS1 (ou CTS2) avec le DPC (Destination Point Code) de CA3. CTS1 lit le DPC et relaie vers CA3.

### Transfert d'appel

*Simple*

1. **IAM (Initial Address Message)** de CA1 vers CA2 (pour appeler U2).
2. CA2 analyse le profil de U2 et détecte le renvoi vers U3.
3. **ACM (Address Complete)** peut être envoyé par CA2 à CA1 pour indiquer que le numéro est valide (optionnel selon le type de renvoi).
4. CA2 initie un nouvel **IAM** vers CA3 (le commutateur de U3).
5. CA3 fait sonner U3 et renvoie **ACM** vers CA2, qui le relaie (ou CPG - Call Progress) vers CA1.
6. Quand U3 décroche, **ANM (Answer Message)** remonte de CA3 -> CA2 -> CA1.
7. Le circuit de parole est établi : U1 <-> CA1 <-> CA2 <-> CA3 <-> U3.

*Détaillé*

1. Phase d'Établissement (Setup) : U1 vers CA2
U1 -> CA1 : Envoi de la numérotation (Setup).
CA1 -> CA2 : Envoi du message IAM (Initial Address Message).
Contenu : Numéro de l'appelant (U1), Numéro de l'appelé (U2).
Routage : CA1 route le message via un CTS vers CA2.
2. Détection et Renvoi (Forwarding) : Au niveau de CA2
CA2 reçoit l'IAM et analyse le numéro de U2.
CA2 consulte sa base de données : U2 a activé un "Transfert d'appel inconditionnel" vers le numéro de U3.
CA2 -> CA1 : Envoi du message CPG (Call Progress) ou parfois ACM avec une indication de redirection.
But : Informer CA1 que l'appel est redirigé (pour affichage éventuel chez U1 "Redirection vers...").
3. Nouvel Établissement : CA2 vers CA3
CA2 agit maintenant comme un commutateur de départ pour la nouvelle jambe de l'appel.
CA2 -> CA3 : Envoi d'un nouvel IAM.
Contenu : Appelant (U1), Appelé (U3), et champ "Original Called Number" (U2) pour indiquer qu'il s'agit d'un renvoi.
4. Confirmation et Sonnerie (Ringing)
CA3 vérifie que U3 est libre et le fait sonner.
CA3 -> CA2 : Envoi de ACM (Address Complete Message).
CA2 -> CA1 : Relai du message ACM.
Résultat : U1 entend la tonalité de retour d'appel (sonnerie), générée par CA1 ou CA2 selon le réseau.
5. Connexion (Answer)
U3 décroche.
CA3 -> CA2 : Envoi de ANM (Answer Message).
CA2 -> CA1 : Relai du message ANM.
Le circuit de parole est verrouillé de bout en bout : U1 <-> CA1 <-> CTS <-> CA2 <-> CTS <-> CA3 <-> U3.

Note importante sur les ressources : Bien que U2 ne parle pas, le chemin traverse CA2. La connexion occupe donc deux circuits : un circuit entre CA1 et CA2, et un circuit entre CA2 et CA3. C'est ce qu'on appelle souvent un routage en "trombone" ou "hairpinning", qui consomme plus de ressources qu'un reroutage direct, mais simplifie la facturation (U1 paie U1->U2, et U2 paie la portion U2->U3).

### Routage hiérarchique

On passe par un CTS avant de redescendre au CA cible, en partant du principe que tous les CTS sont reliés à tous les CA.