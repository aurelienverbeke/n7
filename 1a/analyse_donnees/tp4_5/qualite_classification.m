% fonction qualite_classification (pour l'exercice 2)

function [pourcentage_bonnes_classifications_total,pourcentage_bonnes_classifications_fibrome, ...
          pourcentage_bonnes_classifications_melanome] = qualite_classification(Y_pred,Y)

    pourcentage_bonnes_classifications_total = 100*sum(Y_pred==Y)/size(Y, 1);
    pourcentage_bonnes_classifications_fibrome = 100*sum(Y_pred==Y & Y==1)/sum(Y==1);
    pourcentage_bonnes_classifications_melanome = 100*sum(Y_pred==Y & Y==-1)/sum(Y==-1);

end