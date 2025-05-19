%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPARAISON DE MODULATEURS BANDE DE BASE
% NOM Prénom, Avril 2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PARAMETRES GENERAUX 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fe=24000;       %Fréquence d'échantillonnage
Te=1/Fe;        %Période d'échantillonnage
Rb=3000;        %Débit binaire souhaité
N=1000;         %Nombre de bits générés


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GENERATION DE L'INFORMATION BINAIRE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bits=randi([0,1],1,N);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MAPPING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Modulateur 1
M_mod1 = 2;                   %Ordre de la modulation         : A COMPLETER
Rs_mod1 = Rb/log2(M_mod1);    %Débit symbole                  : A COMPLETER
Ns_mod1 = 1/(Rs_mod1*Te);     %Facteur de suréchantillonnage  : A COMPLETER
symboles_mod1 = 2*bits-1;     %Génération des symboles        : A COMPLETER

%Modulateur 2
M_mod2 = 4;                   %Ordre de la modulation         : A COMPLETER
Rs_mod2 = Rb/log2(M_mod2);    %Débit symbole                  : A COMPLETER
Ns_mod2 = 1/(Rs_mod2*Te);     %Facteur de suréchantillonnage  : A COMPLETER
symboles_mod2 = arrayfun(@(k) mapping_4aire(bits(k*2+1:(k+1)*2)), 0:length(bits)/2-1);          %Génération des symboles        : A COMPLETER

%Modulateur 3
M_mod3 = 2;                   %Ordre de la modulation         : A COMPLETER
Rs_mod3 = Rb/log2(M_mod3);    %Débit symbole                  : A COMPLETER
Ns_mod3 = 1/(Rs_mod3*Te);     %Facteur de suréchantillonnage  : A COMPLETER
symboles_mod3 = 2*bits-1;     %Génération des symboles        : A COMPLETER


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SURECHANTILLONNAGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Modulateur 1
somme_Diracs_ponderes_mod1=kron(symboles_mod1,[1 zeros(1,Ns_mod1-1)]);

%Modulateur 2
somme_Diracs_ponderes_mod2=kron(symboles_mod2,[1 zeros(1,Ns_mod2-1)]);

%Modulateur 3
somme_Diracs_ponderes_mod3=kron(symboles_mod3,[1 zeros(1,Ns_mod3-1)]);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FILTRAGE DE MISE EN FORME (filtres RIF)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Modulateur 1
%Génération de la réponse impulsionnelle du filtre de mise en forme
h_mod1 = ones(1, Ns_mod1); % A COMPLETER
%Filtrage de mise en forme
Signal_mod1=filter(h_mod1,1,somme_Diracs_ponderes_mod1);

%Modulateur 2
%Génération de la réponse impulsionnelle du filtre de mise en forme
h_mod2 = ones(1, Ns_mod2); % A COMPLETER
%Filtrage de mise en forme
Signal_mod2=filter(h_mod2,1,somme_Diracs_ponderes_mod2);

%Modulator 3
%Génération de la réponse impulsionnelle du filtre de mise en forme
alpha=0.5;
h_mod3= rcosdesign(alpha, 8, Ns_mod3); % A COMPLETER
%Filtrage de mise en forme
Signal_mod3=filter(h_mod3,1,somme_Diracs_ponderes_mod3);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRACES DES SIGNAUX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Modulateur 1
figure
echelle_temporelle=[0:length(Signal_mod1)-1]*Te; % A COMPLETER
plot(echelle_temporelle,Signal_mod1)
xlabel('Temps (s)')
ylabel('Signal transmis, Modulateur 1')

%Modulateur 2
figure
plot(echelle_temporelle,Signal_mod2)
xlabel('Temps (s)')
ylabel('Signal transmis, Modulateur 2')

%Modulateur 3
figure
plot(echelle_temporelle,Signal_mod3)
xlabel('Temps (s)')
ylabel('Signal transmis, Modulateur 3')


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ESTIMATION DES DENSITES SPECTRALES DE PUISSANCE DES SIGNAUX GENERES
%(Estimation par périodogramme de Welch)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Modulateur 1
DSP_mod1=pwelch(Signal_mod1,[],[],[],Fe,'twosided');

%Modulator 2
DSP_mod2=pwelch(Signal_mod2,[],[],[],Fe,'twosided');

%Modulator 3
DSP_mod3=pwelch(Signal_mod3,[],[],[],Fe,'twosided');


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRACES DES DSPs POUR COMPARAISON ENTRE ELLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
echelle_frequentielle=linspace(-Fe/2, Fe/2, length(DSP_mod1)); % A COMPLETER
semilogy(echelle_frequentielle,fftshift(DSP_mod1),'b')
hold on
semilogy(echelle_frequentielle,fftshift(DSP_mod2),'r')
semilogy(echelle_frequentielle,fftshift(DSP_mod3),'k')
grid
xlabel('Frequence (Hz)')
ylabel('DSP du signal transmis')
legend('Modulateur 1','Modulateur 2','Modulateur 3')