----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2024 12:17:39
-- Design Name: 
-- Module Name: div_frec - Behavioral
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

entity div_frec is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           refresh : in STD_LOGIC;
           refresh_d : out STD_LOGIC);
end div_frec;

architecture Behavioral of div_frec is

signal cont,cont_prev : unsigned(4 downto 0);
signal div, div_prev : std_logic;
begin

refresh_d<= div;
sinc:process(clk,reset)
begin

if(reset = '1') then
    cont <= (others => '0');
    div <= '0';
elsif(rising_edge(clk)) then
    cont <= cont_prev;
    div <= div_prev;

end if;

end process;


comb: process(cont,refresh, div)
begin
div_prev <= div;
cont_prev <= cont;

if(refresh = '1') then
cont_prev <= cont +1;
end if;


if(cont = 15) then


div_prev <= '1';

else 
div_prev <= '0';
cont_prev <= (others => '0');
end if;
end process;
end Behavioral;
