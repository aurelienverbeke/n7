library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity compteur_tb is
end compteur_tb;

architecture Behavioral of compteur_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    
    -- Inputs

    -- Outputs

    -- Clock period definition
    CONSTANT clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    
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

      wait for 100 ns;	
      
      -- release reset
      
      -- insert stimulus

      wait;
   end process;

end Behavioral;
