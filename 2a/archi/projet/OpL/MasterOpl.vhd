library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MasterOpl is
  port ( rst : in std_logic;
         clk : in std_logic;
         en : in std_logic;
         v1 : in std_logic_vector (7 downto 0);
         v2 : in std_logic_vector(7 downto 0);
         miso : in std_logic;
         ss   : out std_logic;
         sclk : out std_logic;
         mosi : out std_logic;
         val_nand : out std_logic_vector (7 downto 0);
         val_nor : out std_logic_vector (7 downto 0);
         val_xor : out std_logic_vector (7 downto 0);
         busy : out std_logic);
end MasterOpl;

architecture behavior of MasterOpl is

  component er_1octet is
  port ( rst : in std_logic ;
         clk : in std_logic ;
         en : in std_logic ;
         din : in std_logic_vector (7 downto 0) ;
         miso : in std_logic ;
         sclk : out std_logic ;
         mosi : out std_logic ;
         dout : out std_logic_vector (7 downto 0) ;
         busy : out std_logic);
  end component;

  constant N_OCTETS : natural := 3;

  type t_buffer is array (N_OCTETS-1 downto 0) of std_logic_vector(7 downto 0);
  type t_attentes is array (N_OCTETS-1 downto 0) of natural;
  type t_etat is (REPOS, ER_1OCTET);

  signal etat : t_etat;
  signal octets_a_envoyer : t_buffer;
  signal octets_recus : t_buffer;
  signal attentes : t_attentes;

  signal en_er_1octet : std_logic;
  signal busy_er_1octet : std_logic;
  signal octet_a_envoyer : std_logic_vector (7 downto 0);
  signal octet_recu : std_logic_vector (7 downto 0);

begin

  inst_er_1octet : er_1octet port map (rst => rst,
                                        clk => clk,
                                        en => en_er_1octet,
                                        din => octet_a_envoyer,
                                        miso => miso,
                                        sclk => sclk,
                                        mosi => mosi,
                                        dout => octet_recu,
                                        busy => busy_er_1octet);

  process(rst, clk)
    variable cpt : natural;
    variable cpt_octet : natural;
  begin
    -- reset
    if (rst = '0') then
      etat <= REPOS;
      busy <= '0';
      en_er_1octet <= '0';
      ss <= '1';
      attentes <= (15, 3, 5);
    
    -- horloge montante
    elsif (rising_edge(clk)) then
      case etat is
        when REPOS =>
          if (en = '1') then
            busy <= '1';
            octets_a_envoyer(2) <= v1;
            octets_a_envoyer(1) <= v2;
            octets_a_envoyer(0) <= (others => '0');
            ss <= '0';
            etat <= ER_1OCTET;
            cpt_octet := N_OCTETS;
            cpt := attentes(cpt_octet);
          end if;

        when ER_1OCTET =>
          if (cpt_octet > 0) then
            if (cpt > 0) then
              -- attendre
              cpt := cpt - 1;
            else
              -- envoyer l'octet
              

              -- avancer à l'octet suivant
              cpt_octet := cpt_octet - 1;
              cpt := attentes(cpt_octet);
            end if
          else
            -- envoyer les octets
            etat <= REPOS
          end if;
      end case;
    end if;
  end process;
  
end behavior;
