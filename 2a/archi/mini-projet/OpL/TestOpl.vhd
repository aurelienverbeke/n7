library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testopl is
end testopl;

architecture behavioral of testopl is

  component MasterOpl is
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
  end component;

  component SlaveOpl is
    port(
      sclk : in  std_logic;
      mosi : in  std_logic;
      miso : out std_logic;
      ss   : in  std_logic
    );
  end component;

  --Inputs
  signal clk : std_logic := '0';
  signal rst : std_logic := '0';
  signal en : std_logic := '0';
  signal v1 : std_logic_vector(7 downto 0) := (others => '0');
  signal v2 : std_logic_vector(7 downto 0) := (others => '0');

  --Internal
  signal sclk : std_logic;
  signal mosi : std_logic;
  signal miso : std_logic;
  signal ss : std_logic;

  --Outputs
  signal busy : std_logic;
  signal val_nand : std_logic_vector (7 downto 0);
  signal val_nor : std_logic_vector (7 downto 0);
  signal val_xor : std_logic_vector (7 downto 0);

  -- Clock period definitions
  constant clk_period : time := 10 ns;

begin

  master : MasterOpl port map (rst => rst,
                                clk => clk,
                                en => en,
                                v1 => v1,
                                v2 => v2,
                                miso => miso,
                                ss => ss,
                                sclk => sclk,
                                mosi => mosi,
                                val_nand => val_nand,
                                val_nor => val_nor,
                                val_xor => val_xor,
                                busy => busy);

  slave : SlaveOpl port map (miso => miso,
                              ss => ss,
                              sclk => sclk,
                              mosi => mosi);
  
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
    wait for 10 ns;  
    rst <= '1';

    wait for clk_period*10;

    -- insert stimulus here

    v1 <= "10110101";
    v2 <= "11110000";

    en <= '1';

    wait for clk_period;

    en <= '0';
    v1 <= (others => 'U');
    v2 <= (others => 'U');

    wait for 100*clk_period;

    v1 <= "10010100";
    v2 <= "01101001";

    en <= '1';

    wait for clk_period;

    en <= '0';
    v1 <= (others => 'U');
    v2 <= (others => 'U');

    wait for 100*clk_period;

    v1 <= "00000000";
    v2 <= "00000000";

    en <= '1';

    wait for clk_period;

    en <= '0';
    v1 <= (others => 'U');
    v2 <= (others => 'U');

    wait;
  end process;

end behavioral;