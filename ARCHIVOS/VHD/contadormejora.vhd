


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity contadormejora is
Generic (Nbit: INTEGER := 10);
    Port ( clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           reset : in STD_LOGIC;
           --Qx: in std_logic_vector(Nbit-1 downto 0);
           Q : out std_logic_vector (Nbit-1 downto 0));
end contadormejora;

architecture Behavioral of contadormejora is
signal Q_s: unsigned (Nbit-1 downto 0);
signal p_Q_s: unsigned (Nbit-1 downto 0);
signal cambio, p_cambio: std_logic;
begin

process (Q_s,cambio )
begin
if(Q_s="1000101111") then
p_cambio<='1';
elsif (Q_s="0000000000")then
p_cambio<='0';
else
p_cambio<=cambio;
end if;
end process;

process(clk,reset,enable)
begin
if(reset='1') then
    Q_s<="0100010110";
    cambio<='0';
elsif(rising_edge(clk) and enable='1') then
cambio<=p_cambio;
Q_s<=p_Q_s;
end if;  
end process;

process(Q_s,cambio)
begin

    if(cambio='0') then
    p_Q_s<=Q_s+1;
    elsif (cambio='1') then
    p_Q_s<=Q_s-1;
    else
    p_Q_s<=Q_s;
    end if;

end process;

Q<= std_logic_vector(Q_s);


end Behavioral;