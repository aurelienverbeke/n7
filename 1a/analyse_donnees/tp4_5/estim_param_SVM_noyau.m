% fonction estim_param_SVM_noyau (pour l'exercice 3)

function [X_VS,Y_VS,Alpha_VS,c,code_retour] = estim_param_SVM_noyau(X,Y,sigma)

    n = length(Y);

    [alphas, ~, code_retour] = quadprog(diag(Y)*calcul_noyau(X, X, sigma)*diag(Y), -ones(n, 1), [], [], Y', 0, zeros(n,1), []);

    VS = alphas>1e-6;
    Alpha_VS = alphas(VS);
    
    X_VS = X(VS,:);
    Y_VS = Y(VS);

    c = (Alpha_VS'.*Y_VS')*calcul_noyau(X_VS, X_VS(1,:), sigma) - 1/Y_VS(1,:);

end
