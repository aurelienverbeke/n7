
% Nettoyage de l'espace de travail :
clear; % Vider le workspace
close all; % Fermer toutes les fenetres d'affichage
clc; % Vider la fenetre de commande

% Chargement des donnees occultees :
donnees_occultees;

% Estimation du rayon et de la position du centre :
n_tirages = 100;
[G, R_moyen] = calcul_G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees); % FONCTION COMPLETEE DANS EXERCICE_1
[tirages_C,tirages_R] = tirages_aleatoires_uniformes(n_tirages,G,R_moyen); % FONCTION COMPLETEE DANS EXERCICE_3
[C_estime,R_estime] = estimation_C_et_R(x_donnees_bruitees,y_donnees_bruitees,tirages_C,tirages_R); % FONCTION COMPLETEE DANS EXERCICE_3

% Affichage du cercle estime :
theta_cercle = 2*pi/100:2*pi/100:2*pi;
x_cercle_estime = G(1) + R_moyen*cos(theta_cercle);
y_cercle_estime = G(2) + R_moyen*sin(theta_cercle);
plot(x_cercle_estime([1:end 1]),y_cercle_estime([1:end 1]),'b','LineWidth',3);
x_cercle_estime = C_estime(1) + R_estime*cos(theta_cercle);
y_cercle_estime = C_estime(2) + R_estime*sin(theta_cercle);
plot(x_cercle_estime([1:end 1]),y_cercle_estime([1:end 1]),'g','LineWidth',3);
legend(' Cercle initial', ...
	   ' Donnees bruitees', ...
       ' Estimation avec G et R_{moyen}', ...
	   ' Estimation avec tirages uniformes de C et R', ...
	   'Location','Best');
        
clear n_tirages theta_cercle x_cercle_estime y_cercle_estime
