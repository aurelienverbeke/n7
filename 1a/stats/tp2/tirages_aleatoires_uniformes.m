% Fonction tirages_aleatoires_uniformes (exercice_1.m)

function [tirages_angles,tirages_G] = tirages_aleatoires_uniformes(n_tirages,taille)

    tirages_angles = rand(1, n_tirages);
    tirages_angles = tirages_angles*pi - pi/2;

    tirages_G = (rand(2, n_tirages)-0.5)*taille*2;

end