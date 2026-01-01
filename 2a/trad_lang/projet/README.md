# Pour le rapport : explication des implémentations

## Pointeurs

## Procédures

On ne crée pas un type InfoProcedure équivalent de `InfoFun`. Cela impliquerait une duplication des analyses de fonction dans toutes les passes. On fera tout à partir du type de retour qui sera donc `Void`.

Par contre, on crée un `AppelProcedure` different de `AppelFonction` pour ne pas confondre entre l'expression et l'instruction, et on créera une fonction d'analyse des appels annexe qui évitera les duplications de code entre les deux.

Pour le `Retour` : on choisit de créer une expression `RetourVoid` pour les procédures. Ca évitera les `if` à rallonge dans les analyses de `Retour`...


# Idées d'améliorations

## Pointeurs

- [ ] Affichage
- [ ] Addition (attention gestion avec compatibilité entre `Undefined` et `Pointeur of ...`)