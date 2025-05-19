% Fonction estim_param_Dyx_MC (exercice_1.m)

function [a_Dyx,b_Dyx] = ...
                   estim_param_Dyx_MC(x_donnees_bruitees,y_donnees_bruitees)

    var_x = var(x_donnees_bruitees);
    var_y = var(y_donnees_bruitees);

    x_G = mean(x_donnees_bruitees);
    y_G = mean(y_donnees_bruitees);

    cov_x_y = cov(x_donnees_bruitees, y_donnees_bruitees);

    r = cov_x_y(1, 2)/sqrt(var_x*var_y);

    a_Dyx = r*sqrt(var_y/var_x);

    b_Dyx = y_G - a_Dyx*x_G;
    
end