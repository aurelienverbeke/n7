% fonction calcul_bon_partitionnement (pour l'exercice 1)

function meilleur_pourcentage_partitionnement = calcul_bon_partitionnement(Y_pred,Y)

    permutations = perms([1, 2, 3]);
    max = 0

    for permutation = permutations
        Y_pred_permut = zeros(size(Y));
        
        for i=1:length(Y_pred)
            Y_pred_permut(i) = permutation(Y_pred(i));
        end
        
        score = sum(Y_pred_permut == Y);
        
        if score > max
            max = score;
        end
    end

    meilleur_pourcentage_partitionnement = max * 100 / length(Y);

end