%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTATS POUR [0 1 1 1 0 0 1 0]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BITS CODES : [0 0 1 1 1 0 0 1 1 0 1 1 1 1 0 1]
% DISTANCES DANS L'ALGORITHME DE VITERBI :
% 0   0   2 3 3 3 0 2 3
% inf inf 3 2 2 0 3 3 0
% inf 2   0 3 3 3 2 0 3
% inf inf 3 0 0 2 3 3 2

clear all
close all

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PARAMETRES GENERAUX 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fe=12000;       %Fréquence d'échantillonnage
Te=1/Fe;        %Période d'échantillonnage
Rb=3000;        %Débit binaire souhaité
N=1000;         %Nombre de bits générés

M = 2;              %Ordre de la modulation
Rs = Rb/log2(M);    %Débit symbole
Ns = 1/(Rs*Te);     %Facteur de suréchantillonnage

%tableau des valeurs de SNR par bit souhaité à l'entrée du récpeteur en dB
tab_Eb_N0_dB=[0:6]; 
%Passage au SNR en linéaire
tab_Eb_N0=10.^(tab_Eb_N0_dB/10);

%Données convolution
m = 2; %memoire
K = m+1; %longueur de contrainte
k = 1; %bits entree
n = 2; %bits sortie
g_binaire = [1 0 1 ; 1 1 1];
g_octal = bi2de(g_binaire);

%Pour Viterbi
etats = dec2bin(0:2^m-1) - '0';
indice_etat_depart = 1;
% 1 état de départ par ligne, 1 d'arrivée par colonne, dans l'ordre des
% états
treillis = logical([1 0 1 0 ; 1 0 1 0 ; 0 1 0 1 ; 0 1 0 1]);
transitions = [0 0 1 0 ; 1 0 0 0 ; 0 0 0 1 ; 0 1 0 0]; % sn1, 0 si pas de transition
transitions(:,:,2) = [0 0 1 0 ; 1 0 0 0 ; 0 1 0 0 ; 0 0 0 1]; % sn2, 0 si pas de transition
transitions_symboles = transitions*2-1;

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
        bits = randi([0,1],1,N);

        %codage canal
        bits_codes = mod(reshape(conv2(g_binaire, bits), 1, []), 2);
        bits_codes = bits_codes(:,1:end-2*m); %correction des bits de convolution apparus en trop a la fin
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %MAPPING
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        symboles_sans_codage = 2*bits-1;
        symboles = 2*bits_codes-1;
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %SURECHANTILLONNAGE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        somme_Diracs_ponderes_sans_codage=kron(symboles_sans_codage,[1 zeros(1,Ns-1)]);
        somme_Diracs_ponderes=kron(symboles,[1 zeros(1,Ns-1)]);
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %FILTRAGE DE MISE EN FORME 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Génération de la réponse impulsionnelle du filtre de mise en forme
        h= ones(1, Ns);
        %Filtrage de mise en forme
        Signal_emis_sans_codage=filter(h,1,somme_Diracs_ponderes_sans_codage);
        Signal_emis=filter(h,1,somme_Diracs_ponderes);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %CANAL DE PROPAGATION AWGN
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Calcul de la puissance du signal émis
        P_signal_sans_codage=mean(abs(Signal_emis_sans_codage).^2);
        P_signal=mean(abs(Signal_emis).^2);
        %Calcul de la puissance du bruit à ajouter au signal pour obtenir la valeur
        %souhaité pour le SNR par bit à l'entrée du récepteur (Eb/N0) 
        P_bruit_sans_codage=P_signal_sans_codage*Ns/(2*log2(M)*Eb_N0);
        P_bruit=P_signal*Ns/(2*log2(M)*Eb_N0);
        %Génération du bruit gaussien à la bonne puissance en utilisant la fonction
        %randn de Matlab
        Bruit_sans_codage=sqrt(P_bruit_sans_codage)*randn(1,length(Signal_emis_sans_codage)); 
        Bruit=sqrt(P_bruit)*randn(1,length(Signal_emis)); 
        %Ajout du bruit canal au signal émis => signal à l'entrée du récepteur
        Signal_recu_sans_codage=Signal_emis_sans_codage+Bruit_sans_codage;
        Signal_recu=Signal_emis+Bruit;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %FILTRAGE DE RECEPTION
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        hr = h/Ns;
        Signal_recu_filtre_sans_codage=filter(hr,1,Signal_recu_sans_codage);
        Signal_recu_filtre=filter(hr,1,Signal_recu);
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %ECHANTILLONNAGE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Choix de n0
        n0=4;     % A COMPLETER 
        %Echantillonnage à n0+mNs
        Signal_echantillonne_sans_codage=Signal_recu_filtre_sans_codage(n0:Ns:end);
        Signal_echantillonne=Signal_recu_filtre(n0:Ns:end);
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %DECISIONS SUR LES SYMBOLES
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        symboles_recus_sans_codage=sign(Signal_echantillonne_sans_codage);
        symboles_recus=sign(Signal_echantillonne);
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %CALCUL DU TAUX D'ERREUR SYMBOLE CUMULE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        TES_avec_codage=TES_avec_codage+sum(symboles_recus~=symboles)/(N*n/k);
        TES_sans_codage=TES_sans_codage+sum(symboles_recus_sans_codage~=symboles_sans_codage)/N;
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %DEMAPPING
        %ALGORITHME DE VITERBI
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        bits_recus_sans_codage=(symboles_recus_sans_codage+1)/2;
        bits_recus=(symboles_recus+1)/2;

        %decodage dur
        sommes_distances_dur = inf(2^m, 1); sommes_distances_dur(indice_etat_depart) = 0;
        %decodage souple
        sommes_distances_souple = inf(2^m, 1); sommes_distances_souple(indice_etat_depart) = 0;

        for indice_groupe=1:N
            %decodage dur
            % On consomme les bits par groupes de n
            groupe_bits = bits_recus((indice_groupe-1)*n+1:indice_groupe*n);
            groupe_bits_3e_dimension(1,1,:) = groupe_bits;
            
            % Matrice de distances
            %[
            %[etat1->etat1 etat1->etat2 ... etat1->etat2^n]
            %[etat2->etat1 etat2->etat2 ... etat2->etat2^n]
            %...
            %]
            % inf si la transition n'existe pas
            distances = sum(groupe_bits_3e_dimension ~= transitions, 3);
            distances(~treillis) = inf;
            
            [sommes_distances_dur, indice_somme_min] = min(distances + repmat(sommes_distances_dur, 1, 2^n), [], 1);
            sommes_distances_dur = sommes_distances_dur';
            if indice_groupe == 1
                bits_recus_decodes_dur = etats(:, 1);
            else
                bits_recus_decodes_dur = [bits_recus_decodes_dur(indice_somme_min, :) etats(:, 1)];
            end



            %decodage souple
            % On consomme les symboles par groupes de n
            groupe_symboles = Signal_echantillonne((indice_groupe-1)*n+1:indice_groupe*n);
            groupe_symboles_3e_dimension(1,1,:) = groupe_symboles;
            
            % Matrice de distances
            %[
            %[etat1->etat1 etat1->etat2 ... etat1->etat2^n]
            %[etat2->etat1 etat2->etat2 ... etat2->etat2^n]
            %...
            %]
            % inf si la transition n'existe pas
            distances = sum((transitions_symboles - groupe_symboles_3e_dimension).^2, 3);
            distances(~treillis) = inf;
            
            [sommes_distances_souple, indice_somme_min] = min(distances + repmat(sommes_distances_souple, 1, 2^n), [], 1);
            sommes_distances_souple = sommes_distances_souple';
            if indice_groupe == 1
                bits_recus_decodes_souple = etats(:, 1);
            else
                bits_recus_decodes_souple = [bits_recus_decodes_souple(indice_somme_min, :) etats(:, 1)];
            end
        end

        % decodage dur
        [~, indice_somme_min] = min(sommes_distances_dur);
        bits_recus_decodes_dur = bits_recus_decodes_dur(indice_somme_min, :);

        % decodage souple
        [~, indice_somme_min] = min(sommes_distances_souple);
        bits_recus_decodes_souple = bits_recus_decodes_souple(indice_somme_min, :);

        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %CALCUL DU TAUX D'ERREUR BINAIRE CUMULE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        TEB_normal=TEB_normal+sum(bits_recus_sans_codage~=bits)/N;
        TEB_dur=TEB_dur+sum(bits_recus_decodes_dur~=bits, "all")/N;
        TEB_souple=TEB_souple+sum(bits_recus_decodes_souple~=bits, "all")/N;
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %CUMUL DU NOMBRE D'ERREURS ET NOMBRE DE CUMUL REALISES
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        nb_erreurs=nb_erreurs+sum(bits~=bits_recus_sans_codage, "all");   % A COMPLETER
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
title('Tracé du TES pour un mapping binaire avec h=hr')

figure
semilogy(tab_Eb_N0_dB, TEB_THEO,'r-x')
hold on
semilogy(tab_Eb_N0_dB, TEB_simule_normal,'k-o')
semilogy(tab_Eb_N0_dB, TEB_simule_dur,'b-o')
semilogy(tab_Eb_N0_dB, TEB_simule_souple,'g-o')
legend('TEB théorique sans codage', 'TEB simulé sans codage canal', 'TEB simulé avec codage canal et decodage dur', 'TEB simulé avec codage canal et decodage souple')
xlabel('E_b/N_0 (dB)')
ylabel('TEB')
title('Tracé du TEB pour un mapping binaire avec h=hr')