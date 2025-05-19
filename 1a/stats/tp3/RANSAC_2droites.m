% Fonction RANSAC_2droites (exercice_2.m)

function [rho_F_estime,theta_F_estime] = RANSAC_2droites(rho,theta,parametres)

    % Parametres de l'algorithme RANSAC :
    S_ecart = parametres(1); % seuil pour l'ecart
    S_prop = parametres(2); % seuil pour la proportion
    k_max = parametres(3); % nombre d'iterations
    n_donnees = length(rho);
    ecart_moyen_min = Inf;

    for k = 1:k_max
        indices_droites = randperm(n_donnees, 2);
        % on estime une premiere fois le modele sur deux droites choisies
        % aleatoirement
        [rho_F,theta_F,~] = estim_param_F(rho(indices_droites), theta(indices_droites));
        filtre_droites_conformes = abs(rho - rho_F*cos(theta-theta_F)) < S_ecart;
        if sum(filtre_droites_conformes)/n_donnees > S_prop
            % reestimer point de fuite avec droites conformes
            [rho_F_reestime,theta_F_reestime,ecart_moyen_reestime] = estim_param_F(rho(filtre_droites_conformes), theta(filtre_droites_conformes));
            % on regarde si le nouveau modele est plus efficace
            if ecart_moyen_reestime < ecart_moyen_min
                rho_F_estime = rho_F_reestime;
                theta_F_estime = theta_F_reestime;
                ecart_moyen_min = ecart_moyen_reestime;
            end
        end
    end

end