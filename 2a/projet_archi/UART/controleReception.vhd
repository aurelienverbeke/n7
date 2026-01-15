library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity controleReception is
  port (
    clk 		: in std_logic;
    reset 	: in std_logic;
    read 		: in std_logic;
    tmpClk 	: in std_logic;
    tmpRxd 	: in std_logic;
    FErr 		: out std_logic;
    OErr 		: out std_logic;
    DRdy 		: out std_logic;
    data 		: out std_logic_vector(7 downto 0));
end controleReception;

architecture behavioral of controleReception is

  signal buf : std_logic_vector(8 downto 0) := (others => 'U');

  type t_etat is (REPOS, RECEPTION, ATTENTE);
  signal etat : t_etat := REPOS;
  
begin
    
    process (clk, reset) is

      variable compteur : natural := 9;
      variable compteur_read : natural := 5;

    begin
      
      if (reset = '0') then
        DRdy <= '0';
        FErr <= '0';
        OErr <= '0';
        compteur := 8;
        compteur_read := 5;
        data <= (others => '0');
        etat <= REPOS;
      elsif (rising_edge(clk)) then
        case etat is
          when REPOS =>
          if (tmpClk = '1' and tmpRxd = '0') then
              data <= (others => '0');
              DRdy <= '0';
              FErr <= '0';
              OErr <= '0';
              etat <= RECEPTION;
              compteur := 8;
            end if;
          when RECEPTION =>
            -- donnée positionnée sur tmpRxd au front montant de tmpClk
            if (tmpClk = '1') then
              -- on la lit
              buf(compteur) <= tmpRxd;
              if (compteur = 0) then
                -- on est sur le bit de stop
                if (tmpRxd = '1') then
                  -- bit de stop correct
                  data <= buf(8 downto 1);
                  compteur_read := 5;
                  DRdy <= '1';
                  FErr <= '0';
                  OErr <= '0';
                  etat <= ATTENTE;
                else
                  -- bit de stop incorrect
                  FErr <= '1';
                  etat <= REPOS;
                end if;
              else
                -- on est sur un autre bit : start ou donnée
                compteur := compteur - 1;
              end if;
            end if;
          when ATTENTE =>
            compteur_read := compteur_read - 1;
            if (compteur_read = 0) then
              OErr <= '1';
              DRdy <= '0';
              etat <= REPOS;
              buf <= (others => '0');
            elsif (read = '1') then
              DRdy <= '0';
              etat <= REPOS;
              buf <= (others => '0');
            end if;
        end case;
      end if;
    end process;
end behavioral;