# Sans fonction

On cherche à compléter la fonction `analyse_tds_expression`. Pour des raisons de facilité de tests, on va d'abord compléter sans les appels de fonction.

```ocaml
let analyse_tds_expression tds e =
	match e with
	| AstSyntax.AppelFonction _ -> (AstTds.Booleen true)
```

On cherche donc à ajouter dans une Table des Symboles (Tds pour la suite), les différentes informations liées aux expressions qu'on retrouve dans un programme.

On a donc dans le bloc match précédent :

```ocaml
| AstSyntax.Ident identifiant ->
| AstSyntax.Booleen booleen -> 
| AstSyntax.Entier entier -> 
| AstSyntax.Unaire (unaire,e) ->
| AstSyntax.Binaire (binaire,e1,e2) ->
```

> [!NOTE]
> Les binaires et les unaires sont composés d'une expression supplémentaire qu'on analysera de façon récursive. Il faut donc bien penser à spécifier que l'analyse des expressions est récursive.

## Identifiant

Pour l'analyse des identifiants, il nous faut vérifier que l'identifiant est bien dans la table des symboles globale (car on peut l'avoir défini en dehors du bloc courant). Si c'est le cas, on pourra procéder à son traitement. On a donc dans le cas de l'identifiant :

```ocaml
begin
match chercherGlobalement tds identifiant with
| None -> raise (IdentifiantNonDeclare identifiant)
| Some info ->
match info_to_info_ast info with
| InfoConst (_,valeur) -> AstTds.Entier(valeur)
| InfoVar _ -> AstTds.Ident(info)
| InfoFun _ -> raise (MauvaiseUtilisationIdentifiant identifiant)
end
end
```

> [!NOTE]
> - Il est nécessaire ici de grouper les blocs match dans un bloc begin/end, afin que les cas de match ne sortent pas au niveau du match précédent
> - Afin que les tests compilent bien, il faut que les erreurs renvoient l'identifiant sur lequel on a l'erreur. 
> - On doit également vérifier que l'identifiant appelé n'est pas une fonction. C'est en effet traité par appel fonction.


## Le reste

Le reste des traitements n'est pas complexe.

```ocaml
| AstSyntax.Booleen booleen -> AstTds.Booleen(booleen)
| AstSyntax.Entier entier -> AstTds.Entier(entier)
| AstSyntax.Unaire (unaire, e) -> AstTds.Unaire(unaire, analyse_tds_expression tds e)
| AstSyntax.Binaire (binaire, e1, e2) -> AstTds.Binaire(binaire, analyse_tds_expression tds e1, analyse_tds_expression tds e2)
```

> [!NOTE]
> On voit ici la récursivité de l'analyse des expressions, notamment dans le traitement des unaires et des binaires.


# Avec fonction

## Traitement des appels de fonction

On va maintenant traiter les déclarations et appels de fonction. La première étape va être de venir modifier l'analyse des expressions afin de traiter les appels de fonction. On va donc venir vérifier si la fonction qu'on appelle a été déclarée globalement, et on va ensuite la traiter.

```ocaml
| AstSyntax.AppelFonction (identifiant,es) ->
	begin
	match chercherGlobalement tds identifiant with
	| None -> raise (IdentifiantNonDeclare identifiant)
	| Some info -> 
		begin
		match info_ast_to_info info with
		| InfoFun _ -> AstTds.AppelFonction(info, List.map(analyse_tds_expression tds) es)
		| _ -> raise(MauvaiseUtilisationIdentifiant identifiant)
```

> [!NOTE]
> On analyse ici la liste de paramètres afin vérifier qu'ils soient tous conformes à des expressions.

## Traitement des déclarations de fonction

Accrochez-vous bien c'est moins fun à partir de là.

La structure de la table des symboles pour les fonctions est un peu différente : On va ajouter dans la table mère tout les identifiants des fonctions, puis créer une Tds fille **par fonction** pour stocker les paramètres. On créera une table fille à la table fille (donc table petite-fille) pour stocker le bloc de la fonction. On se retrouve donc avec une arborescence à 3 niveaux.


```ocaml
let analyse_tds_fonction maintds (AstSyntax.Fonction(t,n,lp,li)) = 
	match rechercherGlobalement maintds n with
	| None -> 
		let info_fun = info_to_info_ast (InfoFun(n,t,List.map fst lp))
		ajouter maintds n info_fun;
		let tds = creerTDSFille maintds in
		let infos_p = List.map(fun (tp,np) -> (tp,np,info_to_info_ast (InfoVar (np,tp,0,"")))) lp in
		List.iter 
			(
			fun(_,np,info_p) -> 
				let info_ast_param_a_ajouter = chercherLocalement tds np in
				begin
					match info_ast_param_a_ajouter with
					| None -> ajouter tds np info_p
					| Some _ -> raise (DoubleDeclaration np)
				end
			)
			infos_p;
		let tds_bloc = creerTDSFille tds in
		let bloc = analyse_tds_bloc tds_bloc (Some info_fun) li in
		AstTds.Fonction(t,info_fun,List.map (fun (tp, _, info_p)) infos_p, bloc)
	| Some _ -> raise (DoubleDeclaration n)
```

> [!NOTE]
> On a besoin de stocker les différentes InfoAst dans des variables afin de les ajouter dans les différentes Tds. C'est à ça que servent les variables `info_fun`, `infos_p`, et `info_ast_param_a_ajouter`. 
