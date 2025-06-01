#define _GNU_SOURCE
#include "liste_noeud.h"
#include <stdlib.h>
#include <math.h>



struct _cellule {
	noeud_id_t noeud;
	noeud_id_t noeud_precedent;
	float distance;
	struct _cellule* suivante;
};
typedef struct _cellule _cellule;

struct liste_noeud_t {
	_cellule* premiere;
};





liste_noeud_t* creer_liste()
{
	liste_noeud_t* liste = malloc(sizeof(liste_noeud_t));
	liste->premiere = NULL;

	return liste;
}





void detruire_liste_interne(_cellule* cellule)
{
	if (cellule->suivante != NULL)
		detruire_liste_interne(cellule->suivante);
	
	free(cellule);
}

void detruire_liste(liste_noeud_t** liste_ptr)
{
	if (!est_vide_liste(*liste_ptr))
	{
		detruire_liste_interne((*liste_ptr)->premiere);
		(*liste_ptr)->premiere = NULL;
	}

	free(*liste_ptr);
	*liste_ptr = NULL;
}




bool est_vide_liste(const liste_noeud_t* liste)
{
	return liste->premiere == NULL;
}





/**
 * Renvoie la cellule associée à un noeud donné.
 *
 * Pré-conditions : liste != NULL
 *
 * @param liste[in] Liste dans laquelle chercher.
 * @param noeud Noeud à chercher.
 *
 * @return Cellule correspondant au noeud dans la liste.
 */
_cellule* cellule_noeud_liste(const liste_noeud_t* liste, noeud_id_t noeud)
{
	_cellule* curseur = liste->premiere;
	
	while (curseur != NULL)
	{
		if (curseur->noeud == noeud)
			return curseur;
		else
			curseur = curseur->suivante;
	}

	return NULL;
}





bool contient_noeud_liste(const liste_noeud_t* liste, noeud_id_t noeud)
{
	return cellule_noeud_liste(liste, noeud) != NULL;
}





bool contient_arrete_liste(const liste_noeud_t* liste, noeud_id_t source, noeud_id_t destination)
{
	_cellule* curseur = liste->premiere;

	while (curseur != NULL)
	{
		if (curseur->noeud == destination && curseur->noeud_precedent == source)
			return true;
		else
			curseur = curseur->suivante;
	}

	return false;
}





float distance_noeud_liste(const liste_noeud_t* liste, noeud_id_t noeud)
{
	_cellule* cellule_noeud = cellule_noeud_liste(liste, noeud);

	if (cellule_noeud == NULL)
		return INFINITY;
	
	else
		return cellule_noeud->distance;
}





noeud_id_t precedent_noeud_liste(const liste_noeud_t* liste, noeud_id_t noeud)
{
	_cellule* cellule_noeud = cellule_noeud_liste(liste, noeud);

	if (cellule_noeud == NULL)
		return NO_ID;
	
	else
		return cellule_noeud->noeud_precedent;
}





noeud_id_t min_noeud_liste(const liste_noeud_t* liste)
{
	if (est_vide_liste(liste))
		return NO_ID;

	_cellule* curseur = liste->premiere;
	float distance_min = curseur->distance;
	noeud_id_t noeud_min = curseur->noeud;

	while (curseur != NULL)
	{
		if (curseur->distance < distance_min)
		{
			distance_min = curseur->distance;
			noeud_min = curseur->noeud;
		}

		curseur = curseur->suivante;
	}

	return noeud_min;
}





void inserer_noeud_liste(liste_noeud_t* liste, noeud_id_t noeud, noeud_id_t precedent, float distance)
{
	_cellule* nouvelle_cellule = malloc(sizeof(_cellule));
	nouvelle_cellule->noeud = noeud;
	nouvelle_cellule->noeud_precedent = precedent;
	nouvelle_cellule->distance = distance;
	
	if (est_vide_liste(liste))
		nouvelle_cellule->suivante = NULL;
	else
		nouvelle_cellule->suivante = liste->premiere;
	
	liste->premiere = nouvelle_cellule;
}





void changer_noeud_liste(liste_noeud_t* liste, noeud_id_t noeud, noeud_id_t precedent, float distance)
{
	_cellule* cellule_noeud = cellule_noeud_liste(liste, noeud);

	if(cellule_noeud == NULL)
	{
		inserer_noeud_liste(liste, noeud, precedent, distance);
	}
	else
	{
		cellule_noeud->noeud_precedent = precedent;
		cellule_noeud->distance = distance;
	}

}





void supprimer_noeud_liste(liste_noeud_t* liste, noeud_id_t noeud)
{
	if(est_vide_liste(liste))
		return;
	
	_cellule* cellule_noeud = cellule_noeud_liste(liste, noeud);

	if(cellule_noeud == liste->premiere)
	{
		liste->premiere = cellule_noeud->suivante;
		free(cellule_noeud);
	}

	else
	{
		_cellule* curseur = liste->premiere;
		
		while (curseur != NULL && curseur->suivante != NULL)
		{
			if (curseur->suivante->noeud == noeud)
			{
				_cellule* cellule_a_supprimer = curseur->suivante;
				curseur->suivante = cellule_a_supprimer->suivante;
				free(cellule_a_supprimer);
				return;
			}

			curseur = curseur->suivante;
		}
	}
}
