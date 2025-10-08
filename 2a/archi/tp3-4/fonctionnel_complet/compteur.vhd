----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.10.2025 14:25:45
-- Design Name: 
-- Module Name: compteur - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity compteur is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           cpt : out STD_LOGIC_VECTOR(3 downto 0);
           retenue : out STD_LOGIC);
end compteur;

architecture Behavioral of compteur is
begin
    process (clk, reset)
        variable cpt_aux : std_logic_vector(3 downto 0) := (others => '0');
    begin
        if(reset = '0') then
            cpt_aux := (others => '0');
            cpt <= cpt_aux;
            retenue <= '0';
        elsif(rising_edge(clk)) then
            cpt_aux := cpt_aux + 1;
            cpt <= cpt_aux;
            if (cpt_aux = "000") then
                retenue <= '1';
            else
                retenue <= '0';
            end if;
        end if;
    end process;
end Behavioral;
