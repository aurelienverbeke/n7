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

	-- rappel du (des) composant(s)
	-- À COMPLÉTER 
	entity dec7seg_full is
		Port ( v : in STD_LOGIC_MATRIX (7 downto 0)(7 downto 0);
			clk : in STD_LOGIC;
			reset : in STD_LOGIC;
			seg : out STD_LOGIC_VECTOR (7 downto 0);
			an : out STD_LOGIC_VECTOR (7 downto 0)
		);
	end dec7seg_full;

begin

	-- valeurs des sorties (à modifier)

	-- convention afficheur 7 segments 0 => allumé, 1 => éteint
	-- seg <= (others => '1');
	-- aucun afficheur sélectionné
	-- an(7 downto 0) <= (others => '1');
	-- 16 leds éteintes
	led(15 downto 0) <= (others => '0');

	-- connexion du (des) composant(s) avec les ports de la carte
	dec7seg_full_inst : dec7seg_full port map (v=>, clk=>clk, reset=>reset, seg=>seg, an=>an)
		
end synthesis;
