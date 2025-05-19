% Fonction ensemble_E_recursif (exercie_1.m)

function [E,contour,G_somme] = ensemble_E_recursif(E,contour,G_somme,i,j,...
                                                   voisins,G_x,G_y,card_max,cos_alpha)

    % Mise à 0 de la valeur contour du pixel courant pour ne pas retourner dessus
    contour(i,j) = 0;
    % Nombre de voisins (ici 8)
    nb_voisins = size(voisins,1);
    % Indice du voisin
    k = 1;
   
    
    while k<=nb_voisins && size(E, 1)<card_max
        position_voisin = [i j] + voisins(k, :);
        
        % le voisin selectionne est un contour qu'il reste a classifier
        if contour(position_voisin(1), position_voisin(2))
            gradient_voisin = [G_x(position_voisin(1), position_voisin(2)) G_y(position_voisin(1), position_voisin(2))];
            % le voisin est integrable dans le groupe
            if (gradient_voisin/norm(gradient_voisin))*(G_somme/norm(G_somme))' >= cos_alpha
                E = [E ; position_voisin];
                G_somme = G_somme + gradient_voisin;
                [E,contour,G_somme] = ensemble_E_recursif(E, contour, G_somme, position_voisin(1), position_voisin(2), voisins, G_x, G_y, card_max, cos_alpha);
            end
        end

        k = k+1;
    end
    
end