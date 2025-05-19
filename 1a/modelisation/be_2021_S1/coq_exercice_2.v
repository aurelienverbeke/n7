Require Import Naturelle.
Section Session1_2021_Logique_Exercice_2.

Variable A B C : Prop.

Theorem Exercice_2_Naturelle : ((A /\ B) -> C) -> ((A -> C) \/ (B -> C)).
Proof.
I_imp H0.
E_ou (B) (~B).
TE.
I_imp H1.
I_ou_g.
I_imp H2.
E_imp (A/\B).
Hyp H0.
I_et.
Hyp H2.
Hyp H1.
I_imp H1.
I_ou_d.
I_imp H2.
E_antiT.
I_antiT B.
Hyp H2.
Hyp H1.
Qed.

Theorem Exercice_2_Coq : ((A /\ B) -> C) -> ((A -> C) \/ (B -> C)).
Proof.
intros.
left.
intro.

Qed.

End Session1_2021_Logique_Exercice_2.

