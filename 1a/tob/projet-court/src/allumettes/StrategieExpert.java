package allumettes;

/**
 * Definit une stategie expert du jeu des allumettes.
 * Elle joue de manière a gagner.
 */
public class StrategieExpert implements Strategie {

	public int getPrise(Jeu jeu) {
		int nbAllumettesPrises = 0;

		// Il faut laisser [multiple de (PRISE_MAX+1) + 1] allumettes
		nbAllumettesPrises = (jeu.getNombreAllumettes() % (Jeu.PRISE_MAX + 1)
						+ Jeu.PRISE_MAX)
					% (Jeu.PRISE_MAX + 1);

		// Dans le cas où (nbAllumettesRestantes % (PRISE_MAX) == 1),
		// on n'est pas dans une position confortable,
		// on n’en prend qu’une pour se laisser le temps de corriger le tir
		if (nbAllumettesPrises == 0) {
			nbAllumettesPrises = 1;
		}

		return nbAllumettesPrises;
	}
}
