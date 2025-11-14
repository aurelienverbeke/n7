{
(* type token = ID of string | AUTO | IFACE | INET | EOF | LOOPBACK | DHCP | STATIC | ADDRESS | NETMASK | GATEWAY | IP *)
open Parser

exception Error of string
}

(* Définitions de macro pour les expressions régulières *)
let blanc = [' ' '\t' '\n']
let nb = ['0'-'9'] | ['1'-'9']['0'-'9'] | '1'['0'-'9']['0'-'9'] | '2'['0'-'4']['0'-'9'] | '2''5'['0'-'5']
let regex_ip = nb '.' nb '.' nb '.' nb
let regex_interface = ['a'-'z''A'-'Z''0'-'9']+


(* Règles léxicales *)
rule interface = parse
|  blanc (* On ignore les blancs *)
    { interface lexbuf }
| "auto"
    { AUTO }
| "iface"
    { IFACE }
| "inet"
    { INET }
| "loopback"
    { LOOPBACK }
| "dhcp"
    { DHCP }
| "static"
    { STATIC }
| "address"
    { ADDRESS }
| "netmask"
    { NETMASK }
| "gateway"
    { GATEWAY }
| regex_ip
    { IP }
| regex_interface as id
    { ID (id) }
| eof
    { EOF }
| _
{ raise (Error ("Unexpected char: "^(Lexing.lexeme lexbuf)^" at "^(string_of_int (Lexing.lexeme_start
lexbuf))^"-"^(string_of_int (Lexing.lexeme_end lexbuf)))) }
