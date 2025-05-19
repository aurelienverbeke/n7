%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Calcul scientifique
% TP1 - Orthogonalisation de Gram-Schmidt
% cgs.m
%--------------------------------------------------------------------------

function Q = cgs(A)

    % Recuperation du nombre de colonnes de A
    [~, m] = size(A);
    
    % Initialisation de la matrice Q avec la matrice A
    Q = A;
    
    %------------------------------------------------
    % A remplir
    % Algorithme de Gram-Schmidt classique
    %------------------------------------------------

    ys = zeros(size(A));

    for colonne_A = 1:m
        ys = A(:, colonne_A)'*Q(:, 1:colonne_A-1).*Q(:, 1:colonne_A-1);

        y = A(:, colonne_A) - sum(ys, 2);
        
        Q(:, colonne_A) = y / norm(y);
    end

end