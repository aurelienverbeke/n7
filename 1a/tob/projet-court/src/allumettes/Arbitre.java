package allumettes;



/**
 * Arbitre d'un jeu entre 2 joueurs
 */
public class Arbitre {

	private Joueur joueur1; // premier joueur
	private Joueur joueur2; // deuxieme joueur

	private boolean confiant; // l'arbitre doit etre confiant

	private Joueur joueurEnCours; // joueur en train de jouer



	/**
	 * Constructeur prenant en compte la confiance
	 * @param joueur1 Premier joueur
	 * @param joueur2 Deuxieme joueur
	 * @param confiance L'arbitre doit-il etre confiant
	 */
	public Arbitre(Joueur joueur1, Joueur joueur2, boolean confiance) {
		this.joueur1 = joueur1;
		this.joueur2 = joueur2;
		this.confiant = confiance;
		this.joueurEnCours = joueur1;
	}

	/**
	 * Constructeur d'un arbitre confiant
	 * @param joueur1 Premier joueur
	 * @param joueur2 Deuxieme joueur
	 */
	public Arbitre(Joueur joueur1, Joueur joueur2) {
		this(joueur1, joueur2, true);
	}



	/**
	 * Fait jouer 2 joueurs a tour de role
	 * @param jeu Jeu a arbitrer
	 */
	public void arbitrer(Jeu jeu) {
		int nbAllumettesPrises = 0;

		JeuProxy proxy = new JeuProxy(jeu);



		try {
			// faire jouer les joueurs tant qu'il reste des allumettes
			while (jeu.getNombreAllumettes() > 0) {
				System.out.println(jeu);



				// demander au joueur combien d'allumettes il veut prendre
				if (confiant) {
					nbAllumettesPrises = joueurEnCours.getPrise(jeu);
				} else {
					nbAllumettesPrises = joueurEnCours.getPrise(proxy);
				}



				afficherPrise(nbAllumettesPrises);



				// retirer les allumettes du jeu
				// si cela a fonctionne, permuter les joueurs
				try {
					jeu.retirer(nbAllumettesPrises);
					permuterJoueurs();
				} catch (CoupInvalideException e) {
					System.out.println("Impossible ! Nombre invalide : "
								+ e.getCoup()
								+ " (" + e.getProbleme() + ")");
				}

				System.out.println();
			}

			if (joueurEnCours == joueur1) {
				afficherGagnantPerdant(joueur1, joueur2);
			} else {
				afficherGagnantPerdant(joueur2, joueur1);
			}
		} catch (OperationInterditeException e) {
			System.out.println("Abandon de la partie car " + joueurEnCours.getNom()
										+ " triche !");
		}
	}



	/**
	 * Afficher a l'utilisateur le gagnant et le perdant de la partie
	 * @param gagnant Gagnant de la partie
	 * @param perdant Perdant de la partie
	 */
	private void afficherGagnantPerdant(Joueur gagnant, Joueur perdant) {
		System.out.println(perdant.getNom() + " perd !");
		System.out.println(gagnant.getNom() + " gagne !");
	}



	/**
	 * Afficher le nombre d'allumettes prises par l'utilisateur
	 * @param nbAllumettesPrises Nombre d'allumettes prises par l'utilisateur
	 */
	private void afficherPrise(int nbAllumettesPrises) {
		if (nbAllumettesPrises >= 2) {
			System.out.println(joueurEnCours.getNom() + " prend "
						+ nbAllumettesPrises + " allumettes.");
		} else {
			System.out.println(joueurEnCours.getNom() + " prend "
						+ nbAllumettesPrises + " allumette.");
		}
	}



	/**
	 * Assigner le joueur suivant comme joueur en cours
	 */
	private void permuterJoueurs() {
		if (joueurEnCours == joueur1) {
			joueurEnCours = joueur2;
		} else {
			joueurEnCours = joueur1;
		}
	}
}
