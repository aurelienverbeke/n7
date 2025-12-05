(* Module de la passe de gestion des types *)
(* doit être conforme à l'interface Passe *)
open Tds
open Ast
open Type

type t1 = Ast.AstType.programme
type t2 = Ast.AstPlacement.programme


(* analyse_placement_instruction : AstType.instruction -> AstPlacement.instruction *)
(* Paramètre i : l'instruction à analyser *)
(* Paramètre depl : déplacement par rapport à la base du registre de référence *)
(* Paramètre reg : registre de référence *)
(* Calcule la position des variables et tranforme l'instruction
en une instruction de type AstPlacement.instruction *)
(* Erreur si mauvaise utilisation des types *)
let rec analyse_placement_instruction i depl reg =
  match i with
  | AstType.Declaration (info, e) -> 
      begin
        match info_ast_to_info info with
        | InfoVar (_, t, _, _) ->
            modifier_adresse_variable depl reg info;
            (AstPlacement.Declaration(info, e), getTaille t)
        | _ -> failwith "Erreur interne"
      end
  | AstType.Affectation (info, e) -> (AstPlacement.Affectation(info, e), 0)
  | AstType.AffichageInt e -> (AstPlacement.AffichageInt e, 0)
  | AstType.AffichageRat e -> (AstPlacement.AffichageRat e, 0)
  | AstType.AffichageBool e -> (AstPlacement.AffichageBool e, 0)
  | AstType.Conditionnelle (c, t, e) ->
      let nt = analyse_placement_bloc t depl reg in
      let ne = analyse_placement_bloc e depl reg in
      (AstPlacement.Conditionnelle(c, nt, ne), 0)
  | AstType.TantQue (c, b) -> 
      let nb = analyse_placement_bloc b depl reg in
      (AstPlacement.TantQue(c, nb), 0)
  | AstType.Retour (e, info) ->
      begin
        match info_ast_to_info info with
        | InfoFun (_, tr, tp) -> (AstPlacement.Retour(e, getTaille tr, List.fold_right (fun t tq -> tq + (getTaille t)) tp 0), 0)
        | _ -> failwith "Erreur interne"
      end
  | AstType.Empty -> (AstPlacement.Empty, 0)


(* analyse_placement_bloc : AstType.bloc -> AstPlacement.bloc *)
(* Paramètre li : liste d'instructions à analyser *)
(* Paramètre depl : déplacement par rapport à la base du registre de référence *)
(* Paramètre reg : registre de référence *)
(* Calcule la position des variables et tranforme le bloc en un bloc de type AstPlacement.bloc *)
(* Erreur si mauvaise utilisation des types *)
and analyse_placement_bloc li depl reg =
  match li with
  | [] -> ([], 0)
  | i::q -> let (ni, ti) = analyse_placement_instruction i depl reg in
      let (nq, tq) = analyse_placement_bloc q (depl + ti) reg in
      (ni::nq, ti+tq)


(* analyse_placement_fonction : AstType.fonction -> AstPlacement.fonction *)
(* Paramètre : la fonction à analyser *)
(* Calcule la position des variables et tranforme la fonction
en une fonction de type AstPlacement.fonction *)
(* Erreur si mauvaise utilisation des types *)
let analyse_placement_fonction (AstType.Fonction(info, lp, li)) =
  let (nlp, _) = List.fold_right
    (
      fun info_ast_p (acc_p, acc_tailles) ->
        let position = acc_tailles-(getTaille (get_type_variable info_ast_p)) in
        modifier_adresse_variable position "LB" info_ast_p;
        (info_ast_p::acc_p, position)
    )
    lp ([], 0) in
  let nli = analyse_placement_bloc li 3 "LB"
  in AstPlacement.Fonction(info, nlp, nli)


(* analyse_placement_fonction : AstType.fonction -> AstPlacement.fonction *)
(* Paramètre : liste fonctions à analyser *)
(* Calcule la position des variables et tranforme la fonction
en une fonction de type AstPlacement.fonction *)
(* Erreur si mauvaise utilisation des types *)
let analyse_placement_fonctions lf = List.map analyse_placement_fonction lf


(* analyser : AstType.programme -> AstPlacement.programme *)
(* Paramètre : le programme à analyser *)
(* Calcule la position des variables et tranforme le programme
en un programme de type AstPlacement.programme *)
(* Erreur si mauvaise utilisation des types *)
let analyser (AstType.Programme (fonctions, prog)) =
  let n_fonctions = List.map analyse_placement_fonction fonctions in
  let n_prog = analyse_placement_bloc prog 0 "SB" in
  AstPlacement.Programme (n_fonctions, n_prog)