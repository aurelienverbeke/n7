(* Les règles de la déduction naturelle doivent être ajoutées à Coq. *) 
Require Import Naturelle. 

(* Ouverture d'une section *) 
Section LogiqueProposition. 

(* Déclaration de variables propositionnelles *) 
Variable A B C E Y R : Prop. 

Theorem Thm_0 : A /\ B -> B /\ A.
I_imp HAetB.
I_et.
E_et_d (A).
Hyp HAetB.
E_et_g (B).
Hyp HAetB.
Qed.

Theorem Thm_1 : ((A \/ B) -> C) -> (B -> C).
I_imp HAouBimpC.
I_imp HB.
E_imp (A\/B).
Hyp HAouBimpC.
I_ou_d.
Hyp HB.
Qed.

Theorem Thm_2 : A -> ~~A.
I_imp HA.
I_non HnonA.
I_antiT (A).
Hyp HA.
Hyp HnonA.
Qed.

Theorem Thm_3 : (A -> B) -> (~B -> ~A).
I_imp HAimpB.
I_imp HnonB.
I_non HA.
E_non (B).
E_imp (A).
Hyp HAimpB.
Hyp HA.
Hyp HnonB.
Qed.

Theorem Thm_4 : (~~A) -> A.
I_imp HnonnonA.
absurde HnonA.
I_antiT (~A).
Hyp HnonA.
Hyp HnonnonA.
Qed.

Theorem Thm_5 : (~B -> ~A) -> (A -> B).
I_imp HnonBimpnonA.
I_imp HA.
absurde HnonB.
I_antiT (A).
Hyp HA.
E_imp (~B).
Hyp HnonBimpnonA.
Hyp HnonB.
Qed.




Theorem Thm_6 : ((E -> (Y \/ R)) /\ (Y -> R)) -> ~R -> ~E.
I_imp HEimpYouRetYimpR.
I_imp HnonR.
I_non HE.
E_non (R).
E_ou (Y) (R).
E_imp (E).
E_et_g (Y -> R).
Hyp HEimpYouRetYimpR.
Hyp HE.
E_et_d (E -> (Y \/ R)).
Hyp HEimpYouRetYimpR.
I_imp HR.
Hyp HR.
Hyp HnonR.
Qed.

(* Version en Coq *)

Theorem Coq_Thm_0 : A /\ B -> B /\ A.

intro H.
destruct H as (HA,HB).  (* élimination conjonction *)
split.                  (* introduction conjonction *)
exact HB.               (* hypothèse *)
exact HA.               (* hypothèse *)
Qed.


Theorem Coq_E_imp : ((A -> B) /\ A) -> B.
intro H.
destruct H as (HAimpB, HA).
cut (A).
exact HAimpB.
exact HA.
Qed.

Theorem Coq_E_et_g : (A /\ B) -> A.
intro HAetB.
destruct HAetB as (HA, HB).
exact HA.
Qed.

Theorem Coq_E_ou : ((A \/ B) /\ (A -> C) /\ (B -> C)) -> C.
intro H.
destruct H.
destruct H0.
elim H.
exact H0.
exact H1.
Qed.

Theorem Coq_Thm_7 : ((E -> (Y \/ R)) /\ (Y -> R)) -> (~R -> ~E).

Qed.

End LogiqueProposition.

