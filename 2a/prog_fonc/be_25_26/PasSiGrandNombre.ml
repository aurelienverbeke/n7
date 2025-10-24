open GrandNombre

module PasSiGrandNombre : IGrandNombre with type t = int =
struct
  type t = int

  (* Remontée pour pouvoir l'utiliser dans from_digits *)
  let rec puiss n k = match k with
    | 0 -> 1
    | k -> n * (puiss n (k-1))

  let from_int n = n
  let from_digits signum chiffres =
    let nb_chiffres = List.length chiffres
    in let nombre_absolu = List.fold_left (fun acc nombre -> acc+nombre) 0 (List.mapi (fun i chiffre -> chiffre*(puiss 10 (nb_chiffres-i-1))) chiffres)
    in match signum with
      | true -> -nombre_absolu
      | false -> nombre_absolu

  let afficher x = print_int x
  let comparer a b = compare a b
  let plus = (+)
  let moins = (-)
  let mult a b = a * b
  
end

(* Décommenter pour lancer les tests ! *)
(*
module PasSiGrandNombreTest = GrandNombreTest (PasSiGrandNombre)
module PasSiGrandNombreAlgo = GrandNombreAlgorithmes (PasSiGrandNombre)
*)