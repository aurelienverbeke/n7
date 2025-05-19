
% Nettoyage de l'espace de travail :
clear; % Vider le workspace
close all; % Fermer toutes les fenetres d'affichage
clc; % Vider la fenetre de commande

% Recuperation de la taille de l'ecran pour afficher les figures :
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% Lecture d'une image interne a Matlab et conversion en niveaux de gris et en doubles :
I = double(rgb2gray(imread('autumn.tif')));

% Calcul de l'histogramme normalise de l'image d'origine :
[vecteur_Imin_a_Imax,vecteur_frequences] = histogramme_normalise(I); % FONCTION A COMPLETER

% Affichage de l'histogramme normalise de l'image d'origine :
figure('Position',[0.05*L,0.5*H,0.9*L,0.3*H],'Color',[0.7 0.75 0.85]);
subplot(1,2,1)
    imagesc(0:255,0:1.1*max(vecteur_frequences),0:255)
    colormap gray
    axis xy
    hold on
    plot(vecteur_Imin_a_Imax,vecteur_frequences,'r.','LineWidth',2);
    axis([0 255 0 1.1*max(vecteur_frequences)]);
    xlabel('Niveau de gris');
    ylabel('Frequence');
    set(gca,'FontSize',15);
    title('Histogramme normalise de l''image d''origine')

% Calcul de l'image decorrelee :
I_decorrelee = decorrelation_colonnes(I); % FONCTION COMPLETEE DANS EXERCICE_1BIS

% Calcul de l'histogramme normalise de l'image decorrelee : 
[vecteur_Imin_a_Imax,vecteur_frequences] = histogramme_normalise(I_decorrelee); % FONCTION A COMPLETER

% Affichage de l'histogramme normalise de l'image decorrelee :
subplot(1,2,2)
    imagesc(-255:255,0:1.1*max(vecteur_frequences),-255:255)
    colormap gray
    axis xy
    hold on
    plot(vecteur_Imin_a_Imax,vecteur_frequences,'r.','LineWidth',2);
    axis([-255 255 0 1.1*max(vecteur_frequences)]);
    xlabel('Niveau de gris');
    ylabel('Frequence');
    set(gca,'FontSize',15);
    title('Histogramme normalise de l''image decorrelee')
