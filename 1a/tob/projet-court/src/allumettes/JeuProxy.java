package allumettes;



/**
 * Proxy qui ne permet pas de retirer des allumettes
 */
public class JeuProxy implements Jeu {

	private Jeu jeuInterne;



	/**
	 * Constructeur d'un proxy de jeu
	 * Permet de regler le nombre d'allumettes initial
	 * @param jeu Jeu sur lequel faire un proxy
	 */
	public JeuProxy(Jeu jeuCible) {
		this.jeuInterne = jeuCible;
	}



	@Override
	public int getNombreAllumettes() {
		return this.jeuInterne.getNombreAllumettes();
	}



	/**
	 * Genere tout de suite une exception OperationInterditeException
	 */
	@Override
	public void retirer(int nbPrises) {
		throw new OperationInterditeException();
	}



	/**
	 * Retourne une chaine de caracteres representant l'etat du jeu.
	 * Ex : Allumettes restantes : 12
	 * @return Etat du jeu
	 */
	public String toString() {
		return "Allumettes restantes : " + this.getNombreAllumettes();
	}
}
