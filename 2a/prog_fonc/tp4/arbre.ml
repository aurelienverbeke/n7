open Assoc

type 'a arbre = Noeud of bool * ( ('a branche) list)
and 'a branche = 'a * 'a arbre

(* Pour les tests *)
let bb = ('b',Noeud(false,[('a',Noeud(false,[('s',Noeud(true,[]));('t',Noeud(true,[]))]))]))
let bd = ('d',Noeud(false,[('e',Noeud(true,[]))]))
let bl = ('l',Noeud(false,[('a',Noeud(true,[('i',Noeud(true,[('d',Noeud(true,[]));('t',Noeud(true,[]))]));('r',Noeud(false,[('d',Noeud(true,[]))]))]));
                           ('e',Noeud(true,[('s',Noeud(true,[]))]));
                           ('o',Noeud(false,[('n',Noeud(false,[('g',Noeud(true,[]))]))]))]))
let b1 = [bb;bd;bl]
let arbre_sujet = Noeud(false,b1)

(******************************************************************************)
(*   fonction d'appartenance d'une liste d'éléments à un arbre                *)
(*   signature  : appartient : 'a list -> 'a arbre -> bool                    *)
(*   paramètres : - une liste d'éléments (caractères dans le cas d'un dico)   *)
(*                - un arbre n-aire                                           *)
(*   résultat   : le résultat booléen du test                                 *)
(******************************************************************************)
let rec appartient_arbre lc (Noeud (b,lb)) =
  match lc with
  (* on a épuisé la liste : le résultat est le booléen du noeud sur
     lequel on est arrivé *)
  | [] -> b
  (* sinon on cherche la branche correspondant au premier
     caractère de la liste :
     - elle n'existe pas : le mot n'appartient pas au trie
     - on la trouve, on relance aux avec le reste de la liste
       et l'arbre de cette branche *)
  | c::qlc ->
    match recherche c lb with
    | None -> false
    | Some a -> appartient_arbre qlc a

let%test _ = appartient_arbre ['b';'a';'s']  arbre_sujet
let%test _ = appartient_arbre ['b';'a';'t']  arbre_sujet
let%test _ = appartient_arbre ['d';'e']  arbre_sujet
let%test _ = appartient_arbre ['l';'a']  arbre_sujet
let%test _ = appartient_arbre ['l';'a';'i']  arbre_sujet
let%test _ = appartient_arbre ['l';'a';'i';'d']  arbre_sujet
let%test _ = appartient_arbre ['l';'a';'i';'t']  arbre_sujet
let%test _ = appartient_arbre ['l';'a';'r';'d']  arbre_sujet
let%test _ = appartient_arbre ['l';'e']  arbre_sujet
let%test _ = appartient_arbre ['l';'e';'s']  arbre_sujet
let%test _ = appartient_arbre ['l';'o';'n';'g']  arbre_sujet
let%test _ = not (appartient_arbre ['t';'o';'t';'o'] arbre_sujet)
let%test _ = not (appartient_arbre ['b';'a']  arbre_sujet)
let%test _ = not (appartient_arbre ['l';'o';'n']  arbre_sujet)

(******************************************************************************)
(*   fonction d'ajout d'une liste éléments dans un arbre                      *)
(*   signature  : ajout : 'a list -> 'a arbre -> 'a arbre                     *)
(*   paramètres : - une liste d'éléments (caractères dans le cas d'un dico)   *)
(*                - un arbre n-aire                                           *)
(*   résultat   : l'arbre n-aire avec le mot ajouté                           *)
(******************************************************************************)
let rec ajout_arbre lc (Noeud (b, lb)) =
  match lc with
  (* on a épuisé la liste : le résultat est le noeud sur lequel on
     est arrivé avec son booléen mis à vrai *)
  | [] -> Noeud (true, lb)
  (* sinon on cherche l'arbre arbre_c de la branche correspondant
     au premier caractère de la liste;
     si on ne le trouve pas, le résultat de cette recherche est un arbre
     avec une liste de branches vide.

     Le résultat de aux est le noeud en paramètre
     que l'on met à jour en remplacant dans sa liste de branches,
     la branche du premier caractère par la branche dont l'arbre est
     le résultat de l'ajout du reste des caractères à l'arbre arbre_c *)
  | c::qlc ->
    let arbre_c =
      let l = recherche c lb in
      match l with
      | None   -> Noeud (false, [])
      | Some a -> a
    in Noeud (b, maj c (ajout_arbre qlc arbre_c) lb)

let arbre_sujet2 =
  List.fold_right ajout_arbre
    [['b';'a';'s']; ['b';'a';'t']; ['d';'e']; ['l';'a']; ['l';'a';'i'];
     ['l';'a';'i';'d']; ['l';'a';'i';'t']; ['l';'a';'r';'d']; ['l';'e'];
     ['l';'e';'s']; ['l';'o';'n';'g']]
    (Noeud (false,[]))

let arbre_sujet3 =
  List.fold_right ajout_arbre
    [['b';'a';'s']; ['l';'a';'i';'t']; ['b';'a';'t']; ['l';'e']; ['d';'e'];
     ['l';'a';'i']; ['l';'a';'i';'d']; ['l';'e';'s']; ['l';'a';'r';'d'];
     ['l';'a']; ['l';'o';'n';'g']]
    (Noeud (false,[]))

let%test _ = arbre_sujet2 = arbre_sujet
let%test _ = arbre_sujet3 = arbre_sujet

(******************************************************************************)
(*   fonction de retrait d'une liste éléments dans un arbre                   *)
(*   signature  : retrait : 'a list -> 'a arbre -> 'a arbre                   *)
(*   paramètres : - une liste d'éléments (caractères dans le cas d'un dico)   *)
(*                - un arbre n-aire                                           *)
(*   résultat   : l'arbre n-aire sans le mot retiré                           *)
(*                  et sans normalisation de l'arbre (sans retirer branche)   *)
(******************************************************************************)

let rec retrait_arbre lc (Noeud (b, lb)) =
  match lc with
    | [] -> Noeud(false, lb)
    | x::r -> match (recherche x lb) with 
      | None -> Noeud(b, lb)
      | Some br -> Noeud(b, maj x (retrait_arbre r br) lb)

let%test _ = retrait_arbre [] (Noeud(true,[]))= (Noeud(false,[]))
let%test _ = retrait_arbre [] (Noeud(false,[]))= (Noeud(false,[]))
let%test _ = retrait_arbre ['p';'r';'o';'g'] arbre_sujet = arbre_sujet
let%test _ = retrait_arbre [] arbre_sujet = arbre_sujet
let%test _ = retrait_arbre ['l';'o';'n'] arbre_sujet = arbre_sujet
let%test _ = not (appartient_arbre ['b';'a';'s'] (retrait_arbre ['b';'a';'s'] arbre_sujet))
let%test _ = not (appartient_arbre ['l';'a';'i'] (retrait_arbre ['l';'a';'i'] arbre_sujet))
let%test _ = (appartient_arbre ['l';'a'] (retrait_arbre ['l';'a';'i'] arbre_sujet))
let%test _ = (appartient_arbre ['l';'a';'i';'d'] (retrait_arbre ['l';'a';'i'] arbre_sujet))
let%test _ = not (appartient_arbre ['l';'e'] (retrait_arbre ['l';'e'] arbre_sujet))
let%test _ = not (appartient_arbre ['l';'o';'n';'g'] (retrait_arbre ['l';'o';'n';'g'] arbre_sujet))


(******************************************************************************)
(*   fonction de parcours des éléments d'un arbre                             *)
(*   signature  : parcours : 'a arbre -> 'a list list                         *)
(*   paramètres : - un arbre n-aire                                           *)
(*   résultat   : la liste des mots présents dans l'arbre                     *)
(******************************************************************************)

(*
let parcours_arbre arb =
  let rec parcours_aux pile mot =
    let traiter_branches branches =
      match branches with
        | [] -> []
        | branche::r -> 
    match pile with
      | [] -> []
      | Noeud(fin, br)::r -> match br with
        | [] -> parcours_aux ?? mot@[]
        | 
  in parcours_aux [arb] []
*)

let rec parcours_arbre (Noeud(b,lb)) = 
  let rec parcours_reste_branche lb = 
    match lb with 
    | [] -> []
    | (caract,a)::q -> (List.map (fun m -> caract::m) (parcours_arbre a)) @ parcours_reste_branche q
  in 
  if b = true then []::(parcours_reste_branche lb)
  else parcours_reste_branche lb 


(* [eq_perm l l'] retourne true ssi [l] et [l']
   sont égales à permutation près (pour (=)).
   [l] et [l'] ne doivent pas contenir de doublon. *)
   let eq_perm l l' =
      List.length l = List.length l' && List.for_all (fun x -> List.mem x l) l'
  
  let%test _ = parcours_arbre (Noeud(true,[])) = [[]]
  
  let%test _ = parcours_arbre (Noeud(false,[])) = []
  
  let%test _ = eq_perm (parcours_arbre arbre_sujet) [['b';'a';'s']; ['b';'a';'t']; ['d';'e']; ['l';'a']; ['l';'a';'i'];
  ['l';'a';'i';'d']; ['l';'a';'i';'t']; ['l';'a';'r';'d']; ['l';'e'];
  ['l';'e';'s']; ['l';'o';'n';'g']]


(******************************************************************************)
(*   fonction de normalisation d'un arbre, supprime les branches inutiles     *)
(*   signature  : normalisation : 'a arbre -> 'a arbre                        *)
(*   paramètres : - un arbre n-aire à normaliser                              *)
(*   résultat   : l'arbre d'entrée sans branche inutiles                      *)
(******************************************************************************)

(*
let fins_depuis_branches br = List.map fst (List.map snd br)

let faux_si_tous_faux l = List.fold_right (fun boolean acc -> boolean || acc) l false

let rec remonter_faux (Noeud(fin, br)) =
    match br with
      | [] -> fin
      | _ -> faux_si_tous_faux (fins_depuis_branches br)
*)

(*let normalisation (Noeud(fin, br)) = *)

let rec normalisation (Noeud(b,lb)) =
  let rec normal_branches l =
    match l with
      | [] -> []
      | (c,arbre)::q ->
        let arbre_norm = normalisation arbre in
        match arbre_norm with
          | Noeud(false,[]) -> normal_branches q
          | _ -> (c,arbre_norm)::normal_branches q
  in Noeud(b,(normal_branches lb))

let%test _ = normalisation (Noeud (true,[('a',Noeud(false,[]))])) = Noeud(true,[])
let%test _ = normalisation (Noeud (true,[('a',Noeud(false,[]));('e',Noeud(false,[]));('p',Noeud(false,[]))])) = Noeud(true,[])
let%test _ = normalisation (Noeud (true,[('a',Noeud(false,[('a',Noeud(false,[]));('e',Noeud(false,[]));('p',Noeud(false,[]))]))])) = Noeud(true,[])
let%test _ = normalisation arbre_sujet = arbre_sujet
let%test _ = normalisation (retrait_arbre ['d';'e'] arbre_sujet) = Noeud(false,[bb;bl])
let bb' = ('b',Noeud(false,[('a',Noeud(false,[('s',Noeud(true,[]))]))]))
let%test _ = normalisation (retrait_arbre ['b';'a';'t'] arbre_sujet) = Noeud(false,[bb';bd;bl])
let%test _ = normalisation  (retrait_arbre ['b';'a';'s'] (retrait_arbre ['b';'a';'t'] arbre_sujet)) = Noeud(false,[bd;bl])
