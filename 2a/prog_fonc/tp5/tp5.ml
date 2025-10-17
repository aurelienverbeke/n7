(* Evaluation des expressions simples *)



(* Module abstrayant les expressions *)
module type ExprSimple =
sig
  type t
  val const : int -> t
  val plus : t -> t -> t
  val mult : t -> t -> t
end

(* Module réalisant l'évaluation d'une expression *)
module EvalSimple : ExprSimple with type t = int =
struct
  type t = int
  let const c = c
  let plus e1 e2 = e1 + e2
  let mult e1 e2 = e1 * e2
end





(* Solution 1 pour tester *)
(* A l'aide de foncteur *)

(* Définition des expressions *)
module ExemplesSimples (E:ExprSimple) =
struct
  (* 1+(2*3) *)
  let exemple1  = E.(plus (const 1) (mult (const 2) (const 3)) )
  (* (5+2)*(2*3) *)
  let exemple2 =  E.(mult (plus (const 5) (const 2)) (mult (const 2) (const 3)) )
end

(* Module d'évaluation des exemples *)
module EvalExemples =  ExemplesSimples (EvalSimple)

let%test _ = (EvalExemples.exemple1 = 7)
let%test _ = (EvalExemples.exemple2 = 42)





(* Module permettant de convertir les expressions en chaine de caractères*)
module PrintSimple : ExprSimple with type t = string =
struct
  type t = string
  let const c = string_of_int c
  let plus e1 e2 = "(" ^ e1 ^ " + " ^ e2 ^ ")"
  let mult e1 e2 = "(" ^ e1 ^ " * " ^ e2 ^ ")"
end

module PrintSimpleExemples = ExemplesSimples (PrintSimple)
let%test _ = (PrintSimple.mult "3" "5" = "(3 * 5)")
let%test _ = (PrintSimpleExemples.exemple1 = "(1 + (2 * 3))")
let%test _ = (PrintSimpleExemples.exemple2 = "((5 + 2) * (2 * 3))")





(* Module permettant de compter les expressions*)
module CompteSimple : ExprSimple with type t = int =
struct
  type t = int
  let const _ = 0
  let plus e1 e2 = e1 + e2 + 1
  let mult e1 e2 = e1 + e2 + 1
end

(* Tests associés *)
module CompteExemples = ExemplesSimples (CompteSimple)
let%test _ = (CompteExemples.exemple1 = 2)
let%test _ = (CompteExemples.exemple2 = 3)





(* Modules abstrayant les variables dans les expressions*)
module type ExprVar =
sig
  type t
  val def : string -> t -> t -> t
  val var : string -> t
end

module type Expr =
sig
  include ExprSimple
  include (ExprVar with type t := t)
end





(* Modules permettant de convertir les expressions en chaine de caractères*)
module PrintVar : ExprVar with type t = string =
struct
  type t = string
  let def nom e_temp e_final = "let " ^ nom ^ " = " ^ e_temp ^ " in " ^ e_final
  let var nom = nom
end

module Print : Expr with type t = string =
struct
  include PrintSimple
  include (PrintVar:ExprVar with type t := t)
end

(* Tests associés *)
module Exemples (E:Expr) =
struct
  (* 1+(2*3) *)
  let exemple1  = E.(plus (const 1) (mult (const 2) (const 3)) )
  (* (5+2)*(2*3) *)
  let exemple2 =  E.(mult (plus (const 5) (const 2)) (mult (const 2) (const 3)) )
  (* let x = (1+2) in (x*3) *)
  let exemple3  = E.(def "x" (plus (const 1) (const 2)) (mult (var "x") (const 3)))
end

module PrintExemples = Exemples (Print)
let%test _ = (PrintExemples.exemple1 = "(1 + (2 * 3))")
let%test _ = (PrintExemples.exemple2 = "((5 + 2) * (2 * 3))")
let%test _ = (PrintExemples.exemple3 = "let x = (1 + 2) in (x * 3)")





(* Type d'environnement : dictionnaire (clé, valeur entière) *)
type env_t = (string*int) list

module EvalVar : ExprVar with type t = (env_t -> int) =
struct
  type t = int
  let def nom e_temp e_final = fun env -> (nom, e_temp [])::env
  let var nom = fun env -> List.assoc nom env
end