% Fonction estimation_C_et_R (exercice_3.m)

function [C_estime, R_estime] = ...
         estimation_C_et_R(x_donnees_bruitees,y_donnees_bruitees,tirages_C,tirages_R)
    
    %C1R1, C1R2, C1R3, C2R1, C2R2, C2R3, C3R1, C3R2, C3R3

    n_tirages = size(tirages_C, 1);
    diff_x = repmat(x_donnees_bruitees, 1, n_tirages^2) - repelem(tirages_C(:,1)', n_tirages);
    diff_y = repmat(y_donnees_bruitees, 1, n_tirages^2) - repelem(tirages_C(:,2)', n_tirages);
    distances = sqrt(diff_x.^2 + diff_y.^2);
    sommes = sum((distances-repmat(tirages_R', 1, n_tirages)).^2);
    [~, indice_min] = min(sommes);
    C_estime = tirages_C(floor((indice_min-1)/n_tirages)+1, :);
    R_estime = tirages_R(floor(mod(indice_min-1, n_tirages))+1);
   
end