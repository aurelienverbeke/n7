# Expressions régulières

- Interfaces : `(['a'-'z''A'-'Z']*['0'-'9']*)+`
- Adresses IP : 
>[!NOTE]
>**Définition de macros**
>
>`let nb = ['0'-'9']|['1'-'9']['0'-'9']|'1'['0'-'9']['0'-'9']|'2'['0'-'4']['0'-'9']|'2''5'['0'-'5']`
>
>`let ip = nb'.'nb'.'nb'.'nb`


# Règles lexicales : 
```ocaml
type token = ID of string | AUTO | IFACE | (*etc...*)

rule interface = parse
| "auto"
	{AUTO}
| "iface"
	{IFACE}
(*etc...*)
```
>[!NOTE] 
>On crée un type `token` référençant tous les tokens pouvant être rencontrés lors de l'analyse lexicale du code source. On parse ensuite le code source afin de générer une suite de tokens.
>
>On peut utiliser les expressions régulières définies au-dessus afin d'associer des tokens de façon "dynamique" :
>```ocaml
>let regex_iface = ['a'-'z''A'-'Z''0'-'9']+ ; (*Définition d'une expression régulière*)
>
>rule interface = parse
>(*Les parse 'statiques'*)
>| regex_iface
>	{ INTERFACE }
>```
>Il faut penser aussi à ajouter le token `INTERFACE` dans la liste de tokens.

# Tests supplémentaires : 

On peut modifier le fichier de test afin d'induire des erreurs lexicales. Par exemple : 
```
auto lo
iface lo inet lopback

auto eth0
iface eth0 inet dhcp

iface maison inet static
	address 092.168.0.1
	netmask 255.255.255.0
	gateway 192.168.254
```
>[!NOTE]
>**Erreurs remarquées**
>
>On voit que l'analyse lexicale plante sur la première adresse IP fausse et non le `lopback`. En effet cette suite de caractères n'est plus associée au token `LOOPBACK` mais à un token `INTERFACE` , car il suit son expression régulière.
>On remarque également que l'erreur sur l'analyseur lexical indique un caractère `.` inattendu. En effet, comme la suite de caractères `092.168.0.1` ne suit pas l'expression régulière d'un token `IP` , il est considéré comme étant un token `INTERFACE`. Hors l'expression regulière d'une interface n'accepte pas les `.`, ce qui fait planter l'analyse lexicale.


# Règles de production de la grammaire

Une fois les tokens rajoutés dans le parser, on peut rajouter les non terminaux et exprimer les règles de grammaire :

```ocaml

%type <unit> i
%type <unit> t

%start <unit> is

(*Règles de grammaire associées à IS, I et T*)
is :
| i is {()}
| EOF {()}

i :
| AUTO ID {()}
| IFACE ID INET t {()}

t :
| LOOPBACK {()}
| DHCP {()}
| STATIC ADDRESS IP NETMASK IP GATEWAY IP {()}
```
> [!NOTE]
> **Tests**
> 
> En faisant nos tests avec le fichier précédent, on remarque que le token de `lopback` est reconnu comme étant un `INTERFACE`. Cependant la règle de grammaire spécifie que le token suivant un token `INET` doit être un `t`, qui ne peut pas être un `INTERFACE`.

# Analyse sémantique

Lors de l'analyse sémantique, on cherche à faire remonter un couple de listes comprenant la liste des interfaces déclarées (celles positionnées après un token `IFACE`) et la liste des interfaces automatiques (celles positionnées après un token `AUTO`).

Pour cela, il faut modifier le type des symboles non terminaux afin de faire remonter, au niveau de `is`, le couple de listes des interfaces déclarées et des interfaces lancées automatiquement (dans l'ordre) et également, au niveau de `i` , le type de l'interface et son nom afin de la positionner dans la bonne liste dans `is`  :

```ocaml
%{
	type interface = Auto of string | Iface of string
%}

(*Liste de tokens ici*)

%type <interface> i
%type <unit> t

%type <string list * string list> is

is :
| nom=i listes=is {
	match listes with
	| (ifaces,autos) ->
		match nom with
		| Auto n -> (ifaces,n::autos)
		| Iface n -> (n::ifaces, autos)
}
| EOF {([],[])}

i :
| AUTO nom=ID {Auto (nom)}
| IFACE nom=ID INET t {Iface (nom)}

t :
| LOOPBACK {()}
| DHCP {()}
| STATIC ADDRESS IP NETMASK IP GATEWAY IP {()}

```


