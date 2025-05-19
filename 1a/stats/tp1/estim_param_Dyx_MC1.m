% Fonction estim_param_Dyx_MC1 (exercice_2.m)

function [a_Dyx,b_Dyx,coeff_R2] = ...
                   estim_param_Dyx_MC1(x_donnees_bruitees,y_donnees_bruitees)

   A = [x_donnees_bruitees ones(length(x_donnees_bruitees), 1)];

   solution = A'*A\A'*y_donnees_bruitees;

   a_Dyx = solution(1);
   b_Dyx = solution(2);

   y_G = mean(y_donnees_bruitees);

   coeff_R2 = 1 - sum((y_donnees_bruitees-a_Dyx*x_donnees_bruitees-b_Dyx).^2)/(sum((y_donnees_bruitees-y_G).^2));
    
end