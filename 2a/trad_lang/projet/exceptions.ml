open Type
open Ast.AstSyntax

(* Exceptions pour la gestion des identificateurs *)
exception DoubleDeclaration of string 
exception IdentifiantNonDeclare of string 
exception MauvaiseUtilisationIdentifiant of string 

(* Exceptions pour le typage *)
exception TypeInattendu of typ * typ     (* Le premier type est le type réel, le second est le type attendu *)
exception TypesParametresInattendus of typ list * typ list (* types réels, types attendus *)
exception TypeBinaireInattendu of binaire * typ * typ      (* les types réels non compatibles avec les signatures connues de l'opérateur *)
exception TypeVoidHorsTypeProcedure (* Le type void ne sert qu'à définir une procedure *)
exception DereferencementImpossible (* On cherche à déréférencer un non-pointeur *)
exception AffichageNonSupporte (* On cherche à afficher quelque chose qui n'est pas un entier, un booléen ou un rationnel *)

(* Utilisation illégale de return dans le programme principal *)
exception RetourDansMain

(* Utilisation d'un mauvais return entre procédures et fonctions *)
exception MauvaisRetour

(* Exceptions pour la gestion des références *)
exception UtilisationRefInvalide (* Utilisation illégale d'un ref en dehors d'un appel à une fonction ou de la définition de paramètres *)
exception RefManquantOuSuperflu (* Il manque un attribut ref dans les paramètres de la fonction ou dans ceux qui lui ont été transmis *)