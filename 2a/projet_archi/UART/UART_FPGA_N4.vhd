library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity UART_FPGA_N4 is
  port(
    -- bouton noir central qui sert pour le reset
    btnC : in std_logic;
    -- leds
    led : out std_logic_vector(5 downto 0);
    -- horloge
    mclk : in std_logic;
    -- ligne série (à rajouter)
    RxD : in std_logic;
    TxD : out std_logic);
end UART_FPGA_N4;

architecture synthesis of UART_FPGA_N4 is

  -- rappel du (des) composant(s)
  component diviseurClk is
    generic(facteur : natural);
    port(
      clk, reset : in  std_logic;
      nclk       : out std_logic);
  end component;

  component echoUnit is
    port (
      clk, reset : in  std_logic;
      cs, rd, wr : out  std_logic;
      IntR       : in std_logic;         -- interruption de réception
      IntT       : in std_logic;         -- interruption d'émission
      addr       : out  std_logic_vector(1 downto 0);
      data_in    : in  std_logic_vector(7 downto 0);
      data_out   : out std_logic_vector(7 downto 0));
  end component;

  component UARTunit is
    port (
      clk, reset : in  std_logic;
      cs, rd, wr : in  std_logic;
      RxD        : in  std_logic;
      TxD        : out std_logic;
      IntR, IntT : out std_logic;         
      addr       : in  std_logic_vector(1 downto 0);
      data_in    : in  std_logic_vector(7 downto 0);
      data_out   : out std_logic_vector(7 downto 0));
  end component;

  signal resetBtn : std_logic;
  signal clk : std_logic;
  signal cs, rd, wr, IntR, IntT : std_logic;
  signal addr : std_logic_vector(1 downto 0);
  signal echoToUART, uartToEcho : std_logic_vector(7 downto 0);

begin

    resetBtn <= not btnC;

  -- connexion du (des) composant(s) avec les ports de la carte 
  uartInst : UARTunit
    port map (
      clk => clk,
      reset => resetBtn,
      cs => cs,
      rd => rd,
      wr => wr,
      RxD => RxD,
      TxD => TxD,
      IntR => IntR,
      IntT => IntT,
      addr => addr,
      data_in => echoToUART,
      data_out => uartToEcho
    );

    echoInst : echoUnit
      port map (
        clk => clk,
        reset => resetBtn,
        cs => cs,
        rd => rd,
        wr => wr,
        IntR => IntR,
        IntT => IntT,
        addr => addr,
        data_in => uartToEcho,
        data_out => echoToUART
      );

    diviseurClkInst : diviseurClk
      generic map (64)
      port map (
        clk => mclk,
        reset => resetBtn,
        nclk => clk
      );

end synthesis;
