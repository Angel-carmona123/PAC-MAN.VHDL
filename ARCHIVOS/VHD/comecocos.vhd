library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity comecocos is
    Port ( 
    clk:in std_logic;
    reset: in std_logic;--reset asincrono
    refresh: in std_logic;--actualizar pantalla a 60Hz
    move: in std_logic;--fantasma deja moverse al comecococs
    start: in std_logic;--si se pulsa boton
    udlr: in std_logic_vector (3 downto 0);--botones del comecocos
    addrOUT: out std_logic_vector (8 downto 0);-- posición xy la cual
    din: in std_logic_vector (2 downto 0);--elemento que hay de entrada
    dout: out std_logic_vector (2 downto 0);--elemento que se quiera escribir (para poner el comecocos en su posicion y algo en su posicion anterior)
    em: out std_logic;--enable memoria
    done: out std_logic; --comecocos deja moverse al fantasma
    we: out std_logic_vector(0 downto 0);-- write enable
    donde_mira: out std_logic_vector(1 downto 0);
    puntos : out std_logic
    );
    -- lista de elementos
    -- muro=>0, vacio=>1, limon=>2, bola=>3, comecocos=>4, fantasma=>5
end comecocos;

architecture Behavioral of comecocos is
    type estado is (reposo, espera,espera2, dir_boton, act_mov, que_hay, confirmo_dir, ocupa_casilla, muerte);
    signal estado_s, new_estado:      estado;
    signal new_dir, last_dir:         std_logic_vector (8 downto 0);
    signal last_posx, new_last_posx, posx, new_posx: std_logic_vector (3 downto 0):="0111";--4 bits más significativos.
    signal last_posy, new_last_posy, posy, new_posy: std_logic_vector (4 downto 0):="01111";-- 5 bits menos significativos.
    signal new_dout:                  std_logic_vector (2 downto 0);
    signal last_udlr, new_last_udlr, udlr_s, new_udlr: std_logic_vector (3 downto 0);
    signal mueve_pacman:              std_logic;
    signal hay_muro:                  std_logic;
    signal new_hay_muro:              std_logic; 
    signal new_we:                    std_logic_vector(0 downto 0);
    signal done_s:                    std_logic:='0';
    signal cycle, new_cycle:          unsigned (12 downto 0);
    signal em_s, new_em:              std_logic:='1';
    signal vidas, new_vidas:          unsigned (2 downto 0);
    signal puntos_s:                  std_logic;
    signal new_puntos_s:              std_logic;
    signal donde_mira_s:              std_logic_vector(1 downto 0);
    signal donde_mira_p:              std_logic_vector(1 downto 0);
    
begin
    sync: process (clk, reset)
    begin
        if reset='1' then
            --inicio todos los valores que pueda
            estado_s<=reposo;--
            last_udlr<="0001";--
            udlr_s<=(others=>'0');--da igual
            last_posx<="0111";--(others=>'0');--7
            last_posy<= "01111";--(others=>'0');--iniciar en medio: 16
            addrOUT<=last_posx & last_posy;--
            posx<="0111"; -- iniciar en medio
            posy<="01111";--
            mueve_pacman<='0';--
            hay_muro<='0';--
            cycle<="0000000000000";--
            we<=(others=>'0');
            em_s<='0';
            dout<="001";--vacío
            done<='0';--
            vidas<="000";
            puntos_s <='0';
            donde_mira <="00";
        elsif rising_edge(clk) then
            estado_s<=new_estado;--
            last_udlr<=new_last_udlr;--
            udlr_s<=new_udlr;--
            last_posx<=new_last_posx;--
            last_posy<=new_last_posy;--
            addrOUT<=new_dir;--
            posx<=new_posx;--
            posy<=new_posy;--
            hay_muro<=new_hay_muro;--
            cycle<=new_cycle;--
            we<=new_we;--
            em_s<=new_em;--
            dout<=new_dout;--
            done<=done_s;--
            vidas<=new_vidas;
            puntos_s<=new_puntos_s;
            donde_mira<=donde_mira_s;
        end if;
   end process;
        
        maq_Estado: process (estado_s, refresh, start, move, hay_muro, din, done_s, mueve_pacman,
                             last_udlr, new_last_udlr, udlr_s, udlr, cycle, donde_mira_s,
                             last_posx, last_posy, posx, posy, new_posx, new_posy, new_vidas,
                             em_s, puntos_s, vidas)
            begin
                --asigno valores por defecto, si no digo lo contrario:
                new_estado<=estado_s;--mantengo estado
                new_last_udlr<=last_udlr;--mantengo udlr anterior
                new_udlr<=udlr_s;--mantengo urdlr
                new_last_posx<=last_posx;
                new_last_posy<=last_posy;
                new_dir<=new_posx & new_posy;--actualiza la posicion
                new_posx<=posx;--pos anterior
                new_posy<=posy;
                new_hay_muro<=hay_muro;
                new_dout<="001";--vacío
                done_s<='0';
                new_cycle<="0000000000000";
                new_we<=(others=>'0');--no escribir
                new_em<=em_s;
                new_puntos_s<=puntos_s;
                new_vidas<=vidas;
                donde_mira_s<="00";
                
                case estado_s is
                    when reposo=> 
                    if(vidas<="011")then
                       -- if move='1' then--fantasma termina movimiento--probar con fantasma y quitar si hace falta
                            new_udlr<=udlr;
                            --pacman en medio
                            new_posx<="0111";
                            new_posy<="01111";
                            new_dir<= new_posx& new_posy;  
                            new_dout<="100";--comecocos
                            new_we<=(others=>'0');
                            new_estado<=espera;
                        --else new_estado<=reposo; 
                        --end if;
                        else
                        new_estado<=muerte;
                        end if;
                    when espera=>
                        new_em<='0';
                        if (start='1') then--si se pulsa algun boton
                            new_estado<=dir_boton;
                        else 
                            --igual que reposo:
                            new_dout<="100";--comecocos
                            new_dir<= new_posx& new_posy;
                            new_we<=(others=>'0');--1
                            new_udlr<=udlr;
                            new_estado<=espera;
                        end if;
                    when dir_boton=>
                    new_puntos_s<='0';
                        new_em<='1';
                        new_udlr<=udlr;
                        --guardo valor de posición anterior
                        new_last_posx<=posx;
                        new_last_posy<=posy;
                        new_we<=(others=>'0');--no escribo
                        new_dout<="001"; --vacío
                        --guardo valor de dirección
                        new_dir<=last_posx & last_posy;
                        new_cycle<=cycle+1;
                        if (hay_muro='1') then
                            new_udlr<=last_udlr;--seguimos en dirección anterior
                            new_estado<=estado_s;--mantengo estado
                            new_hay_muro<='1';
                        end if;
                        if (cycle>"0000000000010") then
                            if (udlr_s="1000") then
                                new_posx<= std_logic_vector (unsigned(posx)-1);-- si va para arriba: restar fila
                                new_estado<= act_mov;
                                donde_mira_s<="00";
                            elsif (udlr_s="0100") then
                                new_posx<= std_logic_vector (unsigned(posx)+1);--si va para abajo: sumar fila
                                new_estado<= act_mov;
                                donde_mira_s<="01";
                            elsif (udlr_s="0010") then
                                new_posy<= std_logic_vector (unsigned(posy)-1);--si va para izq: restar columna
                                new_estado<= act_mov;
                                donde_mira_s<="10";
                            elsif (udlr_s="0001") then
                                new_posy<= std_logic_vector(unsigned(posy)+1);--si va para derecha: sumar columna
                                new_estado<= act_mov;
                                donde_mira_s<="11";
                            else 
                                new_hay_muro<='1';--por si acaso, que escoja el udlr anterior
                                new_estado<= estado_s;
                            end if;
                        else
                            new_estado<=estado_s;
                        end if;
                    when act_mov=>
                        new_dir<=last_posx & last_posy;
                        new_dout<="001";--vacio
                        new_we<=(others=>'1');
                        new_estado<=que_hay;
                     when que_hay=>
                        new_we<=(others=>'0');
                        new_dir<=new_posx & new_posy;
                        new_cycle<=cycle+1;
                        if (cycle="0000000000011")then
                            new_estado<=confirmo_dir;
                        else
                            new_estado<=que_hay;
                        end if;
                     when confirmo_dir=>
                        new_we<=(others=>'1');
                        new_dir<=new_posx & new_posy;
                        if (din="000") then --hay muro
                            new_dout<="100";--comecocos
                            if (last_udlr/=udlr_s) then
                                new_posx<=last_posx;
                                new_posy<=last_posy;
                                new_last_udlr<=last_udlr;
                                new_hay_muro<='1';
                                new_estado<=dir_boton;
                            else
                                new_posx<=last_posx;
                                new_posy<=last_posy;
                                new_hay_muro<='0';
                                new_estado<=ocupa_casilla;
                            end if;
                        elsif (din="101")then
                            new_estado<=reposo;
                            new_dout<="001"; --escribo vacío
                            new_vidas<=vidas+1;
                        else
                            new_puntos_s <= '1';
                            new_dout<="100";--comecocos
                            new_hay_muro<='0';
                            new_estado<=ocupa_casilla;
                            new_last_udlr<=udlr_s;
                        end if;
                    when ocupa_casilla=>
                        new_puntos_s <= '0';
                        new_dir<=new_posx & new_posy;
                        new_we<=(others=>'1');
                        new_dout<="100";--comecocos
                        new_cycle<=cycle;
                        new_em<='0';
                        if (refresh='1') then 
                            new_cycle<=cycle+1;
                         --   new_em<='1';
                            if (cycle>"1111111111110") then
                                new_we<=(others=>'0');
                                new_udlr<=udlr;
                                new_estado<=espera2;
                                new_last_udlr<=last_udlr;
                                done_s<='1';
                                new_cycle <= (OTHERS => '0');
                            else
                                new_estado<=estado_s;
                            end if;
                        else
                            new_estado<=estado_s;
                        end if;
                        
                    when espera2 => 
                        new_cycle <= cycle +1;
                        new_dout<="100";--comecocos
                        if(cycle = "0111111111110") then new_estado <= espera;
                    end if;
                       
                   when muerte=>
                        new_estado<=muerte;
                    when others=>
                        new_estado<=estado_s;
                    end case;
                end process;
                em<=em_s;
                puntos <=puntos_s;
                end Behavioral;