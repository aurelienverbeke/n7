% fonction estim_param_SVM_marge (pour l'exercice 2)

function [X_VS,w,c,code_retour] = estim_param_SVM_marge(X,Y,lambda)

    n = length(Y);

    [alphas, ~, code_retour] = quadprog((Y.*X)*(Y.*X)', -ones(n, 1), [], [], Y', 0, zeros(n,1), lambda*ones(n, 1));

    VS = alphas>1e-6;
    
    X_VS = X(VS,:);
    Y_VS = Y(VS);

    w = sum(alphas(VS).*Y_VS.*X_VS)';
    
    VS_lambda = alphas & alphas<lambda;

    X_VS_lambda = X(VS_lambda,:);
    Y_VS_lambda = Y(VS_lambda);

    c = w'*X_VS_lambda(1,:)' - 1/Y_VS_lambda(1);

end