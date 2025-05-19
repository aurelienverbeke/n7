% function ACP (pour exercice_2.m)

function [C,bornes_C,coefficients_RVB2gris] = ACP(X)

X_centre = X - mean(X);

Sigma = (1/(size(X_centre, 1)*size(X_centre, 2))) * transpose(X_centre) * X_centre;

[W,D] = eig(Sigma);
[~, indices_sort] = sort(diag(D), "descend");
W = W(:, indices_sort);

C = X_centre*W;
bornes_C = [min(min(C)) ; max(max(C))];
coefficients_RVB2gris = W(:, 1) / sum(W(:, 1));

end