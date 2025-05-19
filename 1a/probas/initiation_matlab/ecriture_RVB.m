% Fonction ecriture_RVB

function image_RVB = ecriture_RVB(image_originale)
    matrice_bleue = image_originale(2:2:end, 1:2:end);
    matrice_rouge = image_originale(1:2:end, 2:2:end);
    matrice_verte = (image_originale(1:2:end, 1:2:end)+image_originale(2:2:end, 2:2:end))/2;
    image_RVB = cat(3, matrice_rouge, matrice_verte, matrice_bleue);
end