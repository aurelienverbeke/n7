open Rat
open Compilateur
open Passe

(* Return la liste des adresses des variables d'un programme RAT *)
let getListeDep ratfile =
  let input = open_in ratfile in
  let filebuf = Lexing.from_channel input in
  try
    let ast = Parser.main Lexer.token filebuf in
    let past = CompilateurRat.calculer_placement ast in
    let listeAdresses = VerifPlacement.analyser past in
    listeAdresses
  with
  | Lexer.Error _ as e ->
      report_error ratfile filebuf "lexical error (unexpected character).";
      raise e
  | Parser.Error as e->
      report_error ratfile filebuf "syntax error.";
      raise e

(* teste si dans le fichier fichier, dans la fonction fonction (main pour programme principal)
la occ occurence de la variable var a l'adresse dep[registre]
*)
let test fichier fonction (var,occ) (dep,registre) = 
  let l = getListeDep fichier in
  let lmain = List.assoc fonction l in
  let rec aux i lmain = 
    if i=1 
    then
      let (d,r) = List.assoc var lmain in
      (d=dep && r=registre)
    else 
      aux (i-1) (List.remove_assoc var lmain)
  in aux occ lmain

(****************************************)
(** Chemin d'accès aux fichiers de test *)
(****************************************)

let pathFichiersRat = "../../../../../tests/placement/avec_fonction/fichiersRat/"


let%test "test8_x_1" = 
   test (pathFichiersRat^"test8.rat")  "main" ("x",1)  (0, "SB")
|| test (pathFichiersRat^"test8.rat")  "main" ("x",1)  (0, "LB")
    
let%test "test8_y_1" = 
   test (pathFichiersRat^"test8.rat")  "main" ("y",1)  (1, "SB")
|| test (pathFichiersRat^"test8.rat")  "main" ("y",1)  (1, "LB")
    
let%test "test8_z_1" = 
   test (pathFichiersRat^"test8.rat")  "main" ("z",1)  (3, "SB")
|| test (pathFichiersRat^"test8.rat")  "main" ("z",1)  (3, "LB")
  
let%test "test8_x_2" = 
   test (pathFichiersRat^"test8.rat")  "main" ("x",2)  (4, "SB")
|| test (pathFichiersRat^"test8.rat")  "main" ("x",2)  (4, "LB")
    
let%test "test8_y_2" = 
   test (pathFichiersRat^"test8.rat")  "main" ("y",2)  (5, "SB")
|| test (pathFichiersRat^"test8.rat")  "main" ("y",2)  (5, "LB")
    
let%test "test8_z_2" = 
   test (pathFichiersRat^"test8.rat")  "main" ("z",2)  (7, "SB")
|| test (pathFichiersRat^"test8.rat")  "main" ("z",2)  (7, "LB")
  
let%test "test8_x1" = 
   test (pathFichiersRat^"test8.rat")  "main" ("x1",1)  (4, "SB")
|| test (pathFichiersRat^"test8.rat")  "main" ("x1",1)  (4, "LB")
    
let%test "test8_y1" = 
   test (pathFichiersRat^"test8.rat")  "main" ("y1",1)  (5, "SB")
|| test (pathFichiersRat^"test8.rat")  "main" ("y1",1)  (5, "LB")
    
let%test "test8_z1" = 
   test (pathFichiersRat^"test8.rat" ) "main" ("z1",1)  (7, "SB")
|| test (pathFichiersRat^"test8.rat" ) "main" ("z1",1)  (7, "LB")

let%test "test8_f_x_1" = 
  test (pathFichiersRat^"test8.rat")  "f" ("x",1)  (3, "LB")
    
let%test "test8_f_y_1" = 
  test (pathFichiersRat^"test8.rat")  "f" ("y",1)  (4, "LB")
    
let%test "test8_f_z_1" = 
  test (pathFichiersRat^"test8.rat")  "f" ("z",1)  (6, "LB")
  
let%test "test8_f_x_2" = 
  test (pathFichiersRat^"test8.rat")  "f" ("x",2)  (7, "LB")
    
let%test "test8_f_y_2" = 
  test (pathFichiersRat^"test8.rat")  "f" ("y",2)  (8, "LB")
    
let%test "test8_f_z_2" = 
  test (pathFichiersRat^"test8.rat")  "f" ("z",2)  (10, "LB")
  
let%test "test8_f_x1" = 
  test (pathFichiersRat^"test8.rat")  "f" ("x1",1)  (7, "LB")
    
let%test "test8_f_y1" = 
  test (pathFichiersRat^"test8.rat")  "f" ("y1",1)  (8, "LB")
    
let%test "test8_f_z1" = 
  test (pathFichiersRat^"test8.rat")  "f" ("z1",1)  (10, "LB")
    
let%test "test8_f_a" = 
  test (pathFichiersRat^"test8.rat")  "f" ("a",1)  (-1, "LB")
    
let%test "test9_f_a" = 
  test (pathFichiersRat^"test9.rat")  "f" ("a",1)  (-1, "LB")

let%test "test10_f_a" = 
  test (pathFichiersRat^"test10.rat")  "f" ("a",1)  (-2, "LB")

let%test "test11_f_a" = 
  test (pathFichiersRat^"test11.rat")  "f" ("a",1)  (-1, "LB")
    
let%test "test12_f_b" = 
  test (pathFichiersRat^"test12.rat")  "f" ("b",1)  (-4, "LB")
    
let%test "test12_f_r" = 
  test (pathFichiersRat^"test12.rat")  "f" ("r",1)  (-3, "LB")
    
let%test "test12_f_i" = 
  test (pathFichiersRat^"test12.rat")  "f" ("i",1)  (-1, "LB")

let%test "testPointeurs1" = 
  test (pathFichiersRat^"testPointeurs1.rat")  "fonction" ("a",1)  (-1, "LB")

let%test "testPointeurs2" = 
  test (pathFichiersRat^"testPointeurs2.rat")  "fonction" ("a",1)  (-1, "LB")

let%test "testPointeurs3" = 
  test (pathFichiersRat^"testPointeurs3.rat")  "fonction" ("a",1)  (-1, "LB")
  
  let%test "testPointeurs4_a" = 
  test (pathFichiersRat^"testPointeurs4.rat")  "fonction" ("a",1)  (-3, "LB")
  
  let%test "testPointeurs4_b" = 
  test (pathFichiersRat^"testPointeurs4.rat")  "fonction" ("b",1)  (-2, "LB")
  
  let%test "testPointeurs4_c" = 
  test (pathFichiersRat^"testPointeurs4.rat")  "fonction" ("c",1)  (-1, "LB")
  
  let%test "testPointeurs5_a" = 
    test (pathFichiersRat^"testPointeurs5.rat")  "fonction" ("a",1)  (-4, "LB")
  
  let%test "testPointeurs5_b" = 
    test (pathFichiersRat^"testPointeurs5.rat")  "fonction" ("b",1)  (-3, "LB")
  
  let%test "testPointeurs5_c" = 
    test (pathFichiersRat^"testPointeurs5.rat")  "fonction" ("c",1)  (-1, "LB")

  let%test "testPointeurs6_x_1" = 
   test (pathFichiersRat^"testPointeurs6.rat")  "main" ("x",1)  (0, "SB")
|| test (pathFichiersRat^"testPointeurs6.rat")  "main" ("x",1)  (0, "LB")
    
let%test "testPointeurs6_y_1" = 
   test (pathFichiersRat^"testPointeurs6.rat")  "main" ("y",1)  (1, "SB")
|| test (pathFichiersRat^"testPointeurs6.rat")  "main" ("y",1)  (1, "LB")
    
let%test "testPointeurs6_z_1" = 
   test (pathFichiersRat^"testPointeurs6.rat")  "main" ("z",1)  (3, "SB")
|| test (pathFichiersRat^"testPointeurs6.rat")  "main" ("z",1)  (3, "LB")
  
let%test "testPointeurs6_x_2" = 
   test (pathFichiersRat^"testPointeurs6.rat")  "main" ("x",2)  (4, "SB")
|| test (pathFichiersRat^"testPointeurs6.rat")  "main" ("x",2)  (4, "LB")
    
let%test "testPointeurs6_y_2" = 
   test (pathFichiersRat^"testPointeurs6.rat")  "main" ("y",2)  (5, "SB")
|| test (pathFichiersRat^"testPointeurs6.rat")  "main" ("y",2)  (5, "LB")
    
let%test "testPointeurs6_z_2" = 
   test (pathFichiersRat^"testPointeurs6.rat")  "main" ("z",2)  (7, "SB")
|| test (pathFichiersRat^"testPointeurs6.rat")  "main" ("z",2)  (7, "LB")
  
let%test "testPointeurs6_x1" = 
   test (pathFichiersRat^"testPointeurs6.rat")  "main" ("x1",1)  (4, "SB")
|| test (pathFichiersRat^"testPointeurs6.rat")  "main" ("x1",1)  (4, "LB")
    
let%test "testPointeurs6_y1" = 
   test (pathFichiersRat^"testPointeurs6.rat")  "main" ("y1",1)  (5, "SB")
|| test (pathFichiersRat^"testPointeurs6.rat")  "main" ("y1",1)  (5, "LB")
    
let%test "testPointeurs6_z1" = 
   test (pathFichiersRat^"testPointeurs6.rat" ) "main" ("z1",1)  (7, "SB")
|| test (pathFichiersRat^"testPointeurs6.rat" ) "main" ("z1",1)  (7, "LB")

let%test "testPointeurs6_f_x_1" = 
  test (pathFichiersRat^"testPointeurs6.rat")  "fonction" ("x",1)  (3, "LB")
    
let%test "testPointeurs6_f_y_1" = 
  test (pathFichiersRat^"testPointeurs6.rat")  "fonction" ("y",1)  (4, "LB")
    
let%test "testPointeurs6_f_z_1" = 
  test (pathFichiersRat^"testPointeurs6.rat")  "fonction" ("z",1)  (6, "LB")
  
let%test "testPointeurs6_f_x_2" = 
  test (pathFichiersRat^"testPointeurs6.rat")  "fonction" ("x",2)  (7, "LB")
    
let%test "testPointeurs6_f_y_2" = 
  test (pathFichiersRat^"testPointeurs6.rat")  "fonction" ("y",2)  (8, "LB")
    
let%test "testPointeurs6_f_z_2" = 
  test (pathFichiersRat^"testPointeurs6.rat")  "fonction" ("z",2)  (10, "LB")
  
let%test "testPointeurs6_f_x1" = 
  test (pathFichiersRat^"testPointeurs6.rat")  "fonction" ("x1",1)  (7, "LB")
    
let%test "testPointeurs6_f_y1" = 
  test (pathFichiersRat^"testPointeurs6.rat")  "fonction" ("y1",1)  (8, "LB")
    
let%test "testPointeurs6_f_z1" = 
  test (pathFichiersRat^"testPointeurs6.rat")  "fonction" ("z1",1)  (9, "LB")
    
let%test "testPointeurs6_f_a" = 
  test (pathFichiersRat^"testPointeurs6.rat")  "fonction" ("a",1)  (-1, "LB")

let%test "testProcedures1_a" = 
  test (pathFichiersRat^"testProcedures1.rat")  "procedure" ("a",1)  (-4, "LB")

let%test "testProcedures1_b" = 
  test (pathFichiersRat^"testProcedures1.rat")  "procedure" ("b",1)  (-2, "LB")

let%test "testProcedures1_c" = 
  test (pathFichiersRat^"testProcedures1.rat")  "procedure" ("c",1)  (-1, "LB")

let%test "testProcedures2_a" = 
  test (pathFichiersRat^"testProcedures2.rat")  "procedure" ("a",1)  (3, "LB")

let%test "testProcedures2_b" = 
  test (pathFichiersRat^"testProcedures2.rat")  "procedure" ("b",1)  (4, "LB")

let%test "testProcedures3_x" = 
  test (pathFichiersRat^"testProcedures3.rat")  "procedure" ("x",1)  (-1, "LB")

let%test "testProcedures3_a" = 
  test (pathFichiersRat^"testProcedures3.rat")  "procedure" ("a",1)  (3, "LB")

let%test "testProcedures3_b" = 
  test (pathFichiersRat^"testProcedures3.rat")  "procedure" ("b",1)  (5, "LB")
  
let%test "testProcedures4_x_1" = 
  test (pathFichiersRat^"testProcedures4.rat")  "main" ("x",1)  (0, "SB")
|| test (pathFichiersRat^"testProcedures4.rat")  "main" ("x",1)  (0, "LB")
   
let%test "testProcedures4_y_1" = 
  test (pathFichiersRat^"testProcedures4.rat")  "main" ("y",1)  (1, "SB")
|| test (pathFichiersRat^"testProcedures4.rat")  "main" ("y",1)  (1, "LB")
   
let%test "testProcedures4_z_1" = 
  test (pathFichiersRat^"testProcedures4.rat")  "main" ("z",1)  (3, "SB")
|| test (pathFichiersRat^"testProcedures4.rat")  "main" ("z",1)  (3, "LB")
 
let%test "testProcedures4_x_2" = 
  test (pathFichiersRat^"testProcedures4.rat")  "main" ("x",2)  (4, "SB")
|| test (pathFichiersRat^"testProcedures4.rat")  "main" ("x",2)  (4, "LB")
   
let%test "testProcedures4_y_2" = 
  test (pathFichiersRat^"testProcedures4.rat")  "main" ("y",2)  (5, "SB")
|| test (pathFichiersRat^"testProcedures4.rat")  "main" ("y",2)  (5, "LB")
   
let%test "testProcedures4_z_2" = 
  test (pathFichiersRat^"testProcedures4.rat")  "main" ("z",2)  (7, "SB")
|| test (pathFichiersRat^"testProcedures4.rat")  "main" ("z",2)  (7, "LB")
 
let%test "testProcedures4_x1" = 
  test (pathFichiersRat^"testProcedures4.rat")  "main" ("x1",1)  (4, "SB")
|| test (pathFichiersRat^"testProcedures4.rat")  "main" ("x1",1)  (4, "LB")
   
let%test "testProcedures4_y1" = 
  test (pathFichiersRat^"testProcedures4.rat")  "main" ("y1",1)  (5, "SB")
|| test (pathFichiersRat^"testProcedures4.rat")  "main" ("y1",1)  (5, "LB")
   
let%test "testProcedures4_z1" = 
  test (pathFichiersRat^"testProcedures4.rat" ) "main" ("z1",1)  (7, "SB")
|| test (pathFichiersRat^"testProcedures4.rat" ) "main" ("z1",1)  (7, "LB")

let%test "testProcedures4_f_x_1" = 
 test (pathFichiersRat^"testProcedures4.rat")  "f" ("x",1)  (3, "LB")
   
let%test "testProcedures4_f_y_1" = 
 test (pathFichiersRat^"testProcedures4.rat")  "f" ("y",1)  (4, "LB")
   
let%test "testProcedures4_f_z_1" = 
 test (pathFichiersRat^"testProcedures4.rat")  "f" ("z",1)  (6, "LB")
 
let%test "testProcedures4_f_x_2" = 
 test (pathFichiersRat^"testProcedures4.rat")  "f" ("x",2)  (7, "LB")
   
let%test "testProcedures4_f_y_2" = 
 test (pathFichiersRat^"testProcedures4.rat")  "f" ("y",2)  (8, "LB")
   
let%test "testProcedures4_f_z_2" = 
 test (pathFichiersRat^"testProcedures4.rat")  "f" ("z",2)  (10, "LB")
 
let%test "testProcedures4_f_x1" = 
 test (pathFichiersRat^"testProcedures4.rat")  "f" ("x1",1)  (7, "LB")
   
let%test "testProcedures4_f_y1" = 
 test (pathFichiersRat^"testProcedures4.rat")  "f" ("y1",1)  (8, "LB")
   
let%test "testProcedures4_f_z1" = 
 test (pathFichiersRat^"testProcedures4.rat")  "f" ("z1",1)  (10, "LB")
   
let%test "testProcedures4_f_a" = 
 test (pathFichiersRat^"testProcedures4.rat")  "f" ("a",1)  (-1, "LB")

let%test "testReferences1_a" = 
  test (pathFichiersRat^"testReferences1.rat")  "fonction" ("a",1)  (-1, "LB")

let%test "testReferences2_a" = 
  test (pathFichiersRat^"testReferences2.rat")  "procedure" ("a",1)  (-1, "LB")

let%test "testReferences3_a" =
  test (pathFichiersRat^"testReferences3.rat")  "fonction" ("a",1)  (-2, "LB")

let%test "testReferences3_b" =
  test (pathFichiersRat^"testReferences3.rat")  "fonction" ("b",1)  (-1, "LB")

let%test "testReferences4_a" =
  test (pathFichiersRat^"testReferences4.rat")  "procedure" ("a",1)  (-2, "LB")

let%test "testReferences4_b" =
  test (pathFichiersRat^"testReferences4.rat")  "procedure" ("b",1)  (-1, "LB")

let%test "testReferences5_a" =
  test (pathFichiersRat^"testReferences5.rat")  "fonction" ("a",1)  (-2, "LB")

let%test "testReferences5_b" =
  test (pathFichiersRat^"testReferences5.rat")  "fonction" ("b",1)  (-1, "LB")

let%test "testReferences6_a" =
  test (pathFichiersRat^"testReferences6.rat")  "procedure" ("a",1)  (-2, "LB")

let%test "testReferences6_b" =
  test (pathFichiersRat^"testReferences6.rat")  "procedure" ("b",1)  (-1, "LB")

let%test "testReferences7_a" =
  test (pathFichiersRat^"testReferences7.rat")  "fonction" ("a",1)  (-4, "LB")

let%test "testReferences7_b" =
  test (pathFichiersRat^"testReferences7.rat")  "fonction" ("b",1)  (-2, "LB")

let%test "testReferences7_c" =
  test (pathFichiersRat^"testReferences7.rat")  "fonction" ("c",1)  (-1, "LB")

let%test "testReferences8_a" =
  test (pathFichiersRat^"testReferences8.rat")  "procedure" ("a",1)  (-4, "LB")

let%test "testReferences8_b" =
  test (pathFichiersRat^"testReferences8.rat")  "procedure" ("b",1)  (-2, "LB")

let%test "testReferences8_c" =
  test (pathFichiersRat^"testReferences8.rat")  "procedure" ("c",1)  (-1, "LB")

let%test "testEnumerations1_n1" = 
  test (pathFichiersRat^"testEnumerations1.rat")  "fonction" ("n1",1)  (3, "LB")

let%test "testEnumerations2_n_1" =
  test (pathFichiersRat^"testEnumerations2.rat") "fonction" ("n", 1) (-1, "LB")