% Fonction probabilites_classe (exercice_3.m)

function [probas_classe_1,probas_classe_2] = probabilites_classe(x_donnees_bruitees,y_donnees_bruitees,sigma,...
                                                                 a_1,b_1,proportion_1,a_2,b_2,proportion_2)
    y_theorique = repmat(y_donnees_bruitees, 1, 2);
    y_pred = [b_1 b_2] + [a_1, a_2].*repmat(x_donnees_bruitees, 1, 2);

    res2 = (y_theorique - y_pred).^2;

    probas = ([proportion_1 proportion_2].*exp(-res2/(2*sigma*sigma))) ./ (repmat(proportion_1*exp(-res2(:,1)/(2*sigma*sigma)), 1, 2) + repmat(proportion_2*exp(-res2(:,2)/(2*sigma*sigma)), 1, 2));

    probas_classe_1 = probas(:, 1);
    probas_classe_2 = probas(:, 2);

end