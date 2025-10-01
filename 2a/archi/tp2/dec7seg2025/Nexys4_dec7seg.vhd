library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Nexys4_dec7seg is
  port (
    -- les 4 switchs utilisés
    sw : in std_logic_vector (3 downto 0);
    -- les anodes pour sélectionner l'afficheur 7 segments
    an : out std_logic_vector (7 downto 0);
    -- afficheur 7 segments (7 segments + point décimal)
    seg : out std_logic_vector (7 downto 0)
  );
end Nexys4_dec7seg;

architecture synthesis of Nexys4_dec7seg is

  -- rappel du (des) composant(s)
	COMPONENT dec7seg
	PORT(
		v : IN std_logic_vector(3 downto 0);          
		seg : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

begin

  -- premier 7-segments sélectionné
  an(7 downto 0) <= (0 => '0', others => '1');

  Inst_dec7seg: dec7seg PORT MAP(
		v => sw,
		seg => seg
	);

end synthesis;
