


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dibuja is
Port ( eje_x : in STD_LOGIC_VECTOR (9 downto 0);
eje_y : in STD_LOGIC_VECTOR (9 downto 0);
direccion_mira : in STD_LOGIC_VECTOR (1 downto 0);
dout_b : in std_logic_vector (2 downto 0);
dout_sprites : in STD_LOGIC_VECTOR(11 DOWNTO 0);
ADDR : out STD_LOGIC_VECTOR (8 downto 0);
RGB : out std_logic_vector (11 downto 0); --Estos dos ultimos son los referentes a los sprites
ADDR_s : out  std_logic_vector (11 downto 0)
);
end dibuja;

architecture Behavioral of dibuja is

signal bits : std_logic_vector (3 downto 0);

begin

dibuja: process(eje_x, eje_y, dout_b, dout_sprites, direccion_mira, bits)

begin

ADDR<=eje_y(7 downto 4)& eje_x(8 downto 4);
ADDR_s <= bits & eje_y(3 downto 0) & eje_x(3 downto 0);
bits <= "0000";
RGB <= (others => '0'); 

if ((unsigned(eje_x)>0 and unsigned(eje_x)<512) and
(unsigned(eje_y)>0 and unsigned(eje_y)<256)) then
    case dout_b is
        when "000" =>
            bits<="0000";
--            RGB <= "000000001111"; --Muro
            RGB <= dout_sprites;
        when "001" =>
            RGB <= "000000000000"; --VACIO
     
        when "010" =>
--            RGB <= "000011110000"; --Limon
            bits<="0001";
          RGB <= dout_sprites;
        when "011" =>
--            RGB <= "011100110000"; --BOLAS
            bits<="0010";
       RGB <= dout_sprites;     
        when "100" =>
        if( direccion_mira = "00") then --mueve hacia arriba
--            RGB <= "111111110000"; --COMECOCOS
            bits<="0100";
             RGB <= dout_sprites;
            elsif( direccion_mira = "01") then --mueve hacia abajo
            bits<="0101";
             RGB <= dout_sprites;
            elsif( direccion_mira = "10") then --mueve hacia izquierda
            bits<="0110";
             RGB <= dout_sprites;
            elsif( direccion_mira = "11") then --mueve hacia derecha
            bits<="0011";
        RGB <= dout_sprites;
        end if;
        when "101" =>
--            RGB <= "111100001111";
            bits<="0111";
        RGB <= dout_sprites;
        when others =>
            RGB<="111100000000";
         
        end case;
        else
        RGB<="111111111111";
end if;
end process;

end Behavioral;
