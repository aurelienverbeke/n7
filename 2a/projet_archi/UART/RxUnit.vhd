library IEEE;
use IEEE.std_logic_1164.all;

entity RxUnit is
  port (
    clk, reset       : in  std_logic;
    enable           : in  std_logic;
    read             : in  std_logic;
    rxd              : in  std_logic;
    data             : out std_logic_vector(7 downto 0);
    Ferr, OErr, DRdy : out std_logic);
end RxUnit;

architecture behavorial of RxUnit is

  signal tmpClk, tmpRxd : std_logic;
  
  component compteur16 is
  port (
    clk 	  : in std_logic;
    enable 	: in std_logic;
    reset 	: in std_logic;
    RxD 	  : in std_logic;
    tmpClk 	: out std_logic;
    tmpRxd 	: out std_logic);
  end component;
  
  component controleReception is
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
  end component;

begin

  compteur16Inst : compteur16
    port map(
      clk => clk,
      enable => enable,
      reset => reset,
      RxD => rxd,
      tmpClk => tmpClk,
      tmpRxd => tmpRxd);
  
  controleReceptionInst : controleReception
    port map(
      clk => clk,
      reset => reset,
      read => read,
      tmpClk => tmpClk,
      tmpRxd => tmpRxd,
      FErr => FErr,
      OErr => OErr,
      DRdy => DRdy,
      data => data);

end behavorial;
