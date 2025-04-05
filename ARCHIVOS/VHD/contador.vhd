library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity contador is
Generic (Nbit: INTEGER := 10);
    Port (
         
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           resets : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR(Nbit-1 downto 0));
end contador;

architecture Behavioral of contador is
signal Q_s,p_Q_s:unsigned(Nbit-1 downto 0);
begin
process(clk,reset,enable)
begin
if(reset='1') then
    Q_s<=(others=>'0');
elsif(rising_edge(clk) and enable='1') then
Q_s<=p_Q_s;
end if;  
end process;

process(resets,Q_s)
begin
if(resets='1') then
p_Q_s<=(others=>'0');
else
p_Q_s<=Q_s+1;
end if;
end process;

Q<= std_logic_vector(Q_s);
end Behavioral;
