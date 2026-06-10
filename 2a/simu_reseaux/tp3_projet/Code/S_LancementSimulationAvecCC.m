%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Script Simulation %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
%close all

%% Parametres simulation
% Parametres abstraction de la couche physique
PhyParam.Ncodes = 54; % Nombre de codes

% Parametres de l'abstraction de couche MAC 
MACParam.Traitement = 5; % Duree de traitement.
MACParam.Rand = 3; %  % Rand maximum - d_rand.
MACParam.NMaxTransmission = 10; %  Nombre max de transmission possible. 

% Scenario de traffic

ChargeAvantOverload = 10; % Nombre de nouveaux utilisateurs par time slot avant la surcharge.
ChargePendantOverload = 30; % Nombre de nouveaux utilisateurs par time slot durant la surcharge.
ChargeApresOverload = 15; % Nombre de nouveaux utilisateurs par time slot apres la surcharge. 
dureeOverload = 200; % Duree en nombre de slots de la surcharge. 
ProfilTrafic = [ChargeAvantOverload*ones(1,100) ChargePendantOverload*ones(1,dureeOverload) ChargeApresOverload*ones(1,300)]; % Generation du profil de trafic. 
idxSlotStats = 101:(101+dureeOverload); % indice des slots ou on calcule les stats. 
NbSlots = length(ProfilTrafic);

% Parametres du controle de charge
CCParam.paccess = 0.75; % Probabilite d'acces 
CCParam.NslotBarringMax = 150; % Nombre de slots max ou l'utilisateur est bloque. 

% MonteCarlo
MonteCarlo = 10; % Nombre iteration de MonteCarlo
SaveThroughputSimulation = nan(MonteCarlo,NbSlots); %Throughput simulations
%---- A remplir ------
% metriques etudiees: débit du réseau, taux de collision, temps d'accès
% moyen

Stats = nan(MonteCarlo, NbSlots, 2);
%----------------------

%% Simulateur

for k = 1:MonteCarlo
    fprintf('Iter : %d \n',k);
    [SaveThroughputSimulation(k,:),Stats(k, :, :)] = F_SimulateurAvecCC(ProfilTrafic,PhyParam,MACParam,CCParam,idxSlotStats);
end
%% Plot

AverageThroughput = mean(SaveThroughputSimulation,1);

figure
plot(AverageThroughput);
xlabel('Time slots','interpreter','latex');
ylabel('Throughput station de base','interpreter','latex');
ylim([0, 25]);
grid on;
title("Throughput Over Time Slots ($p_{access}=" + CCParam.paccess + ", \; N_{Slot Barring}=" + CCParam.NslotBarringMax + "$)", 'interpreter','latex')

CollisionRate = mean(Stats(:, :, 1));

figure
plot(CollisionRate);
ylabel('Collision Rate','interpreter','latex');
grid on;
ylim([0, 1]);
title("Collision Rate Over Time Slots ($p_{access}=" + CCParam.paccess + ", \; N_{Slot Barring}=" + CCParam.NslotBarringMax + "$)",'interpreter','latex');

MeanAccessTime = mean(Stats(:, :, 2));

figure
plot(MeanAccessTime);
xlabel('Time slots','interpreter','latex');
ylabel('Mean Access Time','interpreter','latex');
grid on;
ylim([0, 200]);
xlim([0, NbSlots])
title("Mean Access Time Over Time Slots ($p_{access}=" + CCParam.paccess + ", \; N_{Slot Barring}=" + CCParam.NslotBarringMax + "$)",'interpreter','latex');