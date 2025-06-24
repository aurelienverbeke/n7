package allumettes;



/**
 * Definit une strategie du jeu des allumettes.
 */
public interface Strategie {
	/**
	 * Retourne le nombre d'allumettes que choisit de prendre le joueur.
	 * @param jeu Jeu en cours.
	 * @return Nombre d'allumettes prises
	 */
	int getPrise(Jeu jeu);
}
