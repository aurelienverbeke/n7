library IEEE;
use IEEE.std_logic_1164.all;

entity diviseurClk is
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
end diviseurClk;

architecture behavioural of diviseurClk is
begin
    process (clk, reset)
        variable cpt : natural := 0;
    begin
        if (reset = '0')
        then
            cpt := 0;
            nclk <= '0';
        elsif (rising_edge(clk)) then
            cpt := cpt + 1;
            if (cpt = facteur) then
                cpt := 0;
                nclk <= '1';
            elsif (cpt = 1) then
                nclk <= '0';
            end if;
        end if;
    end process;
end behavioural;
