library IEEE;
use IEEE.std_logic_1164.all;

entity TxUnit is
  port(
    clk, reset : in std_logic;
    enable     : in std_logic;
    ld         : in std_logic;
    txd        : out std_logic;
    regE       : out std_logic;
    bufE       : out std_logic;
    data       : in std_logic_vector(7 downto 0));
end TxUnit;

architecture behavorial of TxUnit is

  -- Les differents etats de notre unite de transmission.
  type states is (IDLE, INIT, EMIT);
  -- L'etat actuel de notre unite de transmission.
  signal state : states;
  -- Un signal interne representatant le bufE out.
  signal bufE_i : std_logic;

begin

  bufE <= bufE_i;

  process(clk, reset)

  -- Le buffer de donnees entrantes.
  variable bufferT    : std_logic_vector(8 downto 0);
  -- Le registre de donnees de transmission.
  variable registerT  : std_logic_vector(8 downto 0);
  --  Le compteur d'envoi de l'information.
  variable compteur   : natural;

  begin
    if (reset = '0') then
      txd       <= '1';
      bufE_i    <= '1';
      regE      <= '1';
      registerT := (others => 'U');
      bufferT   := (others => 'U');
      compteur  := 9;
      state     <= IDLE;
    elsif (rising_edge(clk)) then
      case state is
        when IDLE =>
          -- On initialise la transmission.
          if (ld = '1') then
            bufferT := '0' & data;
            bufE_i  <= '0';
            state   <= INIT;
          end if;
        when INIT =>
          -- Etat intermediaire de recuperation/preparation des donnees.
          compteur  := 9;
          registerT := bufferT;
          bufE_i    <= '1';
          regE      <= '0';
          state     <= EMIT;
        when EMIT =>
          -- A chaque top de clk, on regarde si on recoit un autre ordre de
          -- chargement de buffer de transmission.
          if (ld = '1' and bufE_i = '1') then
            bufferT := '0' & data;
            bufE_i  <= '0';
          end if;

          -- Ordre de transmission.
          if (enable = '1') then
            if (compteur > 0) then
              txd      <= registerT(compteur - 1);
              compteur := compteur - 1;
            else
              regE     <= '1';
              txd      <= '1';
              if (bufE_i = '1') then
                state <= IDLE;
              else
                state <= INIT;
              end if;
            end if;
          end if;
        end case;
    end if;
  end process;

end behavorial;
