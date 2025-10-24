open GrandNombre

(* Diverses fonctions annexes *)
module Util =
struct
  (* signe_absolu : int -> (bool * int)
    Récupérer le signe et la valeur absolue
    Paramètres :
      - n : entier initial
    Retour : (signe de l'entier, valeur absolue)
  *) 
  let signe_absolu n = if n>=0 then (false, n) else (true, -n)
end

module IntListBigNum : sig

  include IGrandNombre with type t = bool * int list

  val comparer_listes : int list -> int list -> int

  val plus_listes : int list -> int list -> int list

  val moins_listes : int list -> int list -> int list

  val mult_coeff : int list -> int -> int list

end = struct
  (* Type pour le grand nombre *)
  type t = bool * int list

  (* normalise : int list -> int list
     Normalise une liste de chiffres, c'est à dire retire autant de 0
     que possible du début du nombre.
     Paramètres :
         n : int list, nombre à normaliser (list de chiffre)
     Retour : n' tel que n et n' représentent le même nombre, mais n' ne
     commence pas par 0
  *)
  let normalise n =
    List.fold_right (fun t nq -> if t = 0 && nq = [] then [] else t::nq) n []

  let%test "normalise-1" = (normalise [1;2;3;0;0;0;0;0] = [1;2;3])
  let%test "normalise-2" = (normalise [1;0;1;0;1;0;1;0] = [1;0;1;0;1;0;1])
  let%test "normalise-3" = (normalise [2] = [2])
  let%test "normalise-4" = (normalise [] = [])
  let%test "normalise-5" = (normalise [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0] = [])

  (* from_int : int -> bool * int list
     Transforme un entier en grand nombre (base 100)
     Paramètres :
      - n : nombre à transformer
    Retour : nombre transformé en grand nombre (base 100)
  *)
  let from_int n = match n with
    | 0 -> (false, [])
    | _ ->
      let rec decomposition m = if m>=100 then (m mod 100)::(decomposition (m/100)) else [m]
      in let (signe, absolu) = Util.signe_absolu n
      in (signe, decomposition absolu)

(* Tests *)
let%test _ = (from_int 2836 = (false, [36;28]))
let%test _ = (from_int 0 = (false, []))
let%test _ = (from_int (-12345) = (true, [45;23;1]))
let%test _ = (from_int (-2) = (true, [2]))

(* from_digit : bool -> int list -> bool * int list
     Transforme une suite de chiffres en grand nombre (base 100)
     Paramètres :
      - signe : signe du nombre (true = negatif)
      - n : suite de chiffres à transformer
    Retour : nombre transformé en grand nombre (base 100)
    Pré-condition : tous les chiffres sont positifs
  *)
let from_digits signe n =
  let rec produit_2 l =
    match l with
      | a::b::r -> a+b*10::(produit_2 r)
      | _ -> l
  in (signe, produit_2 (normalise (List.rev n)))

(* Test *)
let%test "from_digits-0" = (from_digits false [0;0] = (false, []))
let%test "from_digits-1" = (from_digits false [1;2;3;4;5;6;7] = (false, [67;45;23;1]))
let%test "from_digits-2" = (from_digits true [0;0;0;4;2] = (true, [42]))
let%test "from_digits-3" = (from_digits false [1;0;0;0;0] = (false, [0;0;1]))
let%test "from_digits-4" = (from_digits true [] = (true, []))
let%test "from_digits-5" = (from_digits true [9] = (true, [9]))

  let afficher_list =
    let rec afficher_aux fmt = function
      | [] -> ()
      | d :: q -> Format.fprintf fmt "%a%.2d" afficher_aux q d
    in
    fun fmt l ->
      match l with
      | [] -> Format.pp_print_char fmt '0'
      | _ -> afficher_aux fmt l

  let afficher (s,n) =
    Format.printf "%t%a"
      (fun fmt -> if s then Format.pp_print_char fmt '-' else ())
      afficher_list n


  (* comparer_listes : int list -> int list -> int
     Compare deux listes pour savoir laquelle représente le nombre le plus grand.
     Paramètres :
         n1,n2 : int list, nombres à comparer (liste de chiffres)
     Retour : > 0 si n1 > n2, < 0 si n2 > n1, = 0 sinon
  *)
  let comparer_listes n1 n2 =
    let (n1, n2) = (normalise n1, normalise n2)
    in let difference_longueur = List.length n1 - List.length n2
    in if difference_longueur = 0
      then
        (* Les listes ont la même longueur, on compare case par case en partant de la fin*)
        let rec comparer_case_par_case l1 l2 =
          match (l1, l2) with
            (* Les listes étaient de la même longueur, elles le resteront pendant la récursion *)
            | x1::r1, x2::r2 ->
                let difference_nombre = x1 - x2
                in if difference_nombre = 0 then comparer_case_par_case r1 r2 else difference_nombre
            | _ -> 0
        in comparer_case_par_case (List.rev n1) (List.rev n2)
      (* Les listes sont de longueur différente *)
      else difference_longueur

(* Tests *)
let%test "comparer_listes-0" = (comparer_listes [] [] = 0)
let%test "comparer_listes-1" = (comparer_listes [12] [] > 0)
let%test "comparer_listes-2" = (comparer_listes [] [12] < 0)
let%test "comparer_listes-3" = (comparer_listes [78;56;34;12] [78;56;34;12] = 0)
let%test "comparer_listes-4" = (comparer_listes [78;56;34;12] [79;56;34;12] < 0)
let%test "comparer_listes-5" = (comparer_listes [56;34;12] [11;11;11;11] < 0)


  (* comparer : (bool * int list -> bool * int list -> int)
     Compare deux grands nombres.
     Paramètres :
         (signe1, n1) et (signe2, n2) : grands nombres à comparer
     Retour : > 0 si n1 > n2, < 0 si n2 > n1, = 0 sinon
  *)
  let comparer (signe1, n1) (signe2, n2) = match (signe1, signe2, n1, n2) with
    | _, _, [], [] -> 0
    | true, false, _, _ -> -1
    | false, true, _, _ -> 1
    | _, _ , _, _ -> comparer_listes n1 n2

  (* Le module IntListTest, défini en fin de fonction, permet de tester les fonctions sur les grands nombres *)
  (* Tests complémentaires pour les cas limites *)

let%test "comparer-0-1" = (comparer (false,[]) (false,[]) = 0)
let%test "comparer-0-2" = (comparer (false,[]) (true,[]) = 0)

  (* plus_listes : int list -> int list -> int list
     Réalise la somme de deux listes de "chiffres"
     Paramètres :
         n1,n2 : int list, nombres à additionner, sous forme de liste de "chiffres"
     Retour : somme de n1 et n2 (sous forme de liste de "chiffres")
     Le résultat est normalisé
  *)
  let plus_listes n1 n2 =
    let longueur1 = List.length n1 and longueur2 = List.length n2
    (* On fait des listes de la même taille *)
    in let (n1, n2) =
      if longueur1 > longueur2 then (n1, n2@(List.init (longueur1-longueur2) (fun _ -> 0)))
      else if longueur1 < longueur2 then (n1@(List.init (longueur2-longueur1) (fun _ -> 0)), n2)
      else (n1, n2)
    (* On somme en partant de la gauche, ie les "chiffres" de plus faible poids *)
    in let (retenue, resultat) = List.fold_left
      (fun (retenue, somme) (x1, x2) ->
        let nouvelle_somme = x1+x2+retenue in
        if nouvelle_somme > 99 then (nouvelle_somme-99, 0::somme)
        else (0, nouvelle_somme::somme)
      )
      (0, [])
      (List.combine n1 n2)
    (* On fait attention à un possible résultat de la forme [0;0...] si la retenue n'est pas nulle *)
    in match retenue with
      | 0 -> List.rev resultat
      | _ -> List.rev resultat@[retenue]

let%test "plus_listes-base" = (plus_listes [] [] = []) (* 0 + 0 = 0 *)
let%test "plus_listes-zero-1" = (plus_listes [0] [1] = [1]) (* 0 + 1 = 1 *)
let%test "plus_listes-zero-2" = (plus_listes [34;12] [] = [34;12]) (* 1234+0 = 1234 *)
let%test "plus_listes-nominal-1" = (plus_listes [30;20;10] [1;5] = [31;25;10]) (* 102030 +501 = 102531 *)
let%test "plus_listes-nominal-2" = (plus_listes [4;5;6;7] [6;5;4;3] = [10;10;10;10]) (* 7060504 + 3040506 = 10101010 *)
let%test "plus_listes-carrier-1" = (plus_listes [99;10] [1] = [0;11]) (* 1099 + 1 = 1100 *)
let%test "plus_listes-carrier-2" = (plus_listes [10;5] [90;94] = [0;0;1]) (* 510 + 9490 = 10000*)

  (* moins_listes : int list -> int list -> int list
     Réalise la différence positive de deux listes de "chiffres"
     Paramètres :
         n1,n2 : int list, nombres à soustraire, sous forme de liste de "chiffres"
     Retour : différence entre n1 et n2 (sous forme de liste de "chiffres")
     Pré-conditions : n1 >= n2
     Le résultat est normalisé
  *)
  let moins_listes n1 n2 =
    (* On fait des listes de la même taille *)
    let n2 = n2@(List.init ((List.length n1)-(List.length n2)) (fun _ -> 0))
    (* On soustrait en partant de la gauche, ie les "chiffres" de plus faible poids *)
    in let (retenue, resultat) = List.fold_left
      (fun (retenue, difference) (x1, x2) ->
        let nouvelle_difference = x1-retenue-x2 in
        if nouvelle_difference < 0 then (1, 100+nouvelle_difference::difference)
        else (0, nouvelle_difference::difference)
      )
      (0, [])
      (List.combine n1 n2)
    (* On fait attention à un possible résultat de la forme [0;0...] si la retenue n'est pas nulle *)
    in match retenue with
      | 0 -> normalise (List.rev resultat)
      | _ -> normalise (List.rev resultat@[retenue])

let%test "moins_listes-base" = (moins_listes [] [] = [])
let%test "moins_listes-nominal-1" = (moins_listes [10;20;30] [1;1;1] = [9;19;29])
let%test "moins_listes-carrier-1" = (moins_listes [0;10] [1] = [99;9])
let%test "moins_listes-carrier-2" = (moins_listes [0;20;50] [1;20;1] = [99;99;48])
let%test "moins_listes-zero" = (moins_listes [1;2;3] [1;2;3] = [])

  (* Note plus a besoin de moins et moins a besoin de plus ; on les définit
     ensemble. *)
  (* plus : bool * int list -> bool * int list -> int
     Fait la somme de deux grands nombres.
     Paramètres :
         (signe1, n1) et (signe2, n2) : grands nombres à sommer
     Retour : n1 + n2
  *)
  (* moins : bool * int list -> bool * int list -> int
     Fait la différence de deux grands nombres.
     Paramètres :
         (signe1, n1) et (signe2, n2) : grands nombres à soustraire
     Retour : n1 - n2
     Post-conditions : nombre normalisé
  *)

  (* EN COURS, NON ABOUTI *)
  (*
  let rec plus (signe1, n1) (signe2, n2) = match signe1, signe2 with
    | true, false -> ()
    | false, true
  and moins (signe1, n1) (signe2, n2) = (false,[])
  *)

  let rec plus _ _ = (false,[])
  and moins _ _ = (false,[])


  (* mult_coeff : int list -> int -> int list
     Multiplie un grand nombre (une liste de chiffres) par un nombre entier "normal"
     Paramètres :
         n : int list, grand nombre (list de chiffres)
         m : int, entier qui sert de facteur
      Retour : n * m
      Post-conditions : nombre normalisé
  *)
  let mult_coeff _ _ = []
(*
let%test "mult_coeff-0" = mult_coeff [56;34;12] 0 = []
let%test "mult_coeff-1" = mult_coeff [34;12] 2  = [68;24]
let%test "mult_coeff-2" = mult_coeff [34;12] 10 = [40;23;1]
let%test "mult_coeff-3" = mult_coeff [34;12] 51 = [34;29;6]
let%test "mult_coeff-4" = mult_coeff [99;99] 99 = [01;99;98]
*)
  let mult _ _ = (false,[])

  let puiss _ _ = (false,[])
end

(* Décommenter pour lancer les tests ! *)
module IntListTest = GrandNombreTest (IntListBigNum)
module IntListAlgo = GrandNombreAlgorithmes (IntListBigNum)



