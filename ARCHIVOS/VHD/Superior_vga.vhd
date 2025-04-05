
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Superior_VGA is
    Port (
        right : in STD_LOGIC;
        left : in STD_LOGIC;
        up : in STD_LOGIC;
        down : in STD_LOGIC;
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        
        VS : out STD_LOGIC;
        HS : out STD_LOGIC;
        RED : out STD_LOGIC_VECTOR (3 downto 0);
        GRN : out STD_LOGIC_VECTOR (3 downto 0);
        BLU : out STD_LOGIC_VECTOR (3 downto 0);

         dp : out STD_LOGIC;
         an3_0 : out STD_LOGIC_VECTOR(3 downto 0);
         a : out STD_LOGIC;
         b : out STD_LOGIC;
         c : out STD_LOGIC;
         d : out STD_LOGIC;
         e : out STD_LOGIC;
         f : out STD_LOGIC;
         g : out STD_LOGIC
    );
end Superior_VGA;

architecture Behavioral of Superior_VGA is
    -------------------------------------------------------
    component vga_driver
        Port (clk : in STD_LOGIC;
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
    end component;
    -------------------------------------------------------
    component dibuja
        Port ( eje_x : in STD_LOGIC_VECTOR (9 downto 0);
             eje_y : in STD_LOGIC_VECTOR (9 downto 0);
             dout_b : in std_logic_vector (2 downto 0);
             direccion_mira : in std_logic_vector (1 downto 0);
             dout_sprites : in STD_LOGIC_VECTOR(11 DOWNTO 0);
             ADDR : out STD_LOGIC_VECTOR (8 downto 0);
             RGB : out std_logic_vector (11 downto 0);
             ADDR_s : out  std_logic_vector (11 downto 0)
            );
    end component;
    -------------------------------------------------------
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
    ------------------------------------------------------- 
    component sprites
        PORT (
            clka : IN STD_LOGIC;
            addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
        );
    end component;
    -------------------------------------------------------
    component fantasma is
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
    end component;
    -------------------------------------------------------
    component comecocos is
        Port(
            clk:in std_logic;
            reset: in std_logic;--reset asincrono
            refresh: in std_logic;--actualizar pantalla a 60Hz
            move: in std_logic;--fantasma deja moverse al comecococs
            start: in std_logic;--se pulsa boton
            udlr: in std_logic_vector (3 downto 0);--botones del comecocos
            addrOUT: out std_logic_vector (8 downto 0);-- posici n xy que quiero escribir o saber qu  hay
            din: in std_logic_vector (2 downto 0);--elemento que hay de entrada
            dout: out std_logic_vector (2 downto 0);--elemento que se quiera escribir (para poner el comecocos en su posicion y algo en su posicion anterior)
            em: out std_logic;--enable memoria
            done: out std_logic; --comecocos deja moverse al fantasma
            we: out std_logic_vector (0 downto 0);-- write end
            donde_mira: out std_logic_vector(1 downto 0);
            puntos: out std_logic);
    end component;

    -------------------------------------------------------
    component div_frec is
        Port ( clk : in STD_LOGIC;
             reset : in STD_LOGIC;
             refresh : in STD_LOGIC;
             refresh_d : out STD_LOGIC);
    end component;
    -------------------------------------------------------
    component botones is
        Port ( right : in STD_LOGIC;
             left : in STD_LOGIC;
             up : in STD_LOGIC;
             down : in STD_LOGIC;
             udlr : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
     -------------------------------------------------------
    
   component enable_memoria is
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
        
        
        din_mem : out STD_LOGIC_VECTOR(2 downto 0); -- Entradad de datos de la memoria    /
        addr_out : out STD_LOGIC_VECTOR(8 downto 0); -- salida de la direccion    /   
        dout_c : out STD_LOGIC_VECTOR(2 downto 0);  -- Salida de datos de la memoria para el comecocos /
        dout_f1 : out STD_LOGIC_VECTOR(2 downto 0); -- Salida de datos de la memoria para el fantasma 1 /
        dout_f2 : out STD_LOGIC_VECTOR(2 downto 0); -- Salida de datos de la memoria para el fatnasma 2 /
        
        we_out   : out STD_LOGIC_VECTOR(0 downto 0) -- Salida a la memoria para escirutra /
    );
end component;

------------------------------------------------
component puntuacion is
    Port ( clk : in STD_LOGIC;
         reset : in STD_LOGIC;
         punto : in STD_LOGIC;
         dp : out STD_LOGIC;
         an3_0 : out STD_LOGIC_VECTOR(3 downto 0);
         a : out STD_LOGIC;
         b : out STD_LOGIC;
         c : out STD_LOGIC;
         d : out STD_LOGIC;
         e : out STD_LOGIC;
         f : out STD_LOGIC;
         g : out STD_LOGIC);
    end component;
    -------------------------------------------------------
    signal VS_out, HS_out , refresh_s, refresh_d_s:std_logic;
    signal RED_out, GRN_out, BLU_out: std_logic_vector (3 downto 0);
    signal ejex_o_s, ejey_o_s: std_logic_vector (9 downto 0);
    signal enable_pacman, writte_enable : std_logic;
    signal addr_s, addra_s, addra_c_s, addra_f1_s, addra_f2_s : std_logic_vector (8 downto 0);
    signal doutb_s, douta_s, douta_c_s, douta_f1_s, douta_f2_s : std_logic_vector(2 downto 0);
    signal RGB_out_prev : std_logic_vector(11 downto 0);
    signal addr_sprites : std_logic_vector(11 DOWNTO 0);
    signal dout_s :  std_logic_vector(11 downto 0);
    signal dina_s, dina_c_s, dina_f1_s, dina_f2_s : std_logic_vector(2 downto 0);
    signal we_s, we_f1_s,we_c_s, we_f2_s : std_logic_vector (0 downto 0);
    signal start_s: std_logic;
    signal udlr_s: std_logic_vector(3 downto 0);
    signal done_s: std_logic;
    signal em_f1_s, em_f2_s : std_logic;
    signal dir_mir_s: std_logic_vector(1 downto 0);
    signal puntos_s: std_logic;
    signal dp_s, a_s, b_s, c_s, d_s, e_s, f_s, g_s: std_logic;
    signal an3_0_s: std_logic_vector (3 downto 0);
    -------------------------------------------------------
begin
    -------------------------------------------------------
    fantasma1: fantasma
    generic map(
    x => "00110",
    y => "1011"
    )
    port map(
    clk => clk,
    reset => reset,
    dout => douta_f1_s,
    addr => addra_f1_s,
    mover => done_s,
    din => dina_f1_s,
    we => we_f1_s,
    em => em_f1_s
    );
    -------------------------------------------------------
    fantasma2: fantasma
    generic map(
    x => "11000", --Cambiar donde empieza
    y => "0011" --Cambiar donde empieza
    )
    port map(
    clk => clk,
    reset => reset,
    dout => douta_f2_s,
    addr => addra_f2_s,
    mover => done_s,
    din => dina_f2_s,
    we => we_f2_s,
    em => em_f2_s
    );
    -------------------------------------------------------
    mux : enable_memoria
    Port map(
    em_c => enable_pacman,
    em_f1 => em_f1_s,
    em_f2 => em_f2_s,
    we_c => we_c_s,
    we_f1 => we_f1_s,
    we_f2 => we_f2_s,
    addr_c => addra_c_s,
    addr_f1 => addra_f1_s,
--    addr_f2 => (others=>'0'),
    addr_f2 => addra_f2_s,
    din_c => dina_c_s,
    din_f1 => dina_f1_s,
    din_f2 => dina_f2_s,
        
    din_mem => dina_s,
    addr_out => addra_s,
    dout_c => douta_c_s,
    dout_f1 => douta_f1_s,
    dout_f2 => douta_f2_s,
    dout_mem => douta_s,
        
    we_out => we_s
    );
    
    -------------------------------------------------------
    
    
    dibuja_int : dibuja
        Port map(
            eje_x => ejex_o_s,
            eje_y => ejey_o_s,
            RGB => RGB_out_prev,
            ADDR => addr_s,
            ADDR_s => addr_sprites,
            dout_b => doutb_s,
            dout_sprites => dout_s,
            direccion_mira => dir_mir_s
        );
    -------------------------------------------------------
    los_sprites : sprites
        port map(
            clka => clk,
            addra => addr_sprites,
            douta => dout_s
        );
    -------------------------------------------------------
    tablero : tabla
        Port map(
            clka => clk,
            clkb => clk,
            ena => '1',
            wea => we_s,
            addra => addra_s,
            addrb => addr_s,
            dina =>dina_s,
            douta => douta_s,
            web => (others =>'0'),
            dinb => (others =>'0'),
            doutb => doutb_s
        );
    -------------------------------------------------------
    divisor : div_frec
        port map(
            clk => clk,
            reset => reset,
            refresh => refresh_s, --Aqui le meto la entrada del refresh del vga_driver
            refresh_d => refresh_d_s  --Aqui es la se al para cuando que quiero que se mueva mi fantasma
        );
    -------------------------------------------------------
    vga_int: vga_driver
        Port map(
            clk=> clk,
            VS=>VS_out,
            HS=>HS_out,
            RED=>RED_out,
            GRN=>GRN_out,
            BLU=>BLU_out,
            RED_IN=>RGB_out_prev(11 downto 8),
            GRN_IN=>RGB_out_prev(7 downto 4),
            BLU_IN=>RGB_out_prev(3 downto 0),
            reset => reset,
            ejex_o => ejex_o_s,
            ejey_o => ejey_o_s,
            refresh => refresh_s
        );
    -------------------------------------------------------
    Comecocos1: comecocos
        port map(
            clk => clk,
            reset => reset,
            refresh=>refresh_s,--refresh_d_s
            move=>'1',--se al que indica que fantasma termina
            start=>'1',
            udlr=>udlr_s,
            addrOUT=>addra_c_s,
            din=>douta_c_s,
            dout => dina_c_s,
            em=>enable_pacman,
            done=>done_s,
            we=>we_c_s,
            donde_mira => dir_mir_s,
            puntos => puntos_s
        );

    -------------------------------------------
    udlr: botones
        port map(
            udlr=>udlr_s,
            up=>up,
            down=>down,
            left=>left,
            right=>right
        );
    -------------------------------------------
 puntuacion1 : puntuacion 
        port map(
            clk=>clk,
            reset=>reset,
            punto=>puntos_s,
            dp=>dp_s,
            an3_0=>an3_0_s,
            a=>a_s,
            b=>b_s,
            c=>c_s,
            d=>d_s,
            e=>e_s,
            f=>f_s,
            g=>g_s
        );
    -------------------------------------------
    VS <= VS_out;
    HS <= HS_out;
    RED <= RED_out;
    GRN <= GRN_out;
    BLU <= BLU_out;
    dp<=dp_s;
    an3_0<=an3_0_s;
    a<=a_s;
    b<=b_s;
    c<=c_s;
    d<=d_s;
    e<=e_s;
    f<=f_s;
    g<=g_s;
end Behavioral;
