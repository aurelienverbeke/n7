
% Nettoyage de l'espace de travail :
clear; % Vider le workspace
close all; % Fermer toutes les fenetres d'affichage
clc; % Vider la fenetre de commande

% Recuperation de la taille de l'ecran pour afficher les figures :
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% Lecture de l'image :
I = rgb2gray(imread('Images/maisooon.png'));
I = imresize(I,0.1,'nearest');
I = I(1:end-2,round(size(I,2)*0.6):end);
[nb_lignes,nb_colonnes] = size(I);

% Parametres :
set(0,'RecursionLimit',1000);		                % Pour eviter les erreurs a l'execution
alpha = pi/8;						                % Seuil sur l'orientation du gradient (en radians)
cos_alpha = cos(alpha);
seuil_norme = 5*2/sin(alpha);			            % Seuil sur la norme du gradient (decoule d'une etude theorique)
diagonale = floor(sqrt(nb_lignes^2+nb_colonnes^2));
card_max = floor(diagonale/2);				        % Cardinal max d'un ensemble E
card_min = floor(card_max/20);				        % Cardinal min d'un ensemble E

% Gradient du niveau de gris (x vers la droite, y vers le bas) :
I = double(I);
[G_x,G_y] = gradient(I);
pas = 2;
init = 2;
G_x_filtered = 1.5*imgaussfilt(G_x,1);
G_x_plot = G_x*0;
G_x_plot(init:pas:end,1:pas:end) = G_x_filtered(init:pas:end,1:pas:end);
G_y_filtered = 1.5*imgaussfilt(G_y,1);
G_y_plot = G_y*0;
G_y_plot(init:pas:end,1:pas:end) = G_y_filtered(init:pas:end,1:pas:end);

% Affichage des orientations des gradients :
figure('Name','Ensembles candidats','Position',[0.05*L,0.1*H,0.9*L,0.65*H],'Color',[0.7 0.75 0.85]); 
subplot(1,4,1)
    imagesc(I)
    axis image off;
    colormap gray
    hold on
    quiver(G_x_plot/5,G_y_plot/5,'r','Autoscale','off')  % Attention : x = j et y = i
    title('Orientation des gradients','FontSize',15)

% Selection des pixels de contour :
G_norme = sqrt(G_x.^2+G_y.^2);

% Affichage des normes des gradients :   
subplot(1,4,2)
    imagesc(G_norme)
    axis image off
    colormap jet
    title('Norme des gradients','FontSize',15)

% Contours conserves car gradient eleve :    
contour = (G_norme > seuil_norme);
% Pas de pixel de contour sur le bord de l'image (traitement simplifie !) :
contour([1,nb_lignes],:) = 0;
contour(:,[1,nb_colonnes]) = 0;
[i,j] = find(contour);

% Affichage des normes des gradients conserves en tant que contours :   
subplot(1,4,3)
    imagesc(G_norme.*contour)
    axis image off
    % colormap jet
    title('Seuillage en contours','FontSize',15)

% Affichage des orientations des gradients :
subplot(1,4,4)
    imagesc(I)
    axis image off;
    colormap gray
    hold on
    quiver(G_x_plot.*contour/5,G_y_plot.*contour/5,'r','Autoscale','off')  % Attention : x = j et y = i
    title('Orientation des contours','FontSize',15)
