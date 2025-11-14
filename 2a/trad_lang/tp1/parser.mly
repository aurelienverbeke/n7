%{
 type interface = Auto of string | Iface of string
%}


%token <string> ID
%token AUTO
%token IFACE
%token INET
%token EOF
%token LOOPBACK
%token DHCP
%token STATIC
%token ADDRESS
%token NETMASK
%token GATEWAY
%token IP

(* Exercice 2 *)
(* Déclarations du type de l'attribut associé à un non terminal *)
(* Dans un premier temps on ignore cet attribut -> type unit *)
%type <interface> i
%type <unit> t

(* Indication de l'axiom et du type de l'attribut associé à l'axiom *)
(* Dans un premier temps on ignore cet attribut -> type unit *)
%start <string list * string list> is

%%

(*
IS -> I IS
IS -> $

I -> ...
*)

is :
| nom=i listes=is {
    match listes with
    | (ifaces, autos) ->
        match nom with
        | Auto n -> (ifaces, n::autos)
        | Iface n -> (n::ifaces, autos)
} (* action sémantique associée à une règle de prodution -> dans un premier temps () *)
| EOF  {([], [])}


i : 
| AUTO nom=ID { Auto (nom) }
| IFACE nom=ID INET t { Iface (nom) }


t :
| LOOPBACK {()}
| DHCP {()}
| STATIC ADDRESS IP NETMASK IP GATEWAY IP {()}
