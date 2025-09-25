(*
	pgcd : int -> int -> int
	Calcule le pgcd entre deux entiers naturels non nuls
	a, b : entiers desquels on calcule le pgcd
	Retourne le pgcd
	Pre-condition : a>=0 b>=0
*)

(*
let rec pgcd a b =
	if a > b then
		pgcd (a-b) b
	else if a < b then
		pgcd a (b-a)
	else
		a
*)

(*
	pgcd : int -> int -> int
	Calcule le pgcd entre deux entiers
	Si un entier est negatif, on en prend la valeur absolue
	a, b : entiers desquels on calcule le pgcd
	Retourne le pgcd
*)

let pgcd a b =
	let rec pgcd_positif a_pos b_pos = if a_pos > b_pos then
			pgcd_positif (a_pos-b_pos) b_pos
		else if a_pos < b_pos then
			pgcd_positif a_pos (b_pos-a_pos)
		else
			a_pos
	in
		pgcd_positif (abs a) (abs b)

let%test _ = pgcd 1 1 = 1
let%test _ = pgcd 5 5 = 5
let%test _ = pgcd 6 36 = 6
let%test _ = pgcd 42 30 = 6
let%test _ = pgcd (-1) 1 = 1
let%test _ = pgcd 5 (-5) = 5
let%test _ = pgcd (-6) (-36) = 6
let%test _ = pgcd (-42) (-30) = 6
