library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity er_1octet is
  port ( rst : in std_logic ;
         clk : in std_logic ;
         en : in std_logic ;
         din : in std_logic_vector (7 downto 0) ;
         miso : in std_logic ;
         sclk : out std_logic ;
         mosi : out std_logic ;
         dout : out std_logic_vector (7 downto 0) ;
         busy : out std_logic);
end er_1octet;

architecture behavioral_3 of er_1octet is
  type t_etat is (REPOS, RECEPTION, ENVOI);
  signal registre : std_logic_vector (7 downto 0);
  signal etat : t_etat;
begin
  process(rst, clk)
    variable cpt : natural;
  begin
    -- reset
    if (rst = '0') then
      etat <= REPOS;
      sclk <= '1';
      busy <= '0';

    -- horloge montante
    elsif (rising_edge(clk)) then
      case etat is
        when REPOS =>
          if (en = '1') then
            cpt := 7;
            busy <= '1';
            registre <= din;
            sclk <= '0';
            mosi <= din(cpt);
            etat <= RECEPTION;
          end if;

        when RECEPTION =>
          sclk <= '1';
          if (cpt > 0) then
            registre(cpt) <= miso;
            cpt := cpt - 1;
            etat <= ENVOI;
          else
            busy <= '0';
            dout(7 downto 1) <= registre(7 downto 1);
            dout(0) <= miso;
            etat <= REPOS;
          end if;

        when ENVOI =>
          sclk <= '0';
          mosi <= registre(cpt);
          etat <= RECEPTION;
      end case;
    end if;
  end process;
end behavioral_3;
