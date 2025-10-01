library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Nexys4 is
  port (
    -- les 16 switchs
    sw : in std_logic_vector (15 downto 0);
    -- les anodes pour sélectionner l'afficheur 7 segments
    an : out std_logic_vector (7 downto 0);
    -- afficheur 7 segments (point décimal compris, segment 7)
    seg : out std_logic_vector (7 downto 0);
    -- horloge
    mclk : in std_logic;
    -- les 5 boutons noirs
    btnC, btnU, btnL, btnR, btnD : in std_logic;
    -- les 16 leds
    led : out std_logic_vector (15 downto 0)
  );
end Nexys4;

architecture synthesis of Nexys4 is

  COMPONENT additionneur
  PORT (
      X, Y, Cin  : IN  std_logic;
      S, Cout : OUT std_logic
  );
  END COMPONENT additionneur;


begin

  -- valeurs des sorties (à modifier)

  -- convention afficheur 7 segments 0 => allumé, 1 => éteint
  -- seg <= (others => '1');
  -- aucun afficheur sélectionné
  -- an(7 downto 0) <= (others => '1');
  -- 16 leds éteintes
  -- led(15 downto 0) <= (others => '0');

  -- connexion du (des) composant(s) avec les ports de la carte
  Inst_additionneur: additionneur PORT MAP (
    X => sw(2),
    Y => sw(1),
    Cin => sw(0),
    S => led(1),
    Cout => led(0)
  );

    
end synthesis;

