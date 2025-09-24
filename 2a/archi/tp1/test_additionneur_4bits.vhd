library ieee ;
use ieee.std_logic_1164.all;

-- (génération automatique du code du test possible)
entity test_additionneur_4bits is
end test_additionneur_4bits;

architecture arch_test of test_additionneur_4bits is

    -- rappel de l"interface du composant testé
    COMPONENT additionneur_4bits
        PORT (
            A, B    : IN  std_logic_vector(3 downto 0);
            Cin  : IN  std_logic;
            S    : OUT std_logic_vector(3 downto 0);
            Cout : OUT std_logic
        );
    END COMPONENT additionneur_4bits;



    -- signaux locaux à connecter au composant
    signal A, B : std_logic_vector(3 downto 0);
    signal CarryIn : std_logic;
    signal Sum : std_logic_vector(3 downto 0);
    signal CarryOut : std_logic;
    
    -- configuration pour indiquer quelle architecture de l"additionneur
    -- tester (si omis, le logiciel Xilinx ISE en choisit une)
    for a1: additionneur_4bits use entity work.additionneur_4bits(vue_structurelle);

    begin

     -- instantiation et connexion du composant à tester
    a1 : additionneur_4bits
        port map(A, B, CarryIn, Sum, CarryOut);

     -- valeurs données aux signaux en entrée
     -- (exhaustif pour cet exemple)
     -- attention : les valeurs doivent être maintenues, le temps de calculer les
     -- signaux en sortie de l"additionneur

     -- TODO : faire les 16x16x2 permutations
     A <= "0000", 
            "0001" after 20 ns,
            "0010" after 40 ns,
            "0011" after 60 ns,
            "0100" after 80 ns,
            "0101" after 100 ns,
            "0110" after 120 ns,
            "0111" after 140 ns,
            "1000" after 160 ns,
            "1001" after 180 ns,
            "1010" after 200 ns,
            "1011" after 220 ns,
            "1100" after 240 ns,
            "1101" after 260 ns,
            "1110" after 280 ns,
            "1111" after 300 ns;
                
     B <= "0000", 
            "0010" after 40 ns,
            "0100" after 80 ns,
            "0110" after 120 ns,
            "1000" after 160 ns,
            "1010" after 200 ns,
            "1100" after 240 ns,
            "1110" after 280 ns;
                
     CarryIn <= '0', '1' after 160 ns;

    end arch_test;
