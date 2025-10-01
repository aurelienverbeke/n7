library IEEE;
use IEEE.std_logic_1164.all;



-- interface du composant additionneur
entity additionneur_4bits is
  port(
       A, B : in std_logic_vector(3 downto 0);
       Cin : in std_logic;
       S : out std_logic_vector(3 downto 0);
       Cout : out std_logic
      );
end additionneur_4bits;



-- architecture structurelle
architecture vue_structurelle of additionneur_4bits is

    -- importation de l'additionneur 2 bits
    component additionneur is
        port(
            X, Y, Cin : in std_logic;
            S, Cout : out std_logic
        );
    end component;

    -- signaux locaux
    signal l1, l2, l3 : std_logic;

begin

    -- instantiation des 4 additionneurs
    U1 : additionneur port map (X=>A(0), Y=>B(0), Cin=>Cin, S=>S(0), Cout=>l1);
    U2 : additionneur port map (X=>A(1), Y=>B(1), Cin=>l1, S=>S(1), Cout=>l2);
    U3 : additionneur port map (X=>A(2), Y=>B(2), Cin=>l2, S=>S(2), Cout=>l3);
    U4 : additionneur port map (X=>A(3), Y=>B(3), Cin=>l3, S=>S(3), Cout=>Cout);

end vue_structurelle;