#include <stdio.h>
#include <stdlib.h>
#include "tab.h"

// Macros pour les options du programme
#define QUITTER 0
#define AJOUTER 1
#define SUPPRIMER 2

int main() {

	tab_t* tab = creer();
	int choix;
	int quitter = 0;
	int valeur = 0;
	
	while (quitter != 1)
	{
		printf("\nTableau : [");
		for (int i=0 ; i<taille(tab) ; i++)
		{
			printf("%d", element(tab, i));
			if (i <= taille(tab)-2)
			{
				printf(", ");
			}
		}
		printf("]\n");

		printf("Taux d'occupation : %.2f\%\n", ((float)taille(tab)/(float)espace(tab))*100);

		printf("%d. Quitter\n", QUITTER);
		printf("%d. Ajouter un element\n", AJOUTER);
		printf("%d. Supprimer un element\n", SUPPRIMER);

		printf("Choix : ");
		scanf("%d", &choix);

		switch (choix)
		{
			case QUITTER:
				quitter = 1;
				break;
			case AJOUTER:
				printf("Element a ajouter : ");
				scanf("%d", &valeur);
				ajouter(tab, valeur);
				break;
			case SUPPRIMER:
				if (taille(tab) == 0)
				{
					printf("Le tableau est vide.\n");
					break;
				}
				printf("Element a supprimer : ");
				scanf("%d", &valeur);
				supprimer(tab, valeur);
				if ((float)taille(tab)/(float)espace(tab) < 0.25)
				{
					serrer(tab);
					printf("Le tableau est redimensionne !\n");
				}
				break;
			default:
				printf("Choix non valide.\n");
		}
	}

	return 0;
}


