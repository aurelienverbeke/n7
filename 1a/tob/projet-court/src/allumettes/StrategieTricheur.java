package allumettes;

/**
 * Definit une strategie tricheur du jeu des allumettes.
 * Elle tente de ne laisser que 2 allumettes, puis d'en prendre une.
 */
public class StrategieTricheur implements Strategie {

	public int getPrise(Jeu jeu) {
		if (jeu.getNombreAllumettes() > 2) {
			System.out.println("[Je triche...]");

			try {
				// on laisse 2 allumettes

				// on ne peut retirer que maximum PRISE_MAX allumettes
				while (jeu.getNombreAllumettes() >= Jeu.PRISE_MAX + 2) {
					jeu.retirer(Jeu.PRISE_MAX);
				}

				if (jeu.getNombreAllumettes() > 2) {
					jeu.retirer(jeu.getNombreAllumettes() - 2);
				}

				System.out.println("[Allumettes restantes : 2]");
			} catch (CoupInvalideException e) {
				// on s'est bien debrouilles pour ne pas qu'une exception se leve
			}
		}

		return 1;
	}
}
