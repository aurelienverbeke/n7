
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

% Calcul de l'image decorrelee :
I_decorrelee = decorrelation_colonnes(I); % FONCTION COMPLETEE DANS EXERCICE_1BIS

% Codage de Huffman de l'image decorrelee :
[I_encodee,dictionnaire,hauteur_I,largeur_I] = encodage_image(I_decorrelee); % FONCTION COMPLETEE DANS EXERCICE_2BIS

% Calcul de l'image recorrelee :
I_reconstruite = reconstruction_image(I_encodee,dictionnaire,hauteur_I,largeur_I); % FONCTION A COMPLETER

% Erreur de reconstruction :
I_erreur = I_reconstruite-I;
norme_erreur_reconstruction_pixellique = mean(mean(abs(I_erreur)));

% Affichage de l'image d'origine :
figure('Position',[0.1*L,0.1*H,0.8*L,0.7*H],'Color',[0.7 0.75 0.85]);
subplot(2,2,1)
    imagesc(I);
    axis image off;
    colormap gray;
    set(gca,'FontSize',15);
    title('Image d''origine')
    
% Affichage de l'image reconstruite :    
subplot(2,2,2)
    imagesc(I_reconstruite);
    axis image off;
    colormap gray;
    set(gca,'FontSize',15);
    title('Image reconstruite')
    
% Affichage de l'image d'erreur :    
subplot(2,1,2)
    imagesc(I_erreur);
    axis image off;
    colormap gray;
    set(gca,'FontSize',15);
    title(['Image d''erreur (norme = ' num2str(norme_erreur_reconstruction_pixellique,'%.2f') ')'])
    