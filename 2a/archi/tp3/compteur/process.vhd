-- ceci est le code du process permettant de faire évoluer le signal cpt de 0 à F indéfiniment
-- il figure dans le cours et dans le TD 2 consacré aux compteurs 

process (clk, reset)
    
    variable cpt_aux : std_logic_vector(3 downto 0) := (others => '0');
  
  begin
  
    if(reset = '0') then
      cpt_aux := (others => '0');
      cpt <= cpt_aux;
    elsif(rising_edge(clk)) then
      cpt_aux := cpt_aux + 1;
      cpt <= cpt_aux;
    end if;
  
  end process;
