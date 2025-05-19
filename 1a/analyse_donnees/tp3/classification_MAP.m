% fonction classification_MAP (pour l'exercice 3)

function Y_pred_MAP = classification_MAP(X,p1,mu_1,Sigma_1,mu_2,Sigma_2)

    modele_V_1 = p1*diag(exp(-(X-mu_1)*(Sigma_1\(X-mu_1)')/2)/(2*pi*sqrt(det(Sigma_1))));
    modele_V_2 = (1-p1)*diag(exp(-(X-mu_2)*(Sigma_2\(X-mu_2)')/2)/(2*pi*sqrt(det(Sigma_2))));

    Y_pred_MAP = (modele_V_1 < modele_V_2) + 1;
    
end
