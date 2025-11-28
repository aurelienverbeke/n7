library IEEE;
use IEEE.std_logic_1164.all;

entity TxUnit is
  port (
    clk, reset : in std_logic;
    enable     : in std_logic;
    ld         : in std_logic;
    txd        : out std_logic;
    regE       : out std_logic;
    bufE       : out std_logic;
    data       : in std_logic_vector(7 downto 0));
end TxUnit;

architecture behavorial of TxUnit is

  type t_etat is (INIT, CHARGEMENT_BUFFER, CHARGEMENT_REGISTRE, ENVOI, FIN);

  signal etat : t_etat;
  signal BufferT : std_logic_vector (7 downto 0);
  signal RegisterT : std_logic_vector (7 downto 0);

begin

  process (reset, clk)

    variable cpt : natural;

  begin
    -- reset
    if (rst = '0') then
      txd <= '1';
      bufE <= '1';
      regE <= '1';
      etat <= INIT;

    -- horloge montante
    elsif (rising_edge(clk)) then
      case etat is
        when INIT =>
          if (ld = '1') then
            BufferT <= data;
            bufE <= '0';
            etat <= CHARGEMENT_BUFFER;
          end if;
        
        when CHARGEMENT_BUFFER =>
          RegisterT <= BufferT;
          bufE <= '1';
          regE <= '0';
          etat <= CHARGEMENT_REGISTRE;
        
        when CHARGEMENT_REGISTRE =>
          if (enable = '1') then
            txd <= '0';
            cpt := 7;
            etat <= ENVOI;
          end if;
        
        when ENVOI =>
          if (enable = '1') then
              txd <= RegisterT(cpt);
            if (cpt > 0) then
              cpt := cpt - 1;
            else
              etat <= FIN;
            end if;
          end if;
        
        when FIN =>
          if (enable = '1') then
            txd <= '1';
            regE < '1';
            if (bufE = '0') then
              etat <= CHARGEMENT_BUFFER;
            else
              etat <= INIT;
            end if;
          end if;
      end case;
    end if;
  end process

end behavorial;
