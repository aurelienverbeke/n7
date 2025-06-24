package allumettes;

import org.junit.*;
import static org.junit.Assert.*;



/**
 * Classe de test de StrategieRapide
 */
public class StrategieRapideTest {

	@Test
	public void testerGetPriseJeuBase() throws CoupInvalideException {
		int prise = 0;
		
		Joueur joueur = new Joueur("Aurelien", new StrategieRapide());
		JeuBase jeu = new JeuBase(13); // 13
		assertEquals(joueur.getPrise(jeu), 3);
		
		jeu.retirer(3);
		jeu.retirer(2);
		// 8
		assertEquals(joueur.getPrise(jeu), 3);
		
		jeu.retirer(2);
		jeu.retirer(2);
		// 4
		assertEquals(joueur.getPrise(jeu), 3);
		
		jeu.retirer(1); // 3
		assertEquals(joueur.getPrise(jeu), 3);
		
		jeu.retirer(1); // 2
		assertEquals(joueur.getPrise(jeu), 2);
		
		jeu.retirer(1); // 1
		assertEquals(joueur.getPrise(jeu), 1);
	}
}
