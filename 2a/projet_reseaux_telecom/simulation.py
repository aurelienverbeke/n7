"""
Projet Réseaux de Télécommunications 2026

Outil de simulation de réseau RTC

Auteurs :
- Arthur SAUVEZIE
- Aurélien VERBEKE
"""





"""
Librairies
"""
import numpy as np
import random
import matplotlib.pyplot as plt





"""
Exceptions internes
"""
class LienSature(Exception):
    pass

class AucunChemin(Exception):
    pass

class BoucleException(Exception):
    pass


"""
Constantes

Ordre :
0 -> CA1
1 -> CA2
2 -> CA3
3 -> CTS1
4 -> CTS2 
"""
CAPACITES = np.array([
    [0, 10, 0, 100, 100],
    [10, 0, 10, 100, 100],
    [0, 10, 0, 100, 100],
    [100, 100, 100, 0, 1000],
    [100, 100, 100, 1000, 0]
])
ADJACENCE = CAPACITES>0
INDICE_PREMIER_CTS = 3
NB_POINTS = CAPACITES.shape[0]
NB_CTS = NB_POINTS-INDICE_PREMIER_CTS
NB_CA = NB_POINTS-NB_CTS





"""
Classe de gestion de l'état d'un réseau RTC
"""
class Reseau:
    def __init__(self, fonction_routage):
        self.etat_liens = np.array(CAPACITES, copy=True)
        self.nb_appels = 0
        self.nb_appels_refuses = 0
        self.fonction_routage = fonction_routage
    
    def reserver_lien(self, source, destination):
        if (self.etat_liens[source,destination] > 0):
            self.etat_liens[source, destination] -= 1
            self.etat_liens[destination, source] -= 1
        else:
            raise LienSature()
    
    def liberer_lien(self, source, destination):
        self.etat_liens[source, destination] += 1
        self.etat_liens[destination, source] += 1
    
    def lien_libre(self, source, destination):
        return self.etat_liens[source, destination] > 0
    
    def voisins(self, origine):
        return np.argwhere(self.etat_liens[origine]!=0).flatten().tolist()
    
    def appeler(self, source, destination):
        # On compte une tentative d'appel
        self.nb_appels += 1
        
        # On récupère le routage
        try:
            route = self.fonction_routage(self, source, destination)
        except AucunChemin:
            self.nb_appels_refuses += 1
            raise LienSature()
        
        # On regarde si tous les liens sont dispos
        for i in range(len(route)-1):
            if self.lien_libre(route[i], route[i+1]) == 0:
                self.nb_appels_refuses += 1
                raise LienSature()
        
        # Tous les liens sont dispos, ont les réserve
        for i in range(len(route)-1):
            self.reserver_lien(route[i], route[i+1])

        return route

    def raccrocher(self, route):
        for i in range(len(route)-1):
            self.liberer_lien(route[i], route[i+1])







"""
Fonctions de routage
"""

"""
Routage hiérarchique
On part du principe que tous les CTS sont reliés à tous les CA
"""
def router_hierarchique(reseau, source, destination):
    route = [source]

    while(route[-1] != destination):
        if (route[-1] < INDICE_PREMIER_CTS):
            # on est sur un CA, on cherche à remonter à un CTS
            # on en choisit un par modulo pour répartir un minimum...
            route.append(INDICE_PREMIER_CTS + (route[-1]//NB_CTS))
        else:
            # on est sur un CTS, on redescend au CA destination
            route.append(destination)
    
    return route



"""
Routage par partage de charge
"""
def router_partage_de_charge(reseau, source, destination):
    route = [source]
    
    while route[-1] != destination:
        noeud_actuel = route[-1]

        voisins_possibles = []
        poids_liens = []

        for candidat in range(NB_POINTS):
            capacite_local=CAPACITES[noeud_actuel, candidat]
            if capacite_local > 0 and candidat not in route:
                voisins_possibles.append(candidat)
                poids_liens.append(capacite_local)

        if not voisins_possibles:
            raise AucunChemin()
        
        prochain_saut = random.choices(voisins_possibles, poids_liens)[0]
        route.append(prochain_saut)

    return route





"""
Routage par partage de charge optimisé avec longueur max = 3
"""
def router_partage_de_charge_opti(reseau, source, destination):
    route = [source]
    
    while route[-1] != destination:
        noeud_actuel = route[-1]

        voisins_possibles = []
        poids_liens = []

        for candidat in range(NB_POINTS):
            capacite_local=CAPACITES[noeud_actuel, candidat]
            if capacite_local > 0 and candidat not in route:
                voisins_possibles.append(candidat)
                poids_liens.append(capacite_local)
        
        if destination in voisins_possibles and len(route) > 2:
            route.append(destination)
            return route

        if not voisins_possibles:
            raise AucunChemin()
        
        prochain_saut = random.choices(voisins_possibles, poids_liens)[0]
        route.append(prochain_saut)

    return route



"""
Routage par partage de charge adaptatif
On route dynamiquement en fonction de la charge actuelle

On utilise l'algorithme de Dijkstra avec l'inverse de l'occupation des liens qu'on adapte
en attribuant le poids d'un chemin au maximum du poids des liens
Les étapes utilisées sont celles de la page Wikipédia de l'algorithme de Dijkstra
"""
def router_adaptatif(reseau, source, destination):

    sommets_parcourus = set([])
    d = [float("inf")]*NB_POINTS
    d[source] = 0
    predecesseurs = dict()

    # Tant qu'on n'a pas atteint la destination
    while (destination not in sommets_parcourus):
        # Choisir un sommet a hors de P de plus petite distance d[a]
        d_temp = d.copy()
        for sommet_parcouru in sommets_parcourus:
            d_temp[sommet_parcouru] = float("inf")
        if all(val == float("inf") for val in d_temp):
            raise AucunChemin()
        a = np.argmin(d_temp)

        # Mettre a dans P
        sommets_parcourus.add(a)

        # Pour chaque sommet b voisin de a hors de P
        voisins = reseau.voisins(a)

        if len(voisins) == 0:
            raise AucunChemin()

        for b in voisins:
            nouveau_poids = d[a] + 1/reseau.etat_liens[a, b]
            if (d[b] > nouveau_poids):
                d[b] = nouveau_poids
                predecesseurs[b] = a

    route = [destination]
    while (route[0] != source):
        route.insert(0, predecesseurs[route[0]])
    
    return route





def simuler(nb_appels):
    # On lance la simu
    # Appel entre 2 points aléatoires
    # Durée entre 1 et 5 minutes uniformément distribuée
    # Durée de simulation : 1 heure
    # Dernier appel à 55 min

    appels = []

    reseau_hierarchique = Reseau(router_hierarchique)
    reseau_partage_de_charge = Reseau(router_partage_de_charge)
    reseau_partage_de_charge_opti = Reseau(router_partage_de_charge_opti)
    reseau_adaptatif = Reseau(router_adaptatif)

    for i_appel in range(nb_appels):

        timestamp_actuel = i_appel*(3300/nb_appels)
            
        duree_appel = random.randint(60, 300)
        
        source = random.randint(0, NB_CA-1)
        destination = random.randint(0, NB_CA-1)
        while(destination == source):
            destination = random.randint(0, NB_CA-1)

        #print(f"Appel de {source} à {destination} pour {duree_appel} secondes.")
        
        try:
            route_hierarchique = reseau_hierarchique.appeler(source, destination)
            #print("Routage hiérarchique :", route_hierarchique)
        except LienSature:
            route_hierarchique = None

        try:
            route_partage_de_charge = reseau_partage_de_charge.appeler(source, destination)
            #print("Routage par partage de charge :", route_partage_de_charge)
        except LienSature:
            route_partage_de_charge = None
        
        try:
            route_partage_de_charge_opti = reseau_partage_de_charge_opti.appeler(source, destination)
            #print("Routage par partage de charge optimisé :", route_partage_de_charge_opti)
        except LienSature:
            route_partage_de_charge_opti = None

        try:
            route_adaptatif = reseau_adaptatif.appeler(source, destination)
            #print("Routage adaptatif :", route_adaptatif)
        except LienSature:
            route_adaptatif = None

        appels.append( (timestamp_actuel+duree_appel, route_hierarchique, route_partage_de_charge, route_partage_de_charge_opti, route_adaptatif))

        # On libère les appels terminés
        appels_a_liberer = [appel for appel in appels if appel[0] < timestamp_actuel]
        for appel in appels_a_liberer:
            if appel[1] is not None:
                reseau_hierarchique.raccrocher(appel[1])
            if appel[2] is not None:
                reseau_partage_de_charge.raccrocher(appel[2])
            if appel[3] is not None:
                reseau_partage_de_charge_opti.raccrocher(appel[3])
            if appel[4] is not None:
                reseau_adaptatif.raccrocher(appel[4])
            appels.remove(appel)
    
    return (reseau_hierarchique.nb_appels_refuses, reseau_partage_de_charge.nb_appels_refuses, reseau_partage_de_charge_opti.nb_appels_refuses, reseau_adaptatif.nb_appels_refuses, reseau_hierarchique.nb_appels)





if __name__ == "__main__":
    nb_refuses_hierarchique = []
    nb_refuses_par_charge = []
    nb_refuses_par_charge_opti = []
    nb_refuses_adaptatif = []
    nb_total = []

    for nb_appels in range(1000, 10500, 500):
        (nb_refuses_hierarchique_i, nb_refuses_par_charge_i, nb_refuses_par_charge_opti_i, nb_refuses_adaptatif_i, nb_total_i) = simuler(nb_appels)
        nb_refuses_hierarchique.append(nb_refuses_hierarchique_i)
        nb_refuses_par_charge.append(nb_refuses_par_charge_i)
        nb_refuses_par_charge_opti.append(nb_refuses_par_charge_opti_i)
        nb_refuses_adaptatif.append(nb_refuses_adaptatif_i)
        nb_total.append(nb_total_i)

    plt.plot(nb_total, nb_refuses_hierarchique, label="Hiérarchique")
    plt.plot(nb_total, nb_refuses_par_charge, label="Partage de charge")
    plt.plot(nb_total, nb_refuses_par_charge_opti, label="Partage de charge optimisé")
    plt.plot(nb_total, nb_refuses_adaptatif, label="Adaptatif")
    plt.xlabel("Nombre d'appels demandés")
    plt.ylabel("Nombre d'appels refusés")
    plt.legend()
    plt.show()