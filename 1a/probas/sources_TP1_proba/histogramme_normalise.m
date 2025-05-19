% Fonction histogramme_normalise (exercice_2.m)

function [vecteur_Imin_a_Imax,vecteur_frequences] = histogramme_normalise(I)

    vecteur_Imin_a_Imax = min(I, [], "all"):max(I, [], "all")+1;
    vecteur_frequences = histcounts(I, vecteur_Imin_a_Imax)/length(I(:));
    vecteur_Imin_a_Imax = vecteur_Imin_a_Imax(1:end-1);

end