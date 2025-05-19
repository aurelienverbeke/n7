% Fonction estim_param_Dyx_MV_2droites (exercice_2.m) 

function [a_Dyx_1,b_Dyx_1,a_Dyx_2,b_Dyx_2] = ... 
         estim_param_Dyx_MV_2droites(x_donnees_bruitees,y_donnees_bruitees,sigma, ...
                                     tirages_G_1,tirages_psi_1,tirages_G_2,tirages_psi_2)    

    n_tirages = length(tirages_psi_1);

    y_theorique = repmat(y_donnees_bruitees, 1, n_tirages);
    y_pred_1 = tirages_G_1(2,:) + tan(tirages_psi_1).*(repmat(x_donnees_bruitees, 1, n_tirages)-tirages_G_1(1,:));
    y_pred_2 = tirages_G_2(2,:) + tan(tirages_psi_2).*(repmat(x_donnees_bruitees, 1, n_tirages)-tirages_G_2(1,:));

    res2_1 = (y_theorique - y_pred_1).^2;
    res2_2 = (y_theorique - y_pred_2).^2;

    [~, indice_min] = max(sum(log(exp(-res2_1/(2*sigma*sigma)) + exp(-res2_2/(2*sigma*sigma)))));

    a_Dyx_1 = tan(tirages_psi_1(indice_min));
    a_Dyx_2 = tan(tirages_psi_2(indice_min));

    b_Dyx_1 = tirages_G_1(2, indice_min) - a_Dyx_1*tirages_G_1(1, indice_min);
    b_Dyx_2 = tirages_G_2(2, indice_min) - a_Dyx_2*tirages_G_2(1, indice_min);

end