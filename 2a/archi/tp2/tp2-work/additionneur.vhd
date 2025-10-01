library IEEE;
use IEEE.std_logic_1164.all;

-- interface du composant additionneur
entity additionneur is
  port(
       X, Y, Cin    : in std_logic;
       S, Cout    : out std_logic
      );
end additionneur;


architecture vue_flot of additionneur is

  constant delay : time := 2 ns;

  -- signal local
  signal i : std_logic;
  
  begin

    -- 3 équations logiques qui calculent i, Cout et S ==
    -- 3 instructions concurrentes
    S <= i xor Cin after delay;
    Cout <= (X and Y) or (i and Cin) after 2*delay;
    i <= X xor Y after delay;
  end vue_flot;