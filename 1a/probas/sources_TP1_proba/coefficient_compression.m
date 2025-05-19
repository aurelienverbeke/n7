% Fonction coefficient_compression (exercice_2.m)

function coeff_comp = coefficient_compression(signal_non_encode,signal_encode)

    coeff_comp = length(signal_non_encode(:))*8 / length(signal_encode(:));

end