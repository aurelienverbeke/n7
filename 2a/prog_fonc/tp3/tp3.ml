(****** Algorithmes combinatoires et listes ********)


(*CONTRAT
Ajoute un element devant tous les listes d'une liste
Paramètre n : élément à ajouter
Retourne : liste avec l'élément en amont de toutes les listes
*)
let fusion n = List.map (fun l -> n::l)


(*** Code binaires de Gray ***)

(*CONTRAT
Fonction qui génère un code de Gray
Paramètre n : la taille du code
Resultat : le code sous forme de int list list
*)


let rec gray_code n =
	match n with
		| 0 -> [[]]
		| _ -> let gray_code_m_1 = (gray_code (n-1)) in (fusion 0 gray_code_m_1)@(fusion 1 (List.rev gray_code_m_1))

(* TESTS *)
let%test _ = gray_code 0 = [[]]
let%test _ = gray_code 1 = [[0]; [1]]
let%test _ = gray_code 2=  [[0; 0]; [0; 1]; [1; 1]; [1; 0]]
let%test _ = gray_code 3 = [[0; 0; 0]; [0; 0; 1]; [0; 1; 1]; [0; 1; 0]; [1; 1; 0]; [1; 1; 1]; [1; 0; 1];
 [1; 0; 0]]
 let%test _ = gray_code 4 = [[0; 0; 0; 0]; [0; 0; 0; 1]; [0; 0; 1; 1]; [0; 0; 1; 0]; [0; 1; 1; 0];
  [0; 1; 1; 1]; [0; 1; 0; 1]; [0; 1; 0; 0]; [1; 1; 0; 0]; [1; 1; 0; 1];
  [1; 1; 1; 1]; [1; 1; 1; 0]; [1; 0; 1; 0]; [1; 0; 1; 1]; [1; 0; 0; 1];
  [1; 0; 0; 0]]


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
	match (k, l) with
		| (0, _) -> [[]]
		| (_, []) -> [[]]
		(* | (1, _) -> List.fold_right (fun e acc -> [e]::acc) l [] *)
		| (_, e::r) -> if k=(List.length l) then [l]
				else (fusion e (combinaison r (k-1)))@(combinaison r k)
		

(* TESTS *)
let%test _ = combinaison [1;2;3;4] 0 = [[]]
let%test _ = combinaison [1;2;3;4] 1 = [[1]; [2]; [3]; [4]]
let%test _ = combinaison [1;2;3;4] 2 = [[1;2]; [1;3]; [1;4]; [2;3]; [2;4]; [3;4]]
let%test _ = combinaison [1;2;3;4] 3 = [[1;2;3]; [1;2;4]; [1;3;4]; [2;3;4]]
let%test _ = combinaison [1;2;3;4] 4 = [[1;2;3;4]]


(*** Partition d'un entier ***)

(* partition int -> int list
Fonction qui calcule toutes les partitions possibles d'un entier n
Paramètre n : un entier dont on veut calculer les partitions
Préconditions : n >0
Retour : les partitions de n
*)

let rec partition n =
	let rec aux n t =
		if n-t<t then (aux n (t+1))
		else if t<n then (fusion t (partition (n-t)))@(aux n (t+1))
		else [[n]]
	in aux n 1


(* TEST - à décommenter pour tester ! *)
let%test _ = partition 1 = [[1]]
let%test _ = partition 2 = [[1;1];[2]]
let%test _ = partition 3 = [[1; 1; 1]; [1; 2]; [3]]
let%test _ = partition 4 = [[1; 1; 1; 1]; [1; 1; 2]; [1; 3]; [2; 2]; [4]]



(*** Permutations d'une liste ***)

(* CONTRAT
Fonction prend en paramètre un élément e et une liste l et qui insére e à toutes les possitions possibles dans l
Pamaètre e : ('a) l'élément à insérer
Paramètre l : ('a list) la liste initiale dans laquelle insérer e
Reesultat : la liste des listes avec toutes les insertions possible de e dans l
*)

let rec insertion e l = failwith "TO DO"

(* TESTS - à décommenter pour tester !  *)
(*
let%test _ = insertion 0 [1;2] = [[0;1;2];[1;0;2];[1;2;0]]
let%test _ = insertion 0 [] = [[0]]
let%test _ = insertion 3 [1;2] = [[3;1;2];[1;3;2];[1;2;3]]
let%test _ = insertion 3 [] = [[3]]
let%test _ = insertion 5 [12;54;0;3;78] =
[[5; 12; 54; 0; 3; 78]; [12; 5; 54; 0; 3; 78]; [12; 54; 5; 0; 3; 78];
 [12; 54; 0; 5; 3; 78]; [12; 54; 0; 3; 5; 78]; [12; 54; 0; 3; 78; 5]]
 let%test _ = insertion 'x' ['a';'b';'c']=
 [['x'; 'a'; 'b'; 'c']; ['a'; 'x'; 'b'; 'c']; ['a'; 'b'; 'x'; 'c'];
  ['a'; 'b'; 'c'; 'x']]
*)

(* CONTRAT
Fonction qui renvoie la liste des permutations d'une liste
Paramètre l : une liste
Résultat : la liste des permutatiions de l (toutes différentes si les élements de l sont différents deux à deux 
*)

let rec permutations l = failwith "TO DO"

(* TESTS - à décommenter pour tester !  *)
(*
let l1 = permutations [1;2;3]
let%test _ = List.length l1 = 6
let%test _ = List.mem [1; 2; 3] l1 
let%test _ = List.mem [2; 1; 3] l1 
let%test _ = List.mem [2; 3; 1] l1 
let%test _ = List.mem [1; 3; 2] l1 
let%test _ = List.mem [3; 1; 2] l1 
let%test _ = List.mem [3; 2; 1] l1 
let%test _ = permutations [] =[[]]
let l2 = permutations ['a';'b']
let%test _ = List.length l2 = 2
let%test _ = List.mem ['a';'b'] l2 
let%test _ = List.mem ['b';'a'] l2 
*)

