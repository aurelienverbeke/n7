%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ETUDE CHAINE DE TRANSMISSION SUR PORTEUSE
% COMPARAISON 4-ASK/4-QAM AVEC CHAINE PASSE-BAS EQUIVALENTE
% NOM Prénom, Avril 2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PARAMETRES GENERAUX 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fe=12000;       %Fréquence d'échantillonnage
Te=1/Fe;        %Période d'échantillonnage
Rb=3000;        %Débit binaire souhaité
N=1000;         %Nombre de bits générés

M= 4;         %Ordre de la modulation :           A COMPLETER
Rs=Rb/log2(M);         %Débit symbole :                    A COMPLETER
Ns=1/(Rs*Te);         %Facteur de suréchantillonnage :    A COMPLETER

%tableau des valeurs de SNR par bit souhaité à l'entrée du récpeteur en dB
tab_Eb_N0_dB=[0:6]; 
%Passage au SNR en linéaire
tab_Eb_N0=10.^(tab_Eb_N0_dB/10);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BOUCLE SUR LES NIVEAUX DE Eb/N0 A TESTER
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
    TES_4ASK=0;          %Initialisation du TES 4-ASK pour le cumul
    TES_4QAM=0;          %Initialisation du TES 4-QAM pour le cumul
    TEB_4ASK=0;          %Initialisation du TEB 4-ASK pour le cumul
    TEB_4QAM=0;          %Initialisation du TEB 4-QAM pour le cumul
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % BOUCLE POUR PRECISION TES ET TEBS MESURES :COMPTAGE NOMBRE ERREURS
    % (voir annexe texte TP)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    while(nb_erreurs<500)

        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %GENERATION DE L'INFORMATION BINAIRE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        bits=randi([0,1],1,N);
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %MAPPING 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Mapping_4ASK
        symboles_4ASK= pammod(bit2int(bits', 2)', 4, 0, 'gray');     % A COMPLETER
        %Mapping de 4QAM
        symboles_4QAM= qammod(bit2int(bits', 2)', 4, 'gray');     % A COMPLETER
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %SURECHANTILLONNAGE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        somme_Diracs_ponderes_4ASK=kron(symboles_4ASK,[1 zeros(1,Ns-1)]);
        somme_Diracs_ponderes_4QAM=kron(symboles_4QAM,[1 zeros(1,Ns-1)]);
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %FILTRAGE DE MISE EN FORME
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Génération de la réponse impulsionnelle du filtre de mise en forme
        h= ones(1, Ns);     % A COMPLETER           
        %Filtrage de mise en forme
        Signal_emis_4ASK=filter(h,1,somme_Diracs_ponderes_4ASK);
        Signal_emis_4QAM=filter(h,1,somme_Diracs_ponderes_4QAM);
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %CANAL DE PROPAGATION AWGN
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %POUR MODULATION 4-ASK
        %Calcul de la puissance du signal émis
        P_signal=mean(abs(Signal_emis_4ASK).^2);             % A COMPLETER 
        %Calcul de la puissance du bruit à ajouter au signal pour obtenir la valeur
        %souhaité pour le SNR par bit à l'entrée du récepteur (Eb/N0) 
        P_bruit=P_signal*Ns/(2*log2(M)*Eb_N0);     % A COMPLETER
        %Génération du bruit gaussien à la bonne puissance en utilisant la fonction
        %randn de Matlab
        Bruit=sqrt(P_bruit)*randn(1,length(Signal_emis_4ASK)); 
        %Ajout du bruit canal au signal émis => signal à l'entrée du récepteur
        Signal_recu_4ASK=Signal_emis_4ASK+Bruit;
        
        %POUR MODULATION 4-QAM
        %Calcul de la puissance du signal émis
        P_signal=mean(abs(Signal_emis_4QAM).^2);             % A COMPLETER 
        %Calcul de la puissance du bruit à ajouter au signal pour obtenir la valeur
        %souhaité pour le SNR par bit à l'entrée du récepteur (Eb/N0) 
        P_bruit=P_signal*Ns/(2*log2(M)*Eb_N0);     % A COMPLETER
        %Génération du bruit gaussien à la bonne puissance en utilisant la fonction
        %randn de Matlab
        Bruit=sqrt(P_bruit)*(randn(1,length(Signal_emis_4QAM)) + 1i*randn(1,length(Signal_emis_4QAM)));   
        %Ajout du bruit canal au signal émis => signal à l'entrée du récepteur
        Signal_recu_4QAM=Signal_emis_4QAM+Bruit;
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %FILTRAGE DE RECEPTION ADAPTE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Réponse impulsionnelle du filtre de réception
        hr= h/Ns;             % A COMPLETER 
        %Filtrage de réception
        Signal_recu_filtre_4ASK=filter(hr,1,Signal_recu_4ASK);
        Signal_recu_filtre_4QAM=filter(hr,1,Signal_recu_4QAM);
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %ECHANTILLONNAGE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Choix de n0
        n0=8;             % A COMPLETER     
        %Echantillonnage à n0+mNs
        Signal_echantillonne_4ASK=Signal_recu_filtre_4ASK(n0:Ns:end);
        Signal_echantillonne_4QAM=Signal_recu_filtre_4QAM(n0:Ns:end);
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %DECISIONS SUR LES SYMBOLES
        %ET DEMAPPING
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        bits_recus_decimal_4ASK = pamdemod(Signal_echantillonne_4ASK, 4, 0, 'gray');
        bits_recus_4ASK = reshape(int2bit(bits_recus_decimal_4ASK, 2), 1, []);     % A COMPLETER 
        symboles_recus_4ASK = pammod(bits_recus_decimal_4ASK, 4, 0, 'gray');  % A COMPLETER

        bits_recus_decimal_4QAM = qamdemod(Signal_echantillonne_4QAM, 4, 'gray');
        bits_recus_4QAM = reshape(int2bit(bits_recus_decimal_4QAM, 2), 1, []);     % A COMPLETER 
        symboles_recus_4QAM = qammod(bits_recus_decimal_4QAM, 4, 'gray');  % A COMPLETER 
               
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %CALCUL DU TAUX D'ERREUR SYMBOLE CUMULE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        TES_4ASK=TES_4ASK+sum(symboles_recus_4ASK~=symboles_4ASK)/(N/log2(M));  % A COMPLETER 
        TES_4QAM=TES_4QAM+sum(symboles_recus_4QAM~=symboles_4QAM)/(N/log2(M));  % A COMPLETER     
                
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %CALCUL DU TAUX D'ERREUR BINAIRE CUMULE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        TEB_4ASK=TEB_4ASK + sum(bits_recus_4ASK~=bits)/N;  % A COMPLETER 
        TEB_4QAM=TEB_4QAM + sum(bits_recus_4QAM~=bits)/N;  % A COMPLETER 
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %CUMUL DU NOMBRE D'ERREURS ET NOMBRE DE CUMUL REALISES
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        nb_erreurs=nb_erreurs + sum(bits~=bits_recus_4ASK) + sum(bits~=bits_recus_4QAM);  % A COMPLETER   
        nb_cumul=nb_cumul+1;

    end  %fin boucle sur comptage nombre d'erreurs

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %CALCUL DU TAUX D'ERREUR SYMBOLE ET DU TAUX D'ERREUR BINAIRE POUR LA
    %VALEUR TESTEE DE Eb/N0
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    TES_simule_4ASK(indice_bruit)=TES_4ASK/nb_cumul;  
    TES_simule_4QAM(indice_bruit)=TES_4QAM/nb_cumul; 
    TEB_simule_4ASK(indice_bruit)=TEB_4ASK/nb_cumul; 
    TEB_simule_4QAM(indice_bruit)=TEB_4QAM/nb_cumul; 

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %DIAGRAMME DE L'OEIL EN SORTIE DU FILTRE DE RECEPTION AVEC BRUIT
    %TRACE POUR CHAQUE VALEUR DE Eb/N0
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %MODULATION 4-ASK
    oeil=reshape(Signal_recu_filtre_4ASK,Ns,length(Signal_recu_filtre_4ASK)/Ns);
    figure
    plot(oeil)
    title(['Tracé du diagramme de l"oeil en sortie du filtre de réception (4-ASK) pour E_b/N_0 = ' num2str(Eb_N0_dB) 'dB'])

    %MODULATION 4-QAM
    oeil=reshape(Signal_recu_filtre_4QAM,Ns,length(Signal_recu_filtre_4QAM)/Ns);
    figure
    subplot(2,1,1)
    plot(real(oeil))
    subplot(2,1,2)
    plot(imag(oeil))
    title(['Tracé du diagramme de l"oeil en sortie du filtre de réception (4-QAM, voies réelle et imaginiare) pour E_b/N_0 = ' num2str(Eb_N0_dB) 'dB'])

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %TRACE DES CONSTELLATIONS APRES ECHANTILLONNAGE POUR CHAQUE VALEUR DE Eb/N0
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %MODULATION 4-ASK
    figure
    plot(Signal_echantillonne_4ASK, zeros(1, length(Signal_echantillonne_4ASK)), "+");  % A COMPLETER 
    xlabel('a_k')
    ylabel('b_k')
    title(['Tracé de la constellation en sortie du filtre de réception (4-ASK) pour E_b/N_0 = ' num2str(Eb_N0_dB) 'dB'])

    %MODULATION 4-QAM
    figure
    plot(Signal_echantillonne_4QAM, "+");  % A COMPLETER 
    xlabel('a_k')
    ylabel('b_k')
    title(['Tracé de la constellation en sortie du filtre de réception (4-QAM) pour E_b/N_0 = ' num2str(Eb_N0_dB) 'dB'])

end  %fin boucle sur les valeurs testées de Eb/N0

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TESs THEORIQUES CHAINES IMPLANTEES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TES_THEO_4ASK=2*((M-1)/M)*qfunc(sqrt(6*log2(M)*tab_Eb_N0/(M^2-1)));  % A COMPLETER 
TES_THEO_4QAM=4*(1-1/sqrt(M))*qfunc(sqrt(3*log2(M)*tab_Eb_N0/(M-1)));  % A COMPLETER 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TEBs THEORIQUES CHAINES IMPLANTEES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TEB_THEO_4ASK=TES_THEO_4ASK/log2(M);  % A COMPLETER 
TEB_THEO_4QAM=TES_THEO_4QAM/log2(M);  % A COMPLETER 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRACES DES TES ET TEB OBTENUS EN FONCTION DE Eb/N0
%COMPARAISON AVEC LES TES et TEBs THEORIQUES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
semilogy(tab_Eb_N0_dB, TES_THEO_4ASK,'r-x')
hold on
semilogy(tab_Eb_N0_dB, TES_simule_4ASK,'b-o')
semilogy(tab_Eb_N0_dB, TES_THEO_4QAM,'g-*')
semilogy(tab_Eb_N0_dB, TES_simule_4QAM,'k-^')
legend('TES théorique 4-ASK','TES simulé 4-ASK','TES théorique 4-QAM','TES simulé 4-QAM')
xlabel('E_b/N_0 (dB)')
ylabel('TES')

figure
semilogy(tab_Eb_N0_dB, TEB_THEO_4ASK,'r-x')
hold on
semilogy(tab_Eb_N0_dB, TEB_simule_4ASK,'b-o')
semilogy(tab_Eb_N0_dB, TEB_THEO_4QAM,'g-*')
semilogy(tab_Eb_N0_dB, TEB_simule_4QAM,'k-^')
legend('TEB théorique 4-ASK','TEB simulé 4-ASK','TEB théorique 4-QAM','TEB simulé 4-QAM')
xlabel('E_b/N_0 (dB)')
ylabel('TEB')



