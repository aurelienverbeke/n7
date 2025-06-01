%%  Application de la SVD : compression d'images

clear all
close all
clc;

%noms_images = ["BD_Asterix_1.png" "BD_Asterix_2.png" "BD_Asterix_Colored.jpg" "BD_Spirou_1.jpg" "BD_Spirou_2.jpg" "BD_Thorgal_1.jpg"];
noms_images = ["BD_Asterix_1.png" "BD_Asterix_2.png" "BD_Asterix_Colored.jpg" "BD_Spirou_1.jpg" "BD_Spirou_2.jpg" "BD_Thorgal_1.jpg"];
%methodes = round([10 11 12 0 1 2 3]);
methodes = round([10 12 1 2 3]);

for nom_image = noms_images
    % Lecture de l'image
    fprintf(strcat('Image ', nom_image, '\n'))
    I = imread(nom_image);
    I = rgb2gray(I);
    I = double(I);
    
    [q, p] = size(I);
    fprintf(['Taille ' int2str(q) 'x' int2str(p) '\n'])

    methodes_utilisees = ["svd"];
    
    l = min(p,q);
    
    % rangs d'approximation pour la reconstruction
    rangmax = 200;
    ks = round(linspace(1, rangmax, rangmax));

    % vecteur pour stocker la différence entre l'image et l'image
    % reconstruite
    rmses = zeros(size(ks));

    %% Approximation par utilisation de la fonction SVD de MATLAB
    
    % Décomposition par SVD
    [U, S, V] = svd(I);
    
    % reconstruction de chaque image de rang k
    for i = 1:length(ks)
        % recuperation du rang
        k = ks(i);

        % Calcul de l'image de rang k
        Im_k = U(:, 1:k)*S(1:k, 1:k)*V(:, 1:k)';
        
        % Calcul de la différence entre les 2 images (RMSE)
        rmses(i) = sqrt(sum(sum((I-Im_k).^2)));
    end
    
    % Figure des différences entre l'image réelle et les images
    % reconstruites
    figure;
    plot(ks, rmses);
    title(['RMSE reconstruction ' nom_image], 'interpreter', 'none')
    ylabel('RMSE')
    xlabel('Rang k')
    
    
    
    %% Approximation par utilisation des fonctions faites pour le projet

    % tolérance
    eps = 1e-8;
    % nombre d'itérations max pour atteindre la convergence
    maxit = 10000;
    % taille de l'espace de recherche (m)
    search_space = rangmax;
    % pourcentage que l'on se fixe
    percentage = 0.99;
    % p pour les versions 2 et 3 (attention p déjà utilisé comme taille)
    puiss = 3;
    
    for methode = methodes
        t = cputime;
        fprintf(['Méthode ' int2str(methode) ' : '])
        if q >= p
            % calcul des couples propres
            [val_propres, V, flag] = eigen_2025_adapte(I' * I, methode, search_space, eps, maxit, percentage, puiss);
            if flag ~= 0
                fprintf("echec\n")
                continue
            end
        
            % calcul des valeurs singulières
            valeurs_singulieres = sqrt(val_propres);
            % inversion pour avoir dans l'ordre decroissant
            [valeurs_singulieres, indices] = sort(valeurs_singulieres, "descend");
            V = V(:,indices);
        
            % calcul de l'autre ensemble de vecteurs
            U = I*V.*(1./valeurs_singulieres');
        else
            % calcul des couples propres
            [val_propres, U, flag] = eigen_2025_adapte(I * I', methode, search_space, eps, maxit, percentage, puiss);
            if flag ~= 0
                fprintf("echec\n")
                continue
            end

            % calcul des valeurs singulières
            valeurs_singulieres = sqrt(val_propres);
            % inversion pour avoir dans l'ordre decroissant
            [valeurs_singulieres, indices] = sort(valeurs_singulieres, "descend");
            
            U = U(:,indices);
        
            % calcul de l'autre ensemble de vecteurs
            V = I'*U.*(1./valeurs_singulieres');
        end

        fprintf("reussie (")
        
        % reconstruction de chaque image de rang k
        rangmax_apres_eig = min(length(valeurs_singulieres), rangmax);
        fprintf(['nombre de vp : ' int2str(length(valeurs_singulieres)) ', temps : ' int2str(cputime-t) 's)\n'])
        for i = 1:rangmax_apres_eig
            % recuperation du rang
            k = ks(i);
    
            % Calcul de l'image de rang k
            Im_k = U(:, 1:k)*diag(valeurs_singulieres(1:k))*V(:, 1:k)';
            
            % Calcul de la différence entre les 2 images (RMSE)+
            % Mêmes résultats pour toutes les méthodes
            %rmses(i) = sqrt(sum(sum((I-Im_k).^2)));
        end
    end
end
