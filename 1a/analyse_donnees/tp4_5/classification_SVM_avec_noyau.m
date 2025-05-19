% fonction classification_SVM_avec_noyau (pour l'exercice 3)

function Y_pred = classification_SVM_avec_noyau(X,sigma,X_VS,Y_VS,Alpha_VS,c)

    Y_pred = sign(((Alpha_VS'.*Y_VS')*calcul_noyau(X_VS, X, sigma))' - c);

end