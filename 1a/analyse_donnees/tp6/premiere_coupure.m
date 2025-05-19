% fonction premiere_coupure (pour l'exercice 0)

function [valeur_coupure,ind_variable_coupure] = premiere_coupure(X,Y)

    % Initialisation
    min_delta_i_modifie = +Inf;
    X_tries = zeros(size(X));
    n = length(Y);
    % Parcours de chaque variable
    for k = 1:size(X,2)
        % Tri des valeurs de la variable k
        [X_tries(:,k),ind_tri_variable_k] = sort(X(:,k),'ascend');
        Y_tries = Y(ind_tri_variable_k);
        % Parcours des differentes decoupes possibles
        for ind_decoupe = 1:size(X,1)-1
            % Decoupe des Y suivant la limite ind_decoupe (Y_g pour gauche et Y_d pour droite)
            Y_g = Y_tries(1:ind_decoupe);
            Y_d = Y_tries(ind_decoupe+1:end);

            % Calcul des indices de Gini (i_g pour gauche et i_d pour droite)
            i_g = 1 - sum(groupcounts(Y_g).^2)/(length(Y_g)*length(Y_g));
            i_d = 1 - sum(groupcounts(Y_d).^2)/(length(Y_d)*length(Y_d));

            % Calcul du delta_i_modifie = P_g * i_g + P_d * i_d
            delta_i_modifie = length(Y_g)*i_g/n + length(Y_d)*i_d/n;

            % Recuperation de la variable et de la valeur de decoupe
            if delta_i_modifie < min_delta_i_modifie
                min_delta_i_modifie = delta_i_modifie;
                ind_variable_coupure = k;
                valeur_coupure = (X_tries(ind_decoupe,k)+X_tries(ind_decoupe+1,k))/2;
            end
        end
    end
end