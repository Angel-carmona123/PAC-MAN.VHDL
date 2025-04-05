-- Testbench automatically generated

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- use IEEE.NUMERIC_STD.ALL;

entity Superior_VGA_tb is
end Superior_VGA_tb;

architecture test_bench of Superior_VGA_tb is

  
-- Signals for connection to the DUT
  signal right : STD_LOGIC;
  signal left : STD_LOGIC;
  signal up : STD_LOGIC;
  signal down : STD_LOGIC;
  signal VS : STD_LOGIC;
  signal HS : STD_LOGIC;
  signal RED : STD_LOGIC_VECTOR (3 downto 0);
  signal GRN : STD_LOGIC_VECTOR (3 downto 0);
  signal BLU : STD_LOGIC_VECTOR (3 downto 0);
  signal clk : STD_LOGIC := '0';
  signal reset : STD_LOGIC;

  -- Component declaration
  component Superior_VGA
    port (
      right : in STD_LOGIC;
      left : in STD_LOGIC;
      up : in STD_LOGIC;
      down : in STD_LOGIC;
      VS : out STD_LOGIC;
      HS : out STD_LOGIC;
      RED : out STD_LOGIC_VECTOR (3 downto 0);
      GRN : out STD_LOGIC_VECTOR (3 downto 0);
      BLU : out STD_LOGIC_VECTOR (3 downto 0);
      clk : in STD_LOGIC;
      reset : in STD_LOGIC);
  end component;

  constant clockPeriod : time := 10 ns; -- EDIT Clock period

begin
  DUT : Superior_VGA
    port map(
      right => right,
      left => left,
      up => up,
      down => down,
      VS => VS,
      HS => HS,
      RED => RED,
      GRN => GRN,
      BLU => BLU,
      clk => clk,
      reset => reset);

  clk <= not clk after clockPeriod/2;

  stimuli : process
  begin
    right <= '0'; -- EDIT Initial value
    left <= '0'; -- EDIT Initial value
    up <= '1'; -- EDIT Initial value
    down <= '0'; -- EDIT Initial value
    reset <= '1'; -- EDIT Initial value

    -- Wait one clock period
    wait for 1 * clockPeriod;
    reset <= '0';
    -- EDIT Genererate stimuli here

    wait;
  end process;

end test_bench;
