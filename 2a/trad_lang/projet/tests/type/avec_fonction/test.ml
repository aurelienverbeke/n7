open Rat
open Compilateur
open Exceptions

exception ErreurNonDetectee

(****************************************)
(** Chemin d'accès aux fichiers de test *)
(****************************************)

let pathFichiersRat = "../../../../../tests/type/avec_fonction/fichiersRat/"

(**********)
(*  TESTS *)
(**********)


let%test_unit "test2"= 
  let _ = compiler (pathFichiersRat^"test2.rat") in ()

let%test_unit "testAppel1"= 
  let _ = compiler (pathFichiersRat^"testAppel1.rat") in ()

let%test_unit "testAppel2"= 
  let _ = compiler (pathFichiersRat^"testAppel2.rat") in ()

let%test_unit "testAppel3"= 
  let _ = compiler (pathFichiersRat^"testAppel3.rat") in ()

let%test_unit "testAppel4"= 
  let _ = compiler (pathFichiersRat^"testAppel4.rat") in ()

let%test_unit "testAppel5"= 
  let _ = compiler (pathFichiersRat^"testAppel5.rat") in ()

let%test_unit "testAppel6"= 
  try 
    let _ = compiler (pathFichiersRat^"testAppel6.rat")
    in raise ErreurNonDetectee
  with
  | TypesParametresInattendus _ -> ()

let%test_unit "testAppel7"= 
  try 
    let _ = compiler (pathFichiersRat^"testAppel7.rat")
    in raise ErreurNonDetectee
  with
  | TypesParametresInattendus _ -> ()

let%test_unit "testAppel8"= 
  try 
    let _ = compiler (pathFichiersRat^"testAppel8.rat")
    in raise ErreurNonDetectee
  with
  | TypesParametresInattendus _ -> ()

let%test_unit "testAppel9"= 
  try 
    let _ = compiler (pathFichiersRat^"testAppel9.rat")
    in raise ErreurNonDetectee
  with
  | TypesParametresInattendus _ -> ()

let%test_unit "testAppel10"= 
  try 
    let _ = compiler (pathFichiersRat^"testAppel10.rat")
    in raise ErreurNonDetectee
  with
  | TypesParametresInattendus _  -> ()

let%test_unit "testAppel11"= 
  try 
    let _ = compiler (pathFichiersRat^"testAppel11.rat")
    in raise ErreurNonDetectee
  with
  | TypesParametresInattendus _  -> ()

let%test_unit "testAppel12"= 
  try 
    let _ = compiler (pathFichiersRat^"testAppel12.rat")
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Int,Bool) -> ()

let%test_unit "testAppel13"= 
  try 
    let _ = compiler (pathFichiersRat^"testAppel13.rat")
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Int,Rat) -> ()

let%test_unit "testRetourFonction1"= 
  let _ = compiler (pathFichiersRat^"testRetourFonction1.rat") in ()

let%test_unit "testRetourFonction2"= 
  try 
    let _ = compiler (pathFichiersRat^"testRetourFonction2.rat")
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Bool,Int) -> ()

let%test_unit "testRetourFonction3"=
  let _ = compiler (pathFichiersRat^"testRetourFonction3.rat") in ()

let%test_unit "testRetourFonction4"=
  try
    let _ = compiler (pathFichiersRat^"testRetourFonction4.rat")
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Bool,Int) -> ()

let%test_unit "testRecursiviteFonction"= 
  let _ = compiler (pathFichiersRat^"testRecursiviteFonction.rat") in ()

let%test_unit "test"= 
  let _ = compiler (pathFichiersRat^"test.rat") in ()

let%test_unit "code_factrec" = 
let _ = compiler   (pathFichiersRat^"factrec.rat") in ()

let%test_unit "testPointeurs1" = 
    let _ = compiler (pathFichiersRat^"testPointeurs1.rat") in ()

let%test_unit "testPointeurs2" = 
    let _ = compiler (pathFichiersRat^"testPointeurs2.rat") in ()

let%test_unit "testPointeurs3" = 
    try
        let _ = compiler (pathFichiersRat^"testPointeurs3.rat") 
        in raise ErreurNonDetectee
    with
    | TypesParametresInattendus (_, _) -> ()

let%test_unit "testPointeurs4" = 
    try
        let _ = compiler (pathFichiersRat^"testPointeurs4.rat") 
        in raise ErreurNonDetectee
    with
    | TypesParametresInattendus (_, _) -> ()

let%test_unit "testPointeurs5" = 
    try
        let _ = compiler (pathFichiersRat^"testPointeurs5.rat") 
        in raise ErreurNonDetectee
    with
    | TypesParametresInattendus (_, _) -> ()

let%test_unit "testPointeurs6" = 
    try
        let _ = compiler (pathFichiersRat^"testPointeurs6.rat") 
        in raise ErreurNonDetectee
    with
    | TypesParametresInattendus (_, _) -> ()

let%test_unit "testPointeurs7" = 
    try
        let _ = compiler (pathFichiersRat^"testPointeurs7.rat") 
        in raise ErreurNonDetectee
    with
    | TypesParametresInattendus (_, _) -> ()

let%test_unit "testPointeurs8" = 
    try
        let _ = compiler (pathFichiersRat^"testPointeurs8.rat") 
        in raise ErreurNonDetectee
    with
    | TypesParametresInattendus (_, _) -> ()

let%test_unit "testPointeurs9" = 
    let _ = compiler (pathFichiersRat^"testPointeurs9.rat") in ()

let%test_unit "testPointeurs10" = 
    let _ = compiler (pathFichiersRat^"testPointeurs10.rat") in ()

let%test_unit "testPointeurs11" = 
    let _ = compiler (pathFichiersRat^"testPointeurs11.rat") in ()

let%test_unit "testPointeurs12" = 
    try
        let _ = compiler (pathFichiersRat^"testPointeurs12.rat") 
        in raise ErreurNonDetectee
    with
    | TypeInattendu(Pointeur Rat, Pointeur Int) -> ()

let%test_unit "testPointeurs13" = 
    try
        let _ = compiler (pathFichiersRat^"testPointeurs13.rat") 
        in raise ErreurNonDetectee
    with
    | TypeInattendu(Pointeur Bool,Pointeur Int) -> ()

let%test_unit "testPointeurs14" = 
    try
        let _ = compiler (pathFichiersRat^"testPointeurs14.rat") 
        in raise ErreurNonDetectee
    with
    | TypeInattendu(Pointeur Int,Pointeur Rat) -> ()

let%test_unit "testPointeurs15" = 
    try
        let _ = compiler (pathFichiersRat^"testPointeurs15.rat") 
        in raise ErreurNonDetectee
    with
    | TypeInattendu(Pointeur Bool, Pointeur Rat) -> ()

let%test_unit "testPointeurs16" = 
    try
        let _ = compiler (pathFichiersRat^"testPointeurs16.rat") 
        in raise ErreurNonDetectee
    with
    | TypeInattendu(Pointeur Int, Pointeur Bool) -> ()

let%test_unit "testPointeurs17" = 
    try
        let _ = compiler (pathFichiersRat^"testPointeurs17.rat") 
        in raise ErreurNonDetectee
    with
    | TypeInattendu(Pointeur Rat, Pointeur Bool) -> ()

(*
let%test_unit "testProcedures1"= 
  try 
    let _ = compiler (pathFichiersRat^"testProcedures1.rat")
    in raise ErreurNonDetectee
  with
  | TypeVoidHorsTypeProcedure -> ()

let%test_unit "testProcedures2"= 
  let _ = compiler (pathFichiersRat^"testProcedures2.rat") in ()

let%test_unit "testProcedures3"= 
  let _ = compiler (pathFichiersRat^"testProcedures3.rat") in ()

let%test_unit "testProcedures4"= 
  try 
    let _ = compiler (pathFichiersRat^"testProcedures4.rat")
    in raise ErreurNonDetectee
  with
  | TypesParametresInattendus _ -> ()

let%test_unit "testProcedures5"= 
  try 
    let _ = compiler (pathFichiersRat^"testProcedures5.rat")
    in raise ErreurNonDetectee
  with
  | TypesParametresInattendus _ -> ()

let%test_unit "testProcedures6"= 
  try 
    let _ = compiler (pathFichiersRat^"testProcedures6.rat")
    in raise ErreurNonDetectee
  with
  | TypesParametresInattendus _ -> ()

let%test_unit "testProcedures7"= 
  try 
    let _ = compiler (pathFichiersRat^"testProcedures7.rat")
    in raise ErreurNonDetectee
  with
  | TypesParametresInattendus _ -> ()

let%test_unit "testReferences1"= 
  let _ = compiler (pathFichiersRat^"testReferences1.rat") in ()

let%test_unit "testReferences2"= 
  let _ = compiler (pathFichiersRat^"testReferences2.rat") in () 

let%test_unit "testReferences3"= 
  let _ = compiler (pathFichiersRat^"testReferences3.rat") in ()

let%test_unit "testReferences4"= 
  let _ = compiler (pathFichiersRat^"testReferences4.rat") in () 

let%test_unit "testReferences5"= 
  let _ = compiler (pathFichiersRat^"testReferences5.rat") in ()

let%test_unit "testReferences6"= 
  let _ = compiler (pathFichiersRat^"testReferences6.rat") in ()

let%test_unit "testReferences7" = 
  try
      let _ = compiler (pathFichiersRat^"testReferences7.rat") 
      in raise ErreurNonDetectee
  with
  | TypeInattendu(Int, Rat) -> ()

let%test_unit "testReferences8" = 
  try
      let _ = compiler (pathFichiersRat^"testReferences8.rat") 
      in raise ErreurNonDetectee
  with
  | TypeInattendu(Int, Rat) -> ()

let%test_unit "testReferences9"= 
  let _ = compiler (pathFichiersRat^"testReferences9.rat") in ()

let%test_unit "testReferences10"= 
  let _ = compiler (pathFichiersRat^"testReferences10.rat") in ()

let%test_unit "testReferences11"= 
  let _ = compiler (pathFichiersRat^"testReferences11.rat") in ()

let%test_unit "testReferences12"= 
  let _ = compiler (pathFichiersRat^"testReferences12.rat") in ()
  
let%test_unit "testReferences13" = 
  try
      let _ = compiler (pathFichiersRat^"testReferences13.rat") 
      in raise ErreurNonDetectee
  with
  | TypeInattendu(Bool, Int) -> ()

let%test_unit "testReferences14" = 
  try
      let _ = compiler (pathFichiersRat^"testReferences14.rat") 
      in raise ErreurNonDetectee
  with
  | TypeInattendu(Rat, Int) -> ()

let%test_unit "testReferences15"= 
  let _ = compiler (pathFichiersRat^"testReferences15.rat") in ()

let%test_unit "testReferences16"= 
  let _ = compiler (pathFichiersRat^"testReferences16.rat") in ()

let%test_unit "testReferences17"= 
  let _ = compiler (pathFichiersRat^"testReferences17.rat") in ()

let%test_unit "testReferences18"= 
  let _ = compiler (pathFichiersRat^"testReferences18.rat") in ()

let%test_unit "testReferences19" = 
  try
      let _ = compiler (pathFichiersRat^"testReferences19.rat") 
      in raise ErreurNonDetectee
  with
  | TypesParametresInattendus(_, _) -> ()

let%test_unit "testReferences20" = 
  try
      let _ = compiler (pathFichiersRat^"testReferences20.rat") 
      in raise ErreurNonDetectee
  with
  | TypesParametresInattendus(_, _) -> ()

let%test_unit "testReferences21" = 
  try
      let _ = compiler (pathFichiersRat^"testReferences21.rat") 
      in raise ErreurNonDetectee
  with
  | TypeVoidHorsTypeProcedure -> ()

let%test_unit "testReferences22" = 
  try
      let _ = compiler (pathFichiersRat^"testReferences22.rat") 
      in raise ErreurNonDetectee
  with
  | TypeVoidHorsTypeProcedure -> ()

let%test_unit "testReferences23"= 
  let _ = compiler (pathFichiersRat^"testReferences23.rat") in ()

let%test_unit "testReferences24"= 
  let _ = compiler (pathFichiersRat^"testReferences24.rat") in ()
*)

(* Fichiers de tests de la génération de code -> doivent passer la TDS *)
(*
open Unix
open Filename

let rec test d p_tam = 
  try 
    let file = readdir d in
    if (check_suffix file ".rat") 
    then
    (
     try
       let _ = compiler  (p_tam^file) in (); 
     with e -> print_string (p_tam^file); print_newline(); raise e;
    )
    else ();
    test d p_tam
  with End_of_file -> ()

let%test_unit "all_tam" =
  let p_tam = "../../../../../tests/tam/avec_fonction/fichiersRat/" in
  let d = opendir p_tam in
  test d p_tam
  *)