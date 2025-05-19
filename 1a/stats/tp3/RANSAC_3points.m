% Fonction RANSAC_3points (exercice_3)

function [C_estime,R_estime] = RANSAC_3points(x_donnees_bruitees,y_donnees_bruitees,parametres)

    % Parametres de l'algorithme RANSAC :
    S_ecart = parametres(1); % seuil pour l'ecart
    S_prop = parametres(2); % seuil pour la proportion
    k_max = parametres(3); % nombre d'iterations
    n_tirages = parametres(4); 
    n_donnees = size(x_donnees_bruitees,1);
    ecart_moyen_min = Inf;

    for k = 1:k_max
        indices_points = randperm(n_donnees, 3);
        % on estime une premiere fois le modele sur deux points choisis
        % aleatoirement
        [C_3p, R_3p] = estim_param_cercle_3points(x_donnees_bruitees(indices_points), y_donnees_bruitees(indices_points));
        filtre_points_conformes = abs(R_3p - sqrt((x_donnees_bruitees-C_3p(1)).^2+(y_donnees_bruitees-C_3p(2)).^2)) < S_ecart;
        if sum(filtre_points_conformes)/n_donnees > S_prop
            % reestimer cercle avec points conformes
            [G, R_moyen, ~] = calcul_G_et_R_moyen(x_donnees_bruitees(filtre_points_conformes), y_donnees_bruitees(filtre_points_conformes));
            [tirages_C,tirages_R] = tirages_aleatoires_uniformes(n_tirages,G,R_moyen);
            [C_3p_reestime, R_3p_reestime, ecart_moyen_reestime] = estimation_C_et_R(x_donnees_bruitees(filtre_points_conformes), y_donnees_bruitees(filtre_points_conformes), tirages_C, tirages_R);
            % on regarde si le nouveau modele est plus efficace
            if ecart_moyen_reestime < ecart_moyen_min
                C_estime = C_3p_reestime;
                R_estime = R_3p_reestime;
                ecart_moyen_min = ecart_moyen_reestime;
            end
        end
    end

end