(* Module de la passe de gestion des identifiants *)
(* doit être conforme à l'interface Passe *)
open Tds
open Exceptions
open Ast
open Type

type t1 = Ast.AstSyntax.programme
type t2 = Ast.AstTds.programme


(* analyse_tds_affectable : tds -> AstSyntax.affectable -> AstTds.affectable *)
(* Paramètre acces : si l'affectable est utilisé en lecture ou en écriture *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre affectable : l'affectable à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'affectable
en un affectable de type AstTds.affectable *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyse_tds_affectable domaine tds affectable =
  match affectable with
  | AstSyntax.Ident identifiant ->
    begin
      (* On regarde si l'identifiant est dans la table des symboles *)
      match chercherGlobalement tds identifiant with
      | None ->
          (* Identifiant absent de la table des symboles *)
          raise (IdentifiantNonDeclare identifiant)
      | Some info ->
        begin
          match info_ast_to_info info with
          | InfoConst (_, valeur) ->
              begin
                match domaine with
                | AccesLecture -> AstTds.SchrodingerEntier(valeur) (* Identifiant présent dans la table des symboles et c'est une constante, on remplace par sa valeur *)
                | AccesEcriture -> raise (MauvaiseUtilisationIdentifiant identifiant) (* On ne peut pas affecter une valeur à une constante hors définition *)
              end
          | InfoVar _ -> AstTds.SchrodingerAffectable(AstTds.Ident(info)) (* Identifiant présent dans la table des symboles et c'est une variable *)
          | InfoFun _ -> raise (MauvaiseUtilisationIdentifiant identifiant) (* Identifiant présent dans la table des symboles et c'est une fonction, ça ne marche pas hehe *)
        end
    end


(* analyse_tds_expression : tds -> AstSyntax.expression -> AstTds.expression *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'expression
en une expression de type AstTds.expression *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_tds_expression tds e =
  match e with
  | AstSyntax.AppelFonction (identifiant, es) ->
    begin
      (* On regarde si la fonction est dans la table des symboles *)
      match chercherGlobalement tds identifiant with
      | None ->
          (* Identifiant absent de la table des symboles *)
          raise (IdentifiantNonDeclare identifiant)
      | Some info -> 
        begin
          match info_ast_to_info info with
          | InfoFun _ -> AstTds.AppelFonction(info, List.map (analyse_tds_expression tds) es) (* Identifiant présent dans la table des symboles *)
          | _ -> raise (MauvaiseUtilisationIdentifiant identifiant)
        end
    end
  | AstSyntax.Affectable affectable ->
      begin
        match analyse_tds_affectable AccesLecture tds affectable with
        | SchrodingerEntier entier -> AstTds.Entier entier
        | SchrodingerAffectable affectable -> AstTds.Affectable affectable
      end
  | AstSyntax.Null -> AstTds.Null
  | AstSyntax.Booleen booleen -> AstTds.Booleen(booleen)
  | AstSyntax.Entier entier -> AstTds.Entier(entier)
  | AstSyntax.Unaire (unaire, e) -> AstTds.Unaire(unaire, analyse_tds_expression tds e)
  | AstSyntax.Binaire (binaire, e1, e2) -> AstTds.Binaire(binaire, analyse_tds_expression tds e1, analyse_tds_expression tds e2)


(* analyse_tds_instruction : tds -> info_ast option -> AstSyntax.instruction -> AstTds.instruction *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre oia : None si l'instruction i est dans le bloc principal,
                   Some ia où ia est l'information associée à la fonction dans laquelle est l'instruction i sinon *)
(* Paramètre i : l'instruction à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'instruction
en une instruction de type AstTds.instruction *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_tds_instruction tds oia i =
  match i with
  | AstSyntax.Declaration (t, n, e) ->
      begin
        match chercherLocalement tds n with
        | None ->
            (* L'identifiant n'est pas trouvé dans la tds locale,
            il n'a donc pas été déclaré dans le bloc courant *)
            (* Vérification de la bonne utilisation des identifiants dans l'expression *)
            (* et obtention de l'expression transformée *)
            let ne = analyse_tds_expression tds e in
            (* Création de l'information associée à l'identifiant *)
            let info = InfoVar (n,Undefined, 0, "") in
            (* Création du pointeur sur l'information *)
            let ia = info_to_info_ast info in
            (* Ajout de l'information (pointeur) dans la tds *)
            ajouter tds n ia;
            (* Renvoie de la nouvelle déclaration où le nom a été remplacé par l'information
            et l'expression remplacée par l'expression issue de l'analyse *)
            AstTds.Declaration (t, ia, ne)
        | Some _ ->
            (* L'identifiant est trouvé dans la tds locale,
            il a donc déjà été déclaré dans le bloc courant *)
            raise (DoubleDeclaration n)
      end
  | AstSyntax.Affectation (a,e) ->
      (* Vérification de l'utilisation de l'affectable *)
      let nschrodinger = analyse_tds_affectable AccesEcriture tds a in
      (* Vérification de la bonne utilisation des identifiants dans l'expression *)
      (* et obtention de l'expression transformée *)
      let ne = analyse_tds_expression tds e in
      (* Renvoie de la nouvelle affectation où l'affectable a été remplacé par l'information
          et l'expression remplacée par l'expression issue de l'analyse *)
      begin
        match nschrodinger with
        | AstTds.SchrodingerAffectable naffectable -> AstTds.Affectation (naffectable, ne)
        | _ -> failwith "Erreur interne"
      end
  | AstSyntax.Constante (n,v) ->
      begin
        match chercherLocalement tds n with
        | None ->
          (* L'identifiant n'est pas trouvé dans la tds locale,
             il n'a donc pas été déclaré dans le bloc courant *)
          (* Ajout dans la tds de la constante *)
          ajouter tds n (info_to_info_ast (InfoConst (n,v)));
          (* Suppression du noeud de déclaration des constantes devenu inutile *)
          AstTds.Empty
        | Some _ ->
          (* L'identifiant est trouvé dans la tds locale,
          il a donc déjà été déclaré dans le bloc courant *)
          raise (DoubleDeclaration n)
      end
  | AstSyntax.Affichage e ->
      (* Vérification de la bonne utilisation des identifiants dans l'expression *)
      (* et obtention de l'expression transformée *)
      let ne = analyse_tds_expression tds e in
      (* Renvoie du nouvel affichage où l'expression remplacée par l'expression issue de l'analyse *)
      AstTds.Affichage (ne)
  | AstSyntax.Conditionnelle (c,t,e) ->
      (* Analyse de la condition *)
      let nc = analyse_tds_expression tds c in
      (* Analyse du bloc then *)
      let tast = analyse_tds_bloc tds oia t in
      (* Analyse du bloc else *)
      let east = analyse_tds_bloc tds oia e in
      (* Renvoie la nouvelle structure de la conditionnelle *)
      AstTds.Conditionnelle (nc, tast, east)
  | AstSyntax.TantQue (c,b) ->
      (* Analyse de la condition *)
      let nc = analyse_tds_expression tds c in
      (* Analyse du bloc *)
      let bast = analyse_tds_bloc tds oia b in
      (* Renvoie la nouvelle structure de la boucle *)
      AstTds.TantQue (nc, bast)
  | AstSyntax.Retour (e) ->
      begin
      (* On récupère l'information associée à la fonction à laquelle le return est associée *)
      match oia with
        (* Il n'y a pas d'information -> l'instruction est dans le bloc principal : erreur *)
      | None -> raise RetourDansMain
        (* Il y a une information -> l'instruction est dans une fonction *)
      | Some ia ->
        (* Analyse de l'expression *)
        let ne = analyse_tds_expression tds e in
        AstTds.Retour (ne,ia)
      end


(* analyse_tds_bloc : tds -> info_ast option -> AstSyntax.bloc -> AstTds.bloc *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre oia : None si le bloc li est dans le programme principal,
                   Some ia où ia est l'information associée à la fonction dans laquelle est le bloc li sinon *)
(* Paramètre li : liste d'instructions à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le bloc en un bloc de type AstTds.bloc *)
(* Erreur si mauvaise utilisation des identifiants *)
and analyse_tds_bloc tds oia li =
  (* Entrée dans un nouveau bloc, donc création d'une nouvelle tds locale
  pointant sur la table du bloc parent *)
  let tdsbloc = creerTDSFille tds in
  (* Analyse des instructions du bloc avec la tds du nouveau bloc.
     Cette tds est modifiée par effet de bord *)
   let nli = List.map (analyse_tds_instruction tdsbloc oia) li in
   (* afficher_locale tdsbloc ; *) (* décommenter pour afficher la table locale *)
   nli


(* analyse_tds_fonction : tds -> AstSyntax.fonction -> AstTds.fonction *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre : la fonction à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme la fonction
en une fonction de type AstTds.fonction *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyse_tds_fonction maintds (AstSyntax.Fonction(t,n,lp,li)) =
  match chercherGlobalement maintds n with
  | None ->
      (* info_ast associé à la fonction *)  
      let info_fun = info_to_info_ast (InfoFun (n, t, List.map fst lp)) in
      (* On ajoute l'info_ast dans la tds principale *)
      ajouter maintds n info_fun;
      (* On crée la tds fille qui servira aux paramètres de la fonction *)
      let tds = creerTDSFille maintds in
      (* tuples (type, nom, info_ast) pour chacun des paramètres *)
      let infos_p = List.map (fun (tp, np) -> (tp, np, info_to_info_ast (InfoVar (np, tp, 0, "")))) lp in
      (* On ajoute les info_ast des paramètres dans la tds fille *)
      (* Attention les yeux *)
      List.iter
        (
          (* On n'ajoute le paramètre que si il n'a pas déjà été ajouté, sinon on crie *)
          fun (_, np, info_p) ->
            let info_ast_param_a_ajouter = chercherLocalement tds np in
            begin
              match info_ast_param_a_ajouter with
              | None -> ajouter tds np info_p
              | Some _ -> raise (DoubleDeclaration np) (* On crie aaaaaaaaaaaaaaaargf *)
            end
        )
        infos_p;
      (* On crée une tds fille pour le bloc de la fonction *)
      let tds_bloc = creerTDSFille tds in
      (* On analyse le bloc de la fonction pour en tirer un AstTds.Bloc *)
      let bloc = analyse_tds_bloc tds_bloc (Some info_fun) li in
      (* On retourne finalement un AstTds.Fonction *)
      AstTds.Fonction(t, info_fun, List.map (fun (tp, _, info_p) -> (tp, info_p)) infos_p, bloc)
  | Some _ -> raise (DoubleDeclaration n)


(* analyser : AstSyntax.programme -> AstTds.programme *)
(* Paramètre : le programme à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le programme
en un programme de type AstTds.programme *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyser (AstSyntax.Programme (fonctions,prog)) =
  let tds = creerTDSMere () in
  let nf = List.map (analyse_tds_fonction tds) fonctions in
  let nb = analyse_tds_bloc tds None prog in
  AstTds.Programme (nf,nb)
