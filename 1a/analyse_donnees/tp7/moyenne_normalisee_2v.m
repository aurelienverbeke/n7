% fonction moyenne_normalisee_2v (pour l'exercice 1)

function x = moyenne_normalisee_2v(I)
    
I_norm = I./max(1, sum(I, 3));

x = [mean(I_norm(:,:,1), "all") ; mean(I_norm(:,:,2), "all")];

end
