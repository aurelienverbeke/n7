% Fonction estimation_C (exercice_2.m)

function C_estime = estimation_C(x_donnees_bruitees,y_donnees_bruitees,tirages_C,R_moyen)

    n_tirages = size(tirages_C, 1);
    n_points = size(x_donnees_bruitees, 1);
    diff_x = repmat(x_donnees_bruitees, 1, n_tirages) - tirages_C(:,1)';
    diff_y = repmat(y_donnees_bruitees, 1, n_tirages) - tirages_C(:,2)';
    distances = sqrt(diff_x.^2 + diff_y.^2);
    sommes = sum((distances-R_moyen).^2);
    [~, indice_min] = min(sommes);
    C_estime = tirages_C(indice_min, :);

end