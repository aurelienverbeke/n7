library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity compteur16 is
  port (
    clk 	: in std_logic;
    enable 	: in std_logic;
    reset 	: in std_logic;
    RxD 	: in std_logic;
    tmpClk 	: out std_logic;
    tmpRxd 	: out std_logic);
end compteur16;

architecture behavioral of compteur16 is
  
  type t_etat is (REPOS, COMPTAGE);

  signal etat : t_etat := REPOS;
  signal tmpClk_i : std_logic;
  
  
begin

  tmpClk <= tmpClk_i;
  
  process (clk, reset) is

    variable compteur : natural;

  begin

    if (reset = '0') then
      tmpClk_i <= '1';
      etat <= REPOS;
      compteur := 8;
      tmpRxd <= 'U';
    elsif (rising_edge(clk)) then
      case etat is
        when REPOS =>
          if (enable = '1' and RxD = '0') then
            etat <= COMPTAGE;
          end if;
        when COMPTAGE =>
          if (tmpClk_i = '1') then
            tmpClk_i <= '0';
          end if;
          if (enable = '1') then
            compteur := compteur - 1;
            if (compteur = 0) then
              compteur := 16;
              if (tmpClk_i = '0') then
                tmpRxd <= RxD;
                tmpClk_i <= '1';
              end if;
            end if;
          end if;
      end case;
    end if;
  end process;
 
end behavioral;