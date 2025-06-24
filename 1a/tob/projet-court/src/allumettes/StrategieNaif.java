package allumettes;

import java.util.Random;



/**
 * Definit une strategie naïve du jeu des allumettes.
 * Elle prend un nombre aléatoire d'allumettes (max PRISE_MAX).
 */
public class StrategieNaif implements Strategie {

	public int getPrise(Jeu jeu) {
		Random generateurAleatoire = new Random();

		return generateurAleatoire.nextInt(
				Math.min(Jeu.PRISE_MAX,
					jeu.getNombreAllumettes())) + 1;
	}
}
