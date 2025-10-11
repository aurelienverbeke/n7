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
	component dec7seg_full is
		Port ( v0 : in STD_LOGIC_VECTOR (3 downto 0);
			v1 : in STD_LOGIC_VECTOR (3 downto 0);
			v2 : in STD_LOGIC_VECTOR (3 downto 0);
			v3 : in STD_LOGIC_VECTOR (3 downto 0);
			v4 : in STD_LOGIC_VECTOR (3 downto 0);
			v5 : in STD_LOGIC_VECTOR (3 downto 0);
			v6 : in STD_LOGIC_VECTOR (3 downto 0);
			v7 : in STD_LOGIC_VECTOR (3 downto 0);
			clk : in STD_LOGIC;
			reset : in STD_LOGIC;
			seg : out STD_LOGIC_VECTOR (7 downto 0);
			an : out STD_LOGIC_VECTOR (7 downto 0)
		);
	end component;

	entity additionneur_4bits is
		port(
			A, B : in std_logic_vector(3 downto 0);
			Cin : in std_logic;
			S : out std_logic_vector(3 downto 0);
			Cout : out std_logic
		);
	end additionneur_4bits;

	signal somme : std_logic_vector(3 downto 0);
	signal retenue_out : std_logic;

begin

	-- valeurs des sorties (à modifier)

	-- convention afficheur 7 segments 0 => allumé, 1 => éteint
	-- seg <= (others => '1');
	-- aucun afficheur sélectionné
	-- an(7 downto 0) <= (others => '1');
	-- 16 leds éteintes
	led(15 downto 0) <= (others => '0');

	-- connexion du (des) composant(s) avec les ports de la carte
	dec7seg_full_inst : dec7seg_full port map (v0=>(0=>retenue_out, others=>'0'), v1=>somme, v2=>(0=>sw(8), others=>'0'), v3=>sw(3 downto 0), v4=>sw(7 downto 4), v5=>"0000", v6=>"0000", v7=>"0000", clk=>clk, reset=>reset, seg=>seg, an=>an)
	additionneur_inst : additionneur_4bits port map (A=>sw(7 downto 4), B=>(3 downto 0), Cin=>sw(8), S=>somme, Cout=>retenue_out);
		
end synthesis;
