(* Pour les tests *)
(* [eq_perm l l'] retourne true ssi [l] et [l']
   sont égales à à permutation près (pour (=)).
   [l'] ne doit pas contenir de doublon. *)
let eq_perm l l' =
  List.length l = List.length l' && List.for_all (fun x -> List.mem x l) l'





module type StructureDonnees =
sig

  (* Type permettant de stocker le dictionnaire *)
  type dico

  (* Dictionnaire vide *)
  val empty : dico

  (* Ajoute un mot et son encodage au dictionnaire *)
  (* premier parametre : l'encodage du mot *)
  (* deuxième paramètre : le mot *)
  (* troisième paramètre : le dictionnaire *)
  val ajouter : int list -> string -> dico -> dico

  (* Cherche tous les mots associés à un encodage dans un dictionnaire *)
  (* premier parametre : l'encodage du mot *)
  (* second paramètre : le dictionnaire *)
  val chercher : int list -> dico -> string list


  (* Calcule le nombre maximum de mots ayant le même encodage dans un
     dictionnaire *)
  (* paramètre : le dictionnaire *)
  val max_mots_code_identique : dico -> int

  (* Liste tous les mots d'un dictionnaire dont un prefixe de l'encodage est donné en paramètre *)
  (* premier paramètre : le prefixe de l'encodage *)
  (* second paramètre : le dictionnaire *)
  val prefixe : int list -> dico -> string list

end




(* Implémente la structure de données du dictionnaire avec une liste associative (liste de touches, mots associés) *)
module ListAssoc : StructureDonnees with type dico = (int list * string list) list =
struct
  type dico = (int list * string list) list
  let empty = []
  let rec ajouter encodage mot dictionnaire = match dictionnaire with
    | [] -> [(encodage, [mot])]
    | (touches, mots)::r -> if touches = encodage
      then if List.mem mot mots
        then (touches, mots)::r
        else (touches, mot::mots)::r
      else (touches, mots)::(ajouter encodage mot r)
  let chercher encodage dictionnaire = match List.assoc_opt encodage dictionnaire with
      | None -> []
      | Some mots -> mots
  let max_mots_code_identique dictionnaire = List.fold_right (fun (_, mots) acc -> max acc (List.length mots)) dictionnaire 0
  let prefixe prefixe_encodage dictionnaire =
    let longueur_prefixe = List.length prefixe_encodage
    in List.flatten (List.map snd (List.filter (fun (touches, _) -> List.take longueur_prefixe touches = prefixe_encodage) dictionnaire))
end


(* Tests associés *)
let%test _ = eq_perm (ListAssoc.ajouter [2;7;3;3] "aref" [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])]) [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["aref";"bref"]);([2;6;6],["bon"])]
let%test _ = eq_perm (ListAssoc.ajouter [3;6;7;3;3;4;4;8] "enseeiht" []) [([3;6;7;3;3;4;4;8], ["enseeiht"])]
let%test _ = eq_perm (ListAssoc.ajouter [3;6;7;3;3;4;4;8] "enseeiht" [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])]) [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"]);([3;6;7;3;3;4;4;8], ["enseeiht"])]

let%test _ = eq_perm (ListAssoc.chercher [2;2] [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])]) ["bb";"aa";"cc"]
let%test _ = eq_perm (ListAssoc.chercher [3;3] [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])]) []
let%test _ = eq_perm (ListAssoc.chercher [2;7;3;3] [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])]) ["bref"]
let%test _ = eq_perm (ListAssoc.chercher [2;6;6] [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])]) ["bon"]
let%test _ = eq_perm (ListAssoc.chercher [2;6;6] []) []

let%test _ = ListAssoc.max_mots_code_identique [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])] = 3
let%test _ = ListAssoc.max_mots_code_identique [([2;7;3;3],["bref"]);([2;2],["bb";"aa";"cc"]); ([2;6;6],["bon"])] = 3
let%test _ = ListAssoc.max_mots_code_identique [] = 0
let%test _ = ListAssoc.max_mots_code_identique [([2;7;3;3],["bref"]);([2;2],["bb"]); ([2;6;6],["bon"])] = 1

let%test _ = eq_perm (ListAssoc.prefixe [] [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])]) ["bb";"aa";"cc";"bref";"bon"]
let%test _ = eq_perm (ListAssoc.prefixe [] [([2;7;3;3],["bref"]);([2;2],["bb";"aa";"cc"]); ([2;6;6],["bon"])]) ["bref";"bb";"aa";"cc";"bon"]
let%test _ = eq_perm (ListAssoc.prefixe [] []) []
let%test _ = eq_perm (ListAssoc.prefixe [] [([2;7;3;3],["bref"]);([2;2],["bb"]); ([2;6;6],["bon"])]) ["bref";"bb";"bon"]
let%test _ = eq_perm (ListAssoc.prefixe [2] [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])]) ["bb";"aa";"cc";"bref";"bon"]
let%test _ = eq_perm (ListAssoc.prefixe [2;2] [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])]) ["bb";"aa";"cc"]
let%test _ = eq_perm (ListAssoc.prefixe [2;2] [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;2;2],["bac";"bab"]);([2;6;6],["bon"])]) ["bb";"aa";"cc";"bac";"bab"]





(* Implémente la structure de données du dictionnaire avec un arbre *)
type dico_t = Noeud of ( string list * ( int * dico_t ) list )
module Arbre : StructureDonnees with type dico = dico_t =
struct
  type dico = dico_t
  let empty = Noeud([], [])
  let rec ajouter encodage mot (Noeud(mots, branches)) = match encodage with
    | [] -> if List.mem mot mots then Noeud(mots, branches) else Noeud(mot::mots, branches)
    | chiffre::r ->
      let branches_maj = List.map
        (fun (chiffre_branche, sous_arbre) -> if chiffre = chiffre_branche
          then (chiffre_branche, ajouter r mot sous_arbre)
          else (chiffre_branche, sous_arbre)
        )
        branches
      in Noeud(mots, branches_maj)
  let rec chercher encodage (Noeud(mots, branches)) = match encodage with
      | [] -> mots
      | chiffre::r -> match List.assoc_opt chiffre branches with
        | None -> []
        | Some sous_arbre -> chercher r sous_arbre
  let max_mots_code_identique (Noeud(mots, branches)) = failwith ""
  let prefixe prefixe_encodage (Noeud(mots, branches)) = failwith ""
end


(* Test associés - ATTENTION les tests peuvent échouer car l'ordre des branches n'est pas fixé *)  
let a1 = Noeud
    ([],
      [(2,
        Noeud
          ([],
          [(6,
            Noeud
              ([],
                [(6,
                  Noeud
                    ([],
                    [(5,
                      Noeud
                        ([],
                          [(6,
                            Noeud
                              ([], [(8, Noeud ([], [(7, Noeud (["bonjour"], []))]))]))]))]))]))]))])
let%test _ = a1 = Arbre.ajouter [2;6;6;5;6;8;7] "bonjour" Arbre.empty

let a2 = Noeud
    ([],
      [(6,
        Noeud
          ([],
          [(2,
            Noeud
              ([],
                [(2, Noeud ([], [(6, Noeud ([], [(5, Noeud (["ocaml"], []))]))]))]))]))])

let%test _ = a2 = Arbre.ajouter [6;2;2;6;5] "ocaml" Arbre.empty

let a3 =   Noeud
    ([],
      [(2, Noeud (["a"], []));
      (6,
        Noeud
          ([],
          [(2,
            Noeud
              ([],
                [(2, Noeud ([], [(6, Noeud ([], [(5, Noeud (["ocaml"], []))]))]))]))]))])

let%test _ = a3 = Arbre.ajouter [2] "a" a2

let a4 = Noeud ([], [(2, Noeud ([], [(8, Noeud (["au"], []))]))])

let%test _ = a4 = Arbre.ajouter [2;8] "au" Arbre.empty

let a5 = Noeud
    ([], [(2, Noeud ([], [(6, Noeud (["an"], [])); (8, Noeud (["au"], []))]))])

let%test _ = a5 = Arbre.ajouter [2;6] "an" a4

let a6 = Noeud
    ([],
      [(2,
        Noeud
          ([],
          [(6, Noeud (["an"], [(3, Noeud (["ane"], []))]));
            (8, Noeud (["au"], []))]))])

let%test _ = a6 = Arbre.ajouter [2;6;3] "ane" a5

let a7 = Noeud
    ([],
      [(2,
        Noeud
          ([],
          [(6, Noeud (["an"], [(3, Noeud (["ame";"ane"], []))]));
            (8, Noeud (["au"], []))]))])


let%test _ = a7 = Arbre.ajouter [2;6;3] "ame" a6

let a8 = Noeud
    ([],
      [(2,
        Noeud
          ([],
          [(6, Noeud (["an"], [(3, Noeud (["bof";"ame";"ane"], []))]));
            (8, Noeud (["au"], []))]))])


let%test _ = a8 = Arbre.ajouter [2;6;3] "bof" a7

let a9_1 = Noeud
    ([],
      [(2,
        Noeud
          ([],
          [(6, Noeud (["an"], [(3, Noeud (["bof";"ame";"ane"], []))]));
            (8, Noeud (["bu";"au"], []))]))])
let a9_2 = Noeud
    ([],
      [(2,
        Noeud
          ([],
          [(8, Noeud (["bu"; "au"], []));
            (6, Noeud (["an"], [(3, Noeud (["bof"; "ame"; "ane"], []))]))]))])


let%test _ = (a9_1 = Arbre.ajouter [2;8] "bu" a8 || a9_2 = Arbre.ajouter [2;8] "bu" a8)

let%test _ = eq_perm (Arbre.chercher [2;8] a9_1) ["bu"; "au"]
let%test _ = eq_perm (Arbre.chercher [2;6] a9_1) ["an"]
let%test _ = eq_perm (Arbre.chercher [2;6;3] a9_1) ["bof"; "ame"; "ane"]
let%test _ = eq_perm (Arbre.chercher [1;4;5] a9_1) []
let%test _ = eq_perm (Arbre.chercher [2;8] a9_2) ["bu"; "au"]
let%test _ = eq_perm (Arbre.chercher [2;6] a9_2) ["an"]
let%test _ = eq_perm (Arbre.chercher [2;6;3] a9_2) ["bof"; "ame"; "ane"]
let%test _ = eq_perm (Arbre.chercher [1;4;5] a9_2) []

(*
let%test _ = max_mots_code_identique a9_1 = 3
let%test _ = max_mots_code_identique a9_2 = 3
let%test _ = max_mots_code_identique a8 = 3
let%test _ = max_mots_code_identique a7 = 2
let%test _ = max_mots_code_identique a6 = 1
let%test _ = max_mots_code_identique a5 = 1
let%test _ = max_mots_code_identique a4 = 1
let%test _ = max_mots_code_identique a3 = 1
let%test _ = max_mots_code_identique a2 = 1
let%test _ = max_mots_code_identique a1 = 1



let%test _ = eq_perm (prefixe [2] a9_1) ["ame";"an";"ane";"au";"bof";"bu"]
let%test _ = eq_perm (prefixe [2;6] a9_1) ["ame";"an";"ane";"bof"]
let%test _ = eq_perm (prefixe [2;8] a9_1) ["au";"bu"]
let%test _ = eq_perm (prefixe [3;8] a9_1) []
let%test _ = eq_perm (prefixe [] a9_1) ["ame";"an";"ane";"au";"bof";"bu"]
let%test _ = eq_perm (prefixe [] a9_2) ["ame";"an";"ane";"au";"bof";"bu"]
let%test _ = eq_perm (prefixe [] a6) ["an";"ane";"au"]
*)