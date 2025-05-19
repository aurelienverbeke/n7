% fonction moyenne_normalisee_3v (pour l'exercice 1bis)

function x = moyenne_normalisee_3v(I)

    I_norm = I./max(1, sum(I, 3));

    nb_lignes_selection = floor(0.05*size(I_norm, 1));
    nb_colonnes_selection = floor(0.05*size(I_norm, 2));

    I_norm_bords = I_norm;
    I_norm_bords(nb_lignes_selection:size(I_norm_bords, 1)-nb_lignes_selection, nb_colonnes_selection:size(I_norm_bords, 2)-nb_colonnes_selection, :) = 0;

    moy_r_bords = sum(I_norm_bords(:,:,1), "all") / (size(I_norm, 1)*size(I_norm, 2) - (size(I_norm, 1)-nb_lignes_selection*2)*(size(I_norm, 2)-nb_colonnes_selection*2));

    I_norm_centre = I_norm(floor(size(I_norm, 1)/2)-nb_lignes_selection:floor(size(I_norm, 1)/2)+nb_lignes_selection, floor(size(I_norm, 2)/2)-nb_colonnes_selection:floor(size(I_norm, 2)/2)+nb_colonnes_selection, :);

    moy_r_centre = mean(I_norm_centre(:,:,1), "all");
    
    x = [mean(I_norm(:,:,1), "all") ; mean(I_norm(:,:,3), "all") ; moy_r_centre-moy_r_bords];

end
