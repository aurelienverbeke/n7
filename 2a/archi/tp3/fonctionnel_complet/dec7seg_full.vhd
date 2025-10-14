library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;



-- type std_logic_matrix
--package my_types is
--end package;

--package body my_types is
--end package body;

--use work.my_types.all;



entity dec7seg_full is
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
end dec7seg_full;



architecture Structural of dec7seg_full is
	component diviseurClk is
		-- facteur : ratio entre la fréquence de l'horloge origine à 100 MHz
		--		   et celle de l'horloge générée
		--  ex : 100 MHz -> 1Hz : facteur = 100 000 000
		--  ex : 100 MHz -> 1kHz : facteur = 100 000
		generic(facteur : natural);
		port (
			clk   : in std_logic;
			reset : in  std_logic;
			nclk  : out std_logic
		);
	end component;

	component compteur is
		generic(size : natural := 4);
		Port ( clk : in STD_LOGIC;
			reset : in STD_LOGIC;
			cpt : out STD_LOGIC_VECTOR(size-1 downto 0)
		);
	end component;

	component decalage is
		-- v contient un seul '0' (utilisation : anode == segment allumé).
		-- à chaque front montant de l'horloge, la valeur de v est décalée cycliquement
		-- d'une position vers la gauche
		-- "11101111" -> "11011111"
		-- "01111111" -> "11111110"
		port ( clk : in std_logic;
			reset : in std_logic;
			v : out std_logic_vector (7 downto 0)
		);
	end component;

	component dec7seg is
		port (
			v : in std_logic_vector(3 downto 0);
			seg : out std_logic_vector (7 downto 0)
		);
	end component;

	component mux8_to_1 is
		generic(size : natural := 4);
		port (e0, e1, e2, e3, e4, e5, e6, e7 : in  std_logic_vector (size-1 downto 0);
			sel : in  std_logic_vector (2 downto 0);
			s : out  std_logic_vector (size-1 downto 0)
		);
	end component;

	signal nclk : std_logic;
	signal cpt : std_logic_vector(2 downto 0);
	signal internal_v : std_logic_vector(3 downto 0);

begin

	diviseurClk_inst : diviseurClk generic map (100000) port map (clk=>clk, reset=>reset, nclk=>nclk);
	compteur_inst : compteur generic map (3) port map (clk=>nclk, reset=>reset, cpt=>cpt);
	decalage_inst : decalage port map (clk=>nclk, reset=>reset, v=>an);
	mux8_to_1_inst : mux8_to_1 generic map (4) port map (e0=>v0, e1=>v1, e2=>v2, e3=>v3, e4=>v4, e5=>v5, e6=>v6, e7=>v7, sel=>cpt, s=>internal_v);
	dec7seg_inst : dec7seg port map (v=>internal_v, seg=>seg);

end Structural;



architecture Fsm of dec7seg_full is
	
	component diviseurClk is
		-- facteur : ratio entre la fréquence de l'horloge origine à 100 MHz
		--		   et celle de l'horloge générée
		--  ex : 100 MHz -> 1Hz : facteur = 100 000 000
		--  ex : 100 MHz -> 1kHz : facteur = 100 000
		generic(facteur : natural);
		port (
			clk   : in std_logic;
			reset : in  std_logic;
			nclk  : out std_logic
		);
	end component;

	component dec7seg is
		port (
			v : in std_logic_vector(3 downto 0);
			seg : out std_logic_vector (7 downto 0)
		);
	end component;



	type t_etat is (etat0, etat1, etat2, etat3, etat4, etat5, etat6, etat7);

	signal etat : t_etat;
	signal nclk : std_logic;
	signal internal_v : std_logic_vector(3 downto 0);

begin

	process (clk, reset) is
	begin

		if (reset = '0') then
			internal_v <= (others => '1');
			an <= (others => '1');
			etat <= etat0;
		elsif (rising_edge(nclk)) then
			case etat is
				when etat0 =>
					internal_v <= v0;
					an <= (0 => '0', others => '1');
					etat <= etat1;
				when etat1 =>
					internal_v <= v1;
					an <= (1 => '0', others => '1');
					etat <= etat2;
				when etat2 =>
					internal_v <= v2;
					an <= (2 => '0', others => '1');
					etat <= etat3;
				when etat3 =>
					internal_v <= v3;
					an <= (3 => '0', others => '1');
					etat <= etat4;
				when etat4 =>
					internal_v <= v4;
					an <= (4 => '0', others => '1');
					etat <= etat5;
				when etat5 =>
					internal_v <= v5;
					an <= (5 => '0', others => '1');
					etat <= etat6;
				when etat6 =>
					internal_v <= v6;
					an <= (6 => '0', others => '1');
					etat <= etat7;
				when etat7 =>
					internal_v <= v7;
					an <= (7 => '0', others => '1');
					etat <= etat0;
			end case;
		end if;
	end process;
	
	diviseurClk_inst : diviseurClk generic map (100000) port map (clk=>clk, reset=>reset, nclk=>nclk);
	dec7seg_inst : dec7seg port map (v=>internal_v, seg=>seg);

end Fsm;
