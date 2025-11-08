library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Nexys4Joystick is
  port (
    -- les 16 switchs
    swt : in std_logic_vector (15 downto 0);

    -- les 5 boutons noirs
    btnC, btnU, btnL, btnR, btnD : in std_logic;

    -- horloge
    -- 100 MHz
    mclk : in std_logic;

    -- les 16 leds
    led : out std_logic_vector (15 downto 0);

    -- les anodes pour sélectionner les afficheurs 7 segments à utiliser
    an : out std_logic_vector (7 downto 0);

    -- valeur affichée sur les 7 segments (point décimal compris, segment 7)
    ssg : out std_logic_vector (7 downto 0);

    -- 4 ports PMOD
    miso : in std_logic;
    ss, sclk, mosi : out std_logic
  );
end Nexys4Joystick;

architecture synthesis of Nexys4Joystick is

  component diviseurClk is
    generic(facteur : natural);
    port (
      clk, reset : in  std_logic;
      nclk       : out std_logic);
  end component;

  component All7Segments is
    Port ( clk : in  std_logic;
           reset : in std_logic;
           e0 : in std_logic_vector (3 downto 0);
           e1 : in std_logic_vector (3 downto 0);
           e2 : in std_logic_vector (3 downto 0);
           e3 : in std_logic_vector (3 downto 0);
           e4 : in std_logic_vector (3 downto 0);
           e5 : in std_logic_vector (3 downto 0);
           e6 : in std_logic_vector (3 downto 0);
           e7 : in std_logic_vector (3 downto 0);
           an : out std_logic_vector (7 downto 0);
           ssg : out std_logic_vector (7 downto 0));
  end component;

  component MasterJoystick is
    port ( rst : in std_logic;
           clk : in std_logic;
           ledJoystick1 : in std_logic;
           ledJoystick2 : in std_logic;
           miso : in std_logic;
           mosi : out std_logic;
           ss   : out std_logic;
           sclk : out std_logic;
           xJoystick : out std_logic_vector (9 downto 0);
           yJoystick : out std_logic_vector (9 downto 0);
           boutonJoystick1 : out std_logic;
           boutonJoystick2 : out std_logic;
           boutonJoystick3 : out std_logic);
  end component;

  signal clk_1mhz : std_logic;
  signal master_rst : std_logic;

  signal xJoystick : std_logic_vector (9 downto 0);
  signal yJoystick : std_logic_vector (9 downto 0);

  signal digit3xJoystick : std_logic_vector (3 downto 0);
  signal digit3yJoystick : std_logic_vector (3 downto 0);

begin

  master_rst <= '0' when (btnC = '1') else '1';
  digit3xJoystick <= "00" & xJoystick(9 downto 8);
  digit3yJoystick <= "00" & yJoystick(9 downto 8);
  

  inst_diviseurClk : diviseurClk generic map (100) port map (clk=>mclk, reset=>master_rst, nclk=>clk_1mhz);

  inst_MasterJoystick : MasterJoystick port map (rst => master_rst,
                                                  clk => clk_1mhz,
                                                  ledJoystick1 => btnD,
                                                  ledJoystick2 => btnU,
                                                  miso => miso,
                                                  mosi => mosi,
                                                  ss => ss,
                                                  sclk => sclk,
                                                  xJoystick => xJoystick,
                                                  yJoystick => yJoystick,
                                                  boutonJoystick1 => led(2),
                                                  boutonJoystick2 => led(1),
                                                  boutonJoystick3 => led(0));

  inst_All7Segments : All7Segments port map (clk => mclk,
                                              reset => master_rst,
                                              e0 => yJoystick(3 downto 0),
                                              e1 => yJoystick(7 downto 4),
                                              e2 => digit3xJoystick,
                                              e3 => "0000",
                                              e4 => xJoystick(3 downto 0),
                                              e5 => xJoystick(7 downto 4),
                                              e6 => digit3yJoystick,
                                              e7 => "0000",
                                              an => an,
                                              ssg => ssg);
    
end synthesis;
