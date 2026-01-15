open Type

(* Interface des arbres abstraits *)
module type Ast =
sig
   type expression
   type instruction
   type fonction
   type programme
end


(* *************************************** *)
(* AST après la phase d'analyse syntaxique *)
(* *************************************** *)
module AstSyntax =
struct

(* Opérateurs unaires de Rat *)
type unaire = Numerateur | Denominateur

(* Opérateurs binaires de Rat *)
type binaire = Fraction | Plus | Mult | Equ | Inf

(* Affectables : variables, pointeurs... *)
type affectable =
  (* Accès à un identifiant représenté par son nom *)
  | Ident of string
  (* Déréférencement de pointeur *)
  | Deref of affectable

(* Expressions de Rat *)
type expression =
  (* Appel de fonction représenté par le nom de la fonction et la liste des paramètres réels *)
  | AppelFonction of string * expression list
  (* Affectable *)
  | Affectable of affectable
  (* Adresse de variable *)
  | Adresse of string
  (* Allocation mémoire *)
  | Nouveau of typ
  (* Pointeur null *)
  | Null
  (* Booléen *)
  | Booleen of bool
  (* Entier *)
  | Entier of int
  (* Opération unaire représentée par l'opérateur et l'opérande *)
  | Unaire of unaire * expression
  (* Opération binaire représentée par l'opérateur, l'opérande gauche et l'opérande droite *)
  | Binaire of binaire * expression * expression
  (* Passage par référence *)
  | Reference of string
  (* Valeur d'un type énuméré *)
  | Enum of string

(* Instructions de Rat *)
type bloc = instruction list
and instruction =
  (* Déclaration de variable représentée par son type, son nom et l'expression d'initialisation *)
  | Declaration of typ * string * expression
  (* Affectation d'une variable représentée par un affectable et la nouvelle valeur affectée *)
  | Affectation of affectable * expression
  (* Appel de procédure représenté par le nom de la fonction et la liste des paramètres réels *)
  | AppelProcedure of string * expression list
  (* Déclaration d'une constante représentée par son nom et sa valeur (entier) *)
  | Constante of string * int
  (* Affichage d'une expression *)
  | Affichage of expression
  (* Conditionnelle représentée par la condition, le bloc then et le bloc else *)
  | Conditionnelle of expression * bloc * bloc
  (*Boucle TantQue représentée par la conditin d'arrêt de la boucle et le bloc d'instructions *)
  | TantQue of expression * bloc
  (* return d'une fonction *)
  | Retour of expression
  (* return d'une procédure *)
  | RetourVoid

(* Structures des fonctions de Rat *)
(* Nom du type énuméré - Liste des valeurs *)
type enumeration = Enum of string * (string list)

(* Structure des fonctions de Rat *)
(* type de retour - nom - liste des paramètres (association présence de référence, type et nom) - corps de la fonction *)
type fonction = Fonction of typ * string * (bool * typ * string) list * bloc

(* Structure d'un programme Rat *)
(* liste de fonction - programme principal *)
type programme = Programme of enumeration list * fonction list * bloc

end


(* ********************************************* *)
(* AST après la phase d'analyse des identifiants *)
(* ********************************************* *)
module AstTds =
struct

  (* Affectables : variables, pointeurs... *)
  type affectable =
    (* On remplace le nom par l'info ast *)
    | Ident of Tds.info_ast
    (* On remplace le nom par l'info ast *)
    | Deref of affectable

  (* Expressions existantes dans notre langage *)
  (* ~ expression de l'AST syntaxique où les noms des identifiants ont été
  remplacés par les informations associées aux identificateurs *)
  type expression =
    | AppelFonction of Tds.info_ast * expression list
    | Affectable of affectable
    | Adresse of Tds.info_ast
    | Nouveau of typ
    | Null
    | Booleen of bool
    | Entier of int
    | Unaire of AstSyntax.unaire * expression
    | Binaire of AstSyntax.binaire * expression * expression
    | Reference of Tds.info_ast
    | Enum of Tds.info_ast

  (* instructions existantes dans notre langage *)
  (* ~ instruction de l'AST syntaxique où les noms des identifiants ont été
  remplacés par les informations associées aux identificateurs
  + suppression de nœuds (const) *)
  type bloc = instruction list
  and instruction =
    | Declaration of typ * Tds.info_ast * expression (* le nom de l'identifiant est remplacé par ses informations *)
    | AppelProcedure of Tds.info_ast * expression list
    | Affectation of affectable * expression (* l'affectable est remplacé par ses informations *)
    | Affichage of expression
    | Conditionnelle of expression * bloc * bloc
    | TantQue of expression * bloc
    | Retour of expression * Tds.info_ast (* les informations sur la fonction à laquelle est associé le retour *)
    | RetourVoid of Tds.info_ast (* les informations sur la fonction à laquelle est associé le retour *)
    | Empty (* les nœuds ayant disparus: Const *)


  (* Structure des fonctions dans notre langage *)
  (* type de retour - informations associées à l'identificateur (dont son nom) - liste des paramètres (association présence de référence, type et information sur les paramètres) - corps de la fonction *)
  type fonction = Fonction of typ * Tds.info_ast * (bool * typ * Tds.info_ast ) list * bloc

  (* Structure d'un programme dans notre langage *)
  type programme = Programme of fonction list * bloc

  (* Pour le traitement des affectables qui peuvent être soit des constantes entières soit des variables *)
  type schrodinger = SchrodingerEntier of string * int | SchrodingerAffectable of affectable

end


(* ******************************* *)
(* AST après la phase de typage *)
(* ******************************* *)
module AstType =
struct

(* Opérateurs unaires de Rat - résolution de la surcharge *)
type unaire = Numerateur | Denominateur

(* Opérateurs binaires existants dans Rat - résolution de la surcharge *)
type binaire = Fraction | PlusInt | PlusRat | MultInt | MultRat | EquInt | EquBool | Inf

(* Expressions existantes dans Rat *)
(* = expression de AstTds *)
type expression =
  | AppelFonction of Tds.info_ast * expression list
  | Affectable of AstTds.affectable
  | Adresse of Tds.info_ast
  | Nouveau of typ
  | Null
  | Booleen of bool
  | Entier of int
  | Unaire of unaire * expression
  | Binaire of binaire * expression * expression
  | Reference of Tds.info_ast
  | Enum of Tds.info_ast

(* instructions existantes Rat *)
(* = instruction de AstTds + informations associées aux identificateurs, mises à jour *)
(* + résolution de la surcharge de l'affichage *)
type bloc = instruction list
 and instruction =
  | Declaration of Tds.info_ast * expression
  | AppelProcedure of Tds.info_ast * expression list
  | Affectation of AstTds.affectable * expression
  | AffichageInt of expression
  | AffichageRat of expression
  | AffichageBool of expression
  | Conditionnelle of expression * bloc * bloc
  | TantQue of expression * bloc
  | Retour of expression * Tds.info_ast
  | RetourVoid of Tds.info_ast
  | Empty (* les nœuds ayant disparus: Const *)

(* informations associées à l'identificateur (dont son nom), liste des paramètres (avec présence ou non de référence), corps *)
type fonction = Fonction of Tds.info_ast * (bool * Tds.info_ast) list * bloc

(* Structure d'un programme dans notre langage *)
type programme = Programme of fonction list * bloc

end

(* ******************************* *)
(* AST après la phase de placement *)
(* ******************************* *)
module AstPlacement =
struct

(* Expressions existantes dans notre langage *)
(* = expression de AstType  *)
type expression = AstType.expression

(* instructions existantes dans notre langage *)
type bloc = instruction list * int (* taille du bloc *)
 and instruction =
 | Declaration of Tds.info_ast * expression
 | AppelProcedure of Tds.info_ast * expression list
 | Affectation of AstTds.affectable * expression
 | AffichageInt of expression
 | AffichageRat of expression
 | AffichageBool of expression
 | Conditionnelle of expression * bloc * bloc
 | TantQue of expression * bloc
 | Retour of expression * int * int (* taille du retour et taille des paramètres *)
 | RetourVoid of int
 | Empty (* les nœuds ayant disparus: Const *)

(* informations associées à l'identificateur (dont son nom), liste de paramètres (avec présence ou non de référence), corps, expression de retour *)
(* Plus besoin de la liste des paramètres mais on la garde pour les tests du placements mémoire *)
type fonction = Fonction of Tds.info_ast * (bool * Tds.info_ast) list * bloc

(* Structure d'un programme dans notre langage *)
type programme = Programme of fonction list * bloc

end
