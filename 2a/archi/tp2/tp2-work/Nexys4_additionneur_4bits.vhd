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

  COMPONENT additionneur_4bits
  PORT (
      A, B    : IN  std_logic_vector(3 downto 0);
      Cin  : IN  std_logic;
      S    : OUT std_logic_vector(3 downto 0);
      Cout : OUT std_logic
  );
  END COMPONENT additionneur_4bits;

  COMPONENT dec7seg
	PORT(
		v : IN std_logic_vector(3 downto 0);          
		seg : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

  signal sortie: std_logic_vector(3 downto 0);


begin

  -- afficheur 1 sélectionné
  an(7 downto 0) <= (0 => '0', others => '1');
  led(4 downto 1) <= sortie(3 downto 0);

  -- connexion de l'additionneur avec les ports de la carte
  Inst_additionneur: additionneur_4bits PORT MAP (
    A => sw(8 downto 5),
    B => sw(4 downto 1),
    Cin => sw(0),
    S => sortie,
    Cout => led(0)
  );

  Afficheur: dec7seg PORT MAP (
    v => sortie,
    seg => seg
  );

    
end synthesis;

