% Fonction tirages_aleatoires (exercice_1.m)

function tirages_angles = tirages_aleatoires_uniformes(n_tirages)
    
    tirages_angles = rand(n_tirages, 1);
    tirages_angles = tirages_angles*pi - pi/2;

end