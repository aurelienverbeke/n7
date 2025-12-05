function oui = possedechaine(adjacence, chaine)
    oui = true;
    for i=1:length(chaine)-1
        if adjacence(chaine(i), chaine(i+1)) == 0
            oui = false;
            break
        end
    end