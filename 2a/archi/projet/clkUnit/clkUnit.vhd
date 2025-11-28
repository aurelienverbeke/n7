library IEEE;
use IEEE.std_logic_1164.all;

entity clkUnit is
 port (
        clk, reset : in  std_logic;
        enableTX   : out std_logic;
        enableRX   : out std_logic
      );
end clkUnit;

architecture behavorial of clkUnit is

  component diviseurClk is
    generic(facteur : natural);
    port (
      clk, reset : in  std_logic;
      nclk       : out std_logic
    );
  end component;

begin

  diviseurClk_10 : diviseurClk generic map (10) port map (clk=>clk, reset=>reset, nclk=>enableTX);
  diviseurClk_160 : diviseurClk generic map (160) port map (clk=>clk, reset=>reset, nclk=>enableRX);

end behavorial;
