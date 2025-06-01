#ifndef COMPLEX_H
#define COMPLEX_H



// Type utilisateur complexe_t
typedef struct
{
	double im;
	double re;
} complexe_t;





// Fonctions reelle et imaginaire

/**
 *
 * reelle
 *
 * Renvoie la partie reelle d'un complexe
 *
 * Paramètres :
 * - nombre : le nombre dont il faut retourner la partie reelle
 *
 * Post-condition :
 * - [retour] = Re(nombre)
 *
 */
double reelle(complexe_t nombre);

/**
 *
 * imaginaire
 *
 * Renvoie la partie imaginaire d'un complexe
 *
 * Paramètres :
 * - nombre : le nombre dont il faut retourner la partie imaginaire
 *
 * Post-condition :
 * - [retour] = Im(nombre)
 *
 */
double imaginaire(complexe_t nombre);





// Procédures set_reelle, set_imaginaire et init

/**
 *
 * set_reelle
 *
 * Modifie la partie reelle d'un complexe
 *
 * Paramètres :
 * - nombre : le nombre dont il faut modifier la partie reelle
 * - valeur : la nouvelle partie reelle
 *
 * Pré-condition :
 * - nombre != NULL
 *
 * Post-condition :
 * - nombre->re = valeur
 *
 */
void set_reelle(complexe_t* nombre, double valeur);

/**
 *
 * set_imaginaire
 *
 * Modifie la partie imaginaire d'un complexe
 *
 * Paramètres :
 * - nombre : le nombre dont il faut modifier la partie imaginaire
 * - valeur : la nouvelle partie imaginaire
 *
 * Pré-condition :
 * - nombre != NULL
 *
 * Post-condition :
 * - nombre->im = valeur
 *
 */
void set_imaginaire(complexe_t* nombre, double valeur);

/**
 *
 * init
 *
 * Modifie les parties reelle et imaginaire d'un complexe
 *
 * Paramètres :
 * - nombre : le nombre qu'il faut initialiser
 * - valeurRe : la nouvelle partie reelle
 * - valeurIm : la nouvelle partie imaginaire
 *
 * Pré-condition :
 * - nombre != NULL
 *
 * Post-condition :
 * - nombre->re = valeurRe
 * - nombre->im = valeurIm
 *
 */
void init(complexe_t* nombre, double valeurRe, double valeurIm);





// Procédure copie
/**
 * copie
 * Copie les composantes du complexe donné en second argument dans celles du premier
 * argument
 *
 * Paramètres :
 *   resultat       [out] Complexe dans lequel copier les composantes
 *   autre          [in]  Complexe à copier
 *
 * Pré-conditions : resultat non null
 * Post-conditions : resultat et autre ont les mêmes composantes
 */
void copie(complexe_t* resultat, complexe_t autre);





// Algèbre des nombres complexes
/**
 * conjugue
 * Calcule le conjugué du nombre complexe op et le sotocke dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   op             [in]  Complexe dont on veut le conjugué
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : reelle(*resultat) = reelle(op), complexe(*resultat) = - complexe(op)
 */
void conjugue(complexe_t* resultat, complexe_t op);

/**
 * ajouter
 * Réalise l'addition des deux nombres complexes gauche et droite et stocke le résultat
 * dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   gauche         [in]  Opérande gauche
 *   droite         [in]  Opérande droite
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : *resultat = gauche + droite
 */
void ajouter(complexe_t* resultat, complexe_t gauche, complexe_t droite);

/**
 * soustraire
 * Réalise la soustraction des deux nombres complexes gauche et droite et stocke le résultat
 * dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   gauche         [in]  Opérande gauche
 *   droite         [in]  Opérande droite
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : *resultat = gauche - droite
 */
void soustraire(complexe_t* resultat, complexe_t gauche, complexe_t droite);

/**
 * multiplier
 * Réalise le produit des deux nombres complexes gauche et droite et stocke le résultat
 * dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   gauche         [in]  Opérande gauche
 *   droite         [in]  Opérande droite
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : *resultat = gauche * droite
 */
void multiplier(complexe_t* resultat, complexe_t gauche, complexe_t droite);

/**
 * echelle
 * Calcule la mise à l'échelle d'un nombre complexe avec le nombre réel donné (multiplication
 * de op par le facteur réel facteur).
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   op             [in]  Complexe à mettre à l'échelle
 *   facteur        [in]  Nombre réel à multiplier
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : *resultat = op * facteur
 */
void echelle(complexe_t* resultat, complexe_t op, double facteur);

/**
 * puissance
 * Calcule la puissance entière du complexe donné et stocke le résultat dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   op             [in]  Complexe dont on veut la puissance
 *   exposant       [in]  Exposant de la puissance
 *
 * Pré-conditions : resultat non-null, exposant >= 0
 * Post-conditions : *resultat = op * op * ... * op
 *                                 { n fois }
 */
void puissance(complexe_t* resultat, complexe_t op, int exposant);





// Module et argument

/**
 * module_carre
 *
 * Calcule le module au carre d'un complexe
 *
 * Paramètres :
 * - nombre : nombre dont il faut determiner le module au carre
 *
 * Post-condition :
 * - [retour] = |nombre|^2
 */
double module_carre(complexe_t nombre);

/**
 * module
 *
 * Calcule le module d'un complexe
 *
 * Paramètres :
 * - nombre : nombre dont il faut determiner le module
 *
 * Post-condition :
 * - [retour] = |nombre|
 */
double module(complexe_t nombre);

/**
 * argument
 *
 * Calcule l'argument d'un complexe
 *
 * Paramètres :
 * - nombre : nombre dont il faut determiner l'argument
 *
 * Post-condition :
 * - [retour] = arg(nombre)
 */
double argument(complexe_t nombre);





#endif // COMPLEXE_H
