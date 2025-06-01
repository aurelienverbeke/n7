#include "complexe.h"
#include <math.h>           // Pour certaines fonctions trigo notamment



// Implantations de reelle et imaginaire
double reelle(complexe_t nombre)
{
	return nombre.re;
}

double imaginaire(complexe_t nombre)
{
	return nombre.im;
}





// Implantations de set_reelle, set_imaginaire et init
void set_reelle(complexe_t* nombre, double valeur)
{
	nombre->re = valeur;
}

void set_imaginaire(complexe_t* nombre, double valeur)
{
	nombre->im = valeur;
}

void init(complexe_t* nombre, double valeurRe, double valeurIm)
{
	set_reelle(nombre, valeurRe);
	set_imaginaire(nombre, valeurIm);
}





// Implantation de copie
void copie(complexe_t* resultat, complexe_t autre)
{
	init(resultat, reelle(autre), imaginaire(autre));
}





// Implantations des fonctions algébriques sur les complexes
void conjugue(complexe_t* resultat, complexe_t op)
{
	init(resultat, reelle(op), -imaginaire(op));
}

void ajouter(complexe_t* resultat, complexe_t gauche, complexe_t droite)
{
	init(resultat, reelle(gauche)+reelle(droite), imaginaire(gauche)+imaginaire(droite));
}

void soustraire(complexe_t* resultat, complexe_t gauche, complexe_t droite)
{
	init(resultat, reelle(gauche)-reelle(droite), imaginaire(gauche)-imaginaire(droite));
}

void multiplier(complexe_t* resultat, complexe_t gauche, complexe_t droite)
{
	init(resultat,
		reelle(gauche)*reelle(droite) - imaginaire(gauche)*imaginaire(droite),
		reelle(gauche)*imaginaire(droite) + imaginaire(gauche)*reelle(droite));
}

void echelle(complexe_t* resultat, complexe_t op, double facteur)
{
	init(resultat, reelle(op)*facteur, imaginaire(op)*facteur);
}

void puissance(complexe_t* resultat, complexe_t op, int exposant)
{
	// il faut que op^0 = 1
	init(resultat, 1, 0);
	
	// on multiplie exposant fois op par lui-meme
	for(int i=0 ; i<exposant ; i++)
		multiplier(resultat, *resultat, op);
}





// Implantations du module et de l'argument
double module_carre(complexe_t nombre)
{
	return reelle(nombre)*reelle(nombre) + imaginaire(nombre)*imaginaire(nombre);
}

double module(complexe_t nombre)
{
	return sqrt(module_carre(nombre));
}

double argument(complexe_t nombre)
{
	return atan2(imaginaire(nombre), reelle(nombre));
}
