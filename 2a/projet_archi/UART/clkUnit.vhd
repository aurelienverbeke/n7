library IEEE;
use IEEE.std_logic_1164.all;

entity clkUnit is
 port(
    clk, reset : in  std_logic;
    enableTX   : out std_logic;
    enableRX   : out std_logic);
end clkUnit;

architecture behavorial of clkUnit is

  component diviseurClk is
    generic(facteur : natural);
    port(
      clk, reset : in  std_logic;
      nclk       : out std_logic);
  end component;

  signal    clkRX : std_logic;
  signal    clkTX : std_logic;

begin

  diviseurClkRx : diviseurClk
    generic map (10)
    port map(clk => clk, reset => reset, nclk => enableRX);
  
  diviseurClkTx : diviseurClk
    generic map (160)
    port map(clk => clk, reset => reset, nclk => enableTX);

end behavorial;
