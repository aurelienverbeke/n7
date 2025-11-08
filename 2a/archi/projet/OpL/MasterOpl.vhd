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
  type t_etat is (REPOS, ER_OCTET, ATTENTE_ER);

  signal etat : t_etat;
  signal octets_a_envoyer : t_buffer;
  signal octets_recus : t_buffer;
  signal attentes : t_attentes := (15, 3, 5);

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
            etat <= ER_OCTET;
            cpt_octet := N_OCTETS-1;
            cpt := attentes(cpt_octet);
          end if;

        when ER_OCTET =>
          if (cpt > 0) then
            -- attendre
            cpt := cpt - 1;
          else
            -- envoyer l'octet
            octet_a_envoyer <= octets_a_envoyer(cpt_octet);
            en_er_1octet <= '1';
            etat <= ATTENTE_ER;
          end if;
        
        when ATTENTE_ER =>
          -- on attend que le composant er_1octet ait fini de travailler
          en_er_1octet <= '0';
          -- on ajoute la condition sur en_er_1octet sinon
          -- on tombe au meme moment que le basculement de busy_er_1octet et on saute tout
          if (busy_er_1octet = '0' and en_er_1octet = '0') then
            octets_recus(cpt_octet) <= octet_recu;
            if (cpt_octet > 0) then
              -- il reste des octets a envoyer
              cpt_octet := cpt_octet - 1;
              cpt := attentes(cpt_octet);
              etat <= ER_OCTET;
            else
              -- on a envoyé tous les octets
              val_nand <= octets_recus(2);
              val_nor <= octets_recus(1);
              val_xor <= octet_recu;
              ss <= '1';
              busy <= '0';
              etat <= REPOS;
            end if;
          end if;
      end case;
    end if;
  end process;
  
end behavior;
