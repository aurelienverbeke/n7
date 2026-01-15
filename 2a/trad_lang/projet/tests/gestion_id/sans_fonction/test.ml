open Rat
open Compilateur
open Exceptions

exception ErreurNonDetectee

(****************************************)
(** Chemin d'accès aux fichiers de test *)
(****************************************)

let pathFichiersRat = "../../../../../tests/gestion_id/sans_fonction/fichiersRat/"

(**********)
(*  TESTS *)
(**********)

let%test_unit "testAffectation1" = 
  let _ = compiler (pathFichiersRat^"testAffectation1.rat") in ()

let%test_unit "testAffectation2"= 
  try 
    let _ = compiler (pathFichiersRat^"testAffectation2.rat") 
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("y") -> ()

let%test_unit "testAffectation3" = 
  let _ = compiler (pathFichiersRat^"testAffectation3.rat") in ()

let%test_unit "testAffectation4" = 
  try 
    let _ = compiler (pathFichiersRat^"testAffectation4.rat")
    in raise ErreurNonDetectee
  with
  | MauvaiseUtilisationIdentifiant("x") -> ()

let%test_unit "testUtilisation1" = 
  let _ = compiler (pathFichiersRat^"testUtilisation1.rat") in ()

  let%test_unit "testUtilisationConstante" = 
    let _ = compiler (pathFichiersRat^"testUtilisationConstante.rat") in ()

let%test_unit "testUtilisation2" = 
  let _ = compiler (pathFichiersRat^"testUtilisation2.rat") in ()

let%test_unit "testUtilisation3" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation3.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("y") -> ()

let%test_unit "testUtilisation10" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation10.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("x") -> ()

let%test_unit "testUtilisation11" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation11.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("z") -> ()

let%test_unit "testUtilisation12" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation12.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("z") -> ()

let%test_unit "testUtilisation13" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation13.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("z") -> ()

let%test_unit "testUtilisation14" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation14.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("z") -> ()

let%test_unit "testUtilisation15" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation15.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("z") -> ()

let%test_unit "testUtilisation16" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation16.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("y") -> ()

let%test_unit "testUtilisation17" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation17.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("y") -> ()

let%test_unit "testUtilisation18" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation18.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("y") -> ()

let%test_unit "testUtilisation19" = 
  try 
    let _ = compiler (pathFichiersRat^"testUtilisation19.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("y") -> ()

let%test_unit "testRecursiviteVariable" = 
  try 
    let _ = compiler (pathFichiersRat^"testRecursiviteVariable.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("x") -> ()

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
  | IdentifiantNonDeclare("x") -> ()

let%test_unit "testPointeurs5" = 
  try 
    let _ = compiler (pathFichiersRat^"testPointeurs5.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("x") -> ()

let%test_unit "testPointeurs6" = 
  try 
    let _ = compiler (pathFichiersRat^"testPointeurs6.rat")
    in raise ErreurNonDetectee
  with
  | MauvaiseUtilisationIdentifiant("x") -> ()

let%test_unit "testPointeurs7" = 
  try 
    let _ = compiler (pathFichiersRat^"testPointeurs7.rat")
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("x") -> ()

let%test_unit "testPointeurs8" = 
  try 
    let _ = compiler (pathFichiersRat^"testPointeurs8.rat")
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("x") -> ()

let%test_unit "testPointeurs9" = 
  let _ = compiler (pathFichiersRat^"testPointeurs9.rat") in ()

let%test_unit "testPointeurs10" = 
  let _ = compiler (pathFichiersRat^"testPointeurs10.rat") in ()

let%test_unit "testPointeurs11" = 
  let _ = compiler (pathFichiersRat^"testPointeurs11.rat") in ()

let%test_unit "testPointeurs12" = 
  let _ = compiler (pathFichiersRat^"testPointeurs12.rat") in ()

let%test_unit "testPointeurs13" = 
  try 
    let _ = compiler (pathFichiersRat^"testPointeurs13.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("b") -> ()

let%test_unit "testPointeurs14" = 
  try 
    let _ = compiler (pathFichiersRat^"testPointeurs14.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("x") -> ()

let%test_unit "testPointeurs15" = 
  let _ = compiler (pathFichiersRat^"testPointeurs15.rat") in ()

let%test_unit "testReferences1" = 
  try 
    let _ = compiler (pathFichiersRat^"testReferences1.rat")
    in raise ErreurNonDetectee
  with
  | UtilisationRefInvalide -> ()

let%test_unit "testReferences2" = 
  try 
    let _ = compiler (pathFichiersRat^"testReferences2.rat")
    in raise ErreurNonDetectee
  with
  | UtilisationRefInvalide -> ()

let%test_unit "testReferences3" = 
  try 
    let _ = compiler (pathFichiersRat^"testReferences3.rat")
    in raise ErreurNonDetectee
  with
  | UtilisationRefInvalide -> ()

let%test_unit "testEnumerations1" = 
  let _ = compiler (pathFichiersRat^"testEnumerations1.rat") in ()

let%test_unit "testEnumerations2" =
  try
    let _ = compiler (pathFichiersRat^"testEnumerations2.rat")
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("Nom") -> ()

let%test_unit "testEnumerations3" =
  try
    let _ = compiler (pathFichiersRat^"testEnumerations3.rat")
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("Dubois") -> ()

let%test_unit "testEnumerations4" =
  try
    let _ = compiler(pathFichiersRat^"testEnumerations4.rat")
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("Nom") -> ()

let%test_unit "testEnumerations5" =
  try
    let _ = compiler(pathFichiersRat^"testEnumerations5.rat")
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("Dupont") -> ()

let%test_unit "testEnumerations6" =
  try
      let _ = compiler(pathFichiersRat^"testEnumerations6.rat")
      in raise ErreurNonDetectee
  with
  | MauvaiseUtilisationIdentifiant("Nom") -> ()

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
  let p_tam = "../../../../../tests/tam/sans_fonction/fichiersRat/" in
  let d = opendir p_tam in
  test d p_tam
*)