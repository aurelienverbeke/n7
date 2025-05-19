%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ETUDE CHAINE DE TRANSMISSION SUR PORTEUSE
% COMPARAISON 16-PSK/16-QAM AVEC CHAINE PASSE-BAS EQUIVALENTE
% NOM Prénom, Avril 2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PARAMETRES GENERAUX 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PARAMETRES GENERAUX 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fe=12000;       %Fréquence d'échantillonnage
Te=1/Fe;        %Période d'échantillonnage
Rb=3000;        %Débit binaire souhaité
N=1000;         %Nombre de bits générés

M= 16;         %Ordre de la modulation :           A COMPLETER
Rs=Rb/log2(M);         %Débit symbole :                    A COMPLETER
Ns=1/(Rs*Te);         %Facteur de suréchantillonnage :    A COMPLETER

%tableau des valeurs de SNR par bit souhaité à l'entrée du récpeteur en dB
%un peu plus haut que précédemment pour pouvoir utiliser l'approximation du
%TEB théorique en PSK
tab_Eb_N0_dB=[2:8]; 
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
    TES_16PSK=0;          %Initialisation du TES 16-PSK pour le cumul
    TES_16QAM=0;          %Initialisation du TES 16-QAM pour le cumul
    TEB_16PSK=0;          %Initialisation du TEB 16-PSK pour le cumul
    TEB_16QAM=0;          %Initialisation du TEB 16-QAM pour le cumul
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % BOUCLE POUR PRECISION TES ET TEBS MESURES :COMPTAGE NOMBRE ERREURS
    % (voir annexe texte TP)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %while(nb_erreurs<1000)

        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %GENERATION DE L'INFORMATION BINAIRE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        bits=randi([0,1],1,N);
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %MAPPING 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Mapping 16-PSK
        symboles_16PSK=pskmod(bit2int(bits', 4)', 16, 0, 'gray');     % A COMPLETER
        %Mapping 16-QAM
        symboles_16QAM=qammod(bit2int(bits', 4)', 16, 'gray');     % A COMPLETER
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %SURECHANTILLONNAGE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        somme_Diracs_ponderes_16PSK=kron(symboles_16PSK,[1 zeros(1,Ns-1)]);
        somme_Diracs_ponderes_16QAM=kron(symboles_16QAM,[1 zeros(1,Ns-1)]);
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %FILTRAGE DE MISE EN FORME 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Génération de la réponse impulsionnelle du filtre de mise en forme
        h= ones(1, Ns);     % A COMPLETER            
        %Filtrage de mise en forme
        Signal_emis_16PSK=filter(h,1,somme_Diracs_ponderes_16PSK);
        Signal_emis_16QAM=filter(h,1,somme_Diracs_ponderes_16QAM);
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %CANAL DE PROPAGATION AWGN
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %POUR MODULATION 16-PSK
        %Calcul de la puissance du signal émis en 16-PSK
        P_signal=mean(abs(Signal_emis_16PSK).^2);     % A COMPLETER         
        %Calcul de la puissance du bruit à ajouter au signal pour obtenir la valeur
        %souhaité pour le SNR par bit à l'entrée du récepteur (Eb/N0) : voir annexe
        %sujet
        P_bruit=P_signal*Ns/(2*log2(M)*Eb_N0);     % A COMPLETER
        %Génération du bruit gaussien à la bonne puissance en utilisant la fonction
        %randn de Matlab (bruit réel ici car en 16-PSK l'enveloppe complexe est réelle)
        Bruit=sqrt(P_bruit)*(randn(1,length(Signal_emis_16PSK)) + 1i*randn(1,length(Signal_emis_16PSK)));     % A COMPLETER             
        %Ajout du bruit canal au signal émis => signal à l'entrée du récepteur
        Signal_recu_16PSK=Signal_emis_16PSK;%+Bruit;
        
        %POUR MODULATION 16-QAM
        %Calcul de la puissance du signal émis en 16-QAM
        P_signal=mean(abs(Signal_emis_16QAM).^2);     % A COMPLETER             
        %Calcul de la puissance du bruit à ajouter au signal pour obtenir la valeur
        %souhaité pour le SNR par bit à l'entrée du récepteur (Eb/N0) : voir annexe
        %sujet
        P_bruit=P_signal*Ns/(2*log2(M)*Eb_N0);     % A COMPLETER
        %Génération du bruit gaussien à la bonne puissance en utilisant la fonction
        %randn de Matlab (bruit complexe ici)
        Bruit=sqrt(P_bruit)*(randn(1,length(Signal_emis_16QAM)) + 1i*randn(1,length(Signal_emis_16QAM)));     % A COMPLETER             
        %Ajout du bruit canal au signal émis => signal à l'entrée du récepteur
        Signal_recu_16QAM=Signal_emis_16QAM;%+Bruit;
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %FILTRAGE DE RECEPTION ADAPTE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Réponse impulsionnelle du filtre de réception
        hr= h/Ns;     % A COMPLETER
        %Filtrage de réception
        Signal_recu_filtre_16PSK=filter(hr,1,Signal_recu_16PSK);
        Signal_recu_filtre_16QAM=filter(hr,1,Signal_recu_16QAM);
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %ECHANTILLONNAGE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Choix de n0 
        n0=16;     % A COMPLETER   
        %Echantillonnage à n0+mNs
        Signal_echantillonne_16PSK=Signal_recu_filtre_16PSK(n0:Ns:end);
        Signal_echantillonne_16QAM=Signal_recu_filtre_16QAM(n0:Ns:end);
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %DECISIONS SUR LES SYMBOLES 
        %ET DEMAPPING
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        bits_recus_decimal_16PSK = pskdemod(Signal_echantillonne_16PSK, 16, 0, 'gray');
        bits_recus_16PSK = reshape(int2bit(bits_recus_decimal_16PSK, 4), 1, []);     % A COMPLETER 
        symboles_recus_16PSK = pskmod(bits_recus_decimal_16PSK, 16, 0, 'gray');  % A COMPLETER 
        
        bits_recus_decimal_16QAM = qamdemod(Signal_echantillonne_16QAM, 16, 'gray');
        bits_recus_16QAM = reshape(int2bit(bits_recus_decimal_16QAM, 4), 1, []);     % A COMPLETER 
        symboles_recus_16QAM = qammod(bits_recus_decimal_16QAM, 16, 'gray');  % A COMPLETER 
               
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %CALCUL DU TAUX D'ERREUR SYMBOLE CUMULE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        TES_16PSK=TES_16PSK+sum(symboles_recus_16PSK~=symboles_16PSK)/(N/log2(M));     % A COMPLETER
        TES_16QAM=TES_16QAM+sum(symboles_recus_16QAM~=symboles_16QAM)/(N/log2(M));     % A COMPLETER  
                
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %CALCUL DU TAUX D'ERREUR BINAIRE CUMULE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        TEB_16PSK=TEB_16PSK+sum(bits_recus_16PSK~=bits)/N;     % A COMPLETER
        TEB_16QAM=TEB_16QAM+sum(bits_recus_16QAM~=bits)/N;     % A COMPLETER
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %CUMUL DU NOMBRE D'ERREURS ET NOMBRE DE CUMUL REALISES
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        nb_erreurs=nb_erreurs + sum(bits~=bits_recus_16PSK) + sum(bits~=bits_recus_16QAM);     % A COMPLETER
        nb_cumul=nb_cumul+1;

    %end  %fin boucle sur comptage nombre d'erreurs

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %CALCUL DU TAUX D'ERREUR SYMBOLE ET DU TAUX D'ERREUR BINAIRE POUR LA
    %VALEUR TESTEE DE Eb/N0
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    TES_simule_16PSK(indice_bruit)=TES_16PSK/nb_cumul;  
    TES_simule_16QAM(indice_bruit)=TES_16QAM/nb_cumul; 
    TEB_simule_16PSK(indice_bruit)=TEB_16PSK/nb_cumul; 
    TEB_simule_16QAM(indice_bruit)=TEB_16QAM/nb_cumul; 

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %TRACE DES CONSTELLATIONS APRES ECHANTILLONNAGE POUR CHAQUE VALEUR DE Eb/N0
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %MODULATION 16-PSK
    figure
    plot(Signal_echantillonne_16PSK, "+");     % A COMPLETER
    xlabel('a_k')
    ylabel('b_k')
    title(['Tracé de la constellation en sortie du filtre de réception (16-PSK) pour E_b/N_0 = ' num2str(Eb_N0_dB) 'dB'])

    %MODULATION 16-QAM
    figure
    plot(Signal_echantillonne_16QAM, "+");     % A COMPLETER
    xlabel('a_k')
    ylabel('b_k')
    title(['Tracé de la constellation en sortie du filtre de réception (16-QAM) pour E_b/N_0 = ' num2str(Eb_N0_dB) 'dB'])


end  %fin boucle sur les valeurs testées de Eb/N0

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TES ET TEB THEORIQUES CHAINES IMPLANTEES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TES_THEO_16PSK=2*qfunc(sqrt(2*log2(M)*tab_Eb_N0)*sin(pi/M));     % A COMPLETER
TES_THEO_16QAM=4*(1-1/sqrt(M))*qfunc(sqrt(3*log2(M)*tab_Eb_N0/(M-1)));     % A COMPLETER

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CALCUL DU TES ET TEB THEORIQUE DE LA CHAINE IMPLANTEE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TEB_THEO_16PSK=TES_THEO_16PSK/log2(M);     % A COMPLETER
TEB_THEO_16QAM=TES_THEO_16QAM/log2(M);     % A COMPLETER

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRACES DES TES ET TEB OBTENUS EN FONCTION DE Eb/N0
%COMPARAISON AVEC LES TES et TEBs THEORIQUES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
semilogy(tab_Eb_N0_dB, TES_THEO_16PSK,'r-x')
hold on
semilogy(tab_Eb_N0_dB, TES_simule_16PSK,'b-o')
semilogy(tab_Eb_N0_dB, TES_THEO_16QAM,'g-*')
semilogy(tab_Eb_N0_dB, TES_simule_16QAM,'k-^')
legend('TES théorique 16-PSK','TES simulé 16-PSK','TES théorique 16-QAM','TES simulé 16-QAM')
xlabel('E_b/N_0 (dB)')
ylabel('TES')

figure
semilogy(tab_Eb_N0_dB, TEB_THEO_16PSK,'r-x')
hold on
semilogy(tab_Eb_N0_dB, TEB_simule_16PSK,'b-o')
semilogy(tab_Eb_N0_dB, TEB_THEO_16QAM,'g-*')
semilogy(tab_Eb_N0_dB, TEB_simule_16QAM,'k-^')
legend('TEB théorique 16-PSK','TEB simulé 16-PSK','TEB théorique 16-QAM','TEB simulé 16-QAM')
xlabel('E_b/N_0 (dB)')
ylabel('TEB')



