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

ENTITY testRxUnit IS
END testRxUnit;

ARCHITECTURE behavior OF testRxUnit IS 

  -- Component Declaration for the Unit Under Test (UUT)

  COMPONENT RxUnit
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         enable : IN  std_logic;
         read : IN  std_logic;
         rxd : IN  std_logic;
         data : OUT  std_logic_vector(7 downto 0);
         Ferr : OUT  std_logic;
         OErr : OUT  std_logic;
         DRdy : OUT  std_logic
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
  signal read : std_logic := '0';
  signal data : std_logic_vector(7 downto 0) := (others => '0');

  signal rxd : std_logic := '1';
  signal FErr : std_logic := '0';
  signal OErr : std_logic := '0';
  signal DRdy : std_logic := '0';

  -- Clock period definitions
  constant clk_period : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test
  uut0: RxUnit PORT MAP (
        clk => clk,
        reset => reset,
        enable => enableRX,
        read => read,
        rxd => rxd,
        data => data,
        FErr => FErr,
        OErr => OErr,
        DRdy => DRdy
      );

  -- Instantiate the clkUnit
  clkUnit1: clkUnit PORT MAP (
        clk => clk,
        reset => reset,
        enableTX => enableTX,
        enableRX => enableRX
      );
    
  -- Clock process definitions
  clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;


  -- Stimulus process
  stim_proc : process
  begin		
    -- maintien du reset durant 100 ns.
    wait for 100 ns;	
    reset <= '1';

    wait for 200 ns;

    -- bit de debut '0'
    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '0';
    wait for 10 * clk_period;

    -- envoi de 01010101
    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '0';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '1';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '0';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '1';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '0';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '1';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '0';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '1';
    wait for 10 * clk_period;
    
    -- bit de stop
    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '1';

    -- Attente pour le read a 1
    wait for 80 * clk_period;
    if (not (enableRX = '1')) then
      wait until enableRX = '1';
    end if;
    wait for 2 * clk_period;

    -- reception
    read <= '1';
    wait for 5 * clk_period;
    read <= '0';

    -- maintien du reset durant 100 ns.
    wait for 100 ns;	
    reset <= '1';

    wait for 200 ns;

    -- bit de debut '0'
    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '0';
    wait for 10 * clk_period;

    -- envoi de 01010101
    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '0';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '1';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '0';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '1';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '0';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '1';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '0';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '1';
    wait for 10 * clk_period;
    
    -- bit de stop faux
    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '0';

    -- Attente pour le read a 1
    wait for 80 * clk_period;
    if (not (enableRX = '1')) then
      wait until enableRX = '1';
    end if;
    wait for 2 * clk_period;

    -- reception
    read <= '1';
    wait for 5 * clk_period;
    read <= '0';

    -- maintien du reset durant 100 ns.
    wait for 100 ns;	
    reset <= '1';

    wait for 200 ns;

    -- bit de debut '0'
    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '0';
    wait for 10 * clk_period;

    -- envoi de 01010101
    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '0';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '1';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '0';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '1';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '0';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '1';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '0';
    wait for 10 * clk_period;

    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '1';
    wait for 10 * clk_period;
    
    -- bit de stop
    if (not (enableTX = '1')) then
      wait until enableTX = '1';
    end if;
    rxd <= '1';

    -- Attente pour le read qui n'arrivera jamais
    wait for 80 * clk_period;
    if (not (enableRX = '1')) then
      wait until enableRX = '1';
    end if;
    wait for 2 * clk_period;

    wait;
  end process;

END;
