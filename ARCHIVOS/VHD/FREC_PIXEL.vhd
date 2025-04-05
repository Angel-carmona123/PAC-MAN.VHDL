library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FREC_PIXEL is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_pixel : out STD_LOGIC);
end FREC_PIXEL;

    architecture Behavioral of FREC_PIXEL is
signal p_cuenta_s,cuenta_s:unsigned (1 downto 0);
begin
process(reset,clk) is
begin
if (reset='1')then
cuenta_s <= (others=> '0');
elsif(rising_edge(clk)) then
cuenta_s<=p_cuenta_s;
end if;
end process;


process(cuenta_s)is
begin
if(cuenta_s="11") then
clk_pixel<='1';
else
clk_pixel<='0';
end if;
p_cuenta_s<=cuenta_s+1;
end process;
end Behavioral;
