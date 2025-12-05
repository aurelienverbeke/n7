function oui = isEulerien(graphe)
    %verification connexite
    n = length(graphe);
    if sum(graphPower(graphe, n-1), "all") ~= n*n
        oui = false;
    else
        nb_sommets_impairs = sum(mod(sum(graphe), 2));
        oui = (nb_sommets_impairs==0 || nb_sommets_impairs==2);
    end