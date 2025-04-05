library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity enable_memoria is
    Port (
        em_c : in  STD_LOGIC;   -- lectura comecocs /
        em_f1 : in  STD_LOGIC;   -- lectura fantasma 1 /
        em_f2 : in  STD_LOGIC;   -- lectura fantasma 2 /
        we_c : in  STD_LOGIC_VECTOR(0 downto 0);   -- escritura comecocos /
        we_f1 : in  STD_LOGIC_VECTOR(0 downto 0);   -- escritura fantasma 1 /
        we_f2 : in  STD_LOGIC_VECTOR(0 downto 0);   -- escritura fantasma 2 /
        addr_c : in  STD_LOGIC_VECTOR(8 downto 0); -- direccion para el comecocos /
        addr_f1 : in  STD_LOGIC_VECTOR(8 downto 0); -- direccion para el fantasma 1 /
        addr_f2 : in  STD_LOGIC_VECTOR(8 downto 0); -- direccion para el fantasma 2 /
        din_c : in STD_LOGIC_VECTOR(2 downto 0); -- Entrada de datos de la memoria del comecocos /
        din_f1 : in STD_LOGIC_VECTOR(2 downto 0); -- Entrada de datos de la memoria del fantasma 1 /
        din_f2 : in STD_LOGIC_VECTOR(2 downto 0); -- Entrada de datos de la memoria del fantasma 2  /               
        dout_mem : in STD_LOGIC_VECTOR(2 downto 0); -- Salida de datos para la memoria /
        clk: in std_logic;
        
        din_mem : out STD_LOGIC_VECTOR(2 downto 0); -- Entradad de datos de la memoria    /
        addr_out : out STD_LOGIC_VECTOR(8 downto 0); -- salida de la direccion    /   
        dout_c : out STD_LOGIC_VECTOR(2 downto 0);  -- Salida de datos de la memoria para el comecocos /
        dout_f1 : out STD_LOGIC_VECTOR(2 downto 0); -- Salida de datos de la memoria para el fantasma 1 /
        dout_f2 : out STD_LOGIC_VECTOR(2 downto 0); -- Salida de datos de la memoria para el fatnasma 2 /
        we_out   : out STD_LOGIC_VECTOR(0 downto 0) -- Salida a la memoria para escirutra /
    );
end enable_memoria;

architecture Behavioral of enable_memoria  is
begin
    process(em_c, em_f1, em_f2, din_c, addr_c, dout_mem, we_c, din_f1, addr_f1, we_f1, din_f2, addr_f2, we_f2)
    begin
           din_mem  <= (others =>'0');
           addr_out <= (others =>'0');
           dout_c <= (others =>'0');
           dout_f1 <= (others =>'0');
           dout_f2 <= (others =>'0');
           we_out <= (others =>'0');
            -- Priorizamos la escritura y lectura del comecocos
           if(em_c = '1') then
           din_mem <= din_c;
           addr_out <= addr_c;
           dout_c <= dout_mem;
           we_out <= we_c;
           
             elsif(em_f1 = '1') then
           din_mem <= din_f1;
           addr_out <= addr_f1;
           dout_f1 <= dout_mem;
           we_out <= we_f1;
           
            elsif(em_f2 = '1') then
           din_mem <= din_f2;
           addr_out <= addr_f2;
           dout_f2 <= dout_mem;
           we_out <= we_f2;
           
           end if;
    end process;
end Behavioral;
