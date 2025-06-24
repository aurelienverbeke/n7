package allumettes;



/**
 * Definit un joueur du jeu des allumettes.
 */
public class Joueur {
	private String nom = ""; // Nom du joueur
	private Strategie strategie; // Strategie du joueur



	/**
	 * Constructeur
	 * Crée un joueur nommé
	 * @param nom Nom du joueur
	 * @param strategie Strategie du joueur.
	 */
	public Joueur(String nom, Strategie strategie) {
		this.nom = nom;
		remplacerStrategie(strategie);
	}



	/**
	 * Retourne le nom du joueur.
	 * @return Nom du joueur.
	 */
	public String getNom() {
		return this.nom;
	}



	/**
	 * Retourne le nombre d'allumettes que choisit de prendre le joueur.
	 * @param jeu Jeu en cours.
	 * @return Nombre d'allumettes prises
	 */
	public int getPrise(Jeu jeu) {
		return this.strategie.getPrise(jeu);
	};



	/**
	 * Remplace la strategie du joueur
	 * @param strategie Nouvelle strategie.
	 */
	public void remplacerStrategie(Strategie nouvelleStrategie) {
		this.strategie = nouvelleStrategie;
	}
}
