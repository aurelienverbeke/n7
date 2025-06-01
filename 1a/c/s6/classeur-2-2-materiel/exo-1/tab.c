#include "tab.h"
#include <stdlib.h>

// Constante pour la taille initiale
#define TAILLE_INITIALE 4

// Implantation de tab_t
struct tab_t {
	int* elements;
	int tailleAllouee;
	int tailleUtilisee;
};

// creer
tab_t* creer() {
	tab_t* tableau = (tab_t*)malloc(sizeof(tab_t));
	
	tableau->elements = (int*)malloc(4*sizeof(int));
	tableau->tailleAllouee = 4;
	tableau->tailleUtilisee = 0;
	
	return tableau;
}

// detruire
void detruire(tab_t** tab) {
	free((*tab)->elements);
	(*tab)->tailleAllouee = 0;
	(*tab)->tailleUtilisee = 0;
	free(*tab);
}

// ajouter
void ajouter(tab_t* tab, int elt) {
	if (tab->tailleUtilisee == tab->tailleAllouee)
	{
		int* tmp = (int*)realloc(tab->elements, tab->tailleAllouee * 2 * sizeof(int));
		if (tmp != NULL)
		{
			tab->elements = tmp;
			tab->tailleAllouee *= 2;
		}
	}
	
	// On ajoute l'element si la reallocation a fonctionne
	if (tab->tailleUtilisee < tab->tailleAllouee)
	{
		(tab->elements)[tab->tailleUtilisee] = elt;
		(tab->tailleUtilisee)++;
	}
}

// supprimer
void supprimer(tab_t* tab, int elt) {
	for (int i=0 ; i < tab->tailleUtilisee ; i++)
	{
		if ((tab->elements)[i] == elt)
		{
			for(int j=i ; j <= tab->tailleUtilisee-2 ; j++)
			{
				(tab->elements)[j] = (tab->elements)[j+1];
			}
			
			(tab->tailleUtilisee)--;
			
			break;
		}
	}
}

// element
int element(tab_t* tab, int id) {
	return tab->elements[id];
}

// taille
int taille(tab_t* tab) {
	return tab->tailleUtilisee;
}

// espace
int espace(tab_t* tab) {
	return tab->tailleAllouee;
}

// serrer
void serrer(tab_t* tab) {
	if (tab->tailleUtilisee < tab->tailleAllouee && tab->tailleUtilisee > 0)
	{
		int* tmp = realloc(tab->elements, tab->tailleUtilisee * sizeof(int));
		if (tmp != NULL)
		{
			tab->elements = tmp;
			tab->tailleAllouee = tab->tailleUtilisee;
		}
	}
}
