----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.12.2024 22:54:21
-- Design Name: 
-- Module Name: fantasma_memoria - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fantasma_memoria is
--  Port ( );
end fantasma_memoria;

architecture Behavioral of fantasma_memoria is


signal dout, din :std_logic_vector (2 downto 0);
signal addr : std_logic_vector (8 downto 0);
signal we : std_logic_vector (0 downto 0);
signal done : std_logic;
signal reset : std_logic;
signal clk : std_logic :='0';
signal move : std_logic :='0';
constant clock_periode : time := 10ns;


component tabla
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    clkb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
  );
  end component;

component fantasma is
Port ( 
clk : in std_logic;
reset : in std_logic;
dout : in std_logic_vector(2 downto 0);
addr : out std_logic_vector(8 downto 0);
mover : in std_logic;
din : out std_logic_vector(2 downto 0);
we : out std_logic_vector(0 downto 0);
done : out std_logic
);
end component;



begin

clk <= not clk after clock_periode/2;
move <= not move after 25*clock_periode;


fantasma1: fantasma
port map(
clk => clk,
reset => reset,
dout => dout,
addr => addr,
mover => move,
din => din,
we => we,
done => done
);

tablero : tabla
port map(
 clka => clk,
 ena => '1',
 wea => we,
 addra => addr,
 dina => din,
 douta => dout,
 clkb => clk,
 web => (others =>'0'),
 addrb => (others =>'0'),
 dinb  => (others =>'0')
);

process 
begin
    reset <='1';
    
    wait for 1*clock_periode;
    reset <= '0';
    wait ;
    end process;

end Behavioral;
