(* Module de la passe de gestion des types *)
(* doit être conforme à l'interface Passe *)
open Tds
open Ast
open Type
open Tam
open Code

type t1 = Ast.AstPlacement.programme
type t2 = string


(* analyse_type_affectable : AstPlacement.affectable -> string * string *)
(* Paramètre mode_acces : l'affectable est-il accédé en lecture ou en écriture ? *)
(* Paramètre a : l'affectable à convertir *)
(* Paramètre info_ast_refs : info_ast des variables qui sont des références *)
(* Transforme l'affectable en commandes TAM *)
(* Renvoie deux catégories de commandes dans le cas où d'autres (par exemple une expression) devrait s'intercaler entre les deux,
   et le type de l'affectable concerné, nécessaire pour le déréférencement *)
(* Erreur si mauvaise utilisation des types *)
let rec analyse_code_affectable mode_acces a info_ast_refs =
  match a with
  | AstTds.Ident info ->
    begin
      match info_ast_to_info info with
      | InfoVar (_, t, depl, reg) ->
          let taille_t = getTaille t in
          if mode_acces = AccesLecture then
            if List.mem info info_ast_refs then
              (* La variable est une référence, on doit donc charger l'adresse avant de charger la valeur *)
              (load 1 depl reg^(loadi taille_t), t)
            else
              (load taille_t depl reg, t)
          else
            if List.mem info info_ast_refs then
              (* La variable est une référence, on doit donc charger l'adresse avant de ranger la valeur *)
              (load 1 depl reg^(storei taille_t), t)
            else
              (store taille_t depl reg, t)
      | _ -> failwith "Erreur interne"
    end
  | AstTds.Deref aff ->
    begin
      (* On récupère l'adresse pointée en forçant l'accès en lecture pour tous les niveaux hors celui initial *)
      let (instructions, t) = analyse_code_affectable AccesLecture aff info_ast_refs
      in
        match t with
        | Pointeur type_pointe ->
            let taille_type_pointe = getTaille type_pointe
            in
            if mode_acces = AccesLecture then
              (* On charge depuis la mémoire la variable réelle en utilisant la taille du type pointé *)
              (instructions^(loadi taille_type_pointe), type_pointe)
            else
              (* On range vers la mémoire en utilisant la taille du type pointé *)
              (instructions^(storei taille_type_pointe), type_pointe)
        | _ -> failwith "Erreur interne" (* Ce qu'on cherche à déréférencer doit être un pointeur *)
    end


    


(* analyse_type_expression : AstPlacement.expression -> string *)
(* Paramètre e : l'expression à convertir *)
(* Paramètre info_ast_refs : info_ast des variables qui sont des références *)
(* Transforme l'expression en commandes TAM *)
(* Erreur si mauvaise utilisation des types *)
let rec analyse_code_expression e info_ast_refs=
  match e with
  | AstType.AppelFonction (info, le) ->
      let cle = List.fold_right (fun e acc -> (analyse_code_expression e info_ast_refs)^acc) le "" in
      cle^(call "SB" (get_nom_fonction info))
  | AstType.Affectable a ->
      let (inst, _) = analyse_code_affectable AccesLecture a info_ast_refs in inst
  | AstType.Null -> subr "MVoid"
  | AstType.Adresse info ->
      begin
        match info_ast_to_info info with
        | InfoVar (_, _, depl, reg) -> loada depl reg
        | _ -> failwith "Erreur interne"
      end
  | AstType.Nouveau t -> (loadl_int (getTaille t))^(subr "MAlloc")
  | AstType.Booleen booleen -> if booleen then loadl_int 1 else loadl_int 0
  | AstType.Entier entier -> loadl_int entier
  | AstType.Unaire (unaire, e) ->
      let pop_unaire = if unaire=Numerateur then
          pop 0 1
        else
          pop 1 1
        in
        (analyse_code_expression e info_ast_refs)^pop_unaire
  | AstType.Binaire (binaire, e1, e2) ->
    begin
      let ne1 = analyse_code_expression e1 info_ast_refs in
      let ne2 = analyse_code_expression e2 info_ast_refs in
      let nb = match binaire with
        | PlusInt -> subr "IAdd"
        | PlusRat -> call "SB" "RAdd"
        | Fraction -> " "
        | MultInt -> subr "IMul"
        | MultRat -> call "SB" "RMul"
        | EquInt | EquBool -> subr "IEq"
        | Inf -> subr "ILss"
      in ne1^ne2^nb
    end
  | AstType.Reference info ->
      begin
        match info_ast_to_info info with
        | InfoVar (_, _, depl, reg) -> if List.mem info info_ast_refs then load 1 depl reg else loada depl reg
        | _ -> failwith "Erreur interne"
      end


(* analyse_code_instruction : AstPlacement.instruction -> string *)
(* Paramètre i : l'instruction à convertir *)
(* Paramètre info_ast_refs : info_ast des variables qui sont des références *)
(* Transforme l'instruction en commandes TAM *)
(* Erreur si mauvaise utilisation des types *)
let rec analyse_code_instruction i info_ast_refs =
  match i with
  | AstPlacement.Declaration (info, e) -> 
    begin
      match info_ast_to_info info with
      | InfoVar (_, t, depl, reg) ->
          let taille_t = getTaille t in
          (push taille_t)^(analyse_code_expression e info_ast_refs)^(store taille_t depl reg)
      | _ -> failwith "Erreur interne"
    end
  | AstPlacement.AppelProcedure (info, le) ->
      let cle = List.fold_right (fun e acc -> (analyse_code_expression e info_ast_refs)^acc) le "" in
      cle^(call "SB" (get_nom_fonction info))
  | AstPlacement.Affectation (a, e) ->
      let (inst, _) = analyse_code_affectable AccesEcriture a info_ast_refs
      in (analyse_code_expression e info_ast_refs)^inst
  | AstPlacement.AffichageInt e -> (analyse_code_expression e info_ast_refs)^(subr "IOut")
  | AstPlacement.AffichageRat e -> (analyse_code_expression e info_ast_refs)^(call "SB" "ROut")
  | AstPlacement.AffichageBool e -> (analyse_code_expression e info_ast_refs)^(subr "BOut")
  | AstPlacement.Conditionnelle (c, t, e) ->
      let etiquetteElse = getEtiquette () in
      let etiquetteEndif = getEtiquette () in
      (analyse_code_expression c info_ast_refs)
      ^(jumpif 0 etiquetteElse)
      ^(analyse_code_bloc t info_ast_refs)
      ^(jump etiquetteEndif)
      ^(label etiquetteElse)
      ^(analyse_code_bloc e info_ast_refs)
      ^(label etiquetteEndif)
  | AstPlacement.TantQue (c, b) ->
      let etiquetteTq = getEtiquette () in
      let etiquetteEnd = getEtiquette () in
      (label etiquetteTq)
      ^(analyse_code_expression c info_ast_refs)
      ^(jumpif 0 etiquetteEnd)
      ^(analyse_code_bloc b info_ast_refs)
      ^(jump etiquetteTq)
      ^(label etiquetteEnd)
  | AstPlacement.Retour (e, tr, tp) -> (analyse_code_expression e info_ast_refs)^(return tr tp)
  | AstPlacement.RetourVoid (tp) -> return 0 tp
  | AstPlacement.Empty -> ""


(* analyse_placement_bloc : AstPlacement.bloc -> string *)
(* Paramètre li : liste d'instructions à analyser *)
(* Paramètre taille : taille totale occupée par le bloc *)
(* Paramètre info_ast_refs : info_ast des variables qui sont des références *)
(* Transforme l'instruction en commandes TAM *)
(* Erreur si mauvaise utilisation des types *)
and analyse_code_bloc (li, taille) info_ast_refs=
  (List.fold_right (fun i acc -> (analyse_code_instruction i info_ast_refs)^acc) li "")^(pop 0 taille)


(* analyse_placement_fonction : AstPlacement.fonction list -> string *)
(* Paramètre : liste fonctions à analyser *)
(* Calcule la position des variables et tranforme la fonction
en une fonction de type AstPlacement.fonction *)
(* Erreur si mauvaise utilisation des types *)
(* On met un halt au cas où il n'y aurait pas de return *)
let analyse_code_fonctions lf = 
  (List.fold_right
    (fun (AstPlacement.Fonction(info, lp, li)) acc ->
      let info_ast_refs = List.fold_left (fun acc (ref, info) -> if ref then info::acc else acc) [] lp
      in
        (label (get_nom_fonction info))^(analyse_code_bloc li info_ast_refs)
        ^acc
    )
    lf
    ""
  )
  ^(halt)


(* analyser : AstPlacement.programme -> AstPlacement.programme *)
(* Paramètre : le programme à analyser *)
(* Calcule la position des variables et tranforme le programme
en un programme de type AstPlacement.programme *)
(* Erreur si mauvaise utilisation des types *)
let analyser (AstPlacement.Programme (fonctions, prog)) = (getEntete ())^(analyse_code_fonctions fonctions)^(label "main")^(analyse_code_bloc prog [])^(halt)