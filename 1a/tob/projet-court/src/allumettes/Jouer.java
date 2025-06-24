package allumettes;

/** Lance une partie des 13 allumettes en fonction des arguments fournis
 * sur la ligne de commande.
 * @author	Xavier Crégut
 * @version	$Revision: 1.5 $
 */
public class Jouer {

	// nombre d'allumettes par default au debut du jeu
	public static final int NB_ALLUMETTES_DEBUT = 13;

	private static final int NB_JOUEURS = 2;



	/** Lancer une partie. En argument sont donnés les deux joueurs sous
	 * la forme nom@stratégie.
	 * @param args la description des deux joueurs
	 */
	public static void main(String[] args) {
		String[][] paramsJoueurs = new String[NB_JOUEURS][];

		boolean confiant = false;

		Joueur[] joueurs = new Joueur[NB_JOUEURS];

		Jeu jeu;
		Arbitre arbitre;



		try {
			verifierArguments(args);

			confiant = lireConfiance(args);

			for (int i = 0; i < NB_JOUEURS; i++) {
				paramsJoueurs[i] = confiant ? args[i + 1].split("@") : args[i].split("@");
				joueurs[i] = attribuerJoueur(paramsJoueurs[i]);
			}
		} catch (ConfigurationException e) {
			System.out.println();
			System.out.println("Erreur : " + e.getMessage());
			afficherUsage();
			System.exit(1);
		}



		arbitre = new Arbitre(joueurs[0], joueurs[1], confiant);
		arbitre.arbitrer(new JeuBase(NB_ALLUMETTES_DEBUT));
	}



	/**
	 * Verifier qu'il y a bien le bon nombre d'arguments dans la ligne de commande
	 * @param args Ligne de commande
	 */
	private static void verifierArguments(String[] args) {
		if (args.length < NB_JOUEURS) {
			throw new ConfigurationException("Trop peu d'arguments : "
					+ args.length);
		}

		if (args.length > NB_JOUEURS + 1) {
			throw new ConfigurationException("Trop d'arguments : "
					+ args.length);
		}
	}



	/**
	 * Tirer de la ligne de commande la confiance ou non de l'arbitre
	 * @param args Ligne de commande
	 */
	private static boolean lireConfiance(String[] args) {
		if (args.length == NB_JOUEURS) {
			// l'utilisateur n'a fourni que la configuration des 2 joueurs
			// l'arbitre n'est pas confiant
			return false;
		} else {
			// l'utilisateur a aussi fourni un parametre sur la confiance
			// doit etre [-confiant] pour rendre l'arbitre confiant
			if (args[0].equals("-confiant")) {
				return true;
			} else {
				throw new ConfigurationException("Argument invalide : "
						+ args[0]);
			}
		}
	}



	/**
	 * Attribuer la bonne strategie a chacun des joueurs
	 * @param paramsJoueur Parametres fournis par l'utilisateurs, separes par le '@'
	 * @return Joueur avec la strategie choisie par l'utilisateur
	 */
	private static Joueur attribuerJoueur(String[] paramsJoueur) {
		Strategie strategieChoisie;

		if (paramsJoueur.length != 2) {
			throw new ConfigurationException("Probleme dans la fourniture des joueurs"
							+ " (mauvais nombre de parametres)");
		}

		switch (paramsJoueur[1]) {
			case "naif":
				strategieChoisie = new StrategieNaif();
				break;
			case "rapide":
				strategieChoisie = new StrategieRapide();
				break;
			case "expert":
				strategieChoisie = new StrategieExpert();
				break;
			case "tricheur":
				strategieChoisie = new StrategieTricheur();
				break;
			case "humain":
				strategieChoisie = new StrategieHumain(paramsJoueur[0]);
				break;
			default:
				throw new ConfigurationException("Probleme dans la fourniture des joueurs"
						+ " (mauvaise strategie)");
		}

		return new Joueur(paramsJoueur[0], strategieChoisie);
	}



	/**
	 * Afficher des indications sur la manière d'exécuter cette classe.
	 */
	private static void afficherUsage() {
		System.out.println("\n" + "Usage :"
				+ "\n\t" + "java allumettes.Jouer joueur1 joueur2"
				+ "\n\t\t" + "joueur est de la forme nom@stratégie"
				+ "\n\t\t" + "strategie = naif | rapide | expert | humain | tricheur"
				+ "\n"
				+ "\n\t" + "Exemple :"
				+ "\n\t" + "	java allumettes.Jouer Xavier@humain "
					   + "Ordinateur@naif"
				+ "\n"
				);
	}

}
