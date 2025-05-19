% fonction entrainement_foret (pour l'exercice 2)

function foret = entrainement_foret(X,Y,nb_arbres,proportion_individus)

    foret = cell(1, nb_arbres);
    nb_a_selectionner = floor(proportion_individus*length(X));

    for i=1:nb_arbres
        indices_selectionnes = randperm(length(X));
        indices_selectionnes = indices_selectionnes(1:nb_a_selectionner);
        foret{i} = fitctree(X(indices_selectionnes,:), Y(indices_selectionnes), 'NumVariablesToSample', floor(sqrt(size(X, 2))));
    end

end