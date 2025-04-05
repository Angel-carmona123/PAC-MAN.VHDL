


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_driver is
Generic (Nbit:Integer:=10);
Port ( clk : in STD_LOGIC;
reset : in STD_LOGIC;
RED_IN : in STD_LOGIC_VECTOR (3 downto 0);
GRN_IN : in STD_LOGIC_VECTOR (3 downto 0);
BLU_IN : in STD_LOGIC_VECTOR (3 downto 0);
VS : out STD_LOGIC;
HS : out STD_LOGIC;
RED : out STD_LOGIC_VECTOR (3 downto 0);
GRN : out STD_LOGIC_VECTOR (3 downto 0);
BLU : out STD_LOGIC_VECTOR (3 downto 0);
ejex_o : out std_logic_vector (9 downto 0);
ejey_o : out std_logic_vector (9 downto 0);
refresh : out std_logic);

end vga_driver;

architecture Behavioral of vga_driver is

component frec_pixel
Port (clk: in std_logic;
        reset: in std_logic;
        clk_pixel: out std_logic);
 end component;
 
 component contador
 Generic (Nbit:Integer:=10);
 Port(
       
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           resets : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR(Nbit-1 downto 0));
end component;


component comparador
 Generic (Nbit: integer :=8;
        End_Of_Screen: integer :=10;
        Start_Of_Pulse: integer :=20;
        End_Of_Pulse: integer := 30;
        End_Of_Line: integer := 40);
    Port ( clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        data : in STD_LOGIC_VECTOR (Nbit-1 downto 0);
        O1 : out STD_LOGIC;
        O2 : out STD_LOGIC;
        O3 : out STD_LOGIC);
end component;

component Gen_color
Port ( blank_h : in STD_LOGIC;
blank_v : in STD_LOGIC;
RED_in : in STD_LOGIC_VECTOR (3 downto 0);
GRN_in : in STD_LOGIC_VECTOR (3 downto 0);
BLU_in : in STD_LOGIC_VECTOR (3 downto 0);
RED : out STD_LOGIC_VECTOR (3 downto 0);
GRN : out STD_LOGIC_VECTOR (3 downto 0);
BLU : out STD_LOGIC_VECTOR (3 downto 0));

end component;

component contadormejora 
Generic (Nbit: INTEGER := 10);
    Port ( clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           reset : in STD_LOGIC;
           --Qx: in std_logic_vector(Nbit-1 downto 0);
           Q : out std_logic_vector (Nbit-1 downto 0));
end component;

component divfrec2 
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sat : out STD_LOGIC);
end component;


signal clk_pixel_s: std_logic;
signal andout, sat_s: std_logic;
signal eje_x_s,eje_y_s, Qx_s: std_logic_vector(9 downto 0);
signal O3_comp1, O3_comp2,O1_comp1,O1_comp2,O2_comp1,O2_comp2: std_logic;
signal RED_s,GRN_s,BLU_s:std_logic_vector(3 downto 0);
signal RED_out,GRN_out,BLU_out:std_logic_vector(3 downto 0);
signal Q_mejora: std_logic_vector (Nbit-1 downto 0);
begin
andout<=clk_pixel_s and O3_comp1;
frec_pixel1:frec_pixel
port map(
clk=>clk,
reset=>reset,
clk_pixel=> clk_pixel_s
);

divfrec: divfrec2
port map(
clk=>clk,
reset=>reset,
sat=>sat_s
);

cont1:contador
port map(
clk=>clk,
reset=>reset,
enable=> clk_pixel_s,
resets=>andout,
Q=> eje_x_s
);
cont2:contador
port map(
clk=>clk,
reset=>reset,
enable=> andout,
resets=>O3_comp2,
Q=> eje_y_s
);

comp1:comparador
Generic map(
Nbit=>10,
End_of_Screen=>639,
Start_Of_Pulse=>655,
End_Of_pulse=>751,
End_Of_Line=> 799
)
port map(
clk=>clk,
reset=>reset,
data=>eje_x_s,
O1=>O1_comp1,
O2=>O2_comp1,
O3=>O3_comp1
);

comp2:comparador
Generic map(
Nbit=>10,
End_of_Screen=>479,
Start_Of_Pulse=>489,
End_Of_pulse=>491,
End_Of_Line=> 520
)
port map(
clk=>clk,
reset=>reset,
data=>eje_y_s,
O1=>O1_comp2,
O2=>O2_comp2,
O3=>O3_comp2
);


Gen_color1:Gen_color
port map(
blank_h=>O1_comp1,
blank_v=>O1_comp2,
RED_in=>RED_IN,
GRN_in=>GRN_IN,
BLU_in=>BLU_IN,
RED=>RED_out,
GRN=>GRN_out,
BLU=>BLU_out
);

Mejora: contadormejora
port map(
clk=> sat_s,
enable=> O3_comp2,
reset=> reset,
--Qx=>eje_x_s,
Q=>Qx_s
);


HS<=O2_comp1;
VS<=O2_comp2;
RED<=RED_out;
GRN<=GRN_out;
BLU<=BLU_out;
ejex_o<=eje_x_s;
ejey_o<=eje_y_s;
refresh<=andout;

end Behavioral;