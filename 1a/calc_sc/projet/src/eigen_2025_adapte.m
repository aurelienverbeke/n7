function [W, V, flag] = eigen_2025_adapte(A, v, m, eps, maxit, percentage, p)

%%%%%%%%%%%%
% RÉSULTATS
%%%%%%%%%%%%

% W les valeurs propres
% V les vecteurs propres
% flag == 0, le calcul des couples propres a réussi

%%%%%%%%%%%%
% PARAMÈTRES
%%%%%%%%%%%%

% n, taille de la matrice symétrique

% v, méthode de calcul des couples propres
% v == 10, méthode eig de matlab
% v == 11, méthode de la puissance itérée avec déflation
% v == 12, méthode de la puissance itérée avec déflation améliorée (à écrire)
% v == 0, méthode subspace iteration v0 (à compléter pendant la séance)
% v == 1, méthode subspace iteration v1 (fournie)
% v == 2, méthode subspace iteration v2 (à développer)
% v == 3, méthode subspace iteration v3 (à développer)

% m, nombre de valeurs propres cherchées (v0)
% ou taille du sous-espace (V1, v2, v3)

% percentage, pourcentage de la trace que l'on veut atteindre (v1, v2, v3)

% p, puissance de A que l'on applique à chaque itération (v2, v3)

% paramètres pour les méthodes itératives
% eps, tolérance
% maxit, nombre d'itérations max pour atteindre la convergence

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch v
    case 10
        [V, W] = eig(A);
        
        [W, indices] = sort(diag(W), 'descend');
        V = V(:, indices);

        flag = 0;

    case {11 12 0 1 2 3}
        if v==11
            [ V, D, ~, ~, flag ] = power_v11(A, m, percentage, eps, maxit);
        elseif v==12
            [ V, D, ~, ~, flag ] = power_v12(A, m, percentage, eps, maxit);
        elseif v==0
            [ V, D, ~, flag ] = subspace_iter_v0(A, m, eps, maxit);
        elseif v==1
            [ V, D, ~, ~, ~, flag ] = subspace_iter_v1(A, m, percentage, eps, maxit);
        elseif v==2
            [ V, D, ~, ~, ~, flag ] = subspace_iter_v2(A, m, percentage, p, eps, maxit);
        else
            [ V, D, ~, ~, ~, flag ] = subspace_iter_v3(A, m, percentage, p, eps, maxit);
        end
    
        W = diag(D);
            
        if(flag ~= 0)
            W = 0;
            V = 0;
        end
    
    otherwise
        flag = 1;
        
end

end