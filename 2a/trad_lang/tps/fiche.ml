let rec analyse_tds_expression tds e =
  match e with
  | AstSyntax.AppelFonction (identifiant, es) ->
    begin
      match chercherGlobalement tds identifiant with
      | None ->
          raise (IdentifiantNonDeclare identifiant)
      | Some info -> 
        begin
          match info_ast_to_info info with
          | InfoFun _ -> AstTds.AppelFonction(info, List.map (analyse_tds_expression tds) es)
          | _ -> raise (MauvaiseUtilisationIdentifiant identifiant)
        end
    end
  | AstSyntax.Ident identifiant ->
    begin
      match chercherGlobalement tds identifiant with
      | None ->
          raise (IdentifiantNonDeclare identifiant)
      | Some info ->
        begin
          match info_ast_to_info info with
          | InfoConst (_, valeur) -> AstTds.Entier(valeur)
          | InfoVar _ -> AstTds.Ident(info)
          | InfoFun _ -> raise (MauvaiseUtilisationIdentifiant identifiant)
        end
    end
  | AstSyntax.Booleen booleen -> AstTds.Booleen(booleen)
  | AstSyntax.Entier entier -> AstTds.Entier(entier)
  | AstSyntax.Unaire (unaire, e) -> AstTds.Unaire(unaire, analyse_tds_expression tds e)
  | AstSyntax.Binaire (binaire, e1, e2) -> AstTds.Binaire(binaire, analyse_tds_expression tds e1, analyse_tds_expression tds e2)

let rec analyse_tds_instruction tds oia i =
  match i with
  | AstSyntax.Declaration (t, n, e) ->
      begin
        match chercherLocalement tds n with
        | None ->
            let ne = analyse_tds_expression tds e in
            let info = InfoVar (n,Undefined, 0, "") in
            let ia = info_to_info_ast info in
            ajouter tds n ia;
            AstTds.Declaration (t, ia, ne)
        | Some _ ->
            raise (DoubleDeclaration n)
      end
  | AstSyntax.Affectation (n,e) ->
      begin
        match chercherGlobalement tds n with
        | None ->
          raise (IdentifiantNonDeclare n)
        | Some info ->
          begin
            match info_ast_to_info info with
            | InfoVar _ ->
              let ne = analyse_tds_expression tds e in
              AstTds.Affectation (info, ne)
            |  _ ->
              raise (MauvaiseUtilisationIdentifiant n)
          end
      end
  | AstSyntax.Constante (n,v) ->
      begin
        match chercherLocalement tds n with
        | None ->
          ajouter tds n (info_to_info_ast (InfoConst (n,v)));
          AstTds.Empty
        | Some _ ->
          raise (DoubleDeclaration n)
      end
  | AstSyntax.Affichage e ->
      let ne = analyse_tds_expression tds e in
      AstTds.Affichage (ne)
  | AstSyntax.Conditionnelle (c,t,e) ->
      let nc = analyse_tds_expression tds c in
      let tast = analyse_tds_bloc tds oia t in
      let east = analyse_tds_bloc tds oia e in
      AstTds.Conditionnelle (nc, tast, east)
  | AstSyntax.TantQue (c,b) ->
      let nc = analyse_tds_expression tds c in
      let bast = analyse_tds_bloc tds oia b in
      AstTds.TantQue (nc, bast)
  | AstSyntax.Retour (e) ->
      begin
      match oia with
      | None -> raise RetourDansMain
      | Some ia ->
        let ne = analyse_tds_expression tds e in
        AstTds.Retour (ne,ia)
      end

and analyse_tds_bloc tds oia li =
  let tdsbloc = creerTDSFille tds in
   let nli = List.map (analyse_tds_instruction tdsbloc oia) li in nli


let analyse_tds_fonction maintds (AstSyntax.Fonction(t,n,lp,li)) =
  match chercherGlobalement maintds n with
  | None ->
      let info_fun = info_to_info_ast (InfoFun (n, t, List.map fst lp)) in
      ajouter maintds n info_fun;
      let tds = creerTDSFille maintds in
      let infos_p = List.map (fun (tp, np) -> (tp, np, info_to_info_ast (InfoVar (np, tp, 0, "")))) lp in
      List.iter
        (
          fun (_, np, info_p) ->
            let info_ast_param_a_ajouter = chercherLocalement tds np in
            begin
              match info_ast_param_a_ajouter with
              | None -> ajouter tds np info_p
              | Some _ -> raise (DoubleDeclaration np)
            end
        )
        infos_p;
      let tds_bloc = creerTDSFille tds in
      let bloc = analyse_tds_bloc tds_bloc (Some info_fun) li in
      AstTds.Fonction(t, info_fun, List.map (fun (tp, _, info_p) -> (tp, info_p)) infos_p, bloc)
  | Some _ -> raise (DoubleDeclaration n)

let analyser (AstSyntax.Programme (fonctions,prog)) =
  let tds = creerTDSMere () in
  let nf = List.map (analyse_tds_fonction tds) fonctions in
  let nb = analyse_tds_bloc tds None prog in
  AstTds.Programme (nf,nb)

let rec analyse_type_expression e =
  match e with
  | AstTds.AppelFonction (info, es) ->
      begin
        let l = List.map analyse_type_expression es in
        let (nle, nte) = List.split l in
        match info_ast_to_info info with
        | InfoFun (_, tr, tp) ->
          begin
            if (List.equal (=) nte tp)=true then
              (AstType.AppelFonction(info, nle), tr)
            else
              raise (TypesParametresInattendus (nte, tp))
          end
        | _ -> failwith "Erreur interne"
      end
  | AstTds.Ident info -> (AstType.Ident info, get_type_variable info)
  | AstTds.Booleen booleen -> (AstType.Booleen booleen, Bool)
  | AstTds.Entier entier -> (AstType.Entier entier, Int)
  | AstTds.Unaire (unaire, e) ->
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
        let (n1, t1) = analyse_type_expression e1 in
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


let rec analyse_type_instruction i =
  match i with
  | AstTds.Declaration (t, info, e) -> let (ne, te) = analyse_type_expression e in
      if (te=t) then
        begin
          modifier_type_variable t info;
          AstType.Declaration(info, ne)
        end
      else raise (TypeInattendu (te, t))
  | AstTds.Affectation (info, e) -> let (ne, te) = analyse_type_expression e in
      let t = get_type_variable info in
      if (t=te) then
        AstType.Affectation(info, ne)
      else raise (TypeInattendu (te, t))
  | AstTds.Affichage e -> let (ne, te) = analyse_type_expression e in
      begin
        match te with
        | Type.Int -> AstType.AffichageInt ne
        | Type.Bool -> AstType.AffichageBool ne
        | Type.Rat -> AstType.AffichageRat ne
        | Type.Undefined -> failwith "Erreur interne"
      end
  | AstTds.Conditionnelle (c, t, e) ->
      let (nc, tc) = analyse_type_expression c in
      let nt = analyse_type_bloc t in
      let ne = analyse_type_bloc e in
      if (tc=Bool) then
        AstType.Conditionnelle(nc, nt, ne)
      else raise (TypeInattendu (tc, Bool))
  | AstTds.TantQue (c, b) ->
      let (nc, tc) = analyse_type_expression c in
      let nb = analyse_type_bloc b in
      if (tc=Bool) then
        AstType.TantQue(nc, nb)
      else raise (TypeInattendu (tc, Bool))
  | AstTds.Retour (e, info) ->
      let (ne, te) = analyse_type_expression e in
      let (tr, _) = get_types_fonction info in
      if (tr=te) then
        AstType.Retour (ne, info)
      else raise (TypeInattendu (te, tr)) 
  | AstTds.Empty -> AstType.Empty

and analyse_type_bloc li = List.map analyse_type_instruction li

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

let analyser (AstTds.Programme (fonctions, prog)) =
  AstType.Programme(analyse_type_fonctions fonctions, analyse_type_bloc prog)

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

and analyse_placement_bloc li depl reg =
  match li with
  | [] -> ([], 0)
  | i::q -> let (ni, ti) = analyse_placement_instruction i depl reg in
      let (nq, tq) = analyse_placement_bloc q (depl + ti) reg in
      (ni::nq, ti+tq)

let analyse_placement_fonction (AstType.Fonction(info, lp, li)) =
  let (nlp, _) = List.fold_right
    (
      fun info_ast_p (acc_p, acc_position) ->
        let position = acc_position-(getTaille (get_type_variable info_ast_p)) in
        modifier_adresse_variable position "LB" info_ast_p;
        (info_ast_p::acc_p, position)
    )
    lp ([], 0) in
  let nli = analyse_placement_bloc li 3 "LB"
  in AstPlacement.Fonction(info, nlp, nli)

let analyser (AstType.Programme (fonctions, prog)) =
  let n_fonctions = List.map analyse_placement_fonction fonctions in
  let n_prog = analyse_placement_bloc prog 0 "SB" in
  AstPlacement.Programme (n_fonctions, n_prog)

let rec analyse_code_expression e =
  match e with
  | AstType.AppelFonction (info, le) ->
      let cle = List.fold_right (fun e acc -> (analyse_code_expression e)^acc) le "" in
      cle^(call "SB" (get_nom_fonction info))
  | AstType.Ident info ->
    begin
      match info_ast_to_info info with
      | InfoVar (_, t, depl, reg) -> load (getTaille t) depl reg
      | _ -> failwith "Erreur interne"
    end
  | AstType.Booleen booleen -> if booleen then loadl_int 1 else loadl_int 0
  | AstType.Entier entier -> loadl_int entier
  | AstType.Unaire (unaire, e) ->
      let pop_unaire = if unaire=Numerateur then
          pop 0 1
        else
          pop 1 1
        in
        (analyse_code_expression e)^pop_unaire
  | AstType.Binaire (binaire, e1, e2) ->
    begin
      let ne1 = analyse_code_expression e1 in
      let ne2 = analyse_code_expression e2 in
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

let rec analyse_code_instruction i =
  match i with
  | AstPlacement.Declaration (info, e) -> 
    begin
      match info_ast_to_info info with
      | InfoVar (_, t, depl, reg) ->
          let taille_t = getTaille t in
          (push taille_t)^(analyse_code_expression e)^(store taille_t depl reg)
      | _ -> failwith "Erreur interne"
    end
  | AstPlacement.Affectation (info, e) ->
    begin
      match info_ast_to_info info with
      | InfoVar (_, t, depl, reg) -> (analyse_code_expression e)^(store (getTaille t) depl reg)
      | _ -> failwith "Erreur interne"
    end
  | AstPlacement.AffichageInt e -> (analyse_code_expression e)^(subr "IOut")
  | AstPlacement.AffichageRat e -> (analyse_code_expression e)^(call "SB" "ROut")
  | AstPlacement.AffichageBool e -> (analyse_code_expression e)^(subr "BOut")
  | AstPlacement.Conditionnelle (c, t, e) ->
      let etiquetteElse = getEtiquette () in
      let etiquetteEndif = getEtiquette () in
      (analyse_code_expression c)
      ^(jumpif 0 etiquetteElse)
      ^(analyse_code_bloc t)
      ^(jump etiquetteEndif)
      ^(label etiquetteElse)
      ^(analyse_code_bloc e)
      ^(label etiquetteEndif)
  | AstPlacement.TantQue (c, b) ->
      let etiquetteTq = getEtiquette () in
      let etiquetteEnd = getEtiquette () in
      (label etiquetteTq)
      ^(analyse_code_expression c)
      ^(jumpif 0 etiquetteEnd)
      ^(analyse_code_bloc b)
      ^(jump etiquetteTq)
      ^(label etiquetteEnd)
  | AstPlacement.Retour (e, tr, tp) -> (analyse_code_expression e)^(return tr tp)
  | AstPlacement.Empty -> ""

and analyse_code_bloc (li, taille) =
  (List.fold_right (fun i acc -> (analyse_code_instruction i)^acc) li "")^(pop 0 taille)

let analyser (AstPlacement.Programme (fonctions, prog)) = (getEntete ())^(analyse_code_fonctions fonctions)^(label "main")^(analyse_code_bloc prog)^(halt)

module AstSyntax =
struct
  type unaire = Numerateur | Denominateur
  type binaire = Fraction | Plus | Mult | Equ | Inf
  type expression =
    | AppelFonction of string * expression list
    | Ident of string
    | Booleen of bool
    | Entier of int
    | Unaire of unaire * expression
    | Binaire of binaire * expression * expression
  type bloc = instruction list
  and instruction =
    | Declaration of typ * string * expression
    | Affectation of string * expression
    | Constante of string * int
    | Affichage of expression
    | Conditionnelle of expression * bloc * bloc
    | TantQue of expression * bloc
    | Retour of expression
  type fonction = Fonction of typ * string * (typ * string) list * bloc
  type programme = Programme of fonction list * bloc
end

module AstTds =
struct
  type expression =
    | AppelFonction of Tds.info_ast * expression list
    | Ident of Tds.info_ast
    | Booleen of bool
    | Entier of int
    | Unaire of AstSyntax.unaire * expression
    | Binaire of AstSyntax.binaire * expression * expression
  type bloc = instruction list
  and instruction =
    | Declaration of typ * Tds.info_ast * expression
    | Affectation of  Tds.info_ast * expression
    | Affichage of expression
    | Conditionnelle of expression * bloc * bloc
    | TantQue of expression * bloc
    | Retour of expression * Tds.info_as
    | Empty
  type fonction = Fonction of typ * Tds.info_ast * (typ * Tds.info_ast ) list * bloc
  type programme = Programme of fonction list * bloc
end

module AstType =
struct
  type unaire = Numerateur | Denominateur
  type binaire = Fraction | PlusInt | PlusRat | MultInt | MultRat | EquInt | EquBool | Inf
  type expression =
    | AppelFonction of Tds.info_ast * expression list
    | Ident of Tds.info_ast
    | Booleen of bool
    | Entier of int
    | Unaire of unaire * expression
    | Binaire of binaire * expression * expression
  type bloc = instruction list
  and instruction =
    | Declaration of Tds.info_ast * expression
    | Affectation of Tds.info_ast * expression
    | AffichageInt of expression
    | AffichageRat of expression
    | AffichageBool of expression
    | Conditionnelle of expression * bloc * bloc
    | TantQue of expression * bloc
    | Retour of expression * Tds.info_ast
    | Empty
  type fonction = Fonction of Tds.info_ast * Tds.info_ast list * bloc
  type programme = Programme of fonction list * bloc
end

module AstPlacement =
struct
type expression = AstType.expression
type bloc = instruction list * int
 and instruction =
 | Declaration of Tds.info_ast * expression
 | Affectation of Tds.info_ast * expression
 | AffichageInt of expression
 | AffichageRat of expression
 | AffichageBool of expression
 | Conditionnelle of expression * bloc * bloc
 | TantQue of expression * bloc
 | Retour of expression * int * int
 | Empty
type fonction = Fonction of Tds.info_ast * Tds.info_ast list * bloc
type programme = Programme of fonction list * bloc
end