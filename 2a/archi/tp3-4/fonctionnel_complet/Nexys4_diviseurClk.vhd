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
	component diviseurClk is
		-- facteur : ratio entre la fréquence de l'horloge origine à 100 MHz
		-- et celle de l'horloge générée
		-- ex : 100 MHz -> 1Hz : facteur = 100 000 000
		-- ex : 100 MHz -> 1kHz : facteur = 100 000
		generic(facteur : natural);
		port (
			clk : in std_logic;
			reset : in std_logic;
			nclk : out std_logic
		);
	end component;

	COMPONENT compteur is
		Port ( clk : in STD_LOGIC;
			reset : in STD_LOGIC;
			cpt : out STD_LOGIC_VECTOR(3 downto 0);
			retenue : out STD_LOGIC
		);
	end COMPONENT;

	component dec7seg is
		port (
			v : in std_logic_vector(3 downto 0);
			seg : out std_logic_vector (7 downto 0)
		);
	end component;

	signal internal_clk : STD_LOGIC;
	signal cpt : STD_LOGIC_VECTOR(3 downto 0);

begin

	-- valeurs des sorties (à modifier)
	-- convention afficheur 7 segments 0 => allumé, 1 => éteint
	-- seg <= (others => '1');
	-- aucun afficheur sélectionné
	an(7 downto 0) <= (0 => '0', others => '1');
	-- 16 leds éteintes
	led(15 downto 0) <= (others => '0');

	-- connexion du (des) composant(s) avec les ports de la carte
	compteur_inst : compteur port map (clk=>internal_clk, reset=>sw(0), cpt=>cpt, retenue=>seg(7));
	diviseurClk_inst : diviseurClk generic map (100000000) port map (clk=>mclk, reset=>sw(0), nclk=>internal_clk);
	dec7seg_inst : dec7seg port map (v=>cpt, seg=>seg);
		
end synthesis;

