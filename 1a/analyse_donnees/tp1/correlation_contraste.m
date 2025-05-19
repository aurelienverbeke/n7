% function correlation_contraste (pour exercice_1.m)

function [correlation,contraste] = correlation_contraste(X)

X_centre = X - mean(X);

Sigma = (1/(size(X_centre, 1)*size(X_centre, 2))) * transpose(X_centre) * X_centre;

r12 = Sigma(1, 2) / (sqrt(Sigma(1, 1)) * sqrt(Sigma(2, 2)));
r13 = Sigma(1, 3) / (sqrt(Sigma(1, 1)) * sqrt(Sigma(3, 3)));
r23 = Sigma(2, 3) / (sqrt(Sigma(2, 2)) * sqrt(Sigma(3, 3)));

correlation = [1 r12 r13 ; r12 1 r23 ; r13 r23 1];

somme = Sigma(1, 1)^2 + Sigma(2, 2)^2 + Sigma(3, 3)^2;
p1 = Sigma(1, 1)^2 / somme;
p2 = Sigma(2, 2)^2 / somme;
p3 = Sigma(3, 3)^2 / somme;

contraste = [p1 ; p2 ; p3];
    
end
