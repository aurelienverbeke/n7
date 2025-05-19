% Fonction tirages_aleatoires (exercice_3.m)

function [tirages_C,tirages_R] = tirages_aleatoires_uniformes(n_tirages,G,R_moyen)
    
    tirages_C = (2*rand(n_tirages, 2) - 1)*R_moyen + repmat(G', n_tirages, 1);
    tirages_R = (rand(n_tirages, 1) + 1/2)*R_moyen;

end