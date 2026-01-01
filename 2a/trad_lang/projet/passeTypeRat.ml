(* Module de la passe de gestion des types *)
(* doit être conforme à l'interface Passe *)
open Tds
open Exceptions
open Ast
open Type

type t1 = Ast.AstTds.programme
type t2 = Ast.AstType.programme


(* analyse_type_affectable : AstTds.affectable -> typ *)
(* Paramètre : affectable à analyser *)
(* Renvoie le type de l'affectable
 *)
(* Erreur si mauvaise utilisation des types *)
let rec analyse_type_affectable a =
  match a with
  (* Pour un identifiant, on récupère simplement le type de la vairable associée *)
  | AstTds.Ident(info) -> get_type_variable info
  (* Pour un déréférencement, on récupère le type de l'objet pointé et on enlève un pointeur *)
  | AstTds.Deref(affectable_a_dereferencer) ->
    begin
      match analyse_type_affectable affectable_a_dereferencer with
      | Pointeur type_pointe -> type_pointe
      | Undefined -> failwith "Erreur interne"
      | _ -> raise DereferencementImpossible (* On cherche à déréférencer un non-pointeur *)
    end

  
(* analyse_type_expression : AstTds.expression -> AstType.expression * typ *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie la bonne utilisation des types et tranforme l'expression
en une expression de type AstType.expression *)
(* Erreur si mauvaise utilisation des types *)
let rec analyse_type_expression e =
  match e with
  | AstTds.AppelFonction (info, es) ->
      begin
        (* On analyse le type de chacune des expressions des paramètres *)
        let l = List.map analyse_type_expression es in
        (* On sépare en une liste d'expressions et une liste de types *)
        let (nle, nte) = List.split l in
        match info_ast_to_info info with
        (* Il faut que l'identifiant corresponde à une fonction *)
        | InfoFun (_, tr, tp) ->
          begin
            (* On compare les types réels et attendus *)
            if (est_compatible_list nte tp)=true then
              (* Aucune différence trouvée entre types réels et attendus *)
              (AstType.AppelFonction(info, nle), tr)
            else
              (* Différence trouvée entre types réels et attendus à l'indice i *)
              raise (TypesParametresInattendus (nte, tp))
          end
        | _ -> failwith "Erreur interne"
      end
  | AstTds.Affectable a -> (AstType.Affectable a, analyse_type_affectable a)
  | AstTds.Adresse info ->
      (* On demande l'adresse d'une variable
         Son type est un pointeur sur le type de la variable *)
      begin
        match info_ast_to_info info with
        | InfoVar (_, t, _, _) -> (AstType.Adresse info, Pointeur t)
        | _ -> failwith "Erreur interne"
      end
  | AstTds.Null -> (AstType.Null, Pointeur Undefined)
  | AstTds.Nouveau t -> (AstType.Nouveau t, Pointeur t)
  | AstTds.Booleen booleen -> (AstType.Booleen booleen, Bool)
  | AstTds.Entier entier -> (AstType.Entier entier, Int)
  | AstTds.Unaire (unaire, e) ->
      (* Celui là j'ai la flemme de commenter mais c'est trivial *)
      let (ne, te) = analyse_type_expression e in
      if (te=Rat) then
        begin
          match unaire with
          | AstSyntax.Numerateur -> (AstType.Unaire(AstType.Numerateur, ne), Int)
          | AstSyntax.Denominateur -> (AstType.Unaire(AstType.Denominateur, ne), Int)
        end
      else raise (TypeInattendu (te, Rat))
  | AstTds.Binaire (binaire, e1, e2) ->
      begin
        (* On analyse la première expression *)
        let (n1, t1) = analyse_type_expression e1 in
        (* On analyse la deuxième expression *)
        let (n2, t2) = analyse_type_expression e2 in
        match (binaire, t1, t2) with
        | Plus, Int, Int -> (AstType.Binaire(PlusInt, n1, n2), Int)
        | Plus, Rat, Rat -> (AstType.Binaire(PlusRat, n1, n2), Rat)
        | Mult, Int, Int -> (AstType.Binaire(MultInt, n1, n2), Int)
        | Mult, Rat, Rat -> (AstType.Binaire(MultRat, n1, n2), Rat)
        | Equ, Int, Int -> (AstType.Binaire(EquInt, n1, n2), Bool)
        | Equ, Bool, Bool -> (AstType.Binaire(EquBool, n1, n2), Bool)
        | Fraction, Int, Int -> (AstType.Binaire(Fraction, n1, n2), Rat)
        | Inf, Int, Int -> (AstType.Binaire(Inf, n1, n2), Bool)
        | _, _, _ -> raise (TypeBinaireInattendu (binaire, t1,t2))
      end


(* analyse_type_instruction : AstTds.instruction -> AstType.instruction *)
(* Paramètre i : l'instruction à analyser *)
(* Vérifie la bonne utilisation des types et tranforme l'instruction
en une instruction de type AstType.instruction *)
(* Erreur si mauvaise utilisation des types *)
let rec analyse_type_instruction i =
  match i with
  | AstTds.Declaration (t, info, e) -> let (ne, te) = analyse_type_expression e in
      (* On vérifie si le type de la variable correspond au type de l'expression *)
      if (est_compatible t te) then
        begin
          (* On ajoute le type à l'info *)
          modifier_type_variable t info;
          AstType.Declaration(info, ne)
        end
      else raise (TypeInattendu (te, t))
  | AstTds.Affectation (a, e) ->
      (* Analyse du type de l'expression *)
      let (ne, te) = analyse_type_expression e in
      (* Analyse du type de l'affectable cible *)
      let t = analyse_type_affectable a in
      (* On vérifie si le type de la variable correspond au type de l'expression *)
      if (est_compatible t te) then
        AstType.Affectation(a, ne)
      else raise (TypeInattendu (te, t))
  | AstTds.Affichage e -> let (ne, te) = analyse_type_expression e in
      begin
        (* On sépare les affichages en des affichages spécifiques pour chacun des types *)
        match te with
        | Type.Int -> AstType.AffichageInt ne
        | Type.Bool -> AstType.AffichageBool ne
        | Type.Rat -> AstType.AffichageRat ne
        | _ -> raise AffichageNonSupporte
      end
  | AstTds.Conditionnelle (c, t, e) ->
      (* Analyse de la condition *)
      let (nc, tc) = analyse_type_expression c in
      (* Analyse du bloc principal *)
      let nt = analyse_type_bloc t in
      (* Analyse du bloc else *)
      let ne = analyse_type_bloc e in
      (* On vérifie que la condition est bien un booléen *)
      if (tc=Bool) then
        AstType.Conditionnelle(nc, nt, ne)
      else raise (TypeInattendu (tc, Bool))
  | AstTds.TantQue (c, b) ->
      (* Analyse de la condition *)
      let (nc, tc) = analyse_type_expression c in
      (* Analyse du bloc *)
      let nb = analyse_type_bloc b in
      (* On vérifie que la condition est bien un booléen *)
      if (tc=Bool) then
        AstType.TantQue(nc, nb)
      else raise (TypeInattendu (tc, Bool))
  | AstTds.Retour (e, info) ->
      (* Analyse de l'expression du retour *)
      let (ne, te) = analyse_type_expression e in
      (* On récupère le type de retour de la fonction *)
      let (tr, _) = get_types_fonction info in
      (* On vérifie que le type de l'expression de retour correspond bien à celui de la fonction *)
      if (est_compatible tr te) then
        AstType.Retour (ne, info)
      else raise (TypeInattendu (te, tr)) 
  | AstTds.Empty -> AstType.Empty


(* analyse_type_bloc : AstTds.bloc -> AstType.bloc *)
(* Paramètre li : liste d'instructions à analyser *)
(* Vérifie la bonne utilisation des types et tranforme le bloc en un bloc de type AstType.bloc *)
(* Erreur si mauvaise utilisation des types *)
and analyse_type_bloc li = List.map analyse_type_instruction li


(* analyse_type_fonction : AstTds.fonction -> AstType.fonction *)
(* Paramètre : la fonction à analyser *)
(* Vérifie la bonne utilisation des types et tranforme la fonction
en une fonction de type AstType.fonction *)
(* Erreur si mauvaise utilisation des types *)
let analyse_type_fonction (AstTds.Fonction(t, info, lp, li)) =
  modifier_type_fonction t (List.map fst lp) info;
  AstType.Fonction(
    info,
    ( List.map
      (fun (tp, info_ast_p) ->
          match info_ast_to_info info_ast_p with
            | InfoVar(_, _, _, _) ->
                modifier_type_variable tp info_ast_p;
                info_ast_p
            | _ -> failwith "Erreur interne"
      )
      lp
    ),
    analyse_type_bloc li)


(* analyse_type_fonction : AstTds.fonction -> AstType.fonction *)
(* Paramètre : liste fonctions à analyser *)
(* Vérifie la bonne utilisation des types et tranforme la fonction
en une fonction de type AstType.fonction *)
(* Erreur si mauvaise utilisation des types *)
let analyse_type_fonctions lf = List.map analyse_type_fonction lf


(* analyser : AstTds.programme -> AstType.programme *)
(* Paramètre : le programme à analyser *)
(* Vérifie la bonne utilisation des types et tranforme le programme
en un programme de type AstType.programme *)
(* Erreur si mauvaise utilisation des types *)
let analyser (AstTds.Programme (fonctions, prog)) =
  AstType.Programme(analyse_type_fonctions fonctions, analyse_type_bloc prog)