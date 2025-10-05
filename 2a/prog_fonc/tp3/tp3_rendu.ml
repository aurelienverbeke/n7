(*CONTRAT
Ajoute un element devant tous les listes d'une liste
Paramètre n : élément à ajouter
Retourne : liste avec l'élément en amont de toutes les listes
*)
let fusion n = List.map (fun l -> n::l)



(*** Combinaisons d'une liste ***)

(* CONTRAT 
Renvoie toutes les combinaisons de k éléments dans une liste l, en respectant l'ordre des éléments
Paramètres :
	- k : nombre d'éléments à utiliser
	- l : liste à utiliser
Résultat : combinaisons ('a list list)
Pré-condition : 0 <= k <= len(l)
*)
let rec combinaison l k =
	if k=0 then []
	else if k=1 then List.fold_right (fun e acc -> [e]::acc) l []
	else if k=(List.length l) then [l]
	else match l with
		| [] -> []
		| e::r -> (fusion e (combinaison r (k-1)))@(combinaison r k)
		

(* TESTS *)
let%test _ = combinaison [1;2;3;4] 1 = [[1]; [2]; [3]; [4]]
let%test _ = combinaison [1;2;3;4] 2 = [[1;2]; [1;3]; [1;4]; [2;3]; [2;4]; [3;4]]
let%test _ = combinaison [1;2;3;4] 3 = [[1;2;3]; [1;2;4]; [1;3;4]; [2;3;4]]
let%test _ = combinaison [1;2;3;4] 4 = [[1;2;3;4]]
