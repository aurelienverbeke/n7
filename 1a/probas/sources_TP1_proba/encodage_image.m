% Fonction encodage_image (exercice_2.m)

function [I_encodee,dictionnaire,hauteur_I,largeur_I] = encodage_image(I)

    taille_I = size(I);
    hauteur_I = taille_I(1);
    largeur_I = taille_I(2);
    [vecteur_Imin_a_Imax, vecteur_frequences] = histogramme_normalise(I);
    dictionnaire = huffmandict(vecteur_Imin_a_Imax,vecteur_frequences);
    I_encodee = huffmanenco(I(:),dictionnaire);

end