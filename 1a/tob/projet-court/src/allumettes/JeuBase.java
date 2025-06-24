package allumettes;



public class JeuBase implements Jeu {

	// nombre d'allumettes restantes a un moment donne
	private int nbAllumettes;



	/**
	 * Constructeur
	 * @param nbAllumettesDebut Nombre d'allumettes initial
	 */
	public JeuBase(int nbAllumettesDebut) {
		this.nbAllumettes = nbAllumettesDebut;
	}



	@Override
	public int getNombreAllumettes() {
		return this.nbAllumettes;
	}



	@Override
	public void retirer(int nbPrises) throws CoupInvalideException {
		// l'utilisateur essaie de prendre plus d'allumettes qu'il n'y en a
		if (nbPrises > this.nbAllumettes) {
			throw new CoupInvalideException(nbPrises, "> " + this.nbAllumettes);
		}

		// l'utilisateur essaie de prendre moins d'une allumette
		if (nbPrises < 1) {
			throw new CoupInvalideException(nbPrises, "< 1");
		}

		// l'utilisateur essaie de prendre plus de PRISE_MAX allumettes
		if (nbPrises > PRISE_MAX) {
			throw new CoupInvalideException(nbPrises, "> " + PRISE_MAX);
		}

		this.nbAllumettes -= nbPrises;
	}



	/**
	 * Retourne une chaine de caracteres representant l'etat du jeu.
	 * Ex : Allumettes restantes : 12
	 * @return Etat du jeu
	 */
	public String toString() {
		return "Allumettes restantes : " + this.nbAllumettes;
	}
}
