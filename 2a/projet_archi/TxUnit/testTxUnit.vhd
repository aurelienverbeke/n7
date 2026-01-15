--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:09:49 10/31/2018
-- Design Name:   
-- Module Name:   testTxUnit.vhd
-- Project Name:  uart
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TxUnit
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY testTxUnit IS
END testTxUnit;

ARCHITECTURE behavior OF testTxUnit IS 

  -- Component Declaration for the Unit Under Test (UUT)

  COMPONENT TxUnit
  PORT(
        clk : IN  std_logic;
        reset : IN  std_logic;
        enable : IN  std_logic;
        ld : IN  std_logic;
        txd : OUT  std_logic;
        regE : OUT  std_logic;
        bufE : OUT  std_logic;
        data : IN  std_logic_vector(7 downto 0)
      );
  END COMPONENT;
  
  COMPONENT clkUnit
  PORT(
        clk : IN  std_logic;
        reset : IN  std_logic;
        enableTX : OUT  std_logic;
        enableRX : OUT  std_logic
      );
  END COMPONENT;	

  signal clk : std_logic := '0';
  signal reset : std_logic := '0';
  signal enableTx : std_logic := '0';
  signal enableRx : std_logic := '0';
  signal ld : std_logic := '0';
  signal data : std_logic_vector(7 downto 0) := (others => '0');

  signal txd : std_logic;
  signal regE : std_logic;
  signal bufE : std_logic;

  -- Clock period definitions
  constant clk_period : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test
  uut0: TxUnit PORT MAP (
        clk => clk,
        reset => reset,
        enable => enableTX,
        ld => ld,
        txd => txd,
        regE => regE,
        bufE => bufE,
        data => data
      );

  -- Instantiate the clkUnit
  clkUnit1: clkUnit PORT MAP (
        clk => clk,
        reset => reset,
        enableTX => enableTX,
        enableRX => enableRX
      );
    
  -- Clock process definitions
  clk_process :process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;


  -- Stimulus process
  stim_proc: process
  begin		
    -- maintien du reset durant 100 ns.
    wait for 100 ns;	
    reset <= '1';

    wait for 200 ns;

    -- l'émetteur est dispo ?
    if not (regE='1' and bufE='1') then
      wait until regE='1' and bufE='1';
    end if;

    -- si oui, on charge la donnée
    wait for clk_period;
    -- émission du caractère 0x55
    data <= "01010101";
    ld <= '1';

    -- on attend de voir que l'ordre d'émission
    -- a été bien pris en compte avant de rabaisser
    -- le signal ld
    if not (regE='1' and bufE='0') then
      wait until regE='1' and bufE='0';
    end if;
    wait for clk_period;
    ld <= '0';
    
    -- compléter avec des tests qui montrent que la prise en compte de la demande d'émission
    -- d'un autre caractère se fait lorsqu'on émet un caractère et ceci quelque soit
    -- l'étape d'émission

    wait for 200 ns;
    -- émission du caractère 0x45 durant l'emission du caractere 0x55
    data <= "01000101";
    ld <= '1';
    wait for clk_period;
    -- emission du caractere 0x50 juste apres l'information d'emission du caractere
    -- 0x45, elle ne sera pas prise en compte, le buffer de transmission etant deja
    -- rempli, la transmission de 0x45 par contre continuera.
    data <= "01010000";
    wait for clk_period;
    ld <= '0';

    -- emission du caractère 0xCC au moment où on libère le buffer
    -- qui sera pris en compte au top d'horloge suivant
    -- et on remplace aussitôt par undefined en laissant traîner un peu ld
    -- pour vérifier que c'est bien pris en compte
    wait until bufE='1';
    data <= "11001100";
    ld <= '1';
    wait for 2*clk_period;
    data <= "UUUUUUUU";
    wait for 2*clk_period;
    ld <= '0';

    -- emission du caractère 0xF0 au milieu d'une émission
    -- on remplace aussitôt par undefined
    -- pour vérifier que c'est bien pris en compte
    wait for 20 us;
    ld <= '1';
    data <= "11110000";
    wait for clk_period;
    ld <= '0';
    data <= "UUUUUUUU";


    -- on a alors :
      -- * emission de 0x55.
      -- * prise en compte de la demande d'emission de 0x45 car le buffer a ete libere.
      -- * demande d'emission de 0x50, non prise en compte car le buffer est plein a ce
      -- moment la.
      -- * prise en compte de la demande d'emission pour OxCC
      -- * prise en compte de la demande d'emission pour 0xF0
      -- fin de la transmission avex txd qui repart a 1.
    wait;
  end process;

END;
