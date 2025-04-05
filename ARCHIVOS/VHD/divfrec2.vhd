


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity divfrec2 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sat : out STD_LOGIC);
end divfrec2;


architecture Behavioral of divfrec2 is
signal p_cuenta,cuenta: unsigned (9 downto 0);
begin

sinc: process (clk, reset)
begin
    if (reset='1') then
        cuenta <= (others => '0');
    elsif (rising_edge(clk)) then
        cuenta <= p_cuenta;
    end if;
end process;

comb: process (cuenta)
begin
    if (cuenta="1111111111") then
        sat <= '1';
        p_cuenta <= (others => '0');
    else 
        sat <= '0';
        p_cuenta <= cuenta+1;
    end if;
end process;

end Behavioral;
