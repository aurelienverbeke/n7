package allumettes;

import java.util.Scanner;



/**
 * Definit une strategie humain du jeu des allumettes.
 * Le joueur peut tenter de tricher.
 */
public class StrategieHumain implements Strategie {

	private static Scanner scanner = new Scanner(System.in);

	private String nom;



	/**
	 * Constructeur
	 * @param nom Nom du joueur.
	 */
	public StrategieHumain(String nom) {
		this.nom = nom;
		this.scanner.useDelimiter("\n");
	}



	public int getPrise(Jeu jeu) {
		int nbAllumettesPrises = 0;
		boolean entreeOkNb = false;
		boolean entreeOkTriche = false;




		do {
			entreeOkNb = false;
			entreeOkTriche = false;

			System.out.print(nom + ", combien d'allumettes ? ");

			// l'utilisateur a donné un nombre
			entreeOkNb = StrategieHumain.scanner.hasNextInt();

			if (entreeOkNb) {
				nbAllumettesPrises = StrategieHumain.scanner.nextInt();
			} else {
				// l'utilisateur a donné "triche"
				entreeOkTriche = StrategieHumain.scanner.hasNext("triche");
				StrategieHumain.scanner.next();

				if (entreeOkTriche) {
					try {
						jeu.retirer(1);
						System.out.println("[Une allumette en moins, plus que "
								+ jeu.getNombreAllumettes() + ". Chut !]");
					} catch (CoupInvalideException e) {
						// on retire une seule allumette,
						// le coup ne peut pas etre invalide
					}
				}

				if (!entreeOkNb && !entreeOkTriche) {
					System.out.println("Vous devez donner un entier.");
				}
			}

		}
		while (!entreeOkNb);



		return nbAllumettesPrises;
	}
}
