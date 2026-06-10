function [ThroughputSlots,Stats] = F_SimulateurAvecCC(ProfilTrafic,PhyParam,MACParam,CCParam,idxSlotStats)
% ProfilTrafic : Profil de trafic, nombre de nouveaux utilisateurs par time slot
% PhyParam : Parametres de couche physique
% MACParam : Parametres de couche MAC
% CCParam : Parameters de controle de charge
% idxSlotStats : indice des slots ou on calcule les stats.
NbSlots = length(ProfilTrafic); % Nombre de time slots simules.
Utilisateurs = zeros(sum(ProfilTrafic),6); % Matrice Utilisateurs, attention differente de la precedente..
idxArriveeUtilisateurs = 1; % Pour remplir la matrice utilisateurs.
% Colonne numero 1 - Time slot actuel
% Colonne numero 2 - Flag Stats
% Colonne numero 3 - Time slot d'arrivee dans le systeme
% Colonne numero 4 - Time slot sortie du systeme
% Colonne numero 5 - Nombre de transmissions
% Colonne numero 6 - Bool Reussite Transmission

Stats = zeros(NbSlots, 2);
ThroughputSlots = zeros(NbSlots, 1);

for Slot = 1:NbSlots
    
    if min(abs(idxSlotStats-Slot)) == 0
        FlagStats = 1;
    else
        FlagStats = 0;
    end
    
    % Arrivee des nouveaux utilisateurs
    Utilisateurs(idxArriveeUtilisateurs:(idxArriveeUtilisateurs+ProfilTrafic(Slot)-1),1) = Slot;
    Utilisateurs(idxArriveeUtilisateurs:(idxArriveeUtilisateurs+ProfilTrafic(Slot)-1),2) = FlagStats;
    Utilisateurs(idxArriveeUtilisateurs:(idxArriveeUtilisateurs+ProfilTrafic(Slot)-1),3) = Slot;
    Utilisateurs(idxArriveeUtilisateurs:(idxArriveeUtilisateurs+ProfilTrafic(Slot)-1),6) = 0;
    idxArriveeUtilisateurs = idxArriveeUtilisateurs + ProfilTrafic(Slot);
    
    % Controle de charge
    
    NbUtilisateursEnTransmission = sum((Utilisateurs(:,1)-Slot) == 0);
    if NbUtilisateursEnTransmission > 70 % Condition activation controle de charge
        Utilisateurs = ApplicationControleDeCharge(Utilisateurs,Slot,CCParam);
    end
    
    % Simulation des transmissions

    [Utilisateurs, ThroughputSlots(Slot), NbTentativesTransmission] = SimulationTransmission(Utilisateurs,Slot,PhyParam,MACParam);
    
    % ---- Stats ---- %
    Stats(Slot, 1) = ThroughputSlots(Slot) / NbTentativesTransmission; % Taux de collision
    SelecteurUtilisateursSortisACeSlot = (Utilisateurs(:,2) == 1) & (Utilisateurs(:,4) == Slot);
    Stats(Slot, 2) = mean(Slot - Utilisateurs(SelecteurUtilisateursSortisACeSlot, 3)); % Temps d'accès moyen
    
end

    function [Utilisateurs, ThroughputSlot, NbRequeteTransmisesDurantSlot] = SimulationTransmission(Utilisateurs,Slot,PhyParam,MACParam)
        
        IdxUtilisateursEnTransmission = find((Utilisateurs(:,1)-Slot) == 0);
        NbRequeteTransmisesDurantSlot = length(IdxUtilisateursEnTransmission);
        PLRSlot = 1 - exp(-NbRequeteTransmisesDurantSlot/PhyParam.Ncodes);
        
        ThroughputSlot = 0;
        
        for k = 1:length(IdxUtilisateursEnTransmission)
            % ---- A remplir ----
            PaquetPerdu = rand() < PLRSlot;

            if(Utilisateurs(IdxUtilisateursEnTransmission(k), 5) < MACParam.NMaxTransmission)
                if(PaquetPerdu)
                    SlotRetransmission = Slot + MACParam.Traitement + 2;
                    Utilisateurs(IdxUtilisateursEnTransmission(k), 1) = SlotRetransmission;
                    Utilisateurs(IdxUtilisateursEnTransmission(k), 5) = Utilisateurs(IdxUtilisateursEnTransmission(k), 5) + 1;
                else
                    Utilisateurs(IdxUtilisateursEnTransmission(k), 4) = Slot;
                    Utilisateurs(IdxUtilisateursEnTransmission(k), 6) = 1;
                    ThroughputSlot = ThroughputSlot + 1;
                end
            end
        end
        
    end

    function Utilisateurs = ApplicationControleDeCharge(Utilisateurs,Slot,CCParam)
        
        IdxUtilisateursEnTransmission = find((Utilisateurs(:,1)-Slot) == 0);
        for k = 1:length(IdxUtilisateursEnTransmission)
            % ---- A remplir ----
            autorise = rand() < CCParam.paccess;

            if ~autorise
                SlotRetransmission = Slot + randi(CCParam.NslotBarringMax) + 2;
                Utilisateurs(IdxUtilisateursEnTransmission(k), 1) = SlotRetransmission;
                Utilisateurs(IdxUtilisateursEnTransmission(k), 5) = Utilisateurs(IdxUtilisateursEnTransmission(k), 5) + 1;
            end
        end
    end
end