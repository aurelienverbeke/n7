% fonction calcul_noyau (pour l'exercice 3)

function K = calcul_noyau(Xi, Xj, sigma)

    K = zeros(size(Xi, 1), size(Xj, 1));

    for i=1:size(Xi, 1)
        for j=1:size(Xj, 1)
            K(i, j) = exp(-((Xi(i,1)-Xj(j,1))^2+(Xi(i,2)-Xj(j,2))^2)/(2*sigma^2));
        end
    end
end