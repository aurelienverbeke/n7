% fonction classification_MV (pour l'exercice 2)

function Y_pred_MV = classification_MV(X,mu_1,Sigma_1,mu_2,Sigma_2)
    
    modele_V_1 = diag(exp(-(X-mu_1)*(Sigma_1\(X-mu_1)')/2)/(2*pi*sqrt(det(Sigma_1))));
    modele_V_2 = diag(exp(-(X-mu_2)*(Sigma_2\(X-mu_2)')/2)/(2*pi*sqrt(det(Sigma_2))));

    Y_pred_MV = (modele_V_1 < modele_V_2) + 1;
    
end
