----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.12.2024 20:53:53
-- Design Name: 
-- Module Name: fantasma - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fantasma is
generic(
x : std_logic_vector(4 downto 0);
y : std_logic_vector(3 downto 0)
);
Port ( 
clk : in std_logic;
reset : in std_logic;
dout : in std_logic_vector(2 downto 0);
addr : out std_logic_vector(8 downto 0);
mover : in std_logic;
din : out std_logic_vector(2 downto 0);
we : out std_logic_vector(0 downto 0);
done : out std_logic;
em : out std_logic
);
end fantasma;

architecture Behavioral of fantasma is

type ESTADOS is(E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10);
type DIRECCION is(up,left,right,down);

signal estado, estado_prev : ESTADOS;
signal dir : DIRECCION;
signal pos_y, pos_y_prev : unsigned(3 downto 0);
signal pos_x, pos_x_prev : unsigned(4 downto 0);
signal addr_sinc, addr_prev : unsigned(8 downto 0);
signal cont, cont_prev : unsigned(3 downto 0);
signal casilla_guardada_prev, casilla_guardada, casilla_actual_prev, casilla_actual : std_logic_vector(2 downto 0);
signal din_prev, din_s : std_logic_vector(2 downto 0);
signal dir_prev : DIRECCION;
signal em_prev , em_sinc: std_logic;


begin

em <=em_sinc;
din <= din_s;
addr <= std_logic_vector(addr_sinc);


sinc: process(clk, reset)
begin
if(reset='1')then --RESETEAMOS TODAS LAS SEÑALES
    estado <= E0;
    addr_sinc <= (others =>'0');
    cont <= (others => '0');
    din_s <= (others => '0');
    dir <= right;
    pos_x <= unsigned(x);
    pos_y <= unsigned(y);
    casilla_actual <= "001";
    casilla_guardada <= "001";
    em_sinc <= '0';
elsif (rising_edge(clk))then --TODAS LAS SINCRONAS SE VUELVAN ASINCRONAS
    estado <= estado_prev;
    addr_sinc <= addr_prev;
    cont <=cont_prev;
    casilla_guardada <=casilla_guardada_prev;
    casilla_actual <= casilla_actual_prev;
    din_s <= din_prev;
    dir <= dir_prev;
    pos_x <= pos_x_prev;
    pos_y <= pos_y_prev;
    em_sinc <= em_prev;
end if;

end process;

comb: process(estado,mover,din_s,addr_sinc, casilla_guardada, casilla_actual, dir, pos_x, pos_y, cont, dout,em_sinc)
begin
--LE METEMOS LA SINCRONA A CADA COMBINACIONAL PARA EVITAR LACHES
estado_prev <= estado;
addr_prev <= addr_sinc;
casilla_guardada_prev <= casilla_guardada;
casilla_actual_prev <= casilla_actual;
done <= '0';
dir_prev <= dir;
we <= (others => '0');
din_prev <= din_s;
pos_x_prev <= pos_x;
pos_y_prev <= pos_y;
cont_prev <= cont;
em_prev <= em_sinc;

case(estado)is

    when E0=> --ESTADO DE REPOSO
        if(mover='1')then
        estado_prev<=E1;
        em_prev <= '1';
        end if;
        
    when E1=>
        case(dir)is --MIRAMOS LA CASILLA DE A DONDE NOS QUEREMOS MOVER
        when Up => 
            addr_prev <= (pos_y-1) & pos_x; 
        when left => 
            addr_prev <= (pos_y) & (pos_x-1);     
        when Down => 
            addr_prev <= (pos_y+1) & pos_x; 
        when right => 
            addr_prev <= (pos_y) & (pos_x+1); 
        end case;
            
        --COMO VAMOS A TARDAR 
        if(cont<10)then
            cont_prev <= cont+1;
        else
        estado_prev<=E2;
        cont_prev <= (others=>'0');

        end if;
        
        when E2=>
            if(dout = "001" or dout = "010" or dout = "011")then--SE PUEDE MOVER SIN PAC_MAN
                estado_prev<=E3;
            elsif(dout = "000")then--SE ENCUENTRA PARED
                estado_prev<=E4;
            else--CHOCA CON EL COMECOCOS
                estado_prev<=E5; --ESTADO DE MUERTE QUE NO SALE DE AHI
            end if;
            
         when E3=> --ESCRIBO EL FANTASMA
           casilla_actual_prev<= casilla_guardada; --GUARDO LOS DATOS QUE HABIA
           casilla_guardada_prev<= dout; 
           din_prev <= "101";--ESCRIBIMOS FANTASMA EN DONDE APUNTA ADDR;
         --ACTUALIZAMOS POS_Y Y POS_x
           pos_y_prev<= addr_sinc(8 downto 5);
           pos_x_prev<= addr_sinc(4 downto 0);
           estado_prev <= E6;

           
         when E4=>
             case(dir)is --MIRAMOS LA CASILLA DE A DONDE NOS QUEREMOS MOVER
        when Up => 
            dir_prev <= left;
        when left => 
            dir_prev <= down;     
        when Down => 
            dir_prev <= right; 
        when right => 
            dir_prev <= up; 
        end case;
            estado_prev <=E1;

            
            
         when E5=>
                   
         when E6 => --ESCRIBIMOS
         we <= (others=>'0');
            
            if(cont<3)then
            cont_prev <= cont+1;
            else
            estado_prev <=E7;
            we <= (others=>'1');
            cont_prev <= (others=>'0');
            end if;
         
         
         when E7=>
         we<= (others=>'0');
         --AHORA PINTAMOS DONDE HEMOS PASADO CON EL FANTASMA.
        case(dir)is --MIRAMOS LA CASILLA POR DONDE HEMOS PASADO
        when Up => 
            addr_prev <= (pos_y+1) & pos_x; 
        when left => 
            addr_prev <= (pos_y) & (pos_x+1);     
        when Down => 
            addr_prev <= (pos_y-1) & pos_x; 
        when right => 
            addr_prev <= (pos_y) & (pos_x-1); 
        end case;
            if(cont<10)then
            cont_prev <= cont+1;
            else
            estado_prev<=E8;
            cont_prev <= (others=>'0');
            end if;
        when E8 =>
            din_prev <=casilla_actual; --casilla_actual;
            if(cont<3)then
            cont_prev <= cont+1;
            else
            estado_prev<=E9;
            cont_prev <= (others=>'0');
            end if;

        when E9 =>
             we <= (others=>'1');
            estado_prev <= E10;
         
            when E10=>
            we<= (others=>'0');
            done <= '1';
            estado_prev <= E0;
            em_prev <= '0';
           
           
            end case;
         
            
      
end process;




end Behavioral;
