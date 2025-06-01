clear all
close all

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PARAMETRES GENERAUX 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fe=12000;       %Fréquence d'échantillonnage
Te=1/Fe;        %Période d'échantillonnage
Rb=3000;        %Débit binaire souhaité
N=1000;         %Nombre de mots générés

M = 2;              %Ordre de la modulation
Rs = Rb/log2(M);    %Débit symbole
Ns = 1/(Rs*Te);     %Facteur de suréchantillonnage

%tableau des valeurs de SNR par bit souhaité à l'entrée du récpeteur en dB
tab_Eb_N0_dB=[0:6]; 
%Passage au SNR en linéaire
tab_Eb_N0=10.^(tab_Eb_N0_dB/10);

%Matrice génératrice du code de Hamming
k = 4; %longueur des mots avant codage
n = 7; %longueur des mots apres codage
P = [1 0 1 ; 1 1 1 ; 1 1 0 ; 0 1 1];
G = [eye(k) P];
dic_mots_possibles = mod(((dec2bin(0:2^k-1, k) - '0')*G), 2); %technique de zinzin

%Origine des bits
bits_aleatoires = true; %Vrai pour utiliser une séquence aléatoire, faux pour une image
nom_image = "dcode-image.png";

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BOUCLE SUR LES NIVEAUX DE Eb/N0 A TESTER POUR OBTENTION DU TES ET DU TEB
% SIMULES DE LA CHAINE IMPLANTEE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for indice_bruit=1:length(tab_Eb_N0_dB)

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % VALEUR DE Eb/N0 TESTEE
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Eb_N0_dB=tab_Eb_N0_dB(indice_bruit)
    Eb_N0=tab_Eb_N0(indice_bruit);

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % INITIALISATIONS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    nb_erreurs=0;   %Variable permettant de compter le nombre d'erreurs cumulées
    nb_cumul=0;     %Variables permettant de compter le nombre de cumuls réalisés
    TES_avec_codage=0;  %Initialisation du taux d'erreur symbole pour le cumul avec codage canal
    TES_sans_codage=0;  %Initialisation du taux d'erreur symbole pour le cumul sans codage canal
    TEB_normal=0;       %Initialisation du taux d'erreur binaire pour le cumul sans codage canal
    TEB_dur=0;          %Initialisation du taux d'erreur binaire pour le cumul avec codage canal et decodage dur
    TEB_souple=0;          %Initialisation du taux d'erreur binaire pour le cumul avec avec codage canal et decodage souple

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % BOUCLE POUR PRECISION TEB MESURE : COMPTAGE NOMBRE ERREURS SI
    % SEQUENCES ALEATOIRES
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    while(nb_erreurs<500)

        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %GENERATION DE L'INFORMATION BINAIRE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if bits_aleatoires==true
            bits = randi([0,1],N,k);
        else
            %Lecture de l'image
            image = imread(nom_image);

            %Affichage
            figure
            %imshow(image)

            %Transformation de l'image en un train binaire
            vect_image=reshape(image,1,size(image,1)*size(image,2));
            mat_image_binaire=de2bi(vect_image);
            bits=double(reshape(mat_image_binaire,1,size(mat_image_binaire,1)*size(mat_image_binaire,2)));
            N = length(bits)/k;

            %Reshape pour avoir des mots de k bits
            bits = reshape(bits, k, [])';
        end

        %codage canal
        bits_codes = mod(reshape([bits bits*P]', 1, []), 2);
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %MAPPING
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        symboles = 2*bits_codes-1;
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %SURECHANTILLONNAGE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        somme_Diracs_ponderes=kron(symboles,[1 zeros(1,Ns-1)]);
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %FILTRAGE DE MISE EN FORME 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Génération de la réponse impulsionnelle du filtre de mise en forme
        h= ones(1, Ns);
        %Filtrage de mise en forme
        Signal_emis=filter(h,1,somme_Diracs_ponderes);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %CANAL DE PROPAGATION AWGN
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Calcul de la puissance du signal émis
        P_signal=mean(abs(Signal_emis).^2);
        %Calcul de la puissance du bruit à ajouter au signal pour obtenir la valeur
        %souhaité pour le SNR par bit à l'entrée du récepteur (Eb/N0) 
        P_bruit=P_signal*Ns/(2*log2(M)*Eb_N0);
        %Génération du bruit gaussien à la bonne puissance en utilisant la fonction
        %randn de Matlab
        Bruit=sqrt(P_bruit)*randn(1,length(Signal_emis)); 
        %Ajout du bruit canal au signal émis => signal à l'entrée du récepteur
        Signal_recu=Signal_emis+Bruit;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %FILTRAGE DE RECEPTION
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        hr = h/Ns;
        Signal_recu_filtre=filter(hr,1,Signal_recu);
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %ECHANTILLONNAGE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Choix de n0
        n0=4;     % A COMPLETER 
        %Echantillonnage à n0+mNs
        Signal_echantillonne=Signal_recu_filtre(n0:Ns:end);
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %DECISIONS SUR LES SYMBOLES
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        symboles_recus=sign(Signal_echantillonne);
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %CALCUL DU TAUX D'ERREUR SYMBOLE CUMULE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        TES_avec_codage=TES_avec_codage+sum(symboles_recus~=symboles)/(N*n);
        TES_sans_codage=TES_sans_codage+sum(symboles_recus(1:n:end)~=symboles(1:n:end))/N;
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %DEMAPPING
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        bits_recus=(symboles_recus+1)/2;
        bits_recus_codes = reshape(bits_recus, n, [])';

        dic_mots_possibles_pour_comparaison = repmat(dic_mots_possibles, N, 1);
        dic_symboles_possibles_pour_comparaison = dic_mots_possibles_pour_comparaison*2 - 1;

        %decodage dur
        %matrice de distances
        %[
        %[mot1/dico1 mot1/dico2 ... mot1/dico2^k]
        %[mot2/dico1 mot2/dico2 ... mot1/dico2^k]
        %...
        %]

        distances = reshape(sum(bits_recus_codes(repmat(1:end, 2^k, 1), :) ~= dic_mots_possibles_pour_comparaison, 2), 2^k, [])';
        [~, indices_distance_min] = min(distances, [], 2);
        bits_recus_decodes_dur = dic_mots_possibles(indices_distance_min, 1:k);

        %decodage souple
        Signal_echantillonne_par_mot = reshape(Signal_echantillonne, n, [])';
        distances = reshape(sum((Signal_echantillonne_par_mot(repmat(1:end, 2^k, 1), :) - dic_symboles_possibles_pour_comparaison).^2, 2), 2^k, [])';
        [~, indices_distance_min] = min(distances, [], 2);
        bits_recus_decodes_souple = dic_mots_possibles(indices_distance_min, 1:k);

        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %CALCUL DU TAUX D'ERREUR BINAIRE CUMULE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        TEB_normal=TEB_normal+sum(bits_recus_codes(:,1)~=bits(:,1))/N;
        TEB_dur=TEB_dur+sum(bits_recus_decodes_dur~=bits, "all")/N;
        TEB_souple=TEB_souple+sum(bits_recus_decodes_souple~=bits, "all")/N;
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %CUMUL DU NOMBRE D'ERREURS ET NOMBRE DE CUMUL REALISES
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        nb_erreurs=nb_erreurs+sum(bits~=bits_recus_decodes_dur, "all");   % A COMPLETER
        nb_cumul=nb_cumul+1;
    end  %fin boucle sur comptage nombre d'erreurs

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %CALCUL DU TAUX D'ERREUR SYMBOLE ET DU TAUX D'ERREUR BINAIRE POUR LA
    %VALEUR TESTEE DE Eb/N0
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    TES_simule_sans_codage(indice_bruit)=TES_sans_codage/nb_cumul;
    TES_simule_avec_codage(indice_bruit)=TES_avec_codage/nb_cumul;   
    TEB_simule_normal(indice_bruit)=TEB_normal/nb_cumul; 
    TEB_simule_dur(indice_bruit)=TEB_dur/nb_cumul; 
    TEB_simule_souple(indice_bruit)=TEB_souple/nb_cumul; 

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %DIAGRAMME DE L'OEIL EN SORTIE DU FILTRE DE RECEPTION AVEC BRUIT
    %TRACE POUR CHAQUE VALEUR DE Eb/N0
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %oeil=reshape(Signal_recu_filtre,Ns,length(Signal_recu_filtre)/Ns);
    %figure
    %plot(oeil)
    %title(['Tracé du du diagramme de l"oeil en sortie du filtre de réception pour E_b/N_0 = ' num2str(Eb_N0_dB) 'dB'])

    if bits_aleatoires == false
        %Reconstruction de l'image à partir de la suite binaire
        mat_image_binaire_retrouvee=reshape(reshape(bits_recus_decodes_souple', [], 1)', size(image, 1)*size(image, 2),8);
        mat_image_decimal_retrouvee=bi2de(mat_image_binaire_retrouvee);
        image_retrouvee=reshape(mat_image_decimal_retrouvee,size(image, 1), size(image, 2));
        %Visualisation
        figure
        imshow(uint8(image_retrouvee))
    end

end  %fin boucle sur les valeurs testées de Eb/N0

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CALCUL DU TES ET DU TEB THEORIQUE DE LA CHAINE IMPLANTEE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TES_THEO=qfunc(sqrt(2*tab_Eb_N0));   % A COMPLETER
TEB_THEO=TES_THEO/log2(M);   % A COMPLETER

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRACES DES TES ET TEB OBTENUS EN FONCTION DE Eb/N0
%COMPARAISON AVEC LES TES et TEBs THEORIQUES DE LA CHAINE IMPLANTEE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
semilogy(tab_Eb_N0_dB, TES_THEO,'r-x')
hold on
semilogy(tab_Eb_N0_dB, TES_simule_sans_codage,'k-o')
semilogy(tab_Eb_N0_dB, TES_simule_avec_codage,'b-o')
legend('TES théorique', 'TES simulé sans codage canal', 'TES simulé avec codage canal')
xlabel('E_b/N_0 (dB)')
ylabel('TES')
title('TES pour un mapping binaire avec h=hr rectangulaires')

figure
semilogy(tab_Eb_N0_dB, TEB_THEO,'r-x')
hold on
semilogy(tab_Eb_N0_dB, TEB_simule_normal,'k-o')
semilogy(tab_Eb_N0_dB, TEB_simule_dur,'b-o')
semilogy(tab_Eb_N0_dB, TEB_simule_souple,'g-o')
legend('TEB théorique sans codage', 'TEB simulé sans codage canal', 'TEB simulé avec codage canal et decodage dur', 'TEB simulé avec codage canal et decodage souple')
xlabel('E_b/N_0 (dB)')
ylabel('TEB')
title('TEB pour un mapping binaire avec h=hr rectangulaires')