% fonction modelisation_vraisemblance (pour l'exercice 1)

function modele_V = modelisation_vraisemblance(X,mu,Sigma)

    %modele_V = zeros(size(X, 1), 1);

    %for i=1:size(X, 1)
    %    modele_V(i) = exp(-(X(i,:)-mu)*(Sigma\(X(i,:)-mu)')/2)/(2*pi*sqrt(det(Sigma)));
    %end

    modele_V = diag(exp(-(X-mu)*(Sigma\(X-mu)')/2)/(2*pi*sqrt(det(Sigma))));

end