function ThroughputSlots = F_SimulateurSansCC(ProfilTrafic,PhyParam,MACParam)

% ------- Param?tres -----------
% ProfilTrafic : Le profil de trafic, ProfilTrafic(k) est le nombre d'utilisateurs qui transmettent pour la premiere fois au slot k.
% PhyParam : Les parametres couche physique.
% MACParam : Parametres couche MAC. 

NbSlots = length(ProfilTrafic); % Nombre de slots simules.
MatriceUtilisateur = zeros(MACParam.NMaxTransmission,NbSlots); % Matrice permettant de stocker les utilisateurs. 
ThroughputSlots = zeros(1,NbSlots); % Debit par time slot. 

for Slot = 1:NbSlots
    
    % Arrivee des nouveaux utilisateurs
    %------- A Remplir ------%
    MatriceUtilisateur(1,Slot) = ProfilTrafic(Slot);
    %------------------------%
    % Simulation des transmissions
    [MatriceUtilisateur, ThroughputSlots(Slot)] = SimulationTransmission(MatriceUtilisateur,Slot,NbSlots,PhyParam,MACParam);
    
end


end

function [MatriceUtilisateur, ThroughputSlot] = SimulationTransmission(MatriceUtilisateur,Slot,NbSlots,PhyParam,MACParam)

NbRequeteTransmisesDurantSlot = sum(MatriceUtilisateur(:,Slot)); 
PLRSlot = 1 - exp(-NbRequeteTransmisesDurantSlot/PhyParam.Ncodes); % PLR du slot

ThroughputSlot = 0;
for k = 1:MACParam.NMaxTransmission
    
    if(MatriceUtilisateur(k,Slot) > 0)
        for l = 1:MatriceUtilisateur(k,Slot) % Boucle sur tous les utilisateurs qui vont transmettre
        
            %--------- A Remplir -------%    
            PaquetPerdu = rand() < PLRSlot;

            if(k<MACParam.NMaxTransmission)
                if(PaquetPerdu)
                    SlotRetransmission = Slot + MACParam.Traitement + 1;
                    if(SlotRetransmission <= NbSlots)
                        MatriceUtilisateur(k+1,SlotRetransmission) = MatriceUtilisateur(k+1,SlotRetransmission) + 1;
                    end
                else
                    ThroughputSlot = ThroughputSlot + 1;
                end
            end
            %----------------------------%
        end    
    end    
end

end