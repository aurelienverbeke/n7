% fonction estim_param_SVM_dual (pour l'exercice 1)

function [X_VS,w,c,code_retour] = estim_param_SVM_dual(X,Y)
    
    n = length(Y);

    [alphas, ~, code_retour] = quadprog((Y.*X)*(Y.*X)', -ones(n, 1), [], [], Y', 0, zeros(n,1), []);

    VS = alphas>1e-6;
    
    X_VS = X(VS,:);
    Y_VS = Y(VS);

    w = sum(alphas(VS).*Y_VS.*X_VS)';
    
    c = w'*X_VS(1,:)' - 1/Y_VS(1);

end
