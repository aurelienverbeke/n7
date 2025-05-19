% Fonction estimation_C_et_R (exercice_3.m)

function [C_estime,R_estime,ecart_moyen] = ...
         estimation_C_et_R(x_donnees_bruitees,y_donnees_bruitees,tirages_C,tirages_R)

    n_tirages = size(tirages_C, 1);
    diff_x = repmat(x_donnees_bruitees, 1, n_tirages^2) - repelem(tirages_C(:,1)', n_tirages);
    diff_y = repmat(y_donnees_bruitees, 1, n_tirages^2) - repelem(tirages_C(:,2)', n_tirages);
    distances = sqrt(diff_x.^2 + diff_y.^2);
    sommes = sum((distances-repmat(tirages_R', 1, n_tirages)).^2);
    [valeur_min, indice_min] = min(sommes);
    C_estime = tirages_C(floor((indice_min-1)/n_tirages)+1, :);
    R_estime = tirages_R(floor(mod(indice_min-1, n_tirages))+1);
    ecart_moyen = valeur_min / length(x_donnees_bruitees);

end