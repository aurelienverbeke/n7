# A faire

- Vérifier que définir une variable en void* ou void** ça crashe. Pour ça, on peut définir qqc comme une fonction `type_primitif` qui renvoie le type pointé ou multi-pointé, et on vérifie que ce n'est pas void.

# Pour le rapport : explication des implémentations

## Pointeurs

$$\sigma \vdash null : \text{Undefined}^*$$

$$\frac{\sigma \vdash x : t^*}{\sigma \vdash (^* t) : t}$$

$$\frac{\sigma \vdash x : t}{\sigma \vdash (\& t) : t^*}$$

## Procédures

On ne crée pas un type InfoProcedure équivalent de `InfoFun`. Cela impliquerait une duplication des analyses de fonction dans toutes les passes. On fera tout à partir du type de retour qui sera donc `Void`.

Par contre, on crée un `AppelProcedure` different de `AppelFonction` pour ne pas confondre entre l'expression et l'instruction, et on créera une fonction d'analyse des appels annexe qui évitera les duplications de code entre les deux.

Pour le `Retour` : on choisit de créer une expression `RetourVoid` pour les procédures. Ca évitera les `if` à rallonge dans les analyses de `Retour`...

## Références

$$\frac{\sigma \vdash x : t}{\sigma \vdash \text{ref} \; x : t}$$

$$\frac{\sigma \vdash \text{ref} \; x : t}{\sigma \vdash x : t}$$

Pour l'implémentation on pourrait :

- créer un type `Reference of ...`
- les traiter comme des pointeurs dans la phase de traduction de code

On fait finalement le choix d'ajouter un type pour ne pas avoir de code "sale".

Comment gérer le fait qu'on peut transmettre des variables à des emplacements mémoire différents pour une même fonction qui doit avoir des emplacements mémoires intrinsecs fixes ?<br>
&rarr; On choisit de transformer toutes les références en pointeurs. On fait cela à la fin de la passe de typage, c'est la dernière qui vérifie les erreurs du programmeur et la passe de placement mémoire devra travailler sur un espace propre.

# Idées d'améliorations

## Pointeurs

- [ ] Affichage