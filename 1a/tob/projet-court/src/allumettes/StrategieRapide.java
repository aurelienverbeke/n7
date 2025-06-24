package allumettes;



/**
 * Definit une strategie rapide du jeu des allumettes.
 * Elle prend le plus d'allumettes possible (max PRISE_MAX).
 */
public class StrategieRapide implements Strategie {

	public int getPrise(Jeu jeu) {
		return Math.min(Jeu.PRISE_MAX, jeu.getNombreAllumettes());
	}
}
