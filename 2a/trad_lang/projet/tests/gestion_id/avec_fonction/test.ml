open Rat
open Compilateur
open Exceptions

exception ErreurNonDetectee

(****************************************)
(** Chemin d'accès aux fichiers de test *)
(****************************************)

let pathFichiersRat = "../../../../../tests/gestion_id/avec_fonction/fichiersRat/"

(**********)
(*  TESTS *)
(**********)

let%test_unit "testDoubleDeclarationVariable1" = 
  try 
    let _ = compiler (pathFichiersRat^"testDoubleDeclarationVariable1.rat")
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("x") -> ()  

let%test_unit "testDoubleDeclarationVariable2" = 
  let _ = compiler (pathFichiersRat^"testDoubleDeclarationVariable2.rat") in ()

let%test_unit "testDoubleDeclarationVariable3" = 
  let _ = compiler (pathFichiersRat^"testDoubleDeclarationVariable3.rat") in ()
	  
let%test_unit "testDoubleDeclarationVariable4" = 
  try 
    let _ = compiler (pathFichiersRat^"testDoubleDeclarationVariable4.rat") 
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("x") -> ()

let%test_unit "testDoubleDeclarationVariable5" = 
  try 
    let _ = compiler (pathFichiersRat^"testDoubleDeclarationVariable5.rat")
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("x") -> ()

let%test_unit "testDoubleDeclarationVariable6" = 
  try 
    let _ = compiler (pathFichiersRat^"testDoubleDeclarationVariable6.rat") 
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("x") -> ()

let%test_unit "testDoubleDeclarationVariable7" = 
  try 
    let _ = compiler (pathFichiersRat^"testDoubleDeclarationVariable7.rat") 
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("x") -> ()

let%test_unit "testAffectation5" = 
  try 
    let _ = compiler (pathFichiersRat^"testAffectation5.rat")
    in raise ErreurNonDetectee
  with
  | MauvaiseUtilisationIdentifiant("add") -> ()
  | MauvaiseUtilisationIdentifiant("add2") -> ()

let%test_unit "testUtilisation4" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation4.rat")
    in raise ErreurNonDetectee
  with
  | MauvaiseUtilisationIdentifiant("add") -> ()

let%test_unit "testUtilisation5" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation5.rat")
    in raise ErreurNonDetectee
  with
  | MauvaiseUtilisationIdentifiant("add") -> ()

let%test_unit "testUtilisation6" = 
  let _ = compiler (pathFichiersRat^"testUtilisation6.rat") in ()

let%test_unit "testUtilisation7" = 
  let _ = compiler (pathFichiersRat^"testUtilisation7.rat") in ()

let%test_unit "testUtilisation8" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation8.rat")
    in raise ErreurNonDetectee
  with
  | MauvaiseUtilisationIdentifiant("x") -> ()

let%test_unit "testUtilisation9" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation9.rat")
    in raise ErreurNonDetectee
  with
  | MauvaiseUtilisationIdentifiant("z") -> ()

let%test_unit "testUtilisation20" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation20.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("y") -> ()

let%test_unit "testUtilisation21" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation21.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("y") -> ()

let%test_unit "testUtilisation22" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation22.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("y") -> ()

let%test_unit "testUtilisation23" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation23.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("x") -> ()

let%test_unit "testUtilisation24" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation24.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("x") -> ()

let%test_unit "testUtilisation25" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation25.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("a") -> ()

let%test_unit "testUtilisation26" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation26.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("a") -> ()

let%test_unit "testUtilisation27" = 
  let _ = compiler (pathFichiersRat^"testUtilisation27.rat") in ()

let%test_unit "testDeclarationFonction" = 
  let _ = compiler (pathFichiersRat^"testDeclarationFonction.rat") in ()

let%test_unit "testDoubleDeclarationFonction" = 
try 
  let _ = compiler (pathFichiersRat^"testDoubleDeclarationFonction.rat")
  in raise ErreurNonDetectee
with
| DoubleDeclaration("add") -> ()

let%test_unit "testDoubleDeclarationParametre1" = 
try 
  let _ = compiler (pathFichiersRat^"testDoubleDeclarationParametre1.rat")
  in raise ErreurNonDetectee
with
| DoubleDeclaration("a") -> ()

let%test_unit "testDoubleDeclarationParametre2" = 
try 
  let _ = compiler (pathFichiersRat^"testDoubleDeclarationParametre2.rat")
  in raise ErreurNonDetectee
with
| DoubleDeclaration("a") -> ()

let%test_unit "testRecursiviteFonction" = 
let _ = compiler (pathFichiersRat^"testRecursiviteFonction.rat") in ()

let%test_unit "test"= 
  let _ = compiler (pathFichiersRat^"test.rat") in ()

let%test_unit "test2" = 
  let _ = compiler (pathFichiersRat^"test2.rat") in ()

let%test_unit "testRetourFonction"=
  try
    let _ = compiler (pathFichiersRat^"testRetourFonction.rat")
    in raise ErreurNonDetectee
  with
  | RetourDansMain -> ()

let%test_unit "testPointeurs1" = 
  let _ = compiler (pathFichiersRat^"testPointeurs1.rat") in ()

let%test_unit "testPointeurs2" = 
  let _ = compiler (pathFichiersRat^"testPointeurs2.rat") in ()

let%test_unit "testPointeurs3" = 
  let _ = compiler (pathFichiersRat^"testPointeurs3.rat") in ()

let%test_unit "testPointeurs4" = 
  try 
    let _ = compiler (pathFichiersRat^"testPointeurs4.rat")
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("a") -> ()

let%test_unit "testPointeurs5" = 
  let _ = compiler (pathFichiersRat^"testPointeurs5.rat") in ()

let%test_unit "testPointeurs6" = 
  let _ = compiler (pathFichiersRat^"testPointeurs6.rat") in ()

let%test_unit "testPointeurs7" = 
  let _ = compiler (pathFichiersRat^"testPointeurs7.rat") in ()

let%test_unit "testPointeurs8" = 
  try 
    let _ = compiler (pathFichiersRat^"testPointeurs8.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("b") -> ()

let%test_unit "testPointeurs9" = 
  try 
    let _ = compiler (pathFichiersRat^"testPointeurs9.rat")
    in raise ErreurNonDetectee
  with
  | MauvaiseUtilisationIdentifiant("x") -> ()

let%test_unit "testPointeurs10" = 
  let _ = compiler (pathFichiersRat^"testPointeurs10.rat") in ()

let%test_unit "testPointeurs11" = 
  try 
    let _ = compiler (pathFichiersRat^"testPointeurs11.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("pointeurInterne") -> ()

let%test_unit "testPointeurs12" = 
  try 
    let _ = compiler (pathFichiersRat^"testPointeurs12.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("b") -> ()

let%test_unit "testPointeurs13" = 
  try 
    let _ = compiler (pathFichiersRat^"testPointeurs13.rat")
    in raise ErreurNonDetectee
  with
  | MauvaiseUtilisationIdentifiant("fonction") -> ()

let%test_unit "testProcedures1" = 
  let _ = compiler (pathFichiersRat^"testProcedures1.rat") in ()

let%test_unit "testProcedures2" = 
  let _ = compiler (pathFichiersRat^"testProcedures2.rat") in ()

let%test_unit "testProcedures3" = 
  let _ = compiler (pathFichiersRat^"testProcedures3.rat") in ()

let%test_unit "testProcedures4" = 
  let _ = compiler (pathFichiersRat^"testProcedures4.rat") in ()

let%test_unit "testProcedures5" = 
  try 
    let _ = compiler (pathFichiersRat^"testProcedures5.rat")
    in raise ErreurNonDetectee
  with
  | MauvaiseUtilisationIdentifiant("procedure") -> ()

let%test_unit "testProcedures6" = 
  try 
    let _ = compiler (pathFichiersRat^"testProcedures6.rat")
    in raise ErreurNonDetectee
  with
  | MauvaiseUtilisationIdentifiant("procedure") -> ()

let%test_unit "testProcedures7" = 
  let _ = compiler (pathFichiersRat^"testProcedures7.rat") in ()

let%test_unit "testProcedures11" = 
  try 
    let _ = compiler (pathFichiersRat^"testProcedures11.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("procedureInexistante") -> ()

let%test_unit "testProcedures12" = 
  try 
    let _ = compiler (pathFichiersRat^"testProcedures12.rat")
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("procedure") -> ()

let%test_unit "testProcedures13" = 
  let _ = compiler (pathFichiersRat^"testProcedures13.rat") in ()

let%test_unit "testProcedures14" = 
  let _ = compiler (pathFichiersRat^"testProcedures14.rat") in ()

let%test_unit "testProcedures15" = 
  let _ = compiler (pathFichiersRat^"testProcedures15.rat") in ()

let%test_unit "testProcedures16" = 
  try 
    let _ = compiler (pathFichiersRat^"testProcedures16.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("b") -> ()

let%test_unit "testProcedures17" = 
  let _ = compiler (pathFichiersRat^ "testProcedures17.rat") in ()

let%test_unit "testProcedures18" = 
  try 
    let _ = compiler (pathFichiersRat^"testProcedures18.rat")
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("procedure") -> ()

let%test_unit "testProcedures19" = 
  try 
    let _ = compiler (pathFichiersRat^"testProcedures19.rat")
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("procedure") -> ()

let%test_unit "testProcedures20" = 
  let _ = compiler (pathFichiersRat^"testProcedures20.rat") in ()

let%test_unit "testReferences1" = 
  let _ = compiler (pathFichiersRat^"testReferences1.rat") in ()

let%test_unit "testReferences2" = 
  let _ = compiler (pathFichiersRat^"testReferences2.rat") in ()

let%test_unit "testReferences3" = 
  let _ = compiler (pathFichiersRat^"testReferences3.rat") in ()

let%test_unit "testReferences4" = 
  let _ = compiler (pathFichiersRat^"testReferences4.rat") in ()

let%test_unit "testReferences5" = 
  try 
    let _ = compiler (pathFichiersRat^"testReferences5.rat")
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("x") -> ()

let%test_unit "testReferences6" = 
  try 
    let _ = compiler (pathFichiersRat^"testReferences6.rat")
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("x") -> ()

let%test_unit "testReferences7" = 
  let _ = compiler (pathFichiersRat^"testReferences7.rat") in ()

let%test_unit "testReferences8" = 
  let _ = compiler (pathFichiersRat^"testReferences8.rat") in ()

let%test_unit "testReferences9" = 
  try 
    let _ = compiler (pathFichiersRat^"testReferences9.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("a") -> ()

let%test_unit "testReferences10" = 
  try 
    let _ = compiler (pathFichiersRat^"testReferences10.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("a") -> ()

let%test_unit "testReferences11" = 
  let _ = compiler (pathFichiersRat^"testReferences11.rat") in ()

let%test_unit "testReferences12" = 
  let _ = compiler (pathFichiersRat^"testReferences12.rat") in ()

let%test_unit "testReferences13" = 
  let _ = compiler (pathFichiersRat^"testReferences13.rat") in ()

let%test_unit "testReferences14" = 
  let _ = compiler (pathFichiersRat^"testReferences14.rat") in ()

let%test_unit "testReferences15" = 
  try 
    let _ = compiler (pathFichiersRat^"testReferences15.rat")
    in raise ErreurNonDetectee
  with
  | UtilisationRefInvalide -> ()

let%test_unit "testReferences16" = 
  try 
    let _ = compiler (pathFichiersRat^"testReferences16.rat")
    in raise ErreurNonDetectee
  with
  | UtilisationRefInvalide -> ()

let%test_unit "testReferences17" = 
  let _ = compiler (pathFichiersRat^"testReferences17.rat") in ()

let%test_unit "testReferences18" = 
  let _ = compiler (pathFichiersRat^"testReferences18.rat") in ()

let%test_unit "testReferences19" = 
  let _ = compiler (pathFichiersRat^"testReferences19.rat") in ()
  
let%test_unit "testReferences20" = 
  let _ = compiler (pathFichiersRat^"testReferences20.rat") in ()

let%test_unit "testEnumerations1" =
  let _ = compiler (pathFichiersRat^"testEnumerations1.rat") in ()

let%test_unit "testEnumerations2" =
  let _ = compiler (pathFichiersRat^"testEnumerations2.rat") in ()

let%test_unit "testEnumerations3" =
  try
    let _ = compiler (pathFichiersRat^"testEnumerations3.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("b") -> ()

let%test_unit "testEnumerations4.rat" =
  try
    let _ = compiler (pathFichiersRat^"testEnumerations4.rat")
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("a") -> ()

let%test_unit "testEnumerations5" =
  try
    let _ = compiler (pathFichiersRat^"testEnumerations5.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("b") -> ()

let%test_unit "testEnumerations6.rat" =
  try
    let _ = compiler (pathFichiersRat^"testEnumerations6.rat")
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("a") -> ()

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

(*
let%test_unit "all_tam" =
  let p_tam = "../../../../../tests/tam/avec_fonction/fichiersRat/" in
  let d = opendir p_tam in
  test d p_tam
*)
*)