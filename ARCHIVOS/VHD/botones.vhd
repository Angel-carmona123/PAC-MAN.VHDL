library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity botones is
    Port ( right : in STD_LOGIC;
           left : in STD_LOGIC;
           up : in STD_LOGIC;
           down : in STD_LOGIC;
           udlr : out STD_LOGIC_VECTOR (3 downto 0)); 
end botones;

architecture Behavioral of botones is

begin
process(right, left, up, down)
begin

    if(up='1')then udlr<="1000"; --arriba
    
    elsif(down='1')then udlr<="0100"; --abajo
    
    elsif(left='1')then udlr<="0010"; --izquierda
    
    elsif(right='1')then udlr<="0001"; --derecha
    
    else udlr<="0000"; -- Por si hay algun error
    
    end if;
    --Todo dentro de un if para que no haya problemas con la salida udlr en caso de tener dos botones activos
end process;
end Behavioral;
