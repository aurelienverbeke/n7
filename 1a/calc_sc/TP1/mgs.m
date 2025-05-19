%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Calcul scientifique
% TP1 - Orthogonalisation de Gram-Schmidt
% mgs.m
%--------------------------------------------------------------------------

function Q = mgs(A)

    % Recuperation du nombre de colonnes de A
    [~, m] = size(A);
    
    % Initialisation de la matrice Q avec la matrice A
    Q = A;
    
    %------------------------------------------------
    % A remplir
    % Algorithme de Gram-Schmidt modifie
    %------------------------------------------------

    for colonne_A = 1:m
        y = A(:, colonne_A);
        for colonne_Q = 1:colonne_A-1
            y = y - y'*Q(:, colonne_Q)*Q(:, colonne_Q);
        end
        Q(:, colonne_A) = y / norm(y);
    end
end