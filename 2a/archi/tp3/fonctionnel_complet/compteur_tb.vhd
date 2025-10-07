library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity compteur_tb is
end compteur_tb;

architecture Behavioral of compteur_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT compteur is
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               cpt : out STD_LOGIC_VECTOR(3 downto 0);
               retenue : out STD_LOGIC);
    end COMPONENT;
    
    -- Inputs
    signal reset : STD_LOGIC;

    -- Outputs
    signal cpt_out : STD_LOGIC_VECTOR(3 downto 0);
    signal retenue_out : STD_LOGIC;

    -- Clock period definition
    CONSTANT clk_period : time := 10 ns;
    signal clk : STD_LOGIC;
begin

    -- Instantiate the Unit Under Test (UUT)
    compteur_inst : compteur PORT MAP (clk=>clk, reset=>reset, cpt=>cpt_out, retenue=>retenue_out);
    
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
