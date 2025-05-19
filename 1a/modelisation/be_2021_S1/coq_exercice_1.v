Require Import Naturelle.
Section Session1_2021_Logique_Exercice_1.

Variable A B C : Prop.

Theorem Exercice_1_Naturelle :  ((A -> C) \/ (B -> C)) -> ((A /\ B) -> C).
Proof.
I_imp H.
I_imp H0.
E_imp A.
E_ou (A -> C) (B -> C).
Hyp H.
I_imp H1.
I_imp H2.
E_imp A.
Hyp H1.
Hyp H2.
I_imp H1.
I_imp H2.
E_imp B.
Hyp H1.
E_et_d A.
Hyp H0.
E_et_g B.
Hyp H0.
Qed.

Theorem Exercice_1_Coq : ((A -> C) \/ (B -> C)) -> ((A /\ B) -> C).
Proof.
intros.
destruct H0.
destruct H.
cut A.
exact H.
exact H0.
cut B.
exact H.
exact H1.
Qed.

End Session1_2021_Logique_Exercice_1.

