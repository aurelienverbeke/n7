library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity diviseurClk_tb is
end diviseurClk_tb;

architecture Behavioral of diviseurClk_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component diviseurClk is
      -- facteur : ratio entre la fréquence de l'horloge origine à 100 MHz
      --           et celle de l'horloge générée
      --  ex : 100 MHz -> 1Hz : facteur = 100 000 000
      --  ex : 100 MHz -> 1kHz : facteur = 100 000
      generic(facteur : natural);
      port (
            clk   : in std_logic;
            reset : in  std_logic;
            nclk  : out std_logic
           );
    end component;
    
    -- Inputs
    signal reset : STD_LOGIC;

    -- Outputs
    signal nclk_out : STD_LOGIC;

    -- Clock period definition
    CONSTANT clk_period : time := 10 ns;
    signal clk : STD_LOGIC;

begin

    -- Instantiate the Unit Under Test (UUT)
    diviseurClk_inst : diviseurClk
        generic map (10)
        port map (clk=>clk, reset=>reset, nclk=>nclk_out);
    
    -- Clock process
    clk_process : process  
    begin  
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;	
    end process;
    
    -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      reset <= '0';
      wait for 100 ns;	
      
      -- release reset
      reset <= '1';
      
      -- insert stimulus

      wait;
   end process;

end Behavioral;
