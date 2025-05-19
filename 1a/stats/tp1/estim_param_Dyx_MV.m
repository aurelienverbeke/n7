% Fonction estim_param_Dyx_MV (exercice_1.m)

function [a_Dyx,b_Dyx,residus_Dyx] = ...
           estim_param_Dyx_MV(x_donnees_bruitees,y_donnees_bruitees,tirages_psi)

    [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = ...
                centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);

    y_pred = tan(tirages_psi)*x_donnees_bruitees_centrees';
    y_theorique = repmat(y_donnees_bruitees_centrees', length(tirages_psi), 1);

    res = y_theorique - y_pred;
    res2 = res.^2;

    [~, indice_min] = min(sum(res2, 2));

    psi_min = tirages_psi(indice_min);

    a_Dyx = tan(psi_min);

    b_Dyx = y_G - a_Dyx*x_G;

    residus_Dyx = res(indice_min, :);
    
end